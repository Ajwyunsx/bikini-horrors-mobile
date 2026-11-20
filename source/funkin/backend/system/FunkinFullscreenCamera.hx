package funkin.backend.system;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxRect;

/** A camera for backgrounds, video and overlays that reach the display edges. */
class FunkinFullscreenCamera extends FlxCamera
{
	public var onViewportResize:Void->Void;
	private final preserveLayout:Bool;

	public function new(preserveLayout:Bool = false)
	{
		super();
		this.preserveLayout = preserveLayout;
		updateViewport();
	}

	override public function onResize():Void
	{
		updateViewport();
		super.onResize();
		if (onViewportResize != null)
			onViewportResize();
	}

	private function updateViewport():Void
	{
		final viewport = FlxRect.get();
		final mode = Std.downcast(FlxG.scaleMode, FunkinMobileScaleMode);
		if (mode != null)
			mode.getSceneExtension(viewport);

		if (preserveLayout)
			scroll.add(viewport.x - x, viewport.y - y);
		setSize(FlxG.width + Std.int(viewport.width), FlxG.height + Std.int(viewport.height));
		setPosition(viewport.x, viewport.y);
		viewport.put();
	}

	/** Centers a full-screen image or video, using uniform scaling. */
	public function layoutMedia(sprite:FlxSprite):Void
		layoutSprite(sprite, width, height, FunkinMobileScaleMode.isAdaptive());

	public static function layoutSprite(sprite:FlxSprite, width:Int, height:Int, cover:Bool):Void
	{
		if (sprite == null || sprite.frameWidth <= 0 || sprite.frameHeight <= 0)
			return;

		final sx = width / sprite.frameWidth;
		final sy = height / sprite.frameHeight;
		final factor = cover ? Math.max(sx, sy) : Math.min(sx, sy);
		sprite.scale.set(factor, factor);
		sprite.updateHitbox();
		sprite.setPosition((width - sprite.width) * 0.5, (height - sprite.height) * 0.5);
	}

	override public function destroy():Void
	{
		onViewportResize = null;
		super.destroy();
	}
}
