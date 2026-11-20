import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.text.FlxText;

var selectedVersion:Int = 0;
var changedState:Bool = false;

function create() {
    var bg:FlxSprite = new FlxSprite();
    bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    add(bg);

    if (FlxG.save.data.selectedVersion != null) {
        selectedVersion = FlxG.save.data.selectedVersion;
    }
}

function update(elapsed:Float) {
    if (FlxG.keys.justPressed.ESCAPE) {
        FlxG.switchState(new ModState("BHTitleState"));
    }

    if (!changedState) {
        changedState = true;

        trace("Selected version: " + selectedVersion);

        switch (selectedVersion) {
            case 0:
                FlxG.switchState(new ModState("FreeplayV1"));

            case 1:
                FlxG.switchState(new ModState("FreeplayV2"));

            case 2:
                FlxG.switchState(new ModState("FreeplayV3"));

            case 3:
                FlxG.switchState(new ModState("VSelectionState"));

            default:
                FlxG.switchState(new ModState("BHTitleState"));
        }
    }
}
