package funkin.game;

import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import funkin.backend.system.FunkinMobileScaleMode;

/**
 * Camera meant for PlayState hud, allows for flipping the camera.
**/
class HudCamera extends FlxCamera {
	/**
	 * Whenever the camera should flip the y axis.
	 * Keeps the sprites not flipped, but the positions are flipped.
	 */
	public var downscroll:Bool = false;
	public var onViewportResize:Void->Void;
	private final expandViewport:Bool;
	private final extension:FlxRect = new FlxRect();

	public var layoutHeight(get, never):Int;
	private inline function get_layoutHeight():Int
		return height - Std.int(extension.height);

	public function new(x:Float = 0, y:Float = 0, width:Int = 0, height:Int = 0, zoom:Float = 0) {
		super(x, y, width, height, zoom);
		expandViewport = (FlxG.state is PlayState) && x == 0 && y == 0
			&& (width == 0 || width == FlxG.width) && (height == 0 || height == FlxG.height);
		resizeViewport();
	}

	override public function onResize():Void {
		resizeViewport();
		super.onResize();
		if (onViewportResize != null)
			onViewportResize();
	}

	private function resizeViewport():Void {
		if (!expandViewport)
			return;

		final next = FlxRect.get();
		final mode = Std.downcast(FlxG.scaleMode, FunkinMobileScaleMode);
		if (mode != null)
			mode.getSceneExtension(next);
		setSize(width + Std.int(next.width - extension.width), height + Std.int(next.height - extension.height));
		setPosition(x + next.x - extension.x, y + next.y - extension.y);
		extension.copyFrom(next);
		next.put();
	}

	public override function alterScreenPosition(spr:FlxObject, pos:FlxPoint):FlxPoint {
		final y = downscroll ? layoutHeight - pos.y - spr.height : pos.y;
		return pos.set(pos.x - extension.x, y - extension.y);
	}

	public function layoutViewportTile(sprite:FlxSprite, index:Int, count:Int):Void {
		if (count <= 0 || sprite.frameWidth <= 0 || sprite.frameHeight <= 0)
			return;

		final columnWidth = viewWidth / count;
		final factor = Math.max(columnWidth / sprite.frameWidth, viewHeight / sprite.frameHeight);
		sprite.scale.set(factor, factor);
		sprite.updateHitbox();
		final pos = sprite.getScreenPosition(FlxPoint.get(), this);
		final targetX = viewMarginLeft + columnWidth * (index + 0.5) - sprite.width * 0.5;
		final targetY = viewMarginTop + (viewHeight - sprite.height) * 0.5;
		final dy = targetY - pos.y;
		sprite.setPosition(sprite.x + targetX - pos.x, sprite.y + (downscroll ? -dy : dy));
		pos.put();
	}

	override public function destroy():Void {
		onViewportResize = null;
		super.destroy();
	}
}
