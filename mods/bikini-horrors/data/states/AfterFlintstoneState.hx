import funkin.backend.system.FunkinFullscreenCamera;
import funkin.backend.system.FunkinMobileScaleMode;
import hxvlc.flixel.FlxVideoSprite;


var vid:FlxVideoSprite;

function postCreate() {
    startVideo("ME VOY");
}

function startVideo(name:String) {
    var ext = "mp4";

    vid = new FlxVideoSprite();
    vid.autoVolumeHandle = false; 
    add(vid);

    vid.bitmap.onFormatSetup.add(function() {
        if (FunkinMobileScaleMode.isAdaptive())
            FunkinFullscreenCamera.layoutSprite(vid, FlxG.width, FlxG.height, true);
        else {
            vid.setGraphicSize(FlxG.width, FlxG.height);
            vid.updateHitbox();
            vid.screenCenter();
        }
    });

    if (vid.load(Paths.video(name, ext))) {
        vid.bitmap.onEndReached.add(onFinish);
        vid.play();
    } else {
        onFinish();
    }
}

function onFinish() {
    if (vid != null) {
        vid.stop();
        vid.destroy();
        remove(vid);
        vid = null;
        FlxG.switchState(new ModState("VersionHandler"));
    }
}
