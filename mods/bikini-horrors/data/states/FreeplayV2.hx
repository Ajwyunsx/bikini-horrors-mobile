import BaseFreeplay;
import funkin.savedata.FunkinSave;

var dialogueScript = importScript("data/scripts/DialogueManager");

var baseFree:BaseFreeplay;

var dialogue;
var phanes;

var blackOverlay;
var whiteBg;

var unheardMode:Bool = false;
var unheardSong;

var pendingSong:String = null;
var enteringSong:Bool = false;
var dialogueActive:Bool = false;

var totalTime:Float = 0;
var uiOffsetX:Float = 0;
var uiOffsetY:Float = 0;
var uiTween:FlxTween;
var uiTween2:FlxTween;
var lastSelection:Int = -1;
var ui:Dynamic;

var correCorreMode:Bool = false;

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
    baseFree = new BaseFreeplay(this,2);
    
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
    whiteBg = new FlxSprite();
    whiteBg.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
    whiteBg.scrollFactor.set(0, 0);
    whiteBg.alpha = 0;
    add(whiteBg);
    
    blackOverlay = new FlxSprite();
    blackOverlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
    blackOverlay.scrollFactor.set(0, 0);
    blackOverlay.alpha = 0;


    correCorreMode = FlxG.save.data.CorreCorreMode;
    
    if (correCorreMode){
        baseFree.moveFreeze = true;
        baseFree.selectSong("corre-corre-que-te-pillo");
    }

    baseFree.songCutscenes = [
        "pool-parti" => "pizza_tower",
        "for-you-someday" => "for-you-someday",
        "Fertility" => "fertility-5",
        "kaka" => "vent-art",
        "steamunlocked" => "sirope/cinematicaintrosirope"
    ];
    
    checkStoryProgression();
    if( FlxG.save.data.clearedSongs.contains("unheard"))
        baseFree.music="dim_light";
    else
        baseFree.music="gnomes_garden";
    baseFree.playSong();
    baseFree.createEyes();
    createBG();
    baseFree.createUI();


    baseFree.border.makeGraphic(1, 1, 0xFF000000);

    baseFree.border.setGraphicSize(
            Std.int(1667*0.20 + 10),
            Std.int(1667*0.20 + 10)
        );

    baseFree.border.updateHitbox();
    baseFree.border.screenCenter();

    baseFree.border.x = 105;
    baseFree.border.y = 155 - 10;

    baseFree.songTitle.setFormat(
            Paths.font("KrabbyPatty.otf"),
            35,
            0xFF000000,
            "center"
        );

    for (cover in baseFree.covers)
    {
        cover.scale.set(0.20, 0.20);
        cover.updateHitbox();
        //cover.origin.set(cover.width / 2, cover.height);

        cover.x = 110;
        cover.y = 150;
    }

    //baseFree.songTitle.origin.set(baseFree.songTitle.width / 2, baseFree.songTitle.height);
    //baseFree.border.origin.set(baseFree.border.width / 2, baseFree.border.height);


    //dialogue
    createPhanes();
    createDialogue();

    //callbacks
    baseFree.onAccept = function()
    {
        tryEnterSong();
    };

    //first selection
    baseFree.changeSelection(0);


    ui = {
        x: 0,
        y: 0
    };

    baseFree.onSelectionChanged = onSelectionChanged;
    add(blackOverlay);

    baseFree.onCustomSongLoad = function (){
        onCustomSongLoad();
    }
}

function playUIMoveWobble()
{
    // cancel everything
    if (uiTween != null) uiTween.cancel();
    if (uiTween2 != null) uiTween2.cancel();

    // reset fully
    ui.x = 0;
    ui.y = 0;
    ui.rot = 0;

    // apply full starting pose immediately
    ui.x = 6;
    ui.y = -20;
    ui.rot = 4;

    // single tween with multi-stage curve (fake the bounce)
    uiTween = FlxTween.tween(ui, {
        x: 0,
        y: 0,
        rot: 0
    }, 0.50, {
        ease: FlxEase.elasticOut
    });
}

function update(elapsed:Float)
{
    baseFree.update(elapsed);

    baseFree.border.angle = ui.rot;
    baseFree.songTitle.angle = ui.rot;
    signSprite.angle = ui.rot;

    for (cover in baseFree.covers)
    {
        cover.angle = ui.rot;
    }

    baseFree.songTitle.x = -360 + ui.x;
    baseFree.songTitle.y = 510 + ui.y;

    baseFree.border.x = 105 + ui.x;
    baseFree.border.y = 145 + ui.y;

    signSprite.x = 50 + ui.x;
    signSprite.y = -20 + ui.y;


    for (cover in baseFree.covers)
    {
        cover.x = 110 + ui.x;
        cover.y = 150 + ui.y;
    }

    totalTime += elapsed;

    if (baseFree.curSelected != lastSelection)
    {
        lastSelection = baseFree.curSelected;
        playUIMoveWobble();
    }

    //-----------------------------------------
    // DIALOGUE UPDATE
    //-----------------------------------------

    if (dialogue != null && !dialogue.finished)
    {
        dialogue.update(dialogue, elapsed);
    }

    //-----------------------------------------
    // DIALOGUE FINISHED
    //-----------------------------------------

    if (dialogue.finished)
    {
        if (dialogueActive)
        {
            dialogueActive = false;

            phanes.playAnim("idle", true);

            //---------------------------------
            // Enter song after dialogue
            //---------------------------------

            if (enteringSong && pendingSong != null)
            {
                enteringSong = false;
                pendingSong = null;

                // Keep freeze enabled.
                baseFree.enterSong();
            }
            else
            {
                // Resume menu controls.
                baseFree.moveFreeze = false;
                baseFree.selectFreeze = false;
            }
        }
    }
}

function onCustomSongLoad(){
    trace("hola");
                        if (baseFree.songs[baseFree.curSelected].name == "so-retro") {
                            var realData = null;
                            var retroData = null;
                            realData = FunkinSave.getSongHighscore('realbobb', 'real').score;
                            retroData = FunkinSave.getSongHighscore('so-retro', 'hard').score;
                            trace("realdata " + realData + " retrodata " + retroData);
                            if (retroData > 0 && realData > 0){
                                getRetroVariant(2);
                                return true;
                            };
                            if (retroData == 0 && realData == 0) {
                                getRetroVariant(2);
                                return true;
                            };
                            else{
                                if (realData == 0){
                                    getRetroVariant(1);
                                    return true;
                                };
                                else{
                                    getRetroVariant(0);
                                    return true;
                                };
                            };
                        }
}

function tryEnterSong()
{
    var songName =
        baseFree.songs[baseFree.curSelected].name.toLowerCase().split(" ").join("-");

    var saveKey = "seenDialogue_" + songName;

    //-----------------------------------------
    // Already seen?
    //-----------------------------------------

    if (Reflect.field(FlxG.save.data, saveKey) == true)
    {
        baseFree.enterSong();
        return;
    }

    //-----------------------------------------
    // Start dialogue
    //-----------------------------------------

    dialogue.finished = false;

    pendingSong = songName;
    enteringSong = true;
    dialogueActive = true;

    baseFree.moveFreeze = true;
    baseFree.selectFreeze = true;

    dialogue.yap(dialogue, songName);

    Reflect.setField(FlxG.save.data,saveKey,true);

    FlxG.save.flush();
}

function createDialogue()
{
    dialogue = dialogueScript.call(
        "newDialogueManager",
        [
            "v2freeplay",
            phanes,
            null,
            {
                yVisibleOffset: -25,
                textboxGraphic: "menus/v2freeplay/textbox",
                boxYVisible: FlxG.height - 215,
                boxYHidden: FlxG.height + 200,
                textPaddingX: 50,
                textAlign: "left",
                animType: "slide",
                stopWhenFinish: true,
                textColor: 0xFFC000B6
            }
        ]
    );

    if (dialogue == null)
    {
        trace("Dialogue object is null");
        return;
    }

    if (dialogue.textBox != null)
        add(dialogue.textBox);

    if (dialogue.display != null)
        add(dialogue.display);
}

function createPhanes()
{
    phanes = new FunkinSprite(
        900,
        340,
        Paths.image("menus/v2freeplay/phanes_freeplay")
    );

    phanes.addAnim("idle", "idle", 24, true);
    phanes.addAnim("cool", "cool", 24, true);
    phanes.addAnim("default_talk", "default_talk", 24, true);
    phanes.addAnim("up_talk", "up_talk", 24, true);
    phanes.addAnim("left_talk", "left_talk", 24, true);
    phanes.addAnim("excited", "excited", 24, true);
    phanes.addAnim("wave", "wave", 24, true);
    phanes.addAnim("sad_wave", "sad_wave", 24, true);
    phanes.addAnim("worried", "worried", 24, true);
    phanes.addAnim("paper", "paper", 24, true);
    phanes.addAnim("look_paper", "look_paper", 12, false);
    phanes.addAnim("playa", "playa", 4, true);
    phanes.addAnim("wait", "wait", 24, true);
    phanes.addAnim("sad_talk", "triste_talk", 24, true);

    add(phanes);

    phanes.antialiasing = true;
    phanes.scale.set(0.75, 0.75);

    phanes.addOffset("default_talk", 0, 6);
    phanes.addOffset("sad_talk", 0, 6);
    phanes.addOffset("left_talk", 0, 6);

    phanes.addOffset("wave", 150, 230);
    phanes.addOffset("sad_wave", 150, 230);
    phanes.addOffset("uh", 30, 0);
    phanes.addOffset("cool", 100, 0);
    phanes.addOffset("excited", 0, -50);
    phanes.addOffset("wait", 50, 50);

    phanes.playAnim("wave", true);
}

function createBG()
{
    bgSprite = new FlxSprite(-65, -90);
    bgSprite.loadGraphic(Paths.image("states/freeplay_v2/bg"));
    safeSpriteGraphic(bgSprite, "states/freeplay_v2/bg");
    bgSprite.scale.set(0.31, 0.31);
    bgSprite.updateHitbox();
    add(bgSprite);

    signSprite = new FlxSprite(50, -20);
    signSprite.loadGraphic(Paths.image("states/freeplay_v2/painting"));
    safeSpriteGraphic(signSprite, "states/freeplay_v2/painting");
    signSprite.scale.set(0.31, 0.31);
    signSprite.updateHitbox();
    signSprite.antialiasing = true;
    add(signSprite);
    //signSprite.origin.set(signSprite.width / 2, signSprite.height);

    border = new FlxSprite();
    border.makeGraphic(1, 1, 0xFF532A14);
    add(border);
}

function resetDialogueEvents()
{
    for (song in baseFree.songs)
    {
        var selectedName =
            song.name
                .toLowerCase()
                .split(" ")
                .join("-");

        var saveKey = "seenDialogue_" + selectedName;

        Reflect.deleteField(
            FlxG.save.data,
            saveKey
        );
    }

    FlxG.save.flush();
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
        phanes.visible = false;
    }
    else if (unheardMode)
    {
            stopUnheardPreview();
            phanes.visible = true;
            FlxTween.cancelTweensOf(blackOverlay);
            blackOverlay.alpha = 0;
            whiteBg.alpha = 0;
            unheardMode = false;
            setMenuMusicVolume(1.0);
            bgSprite.alpha = 1;
    }

}

function onSelectionChanged(change:Int)
{
    updateSongModes();
}

function getRetroVariant(val){
    FlxG.save.data.clearedSongs.push("so-retro");
    FlxG.save.flush(); 
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
