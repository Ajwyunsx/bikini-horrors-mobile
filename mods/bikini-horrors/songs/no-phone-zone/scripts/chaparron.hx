import flixel.text.FlxText;
import flixel.group.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var mechanicsCam:FlxCamera;
var farolillo:FlxSprite;
var floatingTexts:FlxTypedGroup; 
var possibleY:Array<Float> = [150, 250, 350, 450];
var blackOverlay;
var whiteOverlay;
var screenVignette:FlxSprite;
var lightEnabled:Bool = false;
var beatMod:Int = 4;
var counter:Int = 0;
var threshold:Float = 15;
var insideRange:Bool = false;
var pressedInRange:Bool = false;
var canPress:Bool = false;
var waveAmplitude:Float = 15; 
var waveFrequency:Float = 4;
var letterDelay:Float = 0.3;
var duration:Float = 3.0;
var failLoop:FlxSound;

var startX:Float;

function create() {
    var tent = stage.getSprite("tent");
    var aika = stage.getSprite("aika");
    tent.playAnim("idle");
    aika.playAnim("idle");
    FlxG.cameras.add(mechanicsCam = new HudCamera(), false);
    mechanicsCam.bgColor = 0x00000000;
    failLoop = FlxG.sound.load(Paths.sound('tinnitus'), 0, true); 
    failLoop.play();

    farolillo = new FlxSprite(0, 50);
    try {
        farolillo.loadGraphic(Paths.image('game/ui/pendulo'));
    } catch (e:Dynamic) {
        trace('Failed to load no-phone pendulo graphic: ' + e);
    }
    if (farolillo.graphic == null) {
        farolillo.makeGraphic(1, 1, 0x00000000);
        farolillo.visible = false;
    }
    farolillo.cameras = [mechanicsCam];
    farolillo.scale.set(0.7, 0.7);
    farolillo.updateHitbox();
    farolillo.origin.set(farolillo.width / 2, 0);
    
    var farolX = (FlxG.width / 2) - (farolillo.width / 2);
    farolillo.x = farolX;
    farolillo.alpha = 0;
    add(farolillo);


    floatingTexts = new FlxTypedGroup(); 
    floatingTexts.cameras = [camGame];
    add(floatingTexts);
}

function postCreate() {
    addExtraHitboxKey("SPACE");

    screenVignette = new FlxSprite();
    screenVignette.loadGraphic(Paths.image("vignette_super"));
    screenVignette.setGraphicSize(FlxG.width, FlxG.height, true);
    screenVignette.scrollFactor.set(0, 0);
    screenVignette.alpha = 0.9;
    screenVignette.color = FlxColor.BLACK;
    screenVignette.screenCenter();

    add(screenVignette);
    screenVignette.cameras = [camHUD];

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    whiteOverlay = new FunkinScreenOverlay(FlxColor.WHITE);
    whiteOverlay.alpha = 0;
    whiteOverlay.cameras = [mechanicsCam];
    add(whiteOverlay);

    WindowUtils.winTitle = window.title = "TIKI TAKA RUINING YOUR BRAIN";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 8, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
}

function spawnText(content:String, posY:Float) {
    var textGroup = new FlxSpriteGroup();
    textGroup.x = startX;
    textGroup.y = 0;
    textGroup.ID = Std.int(posY); 
    textGroup.cameras = [mechanicsCam];
    
    var currentX:Float = 0;
    for (i in 0...content.length) {
        var char = content.charAt(i);
        var letter = new FlxText(currentX, 0, 0, char, 32);
        letter.setFormat(Paths.font("KrabbyPatty.otf"), 32, 0x715f00, "center");
        letter.ID = i; 
        textGroup.add(letter);
        currentX += letter.width; 
    }

    textGroup.alpha = 0;
    floatingTexts.add(textGroup);

    FlxTween.tween(textGroup, {alpha: 1}, 0.5);

    FlxTween.tween(textGroup, {x: startX + 400}, duration, {
        onComplete: function(twn:FlxTween) {
            textGroup.destroy();
            floatingTexts.remove(textGroup);
        }
    });

    FlxTween.tween(textGroup, {alpha: 0}, 0.8, {
        startDelay: duration - 0.8
    });
}

function update(elapsed:Float) {
    var time = Conductor.songPosition / 1000; 
    for (group in floatingTexts.members) {
        if (group != null && group.exists) {
            var baseY = group.ID;
            for (letter in group.group.members) {
                if (letter != null) {
                    letter.y = baseY + Math.sin((time * waveFrequency) + (letter.ID * letterDelay)) * waveAmplitude;
                }
            }
        }
    }

    if (lightEnabled) {
        var beat = Conductor.songPosition / Conductor.crochet;
        farolillo.angle = Math.sin(beat * Math.PI / beatMod) * 60;
        canPress = Math.abs(farolillo.angle) < threshold;

        if (mobileSpaceJustPressed()) {
            if (canPress && !pressedInRange) {
                counter--;
                if (counter < 0) counter = 0;
                pressedInRange = true;
                
                FlxTween.tween(whiteOverlay, {alpha: whiteOverlay.alpha - 0.07}, 0.6, {ease: FlxEase.cubeOut});
                FlxTween.tween(failLoop, {volume: failLoop.volume - 0.04}, 0.6);
                createGhost();
            } 
            else if (!canPress) {
                counter++;
                FlxTween.tween(whiteOverlay, {alpha: whiteOverlay.alpha + 0.07}, 0.6, {ease: FlxEase.cubeOut});
                FlxTween.tween(failLoop, {volume: failLoop.volume + 0.04}, 0.6);
            }
        }

        if (canPress) {
            if (!insideRange) {
                insideRange = true;
                pressedInRange = false; 
            }
        } else {
            if (insideRange) {
                if (!pressedInRange) {
                    counter++;
                    FlxTween.tween(whiteOverlay, {alpha: whiteOverlay.alpha + 0.07}, 0.6, {ease: FlxEase.cubeOut});
                    FlxTween.tween(failLoop, {volume: failLoop.volume + 0.04}, 0.6);
                }
                insideRange = false;
            }
        }
    }

    if (counter >= 14) {
        failLoop.stop();
        gameOver();
    }
}


function toggleLight(activar:Bool) {
    if (FlxG.save.data.mech == false) {
        if (activar) {
            lightEnabled = true;
            FlxTween.tween(farolillo, {alpha: 1}, 0.6, {ease: FlxEase.cubeOut});
        } else {
            lightEnabled = false;
            counter = 0;

            FlxTween.tween(whiteOverlay, {alpha: 0}, 0.8);
            if (failLoop != null) FlxTween.tween(failLoop, {volume: 0}, 0.8);
            
            FlxTween.tween(farolillo, {alpha: 0}, 0.6, {
                ease: FlxEase.cubeIn
            });
        }
    }
}

function createGhost() {
    if (farolillo == null || farolillo.graphic == null || !farolillo.visible)
        return;

    var ghost = new FlxSprite(0, 0);
    ghost.loadGraphic(farolillo.graphic);
    ghost.antialiasing = true;
    ghost.scale.set(farolillo.scale.x, farolillo.scale.y);
    ghost.updateHitbox();
    ghost.setPosition(farolillo.x, farolillo.y);
    ghost.origin.set(farolillo.origin.x, farolillo.origin.y);
    ghost.angle = farolillo.angle;
    ghost.cameras = [mechanicsCam];
    ghost.alpha = 0.4;
    add(ghost);

    FlxTween.tween(ghost, {alpha: 0}, 0.4, {
        ease: FlxEase.cubeOut,
        onComplete: function(twn:FlxTween) {
            ghost.destroy();
        }
    });
}

function stepHit(curStep:Int) {

    switch (curStep) {

        case 1:
            startX = 100;
            toggleLight(false);
        
        case 62:
            toggleLight(true);

        case 64:
            spawnText("Come", 250);

        case 68:
            spawnText("little Z gens", 350);

        case 80:
            spawnText("Come with me", 450);

        case 94:
            spawnText("I think you've had enough", 250);

        case 112:
            spawnText("INSTAGRAM REELS", 450);
        
        case 191:
            FlxTween.tween(screenVignette, {alpha: 0.5}, 0.6, {
                ease: FlxEase.cubeIn,
            });
            spawnText("Alone in the rain", 250);

        case 208:
            spawnText("nowhere to run", 450);
        
        case 222:
            spawnText("With no wi-fi to use", 350);
        
        case 236:
            spawnText("but so much fun", 450);
        
        case 319:
            spawnText("Searching for an answer", 250);
        
        case 336:
            spawnText("Searching for it?", 350);
        
        case 352:
            spawnText("No bother to ask your friend", 450);
        
        case 368:
            spawnText("CHAT-GPT", 350);
        
        case 448:
            spawnText("How many movies", 350);
        
        case 464:
            spawnText("did you download?", 450);
        
        case 480:
            spawnText("Digital circus?", 250);
        
        case 495:
            spawnText("Whiplash Or Saw?", 350);
        
        case 576:
            duration = 2.0;
            spawnText("Ding and Dong", 250);
        
        case 582:
            spawnText("the two brothers watched", 350);
        
        case 592:
            spawnText("Your time has come", 250);
        
        case 598:
            spawnText("to unplug your phone", 450);
        
        case 608:
            spawnText("Listen to the nature", 350);
        
        case 616:
            spawnText("or listen to your thoughts", 250);
        
        case 624:
            spawnText("In other time of history", 350);
        
        case 631:
            spawnText("you'll wish you were born", 450);
        
        case 704:
            spawnText("Dark, so dark", 250);
        
        case 711:
            spawnText("a flashlight won't do much", 350);
        
        case 720:
            spawnText("Look right at my lantern", 450);
        
        case 728:
            spawnText("look at it like that", 250);
        
        case 736:
            spawnText("Walk into the montain", 450);
        
        case 744:
            spawnText("with me you will go", 250);
        
        case 752:
            spawnText("Where there is less signal", 350);
        
        case 760:
            spawnText("and less youtube shorts", 450);
        
        case 832:
            duration = 3.0;
            spawnText("Oh kids these days", 250);
        
        case 846:
            spawnText("they lack a lot of brain...", 350);
        
        case 863:
            spawnText("Shitpost everywhere", 450);
        
        case 878:
            spawnText("but no pain or gain...", 350);
        
        case 896:
            spawnText("You're lucky I found you here...", 250);
        
        case 912:
            spawnText("right besides my camp...", 350);
        
        case 928:
            spawnText("Now we can all live", 450);
        
        case 942:
            spawnText("surrounded by the dark...", 350);
        
        case 944:
            toggleLight(false);
        
    }

}
