import funkin.backend.system.FunkinFullscreenCamera;
import funkin.backend.system.FunkinMobileScaleMode;
import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxG;

var timer : Float = 0;
var vid:FlxVideoSprite;

function postCreate() {
    //save data coming in clutch
    var videoName = FlxG.save.data.cutsceneToPlay;
    startVideo(videoName);
}

function startVideo(name:String) {
    trace("trying " + name);
    
    //just in case it's null
    if (name == null || name == "") {
        onFinish();
        return;
    }

    var ext = "mp4";

    vid = new FlxVideoSprite();
    vid.autoVolumeHandle = true; 
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

function update(elapsed:Float){
    timer += elapsed;
    if (timer < 0.2){
        return;
    }
    if (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) {
        onFinish();
    }
}

function onFinish() {
    //clean up the data
    FlxG.save.data.cutsceneToPlay = null;

    if (vid != null) {
        vid.stop();
        vid.destroy();
        remove(vid);
        vid = null;
    }
    
    PlayState.switchToPlayState();
}
