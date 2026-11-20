import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxTextFormatMarkerPair;
import flixel.text.FlxTextFormat;
import flixel.text.FlxText.FlxTextAlign;

var IDLE = 0;
var PULL = 1;
var LOOP = 2;

var slotState = IDLE;

var multipliers = [0,2,4,5,6,8,10];
var chosenMultiplier = 1;
var activeMultiplier = 1;

var spinBeats = 0;
var beatsBeforeStop = 8;

var slotChar;
var wheelChar;

static var money:Int = 0;
var moneyText:FlxText;

var beatMod:Int = 1;

var textVelX:Float = 0;
var textVelY:Float = 0;
var textGravity:Float = 600;
var textAlive:Bool = false;

var darkLights;
var orangeLights;

var slot1:FlxSprite;
var slot2:FlxSprite;
var slot3:FlxSprite;
static var goodigod:FlxSprite;

var slots:Array = [];

var setCamToZero:Bool = false;

function stepHit(step:Int) {
    switch (step) {
        case 392:
            lightTemp("cool");
        case 424:
            lightTemp("normal");
        case 456:
            lightTemp("cool");
        case 488:
            lightTemp("normal");
        case 520:
            lightTemp("cool");
        case 584:
            lightTemp("warm");
        case 644:
            lightTemp("cool");
            bopStrength = 2;
            FlxTween.tween(camGame, { angle: 360 }, 0.551, {
                ease: FlxEase.quadIn}
            );
        case 648:
            setCamToZero = true;
        case 655:
            setCamToZero = false;
        case 904:
            bopStrength = 1;
            lightTemp("normal");
    }
}

function lightTemp(val:String){
    if (val == "cool"){
        FlxTween.tween(darkLights, { alpha: 0.25 }, 0.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(orangeLights, { alpha: 0 }, 0.5, {ease: FlxEase.quadInOut});
    };
    if (val == "warm"){
        FlxTween.tween(orangeLights, { alpha: 0.15 }, 0.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(darkLights, { alpha: 0 }, 0.5, {ease: FlxEase.quadInOut});
    };    
    if (val == "normal"){
        FlxTween.tween(darkLights, { alpha: 0 }, 0.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(orangeLights, { alpha: 0 }, 0.5, {ease: FlxEase.quadInOut});
    };
}

function create()
{
    moneyText = new FlxText(0, 0, 0, "0", 64); // bigger font
    moneyText.setFormat(Paths.font("krabbypatty.otf"), 64, 0xFFFFD700, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    moneyText.scrollFactor.set(1, 1);

    add(moneyText);
}

function postCreate()
{
    addExtraHitboxKey("SPACE");

    camGame.scroll.x = 540;
    camGame.scroll.y = 600;
    strumLines.members[2].vocals.volume = 1;
    money = 0;
    slotChar = strumLines.members[3].characters[0];
    wheelChar = strumLines.members[2].characters[0];

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    new FlxTimer().start(0.5, function(tmr:FlxTimer)
    {
        FlxTween.tween(blackOverlay, { alpha: 0 }, 1);
    });
    darkLights = new FlxSprite().makeGraphic(1300, 720, 0xFFFFD700);
	darkLights.cameras = [camHUD];
	darkLights.blend = BlendMode.SUBTRACT;
	darkLights.alpha = 0;

	add(darkLights);
	orangeLights = new FlxSprite().makeGraphic(1300, 720, 0xFF003ed9);
	orangeLights.blend = BlendMode.SUBTRACT;
	orangeLights.cameras = [camHUD];
	orangeLights.alpha = 0;
	add(orangeLights);
    camGame.zoom = 1.7;

    FlxTween.tween(camGame, { zoom: 0.8 }, 4, {ease: FlxEase.quadInOut});
    for (i in 0...3) {
        var spr = new FlxSprite();
        spr.loadGraphic(Paths.image('daddatel/' + Std.string(FlxG.random.int(0, 9))));
        spr.cameras = [camGame];

        spr.x = slotChar.x + slotChar.width/4 + 47 + (i * 47);
        spr.y = slotChar.y + 386;
        spr.scale.set(0.15, 0.15);
        spr.updateHitbox();
        spr.centerOffsets();
        spr.centerOrigin();
        spr.scrollFactor.set(1, 1);
        add(spr);
        slots.push(spr);
    };

    goodigod = new FlxSprite();
    goodigod.loadGraphic(Paths.image('daddatel/good'));
    goodigod.cameras = [camHUD];

    goodigod.x = 260;
    goodigod.y = 250;
    goodigod.updateHitbox();
    goodigod.centerOffsets();
    goodigod.centerOrigin();
    goodigod.scrollFactor.set(1, 1);
    goodigod.alpha = 0;
    add(goodigod);

    members.remove(boyfriend);
    add(boyfriend);

    members.remove(dad);
    add(dad);
    

}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}


function muteGamble(){
    strumLines.members[2].vocals.volume = 0;
}

function update(elapsed:Float)
{
    if (setCamToZero){
        camGame.angle = 0;
    };
    var beat = Conductor.songPosition / Conductor.crochet;

    if (mobileSpaceJustPressed() && money > 0)
    {
        startGamble();
    };

    moneyText.text = Std.string(money);

    moneyText.scale.set(1, 1);
    moneyText.updateHitbox();

    var mid = slotChar.getGraphicMidpoint();

    moneyText.x = mid.x - (moneyText.width / 2) - 100;
    moneyText.y = slotChar.y + 100 - Math.abs(Math.sin(beat * Math.PI / beatMod) * 30);
    moneyText.angle = 0 + (Math.cos(beat * Math.PI / beatMod) * 10);

    if (textAlive && newText != null)
    {
        textVelY += textGravity * elapsed;
        newText.x += textVelX * elapsed;
        newText.y += textVelY * elapsed;
        newText.angle += textVelX * 0.01;
        if (newText.alpha <= 0)
        {
            newText.kill();
            textAlive = false;
        }
    }

}

function startGamble()
{
    if (slotState != IDLE) return;
     money -= 1;
    slotState = PULL;
    spinBeats = 0;
    strumLines.members[2].vocals.volume = 1;
    slotChar.playAnim("pull", true);
    FlxG.sound.play(Paths.sound("lever_pull"), 0.75);
    new FlxTimer().start(0.1, function(tmr:FlxTimer)
    {
        startLoop();
    });
}

function startLoop()
{
    for (i in 0...3) {
        slots[i].alpha = 0;
    };
    wheelChar.playAnim("pull", true);
    slotState = LOOP;

    slotChar.playAnim("loop", true);
    wheelChar.playAnim("loop", true);

    wheelChar.animation.curAnim.frameRate = 24;
}

function beatHit()
{
    if (slotState == LOOP)
    {
        spinBeats++;

        if (spinBeats >= beatsBeforeStop - 4)
        {
            var progress:Float = (spinBeats - (beatsBeforeStop - 4)) / 4;
            var newRate:Float = 24 - (progress * 10);
            wheelChar.animation.curAnim.frameRate = newRate;
        }

        if (spinBeats >= beatsBeforeStop)
        {
            stopSlot();
        }
    }
}

function hideSlots(val:String){
    for (i in 0...3) {
        if (val == "true"){
            slots[i].alpha = 0;
        }
        else{
            slots[i].alpha = 1;
        }
    }
}

var newText:FlxText;

function stopSlot()
{
    for (i in 0...3) {
        slots[i].alpha = 1;
        slots[i].loadGraphic(Paths.image('daddatel/' + Std.string(FlxG.random.int(0, 9))));
        slots[i].scale.set(0.15, 0.15);
        slots[i].updateHitbox(); 
    };
    
    FlxG.sound.play(Paths.sound("gamble_result"), 0.75);
    strumLines.members[2].vocals.volume = 0;
    chosenMultiplier = rollMultiplier();

    slotChar.playAnim("idle", true);
    wheelChar.playAnim("idle", true);

    songScore = Math.floor(songScore * chosenMultiplier);

    slotState = IDLE;

    if (newText != null) {
        newText.kill();
        remove(newText);
    }

    newText = new FlxText(0, 0, 0, "x" + Std.string(chosenMultiplier), 64);
    newText.setFormat(null, 64, 0xFFFF00FF);
    newText.scrollFactor.set(1, 1);

    newText.x = moneyText.x;
    newText.y = moneyText.y;
    newText.cameras = [camGame];
    newText.alpha = 1;
    insert(members.length-1, newText);
    trace(newText.alpha);
    textVelY = FlxG.random.float(-300, -220); 
    textVelX = FlxG.random.float(-120, 120);  

    textAlive = true;

    FlxTween.tween(newText, { alpha: 0 }, 1.2);
}

function rollMultiplier():Float
{
    var roll = FlxG.random.int(1, 100);

    if (roll == 19) return 119;
    if (roll == 77) return 7;
    if (roll == 1) return 0;
    if (roll == 66) return 10;
    if (roll <= 5) return 0;
    if (roll <= 20) return 0.5;
    if (roll <= 30) return 1;
    if (roll <= 50) return 2;
    if (roll <= 65) return 3;
    if (roll <= 80) return 4;
    if (roll <= 90) return 6;
    if (roll <= 97) return 8;
    return 10;
}
