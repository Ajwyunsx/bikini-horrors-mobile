package funkin.backend;

import flixel.util.FlxColor;
import funkin.backend.system.FunkinMobileScaleMode;
import funkin.game.HudCamera;

/** Color flashes and fades anchored to the visible area of their camera. */
class FunkinScreenOverlay extends FlxSprite {
	public function new(color:FlxColor) {
		super();
		makeGraphic(FlxG.width, FlxG.height, color);
		scrollFactor.set();
	}

	override public function draw():Void {
		if (alpha <= 0)
			return;

		final cam = camera;
		if (FunkinMobileScaleMode.isAdaptive() && cam != null && cam.viewWidth > 0 && cam.viewHeight > 0) {
			final targetWidth = Math.ceil(cam.viewMarginRight) - Math.floor(cam.viewMarginLeft) + 2;
			final targetHeight = Math.ceil(cam.viewMarginBottom) - Math.floor(cam.viewMarginTop) + 2;
			if (Math.round(width) != targetWidth || Math.round(height) != targetHeight) {
				setGraphicSize(targetWidth, targetHeight);
				updateHitbox();
			}

			final pos = getScreenPosition(_point, cam);
			final dy = Math.floor(cam.viewMarginTop) - 1 - pos.y;
			final hud = Std.downcast(cam, HudCamera);
			setPosition(x + Math.floor(cam.viewMarginLeft) - 1 - pos.x,
				y + (hud != null && hud.downscroll ? -dy : dy));
		}
		super.draw();
	}
}
