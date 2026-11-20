package funkin.options.categories;

import flixel.input.keyboard.FlxKey;
import funkin.backend.system.FunkinMobileScaleMode;

class MobileOptions extends TreeMenuScreen
{
	inline public static function listFromString(string:String):Array<String>
	{
		var daList:Array<String> = [];
		daList = string.trim().split('\n');
		trace(daList);

		return daList;
	}
	inline public static function coolTextFile(path:String):Array<String>
	{
		var daList:String = null;
		if(Assets.exists(path)) daList = Assets.getText(path);
		trace(daList);
		return daList != null ? listFromString(daList) : [];
	}

	inline public static function mergeAllTextsNamed(file:String)
	{
		var mergedList:Array<String> = [];
		var list:Array<String> = coolTextFile(file);
		for (value in list)
			if(!mergedList.contains(value) && value.length > 0)
				mergedList.push(value);
		return mergedList;
	}

	var HitboxModes:Array<String>;
	public function new()
	{
		super('optionsTree.mobile-name', 'optionsTree.mobile-name', 'MobileOptions.', ['LEFT_FULL', 'A_B']);

		Options.hitboxMode = "Normal";
		Options.hitboxType = "No Gradient (Old)";

		// Hidden for APK-only mobile flow. Keep the underlying extra-buttons code intact for future reuse.
		// add(new NumOption(getNameID('extraButtons'), getDescID('extraButtons'), 0, 4, 1, 'extraButtons'));
		// add(new ArrayOption(getNameID('hitboxType'), getDescID('hitboxType'), ["No Gradient", "No Gradient (Old)", "Gradient"],
		// 	["No Gradient", "No Gradient (Old)", "Gradient"], 'hitboxType'));
		// add(new ArrayOption(getNameID('hitboxMode'), getDescID('hitboxMode'), HitboxModes, HitboxModes, 'hitboxMode'));
		add(new ArrayOption(getNameID('screenScaleMode'), getDescID('screenScaleMode'),
			[FunkinMobileScaleMode.ADAPTIVE, FunkinMobileScaleMode.FIT, FunkinMobileScaleMode.STRETCH, FunkinMobileScaleMode.CROP],
			[getID('screenScaleMode-adaptive'), getID('screenScaleMode-fit'), getID('screenScaleMode-stretch'), getID('screenScaleMode-crop')],
			'screenScaleMode', (_) -> FunkinMobileScaleMode.apply()));
		add(new Checkbox(getNameID('screenSafeArea'), getDescID('screenSafeArea'), 'screenSafeArea',
			() -> FunkinMobileScaleMode.apply()));
		add(new ArrayOption(getNameID('mobileControlMode'), getDescID('mobileControlMode'), ["hitbox", "official"],
			[getID('mobileControlMode-hitbox'), getID('mobileControlMode-official')], 'mobileControlMode'));
		add(new Checkbox(getNameID('hitboxPos'), getDescID('hitboxPos'), "hitboxPos"));
		add(new NumOption(getNameID('controlsAlpha'), getDescID('controlsAlpha'), 0.0, 1.0, 0.1, "controlsAlpha", (alpha:Float) ->
		{
			if (MusicBeatState.instance != null && MusicBeatState.instance.mobileManager != null) {
				if (MusicBeatState.instance.mobileManager.mobilePad != null)
					MusicBeatState.instance.mobileManager.mobilePad.alpha = alpha;
				if (MusicBeatState.instance.mobileManager.hitbox != null)
					MusicBeatState.instance.mobileManager.hitbox.alpha = alpha;
			}
			if (funkin.backend.system.Controls.instance.mobileC)
			{
				FlxG.sound.volumeUpKeys = [];
				FlxG.sound.volumeDownKeys = [];
				FlxG.sound.muteKeys = [];
			}
			else
			{
				FlxG.sound.volumeUpKeys = [FlxKey.PLUS, FlxKey.NUMPADPLUS];
				FlxG.sound.volumeDownKeys = [FlxKey.MINUS, FlxKey.NUMPADMINUS];
				FlxG.sound.muteKeys = [FlxKey.ZERO, FlxKey.NUMPADZERO];
			}
		}));
	}
}
