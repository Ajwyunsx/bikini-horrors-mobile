// Script by Chezzar and Meiart
var blackOverlay;
public var nick:FlxSprite;

var dadBaseX:Float = 0;
var dadSineTime:Float = 2;
var dadSineAmount:Float = 60;
var dadSineSpeed:Float = 4;
var maracca:Bool = false;

function create() {

    nick = new FlxSprite();
    nick.loadGraphic(Paths.image('logos/nick'));
    nick.scale.set(0.12, 0.12);
    nick.updateHitbox();
    nick.alpha = 0.8;
    nick.scrollFactor.set(0, 0);
    nick.cameras = [camHUD];

    nick.x = FlxG.width - nick.width - 30;
    nick.y = FlxG.height - nick.height - 30;


    add(nick);
}

function update(elapsed:Float) {
    if (maracca) {
        dadSineTime += elapsed * dadSineSpeed;
        dad.x = dadBaseX + Math.cos(dadSineTime / 2) * 1.5 * dadSineAmount;
    }
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 5, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
}


function postCreate() {

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    
    camardo.alpha = 0;
    algas.alpha = 0;
}


function stepHit() { 

    if (curStep == 80) {
        dad.scale.x = 1.5;
    }

    if (curStep == 82) {
        dad.scale.x = 2;
    }

    if (curStep == 84) {
        dad.scale.x = 2.5;
    }

    if (curStep == 86) {
        dad.scale.x = 10;
    }

    if (curStep == 87) {
        dad.scale.x = 1;
    }

    if (curStep == 96) {
        FlxTween.tween(faker, {alpha: 0}, 3.7);
        FlxTween.tween(camardo, {alpha: 1}, 3.7);
        FlxTween.tween(algas, {alpha: 1}, 3.7);
    }

    if (curStep == 112) {
        FlxTween.tween(dad, {y: dad.y - 2500}, 2, {ease: FlxEase.quintIn});
    }

    if (curStep == 128) {
        dad.y = 262;
    }

    if (curStep == 320) {
        FlxTween.color(dad, 7, FlxColor.WHITE, 0xFF303492);
    }

    if (curStep == 384) {
        FlxTween.color(dad, 0.2, 0xFF303492, FlxColor.WHITE);
    }

    if (curStep == 632) {
        FlxTween.tween(dad, {x: dad.x - 2000}, 0.15);
    }

    if (curStep == 636) {
        FlxTween.tween(dad, {x: dad.x + 2000}, 0.15);
    }

    if (curStep == 896) {
        FlxTween.tween(cielo, {alpha: 0}, 3);
    }

    if (curStep == 952) {
        FlxTween.tween(fondo3, {alpha: 0}, 0.6);
        FlxTween.tween(fondo2, {alpha: 0}, 0.6);
        FlxTween.tween(fondo, {alpha: 0}, 0.6);
        FlxTween.tween(terreno, {alpha: 0}, 0.6);
        FlxTween.tween(camardo, {alpha: 0}, 0.6);
        FlxTween.tween(algas, {alpha: 0}, 0.6);
        FlxTween.tween(boyfriend, {alpha: 0}, 0.6);
        FlxTween.tween(gf, {alpha: 0}, 0.6);
    }

    if (curStep == 960) {
        maracca = true;

        boyfriend.alpha = 1;
        gf.alpha = 1;

        cielo.alpha = 1;
        fondo.alpha = 1;
        fondo2.alpha = 1;
        fondo3.alpha = 1;
        terreno.alpha = 1;
        camardo.alpha = 1;
        algas.alpha = 1;
    }

    if (curStep == 1088) {
        dadSineTime = 5;
        dadSineAmount = 960;
        dadSineSpeed = 3;
    }

    if (curStep == 1226) {
        maracca = false;

        dad.x = -87;
    }
}
