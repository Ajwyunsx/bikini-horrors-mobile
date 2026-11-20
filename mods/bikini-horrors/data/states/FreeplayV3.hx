import BaseFreeplay;

var baseFree:BaseFreeplay;

var group:FlxSpriteGroup = new FlxSpriteGroup();

var angleVelocity:Float = 0;
var stiffness:Float = 0.1;
var damping:Float = 0.82;
var targetAngle:Float = 0;

var shakeStrength:Float = 0;
var groupDefaultY:Float = 0;

//Song exclusives
var fevilMode:Bool = false;

var unheardMode:Bool = false;
var unheardSong;
var prisonHitSound;

var blackOverlay;
var whiteBg;

//for megamortalmadness

var megamortalMode:Bool=false;

var isMMM:Bool = false;
var mmmSpeedX:Float = 200;
var mmmSpeedY:Float = 200;
var mmmHue:Float = 0;

var horrorNotif:FlxSprite;
var showNotif:Bool = false;

function safeSpriteGraphic(sprite:FlxSprite, label:String):FlxSprite
{
    if (sprite != null && sprite.graphic == null)
    {
        trace('Missing freeplay sprite graphic: ' + label);
        sprite.makeGraphic(1, 1, 0x00000000);
        sprite.visible = false;
        sprite.alpha = 0;
    }
    return sprite;
}

function create(){
    baseFree = new BaseFreeplay(this,3);
}

function setMenuMusicVolume(volume:Float)
{
    var musicObj:Dynamic = null;

    try {
        musicObj = FlxG.sound.music;
    } catch(e:Dynamic) {
        musicObj = null;
    }

    if (musicObj == null) return;

    if (FlxG.onMobile) {
        try {
            if (volume <= 0)
                musicObj.pause();
            else
                musicObj.resume();
        } catch(e:Dynamic) {}
    } else {
        try {
            musicObj.volume = volume;
        } catch(e:Dynamic) {}
    }
}

function fadeUnheardPreview()
{
    if (unheardSong == null) return;

    if (FlxG.onMobile) return;

    try {
        FlxTween.cancelTweensOf(unheardSong);
        FlxTween.tween(unheardSong, {volume:0.2}, 2);
    } catch(e:Dynamic) {
        try {
            unheardSong.volume = 0.2;
        } catch(e2:Dynamic) {
            unheardSong = null;
        }
    }
}

function stopUnheardPreview()
{
    if (unheardSong == null) return;

    try {
        FlxTween.cancelTweensOf(unheardSong);
    } catch(e:Dynamic) {}

    if (!FlxG.onMobile) {
        try {
            unheardSong.volume = 0;
        } catch(e:Dynamic) {}
    }

    try {
        unheardSong.stop();
    } catch(e:Dynamic) {}

    unheardSong = null;
}

function postCreate()
{
    trace(FlxG.save.data.lastSeenStage);
    trace(FlxG.save.data.storyStage);
    showNotif = checkStoryProgression(); 
    baseFree.music="freeplay";
    baseFree.playSong();
    megamortalMode = FlxG.save.data.megaMortalMode;
    trace(FlxG.save.data.megaMortalMode);
    horrorNotif = new FlxSprite(10, FlxG.height, Paths.image("menus/horror_notif"));
    safeSpriteGraphic(horrorNotif, "menus/horror_notif");
    horrorNotif.alpha = 0;

    if (showNotif){
        horrorNotif.alpha = 1;
        if (shouldPlayPrisonHitNotification())
            prisonHitSound = FlxG.sound.play(Paths.sound('prison-hit'), 0.5, false);
    }

    //Data for songs
    baseFree.songMixes = [
        "infinete" => ["infinete", "infinete-es-mix"]
    ];

    baseFree.songCutscenes = [
        "pool-parti" => "pizza_tower",
        "for-you-someday" => "for-you-someday",
        "Fertility" => "fertility-5",
        "kaka" => "vent-art",
        "steamunlocked" => "sirope/cinematicaintrosirope"
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

    //background creation
    createBG();

    //initialize the baseFreeplay

    baseFree.createEyes();
    baseFree.createUI();

    add(horrorNotif);

    //add items to the group
    group.add(signSprite);
    group.add(baseFree.songTitle);
    for (cover in baseFree.covers){
        group.add(cover);
    }
    group.add(baseFree.border);

    if (freeze != null){
        group.add(freeze);
        freeze.origin(freeze.width / 2, freeze.height / 2);
    }

    //gotta set the callback or else...
    baseFree.onSelectionChanged = onSelectionChanged;

    if (freeze != null){
        add(freeze);
        baseFree.moveFreeze = true;
        baseFree.selectSong("mega-mortal-madness");
    }

    

    baseFree.changeSelection(0);
    add(blackOverlay);
    FlxTween.tween(horrorNotif, {y:FlxG.height - 80}, 1, {startDelay: 1, ease:FlxEase.expoOut});
}

function update(elapsed:Float)
{
    baseFree.update(elapsed);
    shakeStrength *= 0.99;

    //sign physics update

    group.y += (groupDefaultY - group.y) * elapsed * 15;

    var displacement = group.angle - targetAngle;

    var springForce = -stiffness * displacement;

    angleVelocity += springForce;

    angleVelocity *= damping;

    group.angle += angleVelocity;

    //Megamortal update
    updateMMM(elapsed);
}

//Callback

function onSelectionChanged(change:Int)
{
    //shake the sign
    shakeStrength += 1.05;
    //sounds
    FlxG.sound.play(
        Paths.sound(
            "chains" + FlxG.random.int(1,4)
        ),
        2
    );

    group.y = groupDefaultY + 15 + ((shakeStrength-1)*10);
    angleVelocity += change * shakeStrength;

    //song specials
    updateSongModes();
}


function updateSongModes()
{
    var selectedName = baseFree.songs[baseFree.curSelected].name.toLowerCase();

    //Unheard

    if (selectedName == "unheard")
    {
        if (unheardSong == null){
            unheardSong = FlxG.sound.play(Paths.music('unheard_fp'), 0.2, true);
        }
        fadeUnheardPreview();
        
        unheardMode = true;
        setMenuMusicVolume(0);

        whiteBg.alpha = 1;
        blackOverlay.alpha = 1;
        FlxTween.tween(blackOverlay, {alpha:0}, 2);

        bgSprite.alpha = 0;
        boatSprite.alpha = 0;
    }
    else if (unheardMode)
    {
            stopUnheardPreview();
            FlxTween.cancelTweensOf(blackOverlay);
            blackOverlay.alpha = 0;
            whiteBg.alpha = 0;
            unheardMode = false;
            setMenuMusicVolume(1.0);
            bgSprite.alpha = 1;
            boatSprite.alpha = 1;
    }

    //Fevil

    if (selectedName == "f-is-for-fevil")
    {
        fevilMode = true;

        setMenuMusicVolume(0);

        bgSprite.alpha = 0;
        boatSprite.alpha = 0;
    }
    else if (fevilMode)
    {
        fevilMode = false;

        setMenuMusicVolume(1);

        bgSprite.alpha = 1;
        boatSprite.alpha = 1;
    }
}

//mmm

function updateMMM(elapsed:Float)
{
    if (
        baseFree.songTitle.text != "< MEGA MORTAL MADNESS >"
    )
    {
        if (isMMM)
        {
            isMMM = false;

            baseFree.songTitle.color =
                0xFF592004;
        }

        return;
    }

    isMMM = true;

    mmmHue += elapsed * 100;

    if (mmmHue > 360)
        mmmHue = 0;

    baseFree.songTitle.color =
        FlxColor.fromHSB(
            mmmHue,
            1,
            1
        );
}

var freeze:FlxSprite;

function createBG()
{
    var path_bg:String="states/freeplay/bg";
    var path_boat:String="states/freeplay/boat";
    var path_sign:String="states/freeplay/sign";

    if (megamortalMode){
        path_bg = "states/freeplay_frozen/bg";
        path_boat = "states/freeplay_frozen/boat";
        path_sign = "states/freeplay_frozen/sign";
        freeze = new FlxSprite(50, -150, Paths.image("states/freeplay_frozen/freeze"));
        safeSpriteGraphic(freeze, "states/freeplay_frozen/freeze");
        freeze.scale.set(0.3,0.3);
        freeze.updateHitbox();
    }

    bgSprite = new FlxSprite(-95, -430);
    bgSprite.loadGraphic(Paths.image(path_bg));
    safeSpriteGraphic(bgSprite, path_bg);
    bgSprite.scale.set(0.3, 0.3);
    bgSprite.updateHitbox();
    add(bgSprite);

    boatSprite = new FlxSprite(-100, -430);
    boatSprite.loadGraphic(Paths.image(path_boat));
    safeSpriteGraphic(boatSprite, path_boat);
    boatSprite.scale.set(0.3, 0.3);
    boatSprite.updateHitbox();
    add(boatSprite);

    signSprite = new FlxSprite(50, -150);
    signSprite.loadGraphic(Paths.image(path_sign));
    safeSpriteGraphic(signSprite, path_sign);
    signSprite.scale.set(0.3, 0.3);
    signSprite.updateHitbox();
    add(signSprite);

    border = new FlxSprite();
    border.makeGraphic(1,1,0xFF532A14);
    add(border);

    if (megamortalMode){
        
        freeze.x -= 55;
        freeze.y += 50;
    }
}

function destroySoundSafe(sound) {
    if (sound != null && sound.exists) {
        sound.stop();
        sound.destroy();
    }
}

function destroy() {
    destroySoundSafe(prisonHitSound);
    destroySoundSafe(unheardSong);
    prisonHitSound = null;
    unheardSong = null;
}
