import funkin.backend.system.FunkinFullscreenCamera;
import haxe.Json;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

var starvedCam:FlxCamera;
var starved:FlxSprite;

var options:Array<String> = [];
var coolTextGroup:FlxTypedGroup<FunkinText>;
var songDescText:FunkinText;
var label:FunkinText;

var introDone:Bool = false;
var descTimer:FlxTimer;

function create(event) {
    var rawJson:String = Assets.getText(Paths.json('config/pauseDesc'));
    var songData = Json.parse(rawJson);
    var songName:String = PlayState.SONG.meta.name.toLowerCase();
    var data = Reflect.field(songData, songName);
    options = event.options; 
    event.cancel();
    cameras = [];
    
    starvedCam = new FunkinFullscreenCamera(true);
    starvedCam.bgColor = 0xC2000000;
    starvedCam.pixelPerfectRender = true;
    FlxG.cameras.add(starvedCam, false);

    cameras = [starvedCam]; 

    var note = new FlxSprite(-240, -319);
    note.loadGraphic(Paths.image('menus/pause/pause_note'));
    note.scale.set(0.35, 0.35);
    add(note);
    var noteTargetX:Float = note.x;
    note.x = -1500;
    FlxTween.tween(note, {x: noteTargetX}, 0.6, {ease: FlxEase.cubeOut});

    var box = new FlxSprite(-280, -435);
    box.loadGraphic(Paths.image('menus/pause/pause_box'));
    box.scale.set(0.6, 0.6);
    add(box);
    var boxTargetX:Float = box.x;
    box.x = -1500;
    FlxTween.tween(box, {x: boxTargetX}, 0.6, {ease: FlxEase.cubeOut});

    var descriptionTarget:String = "No song.";
    if (data != null && Reflect.hasField(data, "description")) {
        descriptionTarget = Reflect.field(data, "description");
    }

    songDescText = new FunkinText(470, 20, 585, "", 24); // Iniciamos vacío ("")
    songDescText.setFormat(Paths.font("KrabbyPatty.otf"), 20, 0xff000000, "left");
    var tFormat = songDescText.textField.defaultTextFormat;
    tFormat.leading = 17;
    songDescText.textField.defaultTextFormat = tFormat; 
    songDescText.textField.setTextFormat(tFormat);
    add(songDescText);
    
    var descTargetX:Float = songDescText.x;
    songDescText.x = -1500;
    
    FlxTween.tween(songDescText, {x: descTargetX}, 0.6, {
        ease: FlxEase.cubeOut,
        onComplete: function(twn:FlxTween) {
            if (descriptionTarget.length > 0) {
                var words:Array<String> = descriptionTarget.split(" ");
                var wordIndex:Int = 0;

                descTimer = new FlxTimer().start(0.01, function(tmr:FlxTimer) {
                    wordIndex++;
                    
                    if (wordIndex >= words.length) {
                        wordIndex = words.length;
                        tmr.cancel();
                    }
                    
                    songDescText.text = words.slice(0, wordIndex).join(" ");
                }, 0);
            }
        }
    });


    starved = new FlxSprite(500, 250);
    starved.loadGraphic(Paths.image('menus/pause/starved_pause'));
    starved.scale.set(0.7, 0.7);
    add(starved);
    var starvedTargetX:Float = starved.x;
    starved.x = 1500;
    FlxTween.tween(starved, {x: starvedTargetX}, 0.6, {ease: FlxEase.cubeOut});

    coolTextGroup = new FlxTypedGroup();
    add(coolTextGroup);

    for (i in 0...options.length) {
        label = new FunkinText(30, 100 + (i * 120), 0, switch(i){
            case 0: "Resume";
            case 1: "Restart";
            case 2: "Options";
            case 3: "Exit";
            case 4: "Chart";
            default: "tu mama";
        }, 60);
        label.setFormat(Paths.font("KrabbyPatty.otf"), 70, 0xFFfcff5e, "center", FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        label.borderSize = 2;
        label.ID = i;
        coolTextGroup.add(label);
        
        var labelTargetX:Float = label.x;
        label.x = -600;
        
        if (i == options.length - 1) {
            FlxTween.tween(label, {x: labelTargetX}, 0.6, {
                ease: FlxEase.cubeOut, 
                startDelay: i * 0.06,
                onComplete: function(twn:FlxTween) {
                    introDone = true;
                }
            });
        } else {
            FlxTween.tween(label, {x: labelTargetX}, 0.6, {
                ease: FlxEase.cubeOut, 
                startDelay: i * 0.06 
            });
        }
    }

    changeSelection(0);
}

function update(elapsed:Float) {
    if (controls.DOWN_P)
        changeSelection(1);
    if (controls.UP_P)
        changeSelection(-1);

    if (controls.ACCEPT) {
        selectOption(); 
    }
}

function changeSelection(change:Int) {
    curSelected += change;

    if (curSelected < 0)
        curSelected = options.length - 1;
    if (curSelected >= options.length)
        curSelected = 0;

    for (i in 0...coolTextGroup.members.length) {
        var text = coolTextGroup.members[i];

        if (introDone) {
            FlxTween.cancelTweensOf(text);
        }
        
        var targetAlpha:Float = 0.6;
        var targetColor:Int = 0xFF9a6e29;

        if (i == curSelected) {
            targetAlpha = 1.0;
            targetColor = 0xFFfcff5e;
        }

        FlxTween.tween(text, {alpha: targetAlpha}, 0.1, {ease: FlxEase.quadOut});
        FlxTween.color(text, 0.1, text.color, targetColor, {ease: FlxEase.quadOut});
    }
}

function destroy() {
    if (FlxG.cameras.list.contains(starvedCam))
        FlxG.cameras.remove(starvedCam);

    if (descTimer != null)
        descTimer.cancel();
}
