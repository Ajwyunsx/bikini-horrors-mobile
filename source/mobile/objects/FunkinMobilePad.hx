package mobile.objects;

import mobile.MobilePad;
import flixel.FlxG;
import flixel.graphics.frames.FlxTileFrames;
import flixel.graphics.FlxGraphic;
import openfl.display.BitmapData;
import openfl.utils.Assets;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import funkin.backend.assets.ModsFolder;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

class FunkinMobilePad extends MobilePad {
	public var curDPadMode(default, null):String = "NONE";
	public var curActionMode(default, null):String = "NONE";
	private var rightButtons:Array<MobileButton> = [];
	private var bottomButtons:Array<MobileButton> = [];
	private var widthOffset:Int = 0;
	private var heightOffset:Int = 0;
	private var pauseRightMargin:Float = 0;
	private var pauseTopMargin:Float = 0;
	private var pauseScale:Float = 1;

	public function new(DPad:String = "NONE", Action:String = "NONE") {
		super(DPad, Action);
		curDPadMode = DPad;
		curActionMode = Action;
		for (group in buttons)
			for (button in group) {
				if (button.x >= FlxG.initialWidth * 0.5)
					rightButtons.push(button);
				if (button.y >= FlxG.initialHeight * 0.5)
					bottomButtons.push(button);
			}
		resizeToViewport();
		final pause = getButton("buttonP");
		if (pause != null) {
			pauseRightMargin = Math.max(0, FlxG.width - pause.x - pause.width);
			pauseTopMargin = Math.max(0, pause.y);
		}
	}

	public function resizeGameplayPause(viewport:FlxRect, scale:Float):Void {
		final button = getButton("buttonP");
		if (button == null)
			return;
		if (scale != pauseScale) {
			final ratio = scale / pauseScale;
			button.scale.set(button.scale.x * ratio, button.scale.y * ratio);
			button.updateHitbox();
			pauseScale = scale;
		}
		button.setPosition(viewport.right - pauseRightMargin - button.width, viewport.y + pauseTopMargin);
		button.bounds.setPosition(button.x + (button.width - button.bounds.width) * 0.5,
			button.y + (button.height - button.bounds.height) * 0.5);
	}

	public function resizeToViewport():Void {
		if (!FlxG.onMobile)
			return;
		final nextX = FlxG.width - FlxG.initialWidth;
		final nextY = FlxG.height - FlxG.initialHeight;
		if (nextX != widthOffset)
			for (button in rightButtons)
				button.x += nextX - widthOffset;
		if (nextY != heightOffset)
			for (button in bottomButtons)
				button.y += nextY - heightOffset;
		widthOffset = nextX;
		heightOffset = nextY;
	}

	override public function createVirtualButton(x:Float, y:Float, framePath:String, ?scale:Float = 1.0, ?ColorS:Int = 0xFFFFFF, ?returned:String):MobileButton {
		var frames:FlxGraphic;
		var buttonLabelGraphicPath:String = "";
		#if MOD_SUPPORT
		final moddyFolder:String = ModsFolder.getCurrentModAssetPath('mobile');
		#end

		final defaultPath:String = 'assets/mobile/MobilePad/Textures/$framePath.png';
		#if MOD_SUPPORT
		final moddyPath:String = moddyFolder != null ? '$moddyFolder/MobilePad/Textures/$framePath.png' : null;
		if (moddyPath != null && ModsFolder.assetPathExists(moddyPath))
			buttonLabelGraphicPath = moddyPath;
		else
		#end
			buttonLabelGraphicPath = defaultPath;

		#if sys
		if (FileSystem.exists(buttonLabelGraphicPath))
			frames = FlxGraphic.fromBitmapData(BitmapData.fromBytes(File.getBytes(buttonLabelGraphicPath)));
		else
		#end
			frames = FlxGraphic.fromBitmapData(Assets.getBitmapData(buttonLabelGraphicPath));

		var button = new MobileButton(x, y, returned);
		button.scale.set(scale, scale);
		button.frames = FlxTileFrames.fromGraphic(frames, FlxPoint.get(Std.int(frames.width / 2), frames.height));

		button.updateHitbox();
		button.updateLabelPosition();

		button.bounds.makeGraphic(Std.int(button.width - 50), Std.int(button.height - 50), FlxColor.TRANSPARENT);
		button.centerBounds();

		button.immovable = true;
		button.solid = button.moves = false;
		button.antialiasing = Options.antialiasing;
		button.tag = framePath.toUpperCase();
		button.color = FlxColor.WHITE;
		return button;
	}
}
