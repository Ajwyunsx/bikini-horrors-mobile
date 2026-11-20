import funkin.backend.shaders.CustomShader;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import funkin.savedata.FunkinSave;
import funkin.savedata.HighscoreEntry;
import sys.FileSystem;
import haxe.io.Path;
import funkin.backend.utils.WindowUtils;
import funkin.menus.FreeplayState.FreeplaySonglist;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.util.FlxColor;

var blackOverlay;
var whiteBg;
var tweenProgress:FlxTween;
var curSelected:Int = 0;
var songs:Array = [];
var covers:Array<FunkinSprite> = [];
var songTitle:FlxText;
var versiontext:FlxText;
var cover;
var fevilMode:Bool = false;
var unheardMode:Bool = false;
var unheardSong;
var mmmSpeedX:Float = 200;
var mmmSpeedY:Float = 200;
var mmmHue:Float = 0;
var isMMM:Bool = false;
var transShader:CustomShader;
var versionShader:CustomShader;
var lastVersionText:String = "";
var ojitos:Array<FlxSprite> = [];
var water:CustomShader = null;
var bloom:CustomShader = null;
var bloom2:CustomShader = null;

var songMixes:Map<String, Array<String>> = [];
var songCutscenes:Map<String, String> = [];

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

var group:FlxSpriteGroup = new FlxSpriteGroup(); 

var angleVelocity:Float = 0;
var stiffness:Float = 0.1;
var damping:Float = 0.82;
var targetAngle:Float = 0;
var shakeStrenght : Float = 0;
var groupDefaultY:Float = 0;
var ojitosCam:FlxCamera;

var char4Glitch:CustomShader = null;
var deepfry:CustomShader = null;
var char4GlitchTimer:Float = 0;

var selectingSong;

static var vOne = [
        "guater-game",
        "f-is-for-fevil",
        "infinete",
        "sunderwater",
        "catch-and-fish",
        "bubbletwister"
];

function create() {
    FlxG.save.data.beatVOne = checkSongsCleared(vOne);
    updateStoryProgress();
    if (FlxG.sound.music == null || FlxG.sound.music.assetPath != Paths.music('freeplay')) {
        FlxG.sound.playMusic(Paths.music('freeplay'), 1.0, true);
    }

    //FlxG.camera.addShader(bloom);

    var shadersEnabled:Bool = Options.shaderQualityAllows(1);
    var highShaders:Bool = Options.shaderQualityAllows(2);
    if (shadersEnabled) {
        water = new CustomShader("waterDistortion");
        water.strength = highShaders ? 0.15 : 0.08;
        water.detail = highShaders ? 30.0 : 16.0;
    }

    if (highShaders) {
        char4Glitch = new CustomShader("glitching");
        char4Glitch.AMT = 3;
    }

    FlxG.camera.bgColor = 0x00000000;

    ojitosCam = new FlxCamera();
    ojitosCam.bgColor = 0x00000000;
    ojitosCam.zoom = FlxG.camera.zoom;

    FlxG.cameras.remove(FlxG.camera, false);
    FlxG.cameras.add(ojitosCam, false);
    FlxG.cameras.add(FlxG.camera, true);

    if (shadersEnabled) {
        if (highShaders) {
            bloom2 = new CustomShader("bloom");
            bloom2.size = 20;
            bloom2.brightness = 10;
            bloom2.directions = 8;
            bloom2.quality = 6;
            ojitosCam.addShader(bloom2);
        }
        if (water != null)
            ojitosCam.addShader(water);
        //ojitosCam.addShader(char4Glitch);

        if (highShaders) {
            deepfry = new CustomShader("deepfried");

            deepfry.strength = 0.0;
            deepfry.darkness = 0.0;
            deepfry.distort = 0.0;

            FlxG.camera.addShader(deepfry);
        }
    } 

    songs = FreeplaySonglist.get().songs;

    if (FlxG.save.data.lastSelectedSong != null) {
        curSelected = FlxG.save.data.lastSelectedSong;
        if (curSelected >= songs.length) curSelected = 0;
    }

    var laPlayaScore = FunkinSave.getSongHighscore('la-playa', 'hard');
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";

    for (i => song in songs) {
        var name = song.displayName.toLowerCase().split(' ').join('-');

        var ojito = new FlxSprite(805, 100);
        ojito.loadGraphic(Paths.image('ojitos/' + name));
        safeSpriteGraphic(ojito, 'ojitos/' + name);
        ojito.scale.set(0.28, 0.28);
        ojito.updateHitbox();
        ojito.ID = i;
        ojito.alpha = 0;

        ojito.camera = ojitosCam;

        ojitos.push(ojito);
        add(ojito);
    }

    whiteBg = new FlxSprite();
    whiteBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    whiteBg.scrollFactor.set(0, 0);
    whiteBg.alpha = 0;
    add(whiteBg);

    bgSprite = new FlxSprite(-95, -430);
    bgSprite.loadGraphic(Paths.image('states/freeplay/bg'));
    safeSpriteGraphic(bgSprite, 'states/freeplay/bg');
    bgSprite.scale.set(0.3, 0.3);
    bgSprite.alpha = 1;
    bgSprite.updateHitbox();
    add(bgSprite);

    boatSprite = new FlxSprite(-100, -430);
    boatSprite.loadGraphic(Paths.image('states/freeplay/boat'));
    safeSpriteGraphic(boatSprite, 'states/freeplay/boat');
    boatSprite.scale.set(0.3, 0.3);
    boatSprite.alpha = 1;
    boatSprite.updateHitbox();
    add(boatSprite);

    signSprite = new FlxSprite(50, -130);
    signSprite.loadGraphic(Paths.image('states/freeplay/sign'));
    safeSpriteGraphic(signSprite, 'states/freeplay/sign');
    signSprite.scale.set(0.3, 0.3);
    signSprite.alpha = 1;
    signSprite.updateHitbox();
    add(signSprite);

    border = new FlxSprite(0, 0);
    border.makeGraphic(1, 1, 0xFF592004);
    border.visible = true;
    add(border);

    for (i => song in songs) {
        var name = song.displayName.toLowerCase().split(' ').join('-');

        cover = new FunkinSprite(0, 0);
        cover.loadGraphic(Paths.image('menus/covers/' + name));
        safeSpriteGraphic(cover, 'menus/covers/' + name);
        cover.scale.set(0.25, 0.25);
        cover.updateHitbox();
        cover.screenCenter();
        cover.x = 110;
        cover.y = 160;
        cover.ID = i;
        cover.alpha = 0;
        covers.push(cover);
        add(cover);
        group.add(cover);
        cover.origin(cover.width / 2, - cover.height +100);
        signSprite.updateHitbox();
    }

    border.setGraphicSize(Std.int(covers[0].width + 10), Std.int(covers[0].height + 10));
    border.updateHitbox();
    border.screenCenter();
    border.x = 105;
    border.y = 155;


    songTitle = new FlxText(0, 50, FlxG.width, "SONG");
    songTitle.setFormat(Paths.font("KrabbyPatty.otf"), 35, 0xFF592004, "center");
    //songTitle.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFFb0b0b0, 1.5, 1);

    versiontext = new FlxText(0, 120, FlxG.width, "VERSION");
    versiontext.setFormat(Paths.font("KrabbyPatty.otf"), 40, 0xFFFFFFFF, "center");
    //versiontext.setBorderStyle(FlxTextBorderStyle.OUTLINE, 0xFF000000, 2, 1);

    transShader = new CustomShader('chalkShader');
    transShader.data.progress.value = [1.0]; 
    //songTitle.shader = transShader;

    versionShader = new CustomShader('chalkShader');
    versionShader.data.progress.value = [1.0];
    versiontext.shader = versionShader;


    add(songTitle);
    addMobilePad("LEFT_RIGHT", "A_B");
    //add(versiontext);
    trace(versiontext);

    songTitle.x = covers[0].x + (covers[0].width / 2) - (songTitle.width / 2);
    versiontext.x = cover.x + (cover.width / 2) - (versiontext.width / 2);
    songTitle.y = cover.y + 430;
    versiontext.y = cover.y + 350;
    group.add(signSprite);
    group.add(songTitle);
    group.add(versiontext);
    group.add(border);
    changeSelection(0);
    signSprite.origin(signSprite.width/2, -500);
    border.origin(border.width / 2, - border.height + 100);
    cover.songTitle(cover.width / 2, - cover.height +300);
}

function postCreate() {
    blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);

    group.y = group.y - 40;

    songMixes = [
        "infinete" => ["infinete", "infinete-es-mix"]
    ];

    songCutscenes = [
        "pool-parti" => "pizza_tower",
        "for-you-someday" => "for-you-someday",
        "Fertility" => "fertility-5",
        "kaka" => "vent-art",
        "steamunlocked" => "sirope/cinematicaintrosirope"
    ];
    
    add(blackOverlay);
    blackOverlay.alpha = 0;
}

var tottalTimer:Float = FlxG.random.float(10, 500);
function update(elapsed:Float) {
    shakeStrenght += (0 - shakeStrenght) * (elapsed * 2.5); 

    if (!selectingSong)
        group.y += (groupDefaultY - group.y) * (elapsed * 10);

    var displacement = group.angle - targetAngle;
    var springForce = -stiffness * displacement;
    angleVelocity += springForce;
    angleVelocity *= damping;
    water?.time = (tottalTimer += elapsed);

    if (char4Glitch != null)
    {
        char4GlitchTimer += elapsed;
    }

    group.angle += angleVelocity;

    /*if (songTitle.text == "MEGA MORTAL MADNESS") {
        isMMM = true;
        songTitle.fieldWidth = 0; 
        songTitle.alignment = "left"; 

        songTitle.x += mmmSpeedX * elapsed;
        songTitle.y += mmmSpeedY * elapsed;

        if (songTitle.x <= 0) {
            songTitle.x = 0;
            mmmSpeedX = Math.abs(mmmSpeedX);
        } else if ((songTitle.x + songTitle.width) >= FlxG.width) {
            songTitle.x = FlxG.width - songTitle.width;
            mmmSpeedX = -Math.abs(mmmSpeedX);
        }

        if (songTitle.y <= 0) {
            songTitle.y = 0;
            mmmSpeedY = Math.abs(mmmSpeedY);
        } else if ((songTitle.y + songTitle.height) >= FlxG.height) {
            songTitle.y = FlxG.height - songTitle.height;
            mmmSpeedY = -Math.abs(mmmSpeedY);
        }

        mmmHue += elapsed * 100;
        if (mmmHue > 360) mmmHue = 0;
        songTitle.color = FlxColor.fromHSB(mmmHue, 1, 1);
        
    } else if (isMMM) {
        isMMM = false;
        songTitle.fieldWidth = FlxG.width;
        songTitle.alignment = "center";
        songTitle.color = 0xFFFFFFFF;
        songTitle.x = cover.x + (cover.width / 2) - (songTitle.width / 2);
        songTitle.y = covers[0].y - 80;
    }*/

    if (!selectingSong)
    {
        if (controls.LEFT) changeSelection(-1);
        if (controls.RIGHT) changeSelection(1);

        if (controls.ACCEPT)
        {
            selectingSong = true;
    
        var songData = songs[curSelected];
        FlxG.save.data.lastSelectedSong = curSelected;
        FlxG.save.flush();

        // --- PARA CANCIONES CON MIXES ---
        if (songMixes.exists(songData.name)) {
            // Store data in the global publicArray
            publicArray = [songMixes.get(songData.name), songData];
            
            persistentUpdate = false;
            openSubState(new ModSubState("ChooseSongMix"));
            return;
        }

        if (songCutscenes.exists(songData.name)){
            publicArray = ["cutscene", songCutscenes[songData.name]];
        }
        else {
            publicArray = [];
        }

       

        FlxG.sound.play(Paths.sound("menu/freeplay_select"), 1);

        var targetZoom:Float = 2.2;
        var moveAmount:Float = 300;
        var moveUpAmount:Float = -110;

        // Save starting positions
        var startMainX = FlxG.camera.scroll.x;
        var startMainY = FlxG.camera.scroll.y;

        var startOjitosX = ojitosCam.scroll.x;
        var startOjitosY = ojitosCam.scroll.y;

        // Zoom both cameras
        FlxTween.tween(FlxG.camera, {
            zoom: targetZoom
        }, 4, {
            ease: FlxEase.quadInOut
        });

        FlxTween.tween(ojitosCam, {
            zoom: targetZoom
        }, 4, {
            ease: FlxEase.quadInOut
        });

        // Move main camera right
        FlxTween.num(startMainX, startMainX + moveAmount, 4, {
            ease: FlxEase.quadInOut
        }, function(v:Float)
        {
            FlxG.camera.scroll.x = v;
        });

        // Move main camera up
        FlxTween.num(startMainY, startMainY + moveUpAmount, 4, {
            ease: FlxEase.quadInOut
        }, function(v:Float)
        {
            FlxG.camera.scroll.y = v;
        });

        // Move ojitos camera right
        FlxTween.num(startOjitosX, startOjitosX + moveAmount, 4, {
            ease: FlxEase.quadInOut
        }, function(v:Float)
        {
            ojitosCam.scroll.x = v;
        });

        // Move ojitos camera up
        FlxTween.num(startOjitosY, startOjitosY + moveUpAmount, 4, {
            ease: FlxEase.quadInOut
        }, function(v:Float)
        {
            ojitosCam.scroll.y = v;
        });
        
        for (o in ojitos)
        {
            FlxTween.cancelTweensOf(o);
            o.alpha = 0;
        }

        if (deepfry != null) {
            FlxTween.num(0, 1, 5, {
            ease: FlxEase.quadIn
            }, function(v:Float)
            {
                deepfry.strength = v;
                deepfry.darkness = v * 0.55;
                deepfry.distort = v * 0.025;
            });
        }

        var selectedOjo = ojitos[curSelected];

        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();

        FlxTween.tween(group, {y: -1000}, 1, {
            ease: FlxEase.quadIn
            
        });

                FlxTween.tween(selectedOjo, {alpha: 0.1}, 4, {
                ease: FlxEase.quadOut,
                onComplete: function(_)
                {
                    var fadeBlock = new FlxSprite();
                    fadeBlock.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
                    fadeBlock.scrollFactor.set(0, 0);
                    fadeBlock.cameras = [FlxG.camera];
                    fadeBlock.alpha = 1;

                    add(fadeBlock);

                    new FlxTimer().start(2.5, function(_)
                    {
                         // --- PARA ALEATORIEDAD DE MR RETRO ---
                        if (songs[curSelected].name == "so-retro") {
                            var realData = null;
                            var retroData = null;
                            realData = FunkinSave.getSongHighscore('realbobb', 'real').score;
                            retroData = FunkinSave.getSongHighscore('so-retro', 'hard').score;
                            trace("realdata " + realData + " retrodata " + retroData);
                            if (retroData > 0 && realData > 0){
                                getRetroVariant(2);
                                return;
                            };
                            if (retroData == 0 && realData == 0) {
                                getRetroVariant(2);
                                return;
                            };
                            else{
                                if (realData == 0){
                                    getRetroVariant(1);
                                    return;
                                };
                                else{
                                    getRetroVariant(0);
                                    return;
                                };
                            };
                        }
                        PlayState.loadSong(songData.name, songData.difficulties[0]);
                        FlxG.switchState(new ModState("StartCredits"));
                    });
                }
            });

        
    }

    if (controls.ESCAPE) {
        FlxG.save.data.lastSelectedSong = curSelected;
        FlxG.save.flush(); 
        FlxG.switchState(new ModState("BHTitleState"));
    }

    }
}


function changeSelection(change:Int = 0) {

    if (char4Glitch != null)
    {
        char4Glitch.AMT = 5;

        FlxTween.cancelTweensOf(char4Glitch);

        FlxTween.num(5, 0, 0.3, {
            ease: FlxEase.expoOut
        }, function(v:Float)
        {
            char4Glitch.AMT = v;
        });
    }

    shakeStrenght += 1;
    FlxG.sound.play(Paths.sound("chains" + (FlxG.random.int(1,4))), 2);
    group.y = groupDefaultY + 15 + ((shakeStrenght-1)*10);
    angleVelocity += 1 * change * (shakeStrenght);
    curSelected += change;
    if (curSelected < 0) curSelected = songs.length - 1;
    if (curSelected >= songs.length) curSelected = 0;

    songTitle.text = "< " + songs[curSelected].displayName.toUpperCase() + " >";

    var nextVersion:String = "";
    if (curSelected >= 0 && curSelected <= 6) {
        nextVersion = "-v1-";
    } else if (curSelected >= 7 && curSelected <= 10) {
        nextVersion = "-v2-";
    } else {
        nextVersion = "-v3-";
    }
    
    if (songs[curSelected].name.toLowerCase() == "mega-mortal-madness") nextVersion = " ";

    if (nextVersion != lastVersionText) {
        versiontext.text = nextVersion;
        lastVersionText = nextVersion;

        versionShader.data.progress.value = [0.0];
        FlxTween.num(0.0, 1.0, 1, {ease: FlxEase.quadOut}, function(v:Float) {
            versionShader.data.progress.value = [v];
        });
    }
    if (tweenProgress != null){
        tweenProgress.cancel();
    }
    transShader.data.progress.value = [0.0];
    tweenProgress = FlxTween.num(0.0, 1, 1.5, {ease: FlxEase.expoOut}, function(v:Float) {
        transShader.data.progress.value = [v];
    });

    for (i in 0...covers.length) {
        var curCover = covers[i];
        if (curCover.ID == curSelected) {
            curCover.alpha = 1;
        } else {
            curCover.alpha = 0;
        }
    }

    for (i in 0...ojitos.length) {
        var curOjo = ojitos[i];

        if (curOjo.ID == curSelected) {
            curOjo.x = 807;
            curOjo.alpha = 0;
        } else {
            curOjo.alpha = 0;
        }
    }


    var selectedName:String = songs[curSelected].name.toLowerCase();

    if (selectedName == "unheard") {
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
    else{
        if(unheardMode){
            trace("A");
            stopUnheardPreview();
            FlxTween.cancelTweensOf(blackOverlay);
            blackOverlay.alpha = 0;
            whiteBg.alpha = 0;
            unheardMode = false;
            setMenuMusicVolume(1.0);
            bgSprite.alpha = 1;
            boatSprite.alpha = 1;
        }
    }

    if (selectedName == "f-is-for-fevil") {

        if (!fevilMode) {
            fevilMode = true;

            setMenuMusicVolume(0);

            bgSprite.alpha = 0;
            boatSprite.alpha = 0;

        }

    } else {
        if (selectedName == "mega-mortal-madness") versiontext.text = " ";

        if (fevilMode) {
            fevilMode = false;

            setMenuMusicVolume(1.0);

            bgSprite.alpha = 1;
            boatSprite.alpha = 1;
        }

    }
}

function getRetroVariant(val){
    if (val == 2){
        if (FlxG.random.bool(50)){
            PlayState.loadSong("realbobb", "real");
            PlayState.switchToPlayState();
            return;
        };
        else{
            PlayState.loadSong("so-retro", "hard");
            PlayState.switchToPlayState();
        };
    };
    if (val==1){
            PlayState.loadSong("realbobb", "real");
            PlayState.switchToPlayState();
    };
    if (val == 0){
            PlayState.loadSong("so-retro", "hard");
            PlayState.switchToPlayState();
    };
}

static function checkSongsCleared(songList:Array){ 
    var allCleared = true;
    for (song in songList) {
        var entry = FunkinSave.getSongHighscore(song, "hard");
        if (entry.score <= 0) {
            allCleared = false;
            trace("chain broke at" + song);
            break;
        }
    }
    trace(allCleared);
    return allCleared;
}

function updateStoryProgress() {
    var progress = 0;
    
    // Perform your song/achievement checks here
    if (FlxG.save.data.beatVOne) progress = 1;
    if (FlxG.save.data.beatVThree) progress = 2;
    
    // Store it permanently
    FlxG.save.data.storyStage = progress;
    FlxG.save.flush();
}
