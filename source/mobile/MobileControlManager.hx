package mobile;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxDestroyUtil;
import mobile.MobilePad;
import mobile.Hitbox;
import mobile.JoyStick;
import flixel.FlxBasic;
import flixel.math.FlxRect;
import funkin.backend.system.FunkinFullscreenCamera;
import funkin.backend.system.FunkinMobileScaleMode;
import funkin.game.PlayState;

/**
 * A simple mobile manager for who doesn't want to create these manually
 * if you're making big projects or have a experience to how controls work, create the controls yourself
 */
class MobileControlManager implements IFlxDestroyable {
	public var mobilePadCam:FlxCamera;
	public var mobilePad:FunkinMobilePad;
	public var joyStickCam:FlxCamera;
	public var joyStick:FunkinJoyStick;
	public var hitboxCam:FlxCamera;
	public var hitbox:FunkinHitbox;
	public var curState:Dynamic;

	public function new(target:Dynamic):Void
	{
		curState = target;
		//trace("MobileControlManager initialized.");
	}

	//for lua shit
	public function makeMobilePad(DPad:String, Action:String)
	{
		MobileConfig.ensureInitialized();
		resetInputVisuals();
		if (mobilePad != null) removeMobilePad();
		mobilePad = new FunkinMobilePad(DPad, Action);
		configureMobilePadButtons();
		mobilePad.alpha = Options.controlsAlpha;
	}

	public function addMobilePad(DPad:String, Action:String)
	{
		makeMobilePad(DPad, Action);
		curState.add(mobilePad);
	}

	public function removeMobilePad():Void
	{
		if (mobilePad != null)
		{
			curState.remove(mobilePad);
			mobilePad = FlxDestroyUtil.destroy(mobilePad);
		}

		if(mobilePadCam != null)
		{
			FlxG.cameras.remove(mobilePadCam);
			mobilePadCam = FlxDestroyUtil.destroy(mobilePadCam);
		}
	}

	public function addMobilePadCamera(defaultDrawTarget:Bool = false):Void
	{
		mobilePadCam = createControlCamera();
		mobilePadCam.bgColor.alpha = 0;
		FlxG.cameras.add(mobilePadCam, defaultDrawTarget);
		mobilePad.cameras = [mobilePadCam];
		if (mobilePadCam is FunkinFullscreenCamera)
			mobilePad.scrollFactor.set(1, 1);
		resizeGameplayControls();
	}

	public function makeHitbox(?mode:String, ?hints:Bool)
	{
		resetInputVisuals();
		if (hitbox != null) removeHitbox();
		hitbox = new FunkinHitbox(mode, hints);
		hitbox.alpha = Options.controlsAlpha;
	}

	public function addHitbox(?mode:String, ?hints:Bool)
	{
		makeHitbox(mode, hints);
		curState.add(hitbox);
	}

	public function addExtraHitboxKey(key:String = "SPACE", ?buttonID:String):MobileButton
	{
		if (hitbox == null)
			return null;
		return hitbox.addExtraKey(key, buttonID);
	}

	public function removeHitbox():Void
	{
		if (hitbox != null)
		{
			curState.remove(hitbox);
			hitbox = FlxDestroyUtil.destroy(hitbox);
		}

		if(hitboxCam != null)
		{
			FlxG.cameras.remove(hitboxCam);
			hitboxCam = FlxDestroyUtil.destroy(hitboxCam);
		}
	}

	public function addHitboxCamera(defaultDrawTarget:Bool = false):Void
	{
		hitboxCam = createControlCamera();
		hitboxCam.bgColor.alpha = 0;
		FlxG.cameras.add(hitboxCam, defaultDrawTarget);
		hitbox.cameras = [hitboxCam];
		if (hitboxCam is FunkinFullscreenCamera)
			hitbox.scrollFactor.set(1, 1);
		resizeGameplayControls();
	}

	private function createControlCamera():FlxCamera
		return FlxG.onMobile && (curState is PlayState) ? new FunkinFullscreenCamera(true) : new FlxCamera();

	public function resizeGameplayControls():Void
	{
		if (!(hitboxCam is FunkinFullscreenCamera) && !(mobilePadCam is FunkinFullscreenCamera))
			return;

		final viewport = FlxRect.get();
		FunkinMobileScaleMode.getControlViewport(viewport);
		if (hitboxCam is FunkinFullscreenCamera)
			hitbox?.resizeToViewport(viewport);
		if (mobilePadCam is FunkinFullscreenCamera)
			mobilePad?.resizeGameplayPause(viewport, FunkinMobileScaleMode.getGameplayControlScale());
		viewport.put();
	}

	public function makeJoyStick(x:Float = 0, y:Float = 0, ?graphic:String, ?onMove:Float->Float->Float->String->Void, size:Float = 1):Void
	{
		resetInputVisuals();
		if (joyStick != null) removeJoyStick();
		joyStick = new FunkinJoyStick(x, y, graphic, onMove);
		joyStick.scale.set(size, size);
		joyStick.alpha = Options.controlsAlpha;
		joyStick.refreshVisuals(Options.controlsAlpha);
		syncJoyStickDeadZone();
	}

	public function addJoyStick(x:Float = 0, y:Float = 0, ?graphic:String, ?onMove:Float->Float->Float->String->Void, size:Float = 1):Void
	{
		makeJoyStick(x, y, graphic, onMove, size);
		curState.add(joyStick);
	}

	private function syncJoyStickDeadZone():Void
	{
		if (hitbox == null || joyStick == null || joyStick.base == null)
			return;

		hitbox.forEachAlive((button) ->
		{
			if (button.deadZones.indexOf(joyStick.base) == -1)
				button.deadZones.push(joyStick.base);
		});
	}

	public function removeJoyStick():Void
	{
		if (joyStick != null)
		{
			curState.remove(joyStick);
			joyStick = FlxDestroyUtil.destroy(joyStick);
		}

		if(joyStickCam != null)
		{
			FlxG.cameras.remove(joyStickCam);
			joyStickCam = FlxDestroyUtil.destroy(joyStickCam);
		}
	}

	public function addJoyStickCamera(defaultDrawTarget:Bool = false):Void {
		if (joyStick == null)
			return;

		joyStickCam = new FlxCamera();
		joyStickCam.bgColor.alpha = 0;
		FlxG.cameras.add(joyStickCam, defaultDrawTarget);
		applyJoyStickCamera();
	}

	private function applyJoyStickCamera():Void
	{
		if (joyStick == null || joyStickCam == null)
			return;

		joyStick.cameras = [joyStickCam];
		if (joyStick.base != null)
			joyStick.base.cameras = [joyStickCam];
		if (joyStick.thumb != null)
			joyStick.thumb.cameras = [joyStickCam];
		joyStick.refreshVisuals(joyStick.alpha, joyStickCam);
	}

	public function resetInputVisuals():Void
	{
		resetMobilePadButtons();
		resetHitboxButtons();
		resetJoyStickButtons();
	}

	private function resetMobilePadButtons():Void
	{
		if (mobilePad == null || mobilePad.buttons == null)
			return;

		for (group in mobilePad.buttons)
			if (group != null)
				for (button in group)
					resetButton(button);
	}

	private function configureMobilePadButtons():Void
	{
		if (mobilePad == null || mobilePad.buttons == null)
			return;

		for (group in mobilePad.buttons)
			if (group != null)
				for (button in group)
					if (button != null) {
						// Require a fresh touch for menu/gamepad buttons, so holding BACK
						// while a state/menu switches cannot trigger the next screen too.
						button.allowSwiping = false;
					}
	}

	private function resetHitboxButtons():Void
	{
		if (hitbox == null)
			return;

		hitbox.forEachAlive((button) -> resetButton(button));
	}

	private function resetJoyStickButtons():Void
	{
		if (joyStick == null)
			return;

		joyStick.direction = [0, "NONE"];
		resetButton(joyStick.base);
	}

	private function resetButton(button:MobileButton):Void
	{
		if (button == null)
			return;

		button.onOutHandler();
		button.status = MobileButton.NORMAL;
		var animName = button.statusAnimations[MobileButton.NORMAL];
		if (animName != null && button.animation.getByName(animName) != null)
			button.animation.play(animName, true);
	}

	public function destroy():Void {
		removeMobilePad();
		removeHitbox();
		removeJoyStick();
	}
}
