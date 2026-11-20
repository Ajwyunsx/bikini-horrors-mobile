package mobile.objects;

import mobile.Hitbox;
import mobile.MobileButton;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxTileFrames;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import funkin.backend.system.FunkinMobileScaleMode;
import openfl.display.BitmapData;
import openfl.display.Shape;
import openfl.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class FunkinHitbox extends Hitbox {
	public static inline var DEFAULT_EXTRA_COLOR:Int = 0xFFFFFF00;
	public static inline var OFFICIAL_MODE:String = "official";
	public static inline var OFFICIAL_HINT_WIDTH:Int = 146;
	public static inline var OFFICIAL_HINT_HEIGHT:Int = 149;
	public static inline var OFFICIAL_STRUM_SCALE:Float = 1.10;
	public static inline var OFFICIAL_NOTE_SPACING:Int = 40;
	public static inline var OFFICIAL_CENTER_SPACING:Int = 208;
	public static inline var OFFICIAL_VERTICAL_MARGIN:Int = -72;
	public static inline var OFFICIAL_TOUCH_PADDING_X:Int = 28;
	public static inline var OFFICIAL_TOUCH_PADDING_Y:Int = 34;
	public static inline var OFFICIAL_EXTRA_RIGHT_MARGIN:Int = 28;
	public static inline var OFFICIAL_EXTRA_BOTTOM_MARGIN:Int = 36;
	public static inline var OFFICIAL_EXTRA_SPACING:Int = 10;

	public var currentMode:String;
	public var showHints:Bool;
	private var syncedKeys:Map<Int, Bool> = [];
	private var extraHitboxButtons:Array<MobileButton> = [];
	private final controlViewport:FlxRect = new FlxRect();

	public function new(?mode:String, ?showHints:Bool):Void
	{
		super(mode, false); //false means library's hitbox creation is disabled.
		currentMode = mode; //use this there.
		this.showHints = showHints;
		controlViewport.set(0, 0, FlxG.width, FlxG.height);

		/*
			Legacy JSON-driven hitbox backup:

			if (mode != null && mode != "NONE" && MobileConfig.hitboxModes.exists(mode)) {
				for (buttonData in MobileConfig.hitboxModes.get(mode).hints) {
					addHint(buttonData.button, buttonData.buttonIDs, buttonData.buttonUniqueID,
						buttonData.position[0], buttonData.position[1],
						buttonData.scale[0], buttonData.scale[1],
						Util.colorFromString(buttonData.color), buttonData.returnKey);
				}
			}
		*/

		// The mobile port uses a strict four-lane full-screen hitbox by default.
		// "official" mirrors V-Slice's transparent Arrows hitbox placement.
		if (isOfficialMode(currentMode))
			createOfficialNoteHitboxes();
		else
			createDefaultNoteHitboxes();

		scrollFactor.set();
		updateTrackedButtons();

		instance = this;
	}

	private inline function isOfficialMode(?mode:String):Bool
		return mode != null && mode.toLowerCase() == OFFICIAL_MODE;

	public static function getOfficialHintX(index:Int, count:Int):Float
	{
		if (count <= 0)
			return 0;
		final scale = FunkinMobileScaleMode.getGameplayControlScale();
		final hintWidth = OFFICIAL_HINT_WIDTH * scale;
		final spacing = OFFICIAL_NOTE_SPACING * scale;
		if (count == 4) {
			final centerSpacing = OFFICIAL_CENTER_SPACING * scale;
			var pairWidth:Float = hintWidth * 2 + spacing;
			var totalWidth:Float = pairWidth * 2 + centerSpacing;
			var startX:Float = Math.floor((FlxG.width - totalWidth) / 2);
			var groupIndex:Int = Std.int(index / 2);
			var pairIndex:Int = index % 2;
			return startX + groupIndex * (pairWidth + centerSpacing) + pairIndex * (hintWidth + spacing);
		}
		var totalWidth:Float = hintWidth * count + spacing * Math.max(0, count - 1);
		return Math.floor((FlxG.width - totalWidth) / 2) + index * (hintWidth + spacing);
	}

	public static inline function getOfficialHintWidth():Float
		return OFFICIAL_HINT_WIDTH * FunkinMobileScaleMode.getGameplayControlScale();

	public static inline function getOfficialHintHeight():Float
		return OFFICIAL_HINT_HEIGHT * FunkinMobileScaleMode.getGameplayControlScale();

	public static function getOfficialHintY():Float
		return Math.floor(FlxG.height - getOfficialHintHeight() - OFFICIAL_HINT_HEIGHT - OFFICIAL_VERTICAL_MARGIN);

	private static function getOfficialTouchPaddingX():Float
		return FunkinMobileScaleMode.isAdaptive()
			? OFFICIAL_NOTE_SPACING * FunkinMobileScaleMode.getGameplayControlScale() * 0.5
			: OFFICIAL_TOUCH_PADDING_X;

	public static function getOfficialTouchX(index:Int, count:Int):Float
		return Math.max(0, getOfficialHintX(index, count) - getOfficialTouchPaddingX());

	public static function getOfficialTouchY():Float
		return Math.max(0, getOfficialHintY() - OFFICIAL_TOUCH_PADDING_Y);

	public static function getOfficialTouchWidth(index:Int, count:Int):Int
	{
		var x:Float = getOfficialTouchX(index, count);
		final right = getOfficialHintX(index, count) + getOfficialHintWidth() + getOfficialTouchPaddingX();
		return Std.int(Math.max(1, Math.min(FlxG.width, right) - x));
	}

	public static function getOfficialTouchHeight():Int
	{
		var y:Float = getOfficialTouchY();
		return Std.int(Math.max(1, Math.min(FlxG.height - y, getOfficialHintHeight() + OFFICIAL_TOUCH_PADDING_Y * 2)));
	}

	private function createDefaultNoteHitboxes():Void
	{
		var laneWidth:Float = FlxG.width / 4;
		var laneHeight:Int = Std.int(FlxG.height);
		var names:Array<String> = ["buttonNote1", "buttonNote2", "buttonNote3", "buttonNote4"];
		var ids:Array<Array<String>> = [["NOTE_LEFT"], ["NOTE_DOWN"], ["NOTE_UP"], ["NOTE_RIGHT"]];
		var colors:Array<Int> = [0xFFFF00FF, 0xFF00FFFF, 0xFF00FF00, 0xFFFF0000];

		for (i in 0...names.length) {
			var x:Float = i * laneWidth;
			var width:Int = (i == names.length - 1) ? Std.int(FlxG.width - x) : Std.int(Math.ceil(laneWidth));
			addHint(names[i], ids[i], i, x, 0, width, laneHeight, colors[i]);
		}
	}

	private function createOfficialNoteHitboxes():Void
	{
		var names:Array<String> = ["buttonNote1", "buttonNote2", "buttonNote3", "buttonNote4"];
		var ids:Array<Array<String>> = [["NOTE_LEFT"], ["NOTE_DOWN"], ["NOTE_UP"], ["NOTE_RIGHT"]];

		for (i in 0...names.length) {
			var x:Float = getOfficialTouchX(i, names.length);
			var y:Float = getOfficialTouchY();
			addOfficialHint(names[i], ids[i], i, x, y, getOfficialTouchWidth(i, names.length), getOfficialTouchHeight());
		}
	}

	private function createTransparentGraphic(width:Int, height:Int):BitmapData
		return new BitmapData(width, height, true, 0);

	private function addOfficialHint(name:String, ids:Array<String>, uniqueID:Int, x:Float, y:Float, width:Int, height:Int):Void
	{
		var hint = createOfficialHint(ids, uniqueID, x, y, width, height);
		add(hint);
		hintMap.set(name, hint);
		hints.push(hint);
	}

	private function createOfficialHint(name:Array<String>, uniqueID:Int, x:Float, y:Float, width:Int, height:Int):MobileButton
	{
		var hint:MobileButton = new MobileButton(x, y);
		hint.loadGraphic(createTransparentGraphic(width, height));
		hint.setSize(width, height);
		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.IDs = name;
		hint.uniqueID = uniqueID;

		var keyboardKey:FlxKey = getKeyboardKey(null, name);
		hint.onDown.callback = function()
		{
			syncKeyboardKey(keyboardKey, true);
			onButtonDown?.dispatch(hint, name, uniqueID);
		}
		hint.onOut.callback = hint.onUp.callback = function()
		{
			syncKeyboardKey(keyboardKey, false);
			onButtonUp?.dispatch(hint, name, uniqueID);
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}

	public function addExtraKey(key:String = "SPACE", ?buttonID:String, color:Int = DEFAULT_EXTRA_COLOR):MobileButton
	{
		if (key == null || key == "")
			key = "SPACE";
		key = key.toUpperCase();

		if (buttonID == null || buttonID == "")
			buttonID = key;

		var buttonName:String = 'buttonExtra_$key';
		if (hintMap.exists(buttonName))
			return hintMap.get(buttonName);

		var buttonIDs:Array<String> = ["EXTRA_1"];
		for (id in [buttonID, key])
			if (id != null && id != "" && !buttonIDs.contains(id))
				buttonIDs.push(id);

		if (isOfficialMode(currentMode))
			addOfficialExtraHint(buttonName, buttonIDs, -1, key);
		else {
			var buttonHeight:Int = getExtraRegionHeight();
			var buttonY:Float = Options.hitboxPos ? 0 : FlxG.height - buttonHeight;
			addHint(buttonName, buttonIDs, -1, 0, buttonY, FlxG.width, buttonHeight, color, key);
		}

		var button = hintMap.get(buttonName);
		if (button != null) {
			button.cameras = cameras;
			if (!extraHitboxButtons.contains(button))
				extraHitboxButtons.push(button);
			layoutButtons();
			keepExtraKeySeparate(button);
		}
		updateTrackedButtons();
		return button;
	}

	private function getExtraRegionHeight():Int
		return Std.int(controlViewport.height / 4);

	private function addOfficialExtraHint(name:String, ids:Array<String>, uniqueID:Int, key:String):Void
	{
		var hint = createOfficialExtraHint(ids, uniqueID, key);
		add(hint);
		hintMap.set(name, hint);
		hints.push(hint);
	}

	private function createOfficialExtraHint(name:Array<String>, uniqueID:Int, key:String):MobileButton
	{
		var hint:MobileButton = new MobileButton(0, 0, key);
		var frames = loadMobilePadGraphic(getOfficialExtraTexture(key));
		if (frames != null) {
			var frameWidth = Std.int(frames.width / 2);
			var frameHeight = Std.int(frames.height);
			hint.frames = FlxTileFrames.fromGraphic(frames, FlxPoint.get(frameWidth, frameHeight));
			hint.animation.add("normal", [0], 0, false);
			hint.animation.add("pressed", [1], 0, false);
			hint.animation.play("normal");
		} else {
			hint.loadGraphic(createHintGraphic(132, 125, DEFAULT_EXTRA_COLOR));
		}

		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 1;
		hint.IDs = name;
		hint.uniqueID = uniqueID;
		hint.allowSwiping = false;
		hint.antialiasing = Options.antialiasing;
		hint.tag = key;

		var keyboardKey:FlxKey = getKeyboardKey(key, name);
		hint.onDown.callback = function()
		{
			syncKeyboardKey(keyboardKey, true);
			onButtonDown?.dispatch(hint, name, uniqueID);
		}
		hint.onOut.callback = hint.onUp.callback = function()
		{
			syncKeyboardKey(keyboardKey, false);
			onButtonUp?.dispatch(hint, name, uniqueID);
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}

	private function getOfficialExtraTexture(key:String):String
		return "online_space";

	private function loadMobilePadGraphic(framePath:String):FlxGraphic
	{
		final ktxPath:String = 'assets/mobile/MobilePad/Textures/$framePath.astc.ktx';
		final pngPath:String = 'assets/mobile/MobilePad/Textures/$framePath.png';
		var bitmap:BitmapData = null;
		if (Assets.exists(ktxPath))
			bitmap = Assets.getBitmapData(ktxPath);
		#if sys
		if (bitmap == null && FileSystem.exists(pngPath))
			bitmap = BitmapData.fromBytes(File.getBytes(pngPath));
		#end
		if (bitmap == null && Assets.exists(pngPath))
			bitmap = Assets.getBitmapData(pngPath);
		return bitmap != null ? FlxGraphic.fromBitmapData(bitmap) : null;
	}

	private function isExtraHitboxButton(button:MobileButton):Bool
		return button != null && extraHitboxButtons != null && extraHitboxButtons.contains(button);

	private function isDefaultNoteButton(button:MobileButton):Bool
	{
		if (button == null || isExtraHitboxButton(button))
			return false;
		if (button.uniqueID >= 0 && button.uniqueID <= 3)
			return true;
		if (button.IDs != null)
			for (id in button.IDs)
				if (id != null && id.indexOf("NOTE_") == 0)
					return true;
		return false;
	}

	private function resizeHitboxButton(button:MobileButton, x:Float, y:Float, width:Int, height:Int):Void
	{
		if (button == null)
			return;

		button.setPosition(x, y);
		button.setGraphicSize(width, height);
		button.updateHitbox();

		if (button.hintUp != null) {
			button.hintUp.x = x;
			button.hintUp.y = y;
			button.hintUp.setGraphicSize(width, Std.int(Math.max(1, Math.floor(height * 0.02))));
			button.hintUp.updateHitbox();
		}

		if (button.hintDown != null) {
			button.hintDown.x = x;
			button.hintDown.setGraphicSize(width, Std.int(Math.max(1, Math.floor(height * 0.02))));
			button.hintDown.updateHitbox();
			button.hintDown.y = y + button.height - button.hintDown.height;
		}
	}

	public function resizeToViewport(viewport:FlxRect):Void
	{
		controlViewport.copyFrom(viewport);
		layoutButtons();
	}

	private function layoutButtons():Void
	{
		if (isOfficialMode(currentMode)) {
			for (i in 0...4) {
				final button = hintMap.get('buttonNote${i + 1}');
				resizeHitboxButton(button, getOfficialTouchX(i, 4), getOfficialTouchY(), getOfficialTouchWidth(i, 4), getOfficialTouchHeight());
			}
			layoutOfficialExtraButtons();
			return;
		}

		final extraCount = extraHitboxButtons.length;
		final regionHeight = extraCount > 0 ? getExtraRegionHeight() : 0;
		final gameplayY = controlViewport.y + (Options.hitboxPos ? regionHeight : 0);
		final extraY = Options.hitboxPos ? controlViewport.y : controlViewport.bottom - regionHeight;
		final gameplayHeight = Std.int(controlViewport.height) - regionHeight;
		var laneIndex:Int = 0;
		for (hint in hints)
			if (isDefaultNoteButton(hint)) {
				layoutLane(hint, laneIndex, 4, gameplayY, gameplayHeight);
				laneIndex++;
			}

		for (i in 0...extraCount)
			layoutLane(extraHitboxButtons[i], i, extraCount, extraY, regionHeight);
	}

	private function layoutLane(button:MobileButton, index:Int, count:Int, y:Float, height:Int):Void
	{
		final left = Math.floor(index * controlViewport.width / count);
		final right = Math.floor((index + 1) * controlViewport.width / count);
		resizeHitboxButton(button, controlViewport.x + left, y, right - left, height);
	}

	private function layoutOfficialExtraButtons():Void
	{
		var y:Float = controlViewport.bottom - OFFICIAL_EXTRA_BOTTOM_MARGIN;
		for (button in extraHitboxButtons) {
			if (button == null)
				continue;
			var buttonWidth:Float = Math.max(1, button.frameWidth);
			var buttonHeight:Float = Math.max(1, button.frameHeight);
			var x:Float = Math.max(controlViewport.x, controlViewport.right - buttonWidth - OFFICIAL_EXTRA_RIGHT_MARGIN);
			y -= buttonHeight;
			button.setPosition(x, Math.max(controlViewport.y, y));
			button.updateHitbox();
			y -= OFFICIAL_EXTRA_SPACING;
		}
	}

	private function keepExtraKeySeparate(extraButton:MobileButton):Void
	{
		if (extraButton == null)
			return;

		for (hint in hints) {
			if (hint == null || hint == extraButton)
				continue;
			if (hint.deadZones.indexOf(extraButton) == -1)
				hint.deadZones.push(extraButton);
		}
	}

	private function getKeyboardKey(?returned:String, ?ids:Array<String>):FlxKey
	{
		if (returned != null && returned != "")
			return FlxKey.fromString(returned);

		if (ids != null)
			for (id in ids) {
				var key = FlxKey.fromString(id);
				if (key != FlxKey.NONE && key != FlxKey.ANY)
					return key;
			}

		return FlxKey.NONE;
	}

	private function syncKeyboardKey(key:FlxKey, down:Bool):Void
	{
		if (key == FlxKey.NONE || key == FlxKey.ANY)
			return;

		var keyCode:Int = key;
		var wasDown:Bool = syncedKeys.exists(keyCode) && syncedKeys.get(keyCode);
		if (wasDown == down)
			return;

		@:privateAccess FlxG.keys.updateKeyStates(keyCode, down);
		syncedKeys.set(keyCode, down);
	}

	override function createHintGraphic(Width:Int, Height:Int, Color:Int = 0xFFFFFF, ?isLane:Bool = false):BitmapData
	{
		var shape:Shape = new Shape();
		shape.graphics.beginFill(Color);
		shape.graphics.lineStyle(10, Color, 1);
		shape.graphics.drawRect(0, 0, Width, Height);
		shape.graphics.endFill();

		var bitmap:BitmapData = new BitmapData(Width, Height, true, 0);
		bitmap.draw(shape);
		return bitmap;
	}

	override public function createHint(name:Array<String>, uniqueID:Int, x:Float, y:Float, width:Int, height:Int, color:Int = 0xFFFFFF, ?returned:String):MobileButton
	{
		var hint:MobileButton = new MobileButton(x, y, returned);
		hint.loadGraphic(createHintGraphic(width, height, color));

		if (showHints) {
			var doHeightFix:Bool = false;
			if (height == 144) doHeightFix = true;

			//Up Hint
			hint.hintUp = new FlxSprite();
			hint.hintUp.loadGraphic(createHintGraphic(width, Math.floor(height * (doHeightFix ? 0.060 : 0.020)), color, true));
			hint.hintUp.x = x;
			hint.hintUp.y = hint.y;

			//Down Hint
			hint.hintDown = new FlxSprite();
			hint.hintDown.loadGraphic(createHintGraphic(width, Math.floor(height * (doHeightFix ? 0.060 : 0.020)), color, true));
			hint.hintDown.x = x;
			hint.hintDown.y = hint.y + hint.height / (doHeightFix ? 1.060 : 1.020);
		}

		hint.solid = false;
		hint.immovable = true;
		hint.scrollFactor.set();
		hint.alpha = 0.00001;
		hint.IDs = name;
		hint.uniqueID = uniqueID;
		var keyboardKey:FlxKey = getKeyboardKey(returned, name);
		hint.onDown.callback = function()
		{
			syncKeyboardKey(keyboardKey, true);
			onButtonDown?.dispatch(hint, name, uniqueID);
			if (hint.alpha != alpha)
				hint.alpha = alpha;
			if ((hint.hintUp?.alpha != 0.00001 || hint.hintDown?.alpha != 0.00001) && hint.hintUp != null && hint.hintDown != null)
				hint.hintUp.alpha = hint.hintDown.alpha = 0.00001;
		}
		hint.onOut.callback = hint.onUp.callback = function()
		{
			syncKeyboardKey(keyboardKey, false);
			onButtonUp?.dispatch(hint, name, uniqueID);
			if (hint.alpha != 0.00001)
				hint.alpha = 0.00001;
			if ((hint.hintUp?.alpha != alpha || hint.hintDown?.alpha != alpha) && hint.hintUp != null && hint.hintDown != null)
				hint.hintUp.alpha = hint.hintDown.alpha = alpha;
		}
		#if FLX_DEBUG
		hint.ignoreDrawDebug = true;
		#end
		return hint;
	}

	override function destroy():Void
	{
		if (syncedKeys != null)
			for (keyCode=>isDown in syncedKeys)
				if (isDown)
					@:privateAccess FlxG.keys.updateKeyStates(keyCode, false);
		syncedKeys = null;
		super.destroy();
	}
}
