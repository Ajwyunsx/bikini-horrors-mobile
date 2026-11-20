import funkin.backend.system.FunkinFullscreenCamera;
import funkin.backend.system.FunkinMobileScaleMode;
import funkin.backend.week.Week;
import flixel.util.FlxColor;
import hxvlc.flixel.FlxVideoSprite;

import flixel.util.FlxTimer;

var videoTimer:FlxTimer;
var randomVideos:Array<String> = [
    "joder/A",
    "joder/D",
    "joder/I",
    "joder/O",
    "joder/S"
];


var vid:FlxVideoSprite;

var bgSprite:FlxSprite;
var curSelected:Int = 0;
var coversArray:Array<FlxSprite> = [];
var coverSpacing:Float = 280;
var baseScale:Float = 0.9;
var selectedScale:Float = 0.95;

var blackOverlay;


function create() {
    bgSprite = new FlxSprite(-280, -150).loadGraphic(Paths.image('states/rumbeling/suelo'));
    bgSprite.scale.set(0.7, 0.7);
    bgSprite.updateHitbox();
    add(bgSprite);

    godhand = new FlxSprite(290, 50);
    godhand.frames = Paths.getSparrowAtlas('states/rumbeling/godhand');
    godhand.animation.addByPrefix('idle', 'idle', 24, true);
    godhand.scale.set(0.7, 0.7);
    godhand.updateHitbox();
    godhand.animation.play('idle');
    add(godhand);

    daimago = new FlxSprite(-150, 140);
    daimago.frames = Paths.getSparrowAtlas('states/rumbeling/daimago_final');
    daimago.animation.addByPrefix('idle', 'daimago_idle', 24, true);
    daimago.animation.addByPrefix('ready', 'daimago_ready', 24, true);
    daimago.scale.set(0.7, 0.7);
    daimago.updateHitbox();
    daimago.alpha= 0.5;
    daimago.animation.play('idle');
    add(daimago);

    pacma = new FlxSprite(600, 20);
    pacma.frames = Paths.getSparrowAtlas('states/rumbeling/pacma_final');
    pacma.animation.addByPrefix('idle', 'pacma_idle', 24, true);
    pacma.animation.addByPrefix('ready', 'pacma_ready', 24, true);
    pacma.scale.set(0.7, 0.7);
    pacma.updateHitbox();
    pacma.alpha= 0.5;
    pacma.animation.play('idle');
    add(pacma);

    nombres = new FlxSprite(-80, 380).loadGraphic(Paths.image('states/rumbeling/nombres'));
    nombres.scale.set(0.62, 0.62);
    nombres.updateHitbox();
    add(nombres);

    left = new FunkinSprite(520, 600, Paths.image("states/rumbeling/leftArrow"));
    left.frames = Paths.getSparrowAtlas('states/rumbeling/leftArrow');
    left.addAnim('idle', 'leftIdle', 24, true);
    left.addAnim('leftConfirm', 'leftConfirm', 24, false);
    left.scale.set(0.7, 0.7);
    left.addOffset("leftConfirm", 10, 10);
    left.updateHitbox();
    left.playAnim('idle');
    add(left);

    right = new FunkinSprite(660, 600, Paths.image("states/rumbeling/rightArrow"));
    right.addAnim('idle', 'rightIdle', 24, true);
    right.addAnim('rightConfirm', 'rightConfirm', 24, false);
    right.scale.set(0.7, 0.7);
    right.addOffset("rightConfirm", 10, 10);
    right.updateHitbox();
    right.playAnim('idle');
    add(right);

    


    if (FlxG.sound.music == null || FlxG.sound.music.assetPath != Paths.music('party_hard')) {
        FlxG.sound.playMusic(Paths.music('party_hard'), 1.0, true);
    }
    


    changeSelection(0, false);


    

    blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 1;
    add(blackOverlay);

    startRandomVideoLoop();
}

function startRandomVideoLoop()
{
    if (!randomVideosEnabled)
        return;

    if (videoTimer != null)
        videoTimer.cancel();

    videoTimer = new FlxTimer().start(20, function(tmr:FlxTimer)
    {
        playRandomVideo();
    });
}

function playRandomVideo()
{
    if (!randomVideosEnabled)
        return;

    var randomIndex:Int = FlxG.random.int(0, randomVideos.length - 1);
    startRandomLoopVideo(randomVideos[randomIndex]);
}

function startRandomLoopVideo(name:String)
{
    var ext = "mp4";

    vid = new FlxVideoSprite();
    vid.autoVolumeHandle = false;
    add(vid);

    vid.bitmap.onFormatSetup.add(function()
    {
        if (FunkinMobileScaleMode.isAdaptive())
            FunkinFullscreenCamera.layoutSprite(vid, FlxG.width, FlxG.height, true);
        else {
            vid.setGraphicSize(FlxG.width, FlxG.height);
            vid.updateHitbox();
            vid.screenCenter();
        }
    });

    if (vid.load(Paths.video(name, ext)))
    {
        vid.bitmap.onEndReached.add(function()
        {
            if (vid != null)
            {
                vid.stop();
                remove(vid);
                vid.destroy();
                vid = null;
            }

            startRandomVideoLoop();
        });

        vid.play();
    }
}

var randomVideosEnabled:Bool = true;

function stopRandomVideoLoop()
{
    randomVideosEnabled = false;

    if (videoTimer != null)
    {
        videoTimer.cancel();
        videoTimer = null;
    }

    if (vid != null)
    {
        vid.stop();
        remove(vid);
        vid.destroy();
        vid = null;
    }
}

var selectedDirection:Int = 0;

function update(elapsed:Float) {

    if (freezeControls) {
        return;
    }

    if (FlxG.keys.justPressed.LEFT) {
        left.playAnim('leftConfirm');
        right.playAnim('idle');

        daimago.animation.play('ready');
        pacma.animation.play('idle');

        selectedDirection = -1;
    }

    if (FlxG.keys.justPressed.RIGHT) {
        right.playAnim('rightConfirm');
        left.playAnim('idle');

        daimago.animation.play('idle');
        pacma.animation.play('ready');

        selectedDirection = 1;
    }


    if (FlxG.keys.justPressed.ENTER)
    {
        stopRandomVideoLoop();

        if (selectedDirection == -1)
        {
            startVideo("rumbeling/daimago_culo");
        }

        if (selectedDirection == 1)
        {
            startVideo("rumbeling/pacma_culo");
        }

        remove(right);
        remove(left);
        remove(daimago);
        remove(pacma);
        remove(godhand);
        remove(bgSprite);
        remove(nombres);
    }

    new FlxTimer().start(1, function(timer:FlxTimer)
    {
        FlxTween.tween(blackOverlay, {alpha: 0}, 5, {
            onComplete: function(twn:FlxTween)
            {
                remove(blackOverlay);
                blackOverlay.destroy();
            }
        });
    });

}


function changeSelection(change:Int = 0, playSound:Bool = true) {
    curSelected += change;

    if (curSelected < 0) curSelected = coversArray.length - 1;
    if (curSelected >= coversArray.length) curSelected = 0;
}

function selectVersion(index:Int) {
    if (index == 1 && !isV2Unlocked) {
        return; 
    }

    publicArray[0] = index; 
    FlxG.switchState(new ModState("VersionHandler")); 
}

var freezeControls:Bool = false;

function startVideo(name:String) {

    freezeControls = true;
    FlxG.sound.music.stop();

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
