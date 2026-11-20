import BaseFreeplay;

var baseFree:BaseFreeplay;

var group:FlxSpriteGroup = new FlxSpriteGroup();

var angleVelocity:Float = 0;
var stiffness:Float = 0.1;
var damping:Float = 0.82;
var targetAngle:Float = 0;

var shakeStrength:Float = 0;
var groupDefaultY:Float = 0;

var fevilMode:Bool = false;

var unheardMode:Bool = false;
var unheardSong:Dynamic = null;

var blackOverlay:FlxSprite;
var whiteBg:FlxSprite;

var bgSprite:FlxSprite;
var boatSprite:FlxSprite;
var signSprite:FlxSprite;
var border:FlxSprite;

var isMMM:Bool = false;
var mmmSpeedX:Float = 200;
var mmmSpeedY:Float = 200;
var mmmHue:Float = 0;

function callSafe(obj:Dynamic, func:String)
{
    if (obj == null) return;

    try
    {
        var f = Reflect.field(obj, func);
        if (f != null)
            Reflect.callMethod(obj, f, []);
    }
    catch(e:Dynamic)
    {
    }
}

function getMusicObj():Dynamic
{
    if (FlxG.sound == null) return null;

    try
    {
        return Reflect.field(FlxG.sound, "music");
    }
    catch(e:Dynamic)
    {
        return null;
    }

    return null;
}

function pauseMainMusic()
{
    var musicObj:Dynamic = getMusicObj();

    if (musicObj != null)
        callSafe(musicObj, "pause");
}

function resumeMainMusic()
{
    var musicObj:Dynamic = getMusicObj();

    if (musicObj != null)
        callSafe(musicObj, "resume");
}

function stopSoundSafe(snd:Dynamic)
{
    if (snd == null) return;

    try
    {
        FlxTween.cancelTweensOf(snd);
    }
    catch(e:Dynamic)
    {
    }

    callSafe(snd, "stop");
    callSafe(snd, "destroy");
}

function postCreate()
{
    baseFree = new BaseFreeplay(this, 1);
    baseFree.music = "freeplay";
    baseFree.playSong();

    baseFree.songMixes = [
        "infinete" => ["infinete", "infinete-es-mix"]
    ];

    baseFree.songCutscenes = [
        "pool-parti" => "pizza_tower",
        "for-you-someday" => "for-you-someday",
        "Fertility" => "fertility-5",
        "kaka" => "vent-art"
    ];

    whiteBg = new FlxSprite();
    whiteBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    whiteBg.scrollFactor.set(0, 0);
    whiteBg.alpha = 0;
    add(whiteBg);

    blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 0;

    createBG();

    baseFree.createEyes();
    baseFree.createUI();

    group.add(signSprite);
    group.add(baseFree.songTitle);

    for (cover in baseFree.covers)
    {
        group.add(cover);
    }

    group.add(baseFree.border);

    baseFree.onSelectionChanged = onSelectionChanged;

    baseFree.changeSelection(0);

    add(blackOverlay);
}

function update(elapsed:Float)
{
    if (baseFree != null)
        baseFree.update(elapsed);

    shakeStrength *= 0.99;

    group.y += (groupDefaultY - group.y) * elapsed * 15;

    var displacement = group.angle - targetAngle;
    var springForce = -stiffness * displacement;

    angleVelocity += springForce;
    angleVelocity *= damping;

    group.angle += angleVelocity;

    updateMMM(elapsed);
}

function onSelectionChanged(change:Int)
{
    shakeStrength += 1.05;

    try
    {
        FlxG.sound.play(
            Paths.sound("chains" + FlxG.random.int(1, 4)),
            2
        );
    }
    catch(e:Dynamic)
    {
    }

    group.y = groupDefaultY + 15 + ((shakeStrength - 1) * 10);
    angleVelocity += change * shakeStrength;

    updateSongModes();
}

function updateSongModes()
{
    if (baseFree == null) return;
    if (baseFree.songs == null) return;
    if (baseFree.curSelected < 0) return;
    if (baseFree.curSelected >= baseFree.songs.length) return;

    var selectedName:String = baseFree.songs[baseFree.curSelected].name.toLowerCase();

    if (selectedName == "unheard")
    {
        if (unheardSong == null)
        {
            try
            {
                unheardSong = FlxG.sound.load(Paths.music("unheard_fp"), 0.2, true);

                if (unheardSong != null)
                    callSafe(unheardSong, "play");
            }
            catch(e:Dynamic)
            {
                unheardSong = null;
            }
        }

        unheardMode = true;

        pauseMainMusic();

        whiteBg.alpha = 1;
        blackOverlay.alpha = 1;

        try
        {
            FlxTween.cancelTweensOf(blackOverlay);
            FlxTween.tween(blackOverlay, {alpha: 0}, 2);
        }
        catch(e:Dynamic)
        {
        }

        bgSprite.alpha = 0;
        boatSprite.alpha = 0;
    }
    else if (unheardMode)
    {
        stopSoundSafe(unheardSong);
        unheardSong = null;

        try
        {
            FlxTween.cancelTweensOf(blackOverlay);
        }
        catch(e:Dynamic)
        {
        }

        blackOverlay.alpha = 0;
        whiteBg.alpha = 0;

        unheardMode = false;

        resumeMainMusic();

        bgSprite.alpha = 1;
        boatSprite.alpha = 1;
    }

    if (selectedName == "f-is-for-fevil")
    {
        if (!fevilMode)
        {
            fevilMode = true;
            pauseMainMusic();
        }

        bgSprite.alpha = 0;
        boatSprite.alpha = 0;
    }
    else if (fevilMode)
    {
        fevilMode = false;

        resumeMainMusic();

        bgSprite.alpha = 1;
        boatSprite.alpha = 1;
    }
}

function updateMMM(elapsed:Float)
{
    if (baseFree == null) return;
    if (baseFree.songTitle == null) return;

    if (baseFree.songTitle.text != "< MEGA MORTAL MADNESS >")
    {
        if (isMMM)
        {
            isMMM = false;
            baseFree.songTitle.color = 0xFF592004;
        }

        return;
    }

    isMMM = true;

    mmmHue += elapsed * 100;

    if (mmmHue > 360)
        mmmHue = 0;

    baseFree.songTitle.color = FlxColor.fromHSB(
        mmmHue,
        1,
        1
    );
}

function createBG()
{
    bgSprite = new FlxSprite(-95, -430);
    bgSprite.loadGraphic(Paths.image("states/freeplay/bg"));
    bgSprite.scale.set(0.3, 0.3);
    bgSprite.updateHitbox();
    add(bgSprite);

    boatSprite = new FlxSprite(-100, -430);
    boatSprite.loadGraphic(Paths.image("states/freeplay/boat"));
    boatSprite.scale.set(0.3, 0.3);
    boatSprite.updateHitbox();
    add(boatSprite);

    signSprite = new FlxSprite(50, -150);
    signSprite.loadGraphic(Paths.image("states/freeplay/sign"));
    signSprite.scale.set(0.3, 0.3);
    signSprite.updateHitbox();
    add(signSprite);

    border = new FlxSprite();
    border.makeGraphic(1, 1, 0xFF532A14);
    add(border);
}

function destroy()
{
    stopSoundSafe(unheardSong);
    unheardSong = null;

    resumeMainMusic();
}
