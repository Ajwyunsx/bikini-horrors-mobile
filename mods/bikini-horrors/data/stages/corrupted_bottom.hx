var spongelordY:Float;
var blackOverlay;

var timer:Float = 0;

function postCreate(){
    camZooming = true;
    camGame.zoom = 2;
    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    spongelordY = spongelord.y;
}

function stepHit(curStep:Int) {
    if (curStep == 1) {
        hudVisibility(false);
        camZooming = false;
        camGame.zoom = 2;
        camGame.scroll.y = -400;
        FlxTween.tween(camGame, {zoom:0.4}, 7, {ease:FlxEase.quadInOut});
        FlxTween.tween(blackOverlay, {alpha: 0}, 4);
    }

    if (curStep == 16){
        hudVisibility(true);
    }

    if (curStep == 68) {
        camZooming = true;

    } 

    if (curStep == 248) {
        camGame.target = null;
        FlxTween.tween(camGame.scroll, {x:-663, y:-85 - 150}, 1, {ease:FlxEase.quadInOut});
    } 

    if (curStep == 258) {
        camGame.target = camFollow;
    }

    if (curStep == 512) {
       atras.alpha = 1;
       fondo.alpha=1;
       fondoFake.alpha=0;
       dad.x += 490;
       dad.y += 200;
       boyfriend.x -= 680;
       boyfriend.y -= 10;
    }

    if (curStep == 2176) {
       spongelord.alpha = 1;
       FlxTween.tween(spongelord, {alpha:1}, 2);
    }
}

function update(elapsed:Float){
    timer += elapsed;
    spongelord.y = spongelordY + Math.sin(timer * 1.25) * 30;
}

function hudVisibility(val:Bool){
        strumLines.visible = val;
        healthBar.visible = val;
        healthBarBG.visible = val;
        iconP1.visible = val;
        iconP2.visible = val;
        scoreTxt.visible = val;
        missesTxt.visible = val;
        accuracyTxt.visible = val;
}
