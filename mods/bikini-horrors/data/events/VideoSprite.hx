import funkin.backend.system.FunkinFullscreenCamera;
import funkin.backend.system.FunkinMobileScaleMode;
// Script by Aika
import hxvlc.flixel.FlxVideoSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxTimer;
import flixel.util.FlxPoint;
import flixel.FlxState;
import funkin.backend.utils.VideoPauseUtil;

public var currentVid:FlxVideoSprite;
var vidList:Map<String, FlxVideoSprite> = [];
var camVideo:FunkinFullscreenCamera;

function postCreate() {
    camVideo = new FunkinFullscreenCamera();
    camVideo.visible = false;
    camVideo.onViewportResize = function() {
        camVideo.bgColor = FunkinMobileScaleMode.isAdaptive() ? 0xFF000000 : 0;
        for (v in vidList)
            if (v.bitmap != null && v.bitmap.bitmapData != null)
                camVideo.layoutMedia(v);
    };
    camVideo.onViewportResize();
    FlxG.cameras.insert(camVideo, FlxG.cameras.list.indexOf(camHUD), false);

    for (event in PlayState.SONG.events) {
        if (event.name == "VideoSprite") {
            var vidName = event.params[0];
            
            if (vidList.exists(vidName)) continue;

            var v = new FlxVideoSprite(0, 0);
            v.antialiasing = true;
            v.cameras = [camVideo];
            v.scrollFactor.set(0, 0);
            
            v.bitmap.onFormatSetup.add(function():Void {
                if (v.bitmap != null && v.bitmap.bitmapData != null)
                    camVideo.layoutMedia(v);
            });

            v.visible = false;
            add(v);
            v.autoPause = false;

            if (v.load(Paths.video(vidName), [":hwdec=auto", ":input-repeat=0"])) {
                vidList.set(vidName, v);
            }
        }
    }
}

function onVideoEnd():Void {
    camVideo.visible = false;
    if (currentVid != null) {
        currentVid.visible = false;
        currentVid.stop();
        currentVid.bitmap.onEndReached.remove(onVideoEnd);
        currentVid = null;
    }
}

function onEvent(event) {
    if (event.event.name == "VideoSprite") {
        var vidName = event.event.params[0];
        
        if (currentVid != null) {
            currentVid.bitmap.onEndReached.remove(onVideoEnd);
            currentVid.stop();
            currentVid.visible = false;
            currentVid = null;
            camVideo.visible = false;
        }

        var v = vidList.get(vidName);
        if (v == null) return;

        currentVid = v;
        camVideo.visible = true;
        currentVid.visible = true;
        currentVid.bitmap.onEndReached.add(onVideoEnd);
        
        currentVid.play();
    }
}


function onGamePause() {
    if (currentVid != null && currentVid.visible) {
        currentVid.pause();
    }
}

function onGameResume() {
    if (currentVid != null && currentVid.visible && !PlayState.instance.paused) {
        currentVid.resume();
    }
}

function update(elapsed) {
    if (!PlayState.instance.paused && currentVid != null && currentVid.visible) {
        if (!currentVid.bitmap.isPlaying) currentVid.resume();
    }
}

function onFocusLost() {
    if (!FlxG.autoPause) return;
    if (currentVid != null) currentVid.pause();
}

function onFocus() {
    if (!FlxG.autoPause || paused) return;
    if (!PlayState.instance.paused && VideoPauseUtil.canAutoResume() && currentVid != null) {
        currentVid.resume();
    }
}

function destroy() {
    for (v in vidList) {
        v.stop();
        v.destroy();
    }
    vidList.clear();
}
