package funkin.backend.system;

import flixel.FlxG;
import flixel.FlxState;
import flixel.math.FlxRect;
import flixel.system.scaleModes.BaseScaleMode;
import funkin.game.PlayState;

/** Measures the safe viewport used by states, cameras and touch input. */
class FunkinMobileScaleMode extends BaseScaleMode
{
	public static inline var ADAPTIVE:String = "adaptive";
	public static inline var FIT:String = "fit";
	public static inline var STRETCH:String = "stretch";
	public static inline var CROP:String = "crop";

	public var mode(default, null):String;
	public var safeArea(default, null):Bool;
	private static var watchingStates:Bool = false;

	#if android
	private static var readInsets:Dynamic;
	private static var watchingInsets:Bool = false;
	private static var nextInsetCheck:Float = 0;
	#end
	private var displayInsets:Array<Int>;
	private final safeStage:FlxRect = new FlxRect();

	public function new(?mode:String, safeArea:Bool = true)
	{
		super();
		this.mode = sanitizeMode(mode);
		this.safeArea = safeArea;
	}

	public static function apply():Void
	{
		#if mobile
		if (FlxG.game == null || FlxG.stage == null || FlxG.stage.stageWidth <= 0 || FlxG.stage.stageHeight <= 0)
			return;

		final mode = Options.screenScaleMode = sanitizeMode(Options.screenScaleMode);
		final active = Std.downcast(FlxG.scaleMode, FunkinMobileScaleMode);
		if (active == null || active.mode != mode || active.safeArea != Options.screenSafeArea)
			FlxG.scaleMode = new FunkinMobileScaleMode(mode, Options.screenSafeArea);

		if (!watchingStates)
		{
			watchingStates = true;
			FlxG.signals.preStateCreate.add(measureNextState);
		}

		#if android
		if (!watchingInsets)
		{
			watchingInsets = true;
			FlxG.signals.postUpdate.add(checkDisplayInsets);
		}
		#end
		#end
	}

	private static function measureNextState(_:FlxState):Void
	{
		if (!(FlxG.scaleMode is FunkinMobileScaleMode))
			return;

		// The new state is assigned before this signal. Measure before its script builds the UI.
		FlxG.resizeGame(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		@:privateAccess FlxG.cameras.resize();
	}

	public static function isAdaptive():Bool
	{
		final active = Std.downcast(FlxG.scaleMode, FunkinMobileScaleMode);
		return active != null && active.mode == ADAPTIVE;
	}

	public static function sanitizeMode(mode:String):String
	{
		return switch (mode)
		{
			case ADAPTIVE | FIT | STRETCH | CROP: mode;
			default: ADAPTIVE;
		}
	}

	override public function onMeasure(width:Int, height:Int):Void
	{
		if (width <= 0 || height <= 0)
			return;

		final oldWidth = FlxG.width;
		final oldHeight = FlxG.height;
		@:privateAccess {
			FlxG.width = FlxG.initialWidth;
			FlxG.height = FlxG.initialHeight;
		}

		displayInsets = safeArea ? getDisplayInsets(width, height) : [0, 0, 0, 0];
		// Some curved panels do not advertise a waterfall inset.
		final edgeMargin = safeArea && mode == ADAPTIVE && width > height ? Math.round(height * 0.025) : 0;
		final left = Math.max(edgeMargin, displayInsets[0]);
		final right = Math.max(edgeMargin, displayInsets[2]);
		final top = Math.max(edgeMargin, displayInsets[1]);
		final bottom = Math.max(edgeMargin, displayInsets[3]);
		final availableWidth = Math.max(1, width - left - right);
		final availableHeight = Math.max(1, height - top - bottom);
		safeStage.set(left, top, availableWidth, availableHeight);
		final scaleX = availableWidth / FlxG.width;
		final scaleY = availableHeight / FlxG.height;

		if (mode == STRETCH)
			scale.set(scaleX, scaleY);
		else
		{
			final uniformScale = mode == CROP ? Math.max(scaleX, scaleY) : Math.min(scaleX, scaleY);
			scale.set(uniformScale, uniformScale);
			if (mode == ADAPTIVE && !(FlxG.state is PlayState))
			{
				// Menus lay out against the safe rectangle. Gameplay charts retain their authored coordinates.
				@:privateAccess {
					FlxG.width = Math.floor(availableWidth / uniformScale + 0.000001);
					FlxG.height = Math.floor(availableHeight / uniformScale + 0.000001);
				}
			}
		}

		deviceSize.set(width, height);
		gameSize.set(FlxG.width * scale.x, FlxG.height * scale.y);
		offset.set(left + (availableWidth - gameSize.x) * 0.5, top + (availableHeight - gameSize.y) * 0.5);
		updateGamePosition();

		if (oldWidth != FlxG.width || oldHeight != FlxG.height)
			for (camera in FlxG.cameras.list)
				if (!(camera is FunkinFullscreenCamera) && camera.x == 0 && camera.y == 0
					&& camera.width == oldWidth && camera.height == oldHeight)
					camera.setSize(FlxG.width, FlxG.height);
	}

	/** Safe bounds in the same logical coordinates as the gameplay HUD. */
	public static function getControlViewport(result:FlxRect):Void
	{
		final active = Std.downcast(FlxG.scaleMode, FunkinMobileScaleMode);
		if (active == null || active.mode != ADAPTIVE || active.scale.x <= 0 || active.scale.y <= 0) {
			result.set(0, 0, FlxG.width, FlxG.height);
			return;
		}

		final left = Math.ceil((active.safeStage.x - active.offset.x) / active.scale.x - 0.000001);
		final top = Math.ceil((active.safeStage.y - active.offset.y) / active.scale.y - 0.000001);
		final right = Math.floor((active.safeStage.right - active.offset.x) / active.scale.x + 0.000001);
		final bottom = Math.floor((active.safeStage.bottom - active.offset.y) / active.scale.y + 0.000001);
		result.set(left, top, Math.max(1, right - left), Math.max(1, bottom - top));
	}

	public static function getGameplayControlScale():Float
	{
		final active = Std.downcast(FlxG.scaleMode, FunkinMobileScaleMode);
		if (active == null || active.mode != ADAPTIVE || active.gameSize.x <= 0)
			return 1;

		// Grow the buttons on wider devices while keeping the official arrows inside camHUD.
		return Math.min(1.25, Math.max(1, active.safeStage.width / active.gameSize.x));
	}

	/** Extra logical pixels a camera needs to reach the physical edges. */
	public function getSceneExtension(result:FlxRect):Void
	{
		if (mode != ADAPTIVE || scale.x <= 0 || scale.y <= 0)
		{
			result.set(0, 0, 0, 0);
			return;
		}

		final left = Math.ceil(Math.max(0, offset.x / scale.x));
		final top = Math.ceil(Math.max(0, offset.y / scale.y));
		final right = Math.ceil(Math.max(0, (deviceSize.x - offset.x - gameSize.x) / scale.x));
		final bottom = Math.ceil(Math.max(0, (deviceSize.y - offset.y - gameSize.y) / scale.y));
		result.set(-left, -top, left + right, top + bottom);
	}

	#if android
	private static function checkDisplayInsets():Void
	{
		final now = haxe.Timer.stamp();
		if (now < nextInsetCheck)
			return;
		nextInsetCheck = now + 0.25;

		final active = Std.downcast(FlxG.scaleMode, FunkinMobileScaleMode);
		if (active == null || !active.safeArea || active.displayInsets == null)
			return;

		final insets = getDisplayInsets(FlxG.stage.stageWidth, FlxG.stage.stageHeight);
		for (i in 0...4)
			if (insets[i] != active.displayInsets[i])
			{
				// Insets can arrive after startup or change without a stage resize.
				@:privateAccess FlxG.game.onResize(null);
				return;
			}
	}
	#end

	public static function getDisplayInsets(width:Int, height:Int):Array<Int>
	{
		#if android
		if (readInsets == null)
			readInsets = lime.system.JNI.createStaticMethod("com/ajwwk/mobile/DisplayInsets", "getInsets", "()[I", false, true);

		final raw:Array<Int> = readInsets != null ? readInsets() : null;
		if (raw != null && raw.length == 6 && raw[4] > 0 && raw[5] > 0 && width > 0 && height > 0
			&& (raw[4] >= raw[5]) == (width >= height))
		{
			// The native snapshot uses content-view pixels. Convert for stages rendered at a different scale.
			final scaleX = width / raw[4];
			final scaleY = height / raw[5];
			final left = Math.ceil(raw[0] * scaleX);
			final top = Math.ceil(raw[1] * scaleY);
			final right = Math.ceil(raw[2] * scaleX);
			final bottom = Math.ceil(raw[3] * scaleY);
			if (left + right < width && top + bottom < height)
				return [left, top, right, bottom];
		}
		#end
		return [0, 0, 0, 0];
	}
}
