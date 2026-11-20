import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.ui.FlxBar.FlxBarFillDirection;
import flixel.ui.FlxBar;
import flixel.util.FlxAxes;
import flixel.FlxSprite;
var beatMod:Int = 4;
var blackOverlay;
var canShake:Bool = true;
var txt:FunkinText;
var origincucaracha;

function create(){
    txt = new FunkinText(10, FlxG.height - 40, 0, "too-slow - Hard | KE 1.5.4");
    txt.setFormat(Paths.font("Camera.ttf"), 15, FlxColor.WHITE, true);

    txt.borderStyle = FlxTextBorderStyle.OUTLINE;
    txt.borderColor = FlxColor.BLACK;
    txt.borderSize = 0.5;

    txt.antialiasing = true;
    txt.scrollFactor.set(0, 0);
    txt.cameras = [camHUD];
    txt.alpha = 0;
    add(txt);
}

function postCreate(){
    gf.origin.set(gf.width / 2, -600);
    camZooming = true;
    camGame.zoom = 2;
    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    canShake = true;

    hello.cameras = [camHUD];
    hello.screenCenter();

    origincucaracha = cucaracha_bob.x;
    cucaracha_bob.x -= 2000;
    cucaracha_bob.playAnim("walk");

    
}

function update(elapsed:Float){

    if (canShake)
    {
        var beat = Conductor.songPosition / Conductor.crochet;
        gf.angle = Math.sin(beat * Math.PI / beatMod) * 3;  
    }
    else
    {
        gf.angle = 0;
    }

}

function onDadHit() {
    if (canShake) FlxG.camera.shake(0.005, 0.1);
}

function stepHit(curStep:Int) {

    if (curStep == 1) {
        camZooming = false;
        FlxTween.tween(camGame, {zoom:0.5}, 8.5, {ease:FlxEase.quadInOut});
        FlxTween.tween(blackOverlay, {alpha: 0}, 4);


        FlxTween.tween(cucaracha_bob, {x: origincucaracha}, 199, {
            onComplete: function(twn:FlxTween)
            {
                cucaracha_bob.playAnim("idle");
            }
        });
    }

    if (curStep == 68) {
        camZooming = true;
    } 

    if (curStep == 140) {
        camZooming = true;
        FlxTween.tween(camGame, {zoom:0.6}, 0.45, {ease:FlxEase.expoIn});
    } 

    if (curStep == 144) {
        beatMod = 2;
    } 

    if (curStep == 276){
        animao.alpha = 1;
        FlxTween.tween(animao, {alpha:0.4}, 0.4, {ease:FlxEase.quadOut});
    }

    if (curStep == 544){
        animao.alpha = 0;
        pilares.alpha = 0;
        bosque.alpha = 0;
        suelo.alpha = 0;
        roca.alpha = 0;

        too_slow.alpha = 1;
        canShake = false;
        gf.y += 1600;
        gf.x += 1300;
    }

    if (curStep == 1056){
        animao.alpha = 0;
        pilares.alpha = 1;
        bosque.alpha = 1;
        suelo.alpha = 1;
        roca.alpha = 1;
        hello.alpha = 0;

        too_slow.alpha = 0;
        canShake = true;
        gf.y -= 1600;
        gf.x -= 1300;
    }

    if (curStep == 1052){
        hello.alpha = 1;
    }

    if (curStep == 1200) {
        animao.alpha = 1;
    }

    if (curStep == 1600) {
        animao.alpha = 1;
    }

    if (curStep == 1328){
        animao.alpha = 1;
        FlxTween.tween(animao, {alpha:0.4}, 0.2, {ease:FlxEase.quadOut});
    }

    switch (curStep)
    {
        case 544:
            txt.alpha = 1;
            for (txt in [accuracyTxt, missesTxt, scoreTxt, timePassedTxt, totalTimeTxt, rankTxt])
            {
                if (txt == null) continue;

                txt.setFormat(Paths.font("Camera.ttf"), txt.size, txt.color, true);
                txt.borderStyle = FlxTextBorderStyle.OUTLINE;
                txt.borderColor = FlxColor.BLACK;
                txt.borderSize = 1;
                txt.y += 10;
            }
        case 1052:
            txt.alpha = 0;
    }

}
