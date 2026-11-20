import openfl.filters.ShaderFilter;
import openfl.display.BlendMode;

var dadBaseY:Float = 0;
var dadBaseX:Float = 0;
var bfBaseY:Float = 0;
var bfBaseX:Float = 0;
var dadSineTime:Float = 2;
var dadSineAmount:Float = 60;
var dadSineSpeed:Float = 4;
var bobFly:Bool = false;
var bfFly:Bool = false;
var camAngle:Float = 0;
var targetAngle:Float = 0;

var blackOverlay;
var panelCam = new FlxCamera();
var freezeCam:Bool = false;

var spaceSpeed = 5000;
var spaceLayers = [];
var spaceLoopOffset:Float = -2000;


function postCreate() {
    shine1.blend = BlendMode.ADD;
    shine2.blend = BlendMode.ADD;
    dadBaseY = dad.y;
    dadBaseX = dad.x;
    bfBaseY = boyfriend.y - 240;
    bfBaseX = boyfriend.x;
    FlxG.cameras.remove(camHUD, false);
    FlxG.cameras.add(panelCam, false);
    FlxG.cameras.add(camHUD, false);
    panelCam.zoom = 0.9;

    white.screenCenter();
    darkLights.blend = BlendMode.SUBTRACT;
    darkLights.alpha = 0;

    panelCam.bgColor = FlxColor.TRANSPARENT;
    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    introPanel.cameras = [panelCam];
    keepupPanel.cameras = [panelCam];
    laughPanel.cameras = [panelCam];
    bobTransform.cameras = [panelCam];
    bfTransform.cameras = [panelCam];
    tartarSauce.cameras = [panelCam];
    white.cameras = [panelCam];
    spaceLayers = [
        { sprites: [spaceBg1, spaceBg2], height: 0, speedFactor: 0.5 },
        { sprites: [stars1, stars4], height: 0, speedFactor: 0.1 },
        { sprites: [stars7, stars10], height: 0, speedFactor: 0.1 },
        { sprites: [stars2, stars5], height: 0, speedFactor: 0.15 },
        { sprites: [stars8, stars11], height: 0, speedFactor: 0.15 },
        { sprites: [stars3, stars6], height: 0, speedFactor: 0.2 },
        { sprites: [stars9, stars12], height: 0, speedFactor: 0.2 },
        { sprites: [galaxy1, galaxy3], height: 0, speedFactor: 0.25 },
        { sprites: [galaxy2, galaxy4], height: 0, speedFactor: 0.3 },
        { sprites: [shine1, shine2], height: 0, speedFactor: 0.4 },
    ];

    for (layer in spaceLayers) {

        layer.height = getHeight(layer.sprites[0]);

        for (i in 0...layer.sprites.length) {
            layer.sprites[i].y = layer.sprites[0].y + layer.height * i;
        }
    }
}

function update(elapsed:Float) {
    if (bobFly) {
        dadSineTime += elapsed * dadSineSpeed;
        dad.y = dadBaseY + Math.sin(dadSineTime) * dadSineAmount;
        dad.x = dadBaseX + Math.cos(dadSineTime / 2) * 1.5 * dadSineAmount;
        dad.angle = Math.cos(dadSineTime / 2) * dadSineAmount / 50;
    }
    if (bfFly) {
        boyfriend.y = bfBaseY + Math.sin(dadSineTime/1.2 + Math.PI/2) * (dadSineAmount / 1.2);
        boyfriend.x = bfBaseX + Math.cos((dadSineTime/1.2+ Math.PI/2) / 2) * 1 * (dadSineAmount / 1.2);
        boyfriend.angle = Math.cos((dadSineTime/1.2+ Math.PI/2) / 2) * dadSineAmount / (50* 1.2);
    }

    camAngle = FlxMath.lerp(camAngle, targetAngle, 0.05);
    camGame.angle = camAngle;

    darkLights.angle = -camGame.angle;

    for (layer in spaceLayers)
        moveLayerVertical(layer, elapsed);
}

var gfPrevx:Float;
var gfPrevy:Float;

function stepHit(curStep:Int) {
    if (curStep == 1){
        camHUD.alpha = 1;
        hudVisibility(false);
        FlxTween.tween(blackOverlay, { alpha: 0 }, 0.4);
        introPanel.screenCenter();
        FlxTween.tween(panelCam, { zoom: 0.8 }, 0.7, {ease: FlxEase.quadOut});
        panelCam.scroll.y = -200;
        FlxTween.tween(panelCam.scroll, { y : -420 }, 0.7, {ease: FlxEase.quadOut});        
    }

    if (curStep == 20){
        FlxTween.tween(panelCam, { zoom: 0.75 }, 0.5, {ease: FlxEase.quadInOut});
        FlxTween.tween(panelCam.scroll, { y : 300 }, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(panelCam.scroll, { x : 0 }, 1, {ease: FlxEase.quadInOut}); 
    }


    if (curStep == 34){
        FlxTween.tween(panelCam, { zoom: 0.9 }, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(panelCam.scroll, { y : 450 }, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(panelCam.scroll, { x : 160 }, 1, {ease: FlxEase.expoInOut}); 
    }

    if (curStep == 56){
        camHUD.alpha = 0;
        hudVisibility(true);
        FlxTween.tween(camHUD, { alpha : 1 }, 0.5);
    }

    if (curStep == 54){
        FlxTween.tween(introPanel, { alpha : 0 }, 0.5);
        FlxTween.tween(panelCam.scroll, { y : 600 }, 0.5, {ease: FlxEase.quadIn}); 
    }

    if (curStep == 64) {
        bobFly = true;
    }

    if (curStep == 312){
        panelCam.zoom = 0.7;
        FlxTween.tween(camHUD, { alpha: 0 }, 0.2);
        FlxTween.tween(keepupPanel, { alpha: 1 }, 0.3);
        keepupPanel.screenCenter();
        FlxTween.tween(panelCam, { zoom: 0.6 }, 1, {ease: FlxEase.expoOut});
        panelCam.scroll.y = -700;
        panelCam.scroll.x = -600;
        FlxTween.tween(panelCam.scroll, { y : -120 }, 1, {ease: FlxEase.expoOut});
    }

    if (curStep == 328){
        FlxTween.tween(panelCam.scroll, { x : 300 }, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(panelCam.scroll, { y : 200 }, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(panelCam, { zoom: 0.5 }, 1, {ease: FlxEase.expoInOut});
    }

    if (curStep == 344) {
        FlxTween.tween(camHUD, { alpha : 1 }, 0.3);
        FlxTween.tween(keepupPanel, { alpha: 0 }, 0.3);
    }

    if (curStep == 686) {
        white.alpha = 1;
        panelCam.alpha = 0;
        panelCam.zoom = 0.6;
        FlxTween.tween(panelCam, { alpha: 1 }, 0.3);
        laughPanel.alpha = 1;
        laughPanel.screenCenter();
        FlxTween.tween(panelCam, { zoom: 0.3 }, 1, {ease: FlxEase.expoOut});
        panelCam.scroll.y = -400;
        panelCam.scroll.x = -65;
        FlxTween.tween(panelCam.scroll, { y : 0 }, 1, {ease: FlxEase.expoOut});
    }

    if (curStep == 703) {
        white.alpha = 1;
        laughPanel.alpha = 1;
        FlxTween.tween(panelCam, { alpha: 0 }, 0.3);
        FlxTween.tween(panelCam.scroll, { y : 500 }, 0.5, {ease: FlxEase.quadIn});
    }

    if (curStep == 720) {
        panelCam.bgColor = FlxColor.TRANSPARENT;
        white.alpha = 0;
        panelCam.alpha = 1;
        laughPanel.alpha = 0;
    }

    if (curStep == 992) {
        targetAngle = 10;
    }

    if (curStep == 1056) {
        targetAngle = -10;
    }

    if (curStep == 1088) {
        targetAngle = 0;
    }

    if (curStep == 1156) {
        panelCam.zoom = 0.8;
        FlxTween.tween(bobTransform, { alpha: 1 }, 0.3);
        bobTransform.screenCenter();
        FlxTween.tween(panelCam, { zoom: 0.9 }, 0.5, {ease: FlxEase.expoOut});
        panelCam.scroll.y = -0;
        panelCam.scroll.x = -310;
        FlxTween.tween(panelCam.scroll, { y : -115 }, 1, {ease: FlxEase.expoOut});
        dadBaseX -= 200;
    }

    if (curStep == 1170) {
        FlxTween.tween(panelCam.scroll, { x : 290 }, 1, {ease: FlxEase.expoInOut});
    }
    
    if (curStep == 1178) {
        panelCam.bgColor = FlxColor.WHITE;
        panelCam.shake(0.02, 0.3);
        FlxTween.tween(panelCam, { zoom: 0.8 }, 0.5, {ease: FlxEase.backOut});
    }

    if (curStep == 1184) {
        FlxTween.tween(panelCam, { alpha: 0 }, 0.3);
        FlxTween.tween(panelCam.scroll, { y : 500 }, 0.5, {ease: FlxEase.quadIn});
    }

    if (curStep == 1192){
        bobTransform.alpha = 0;
        panelCam.bgColor = FlxColor.TRANSPARENT;
        panelCam.alpha = 1;
    }

    if (curStep == 1296) {
        white.alpha = 1;
        panelCam.alpha = 0;
        panelCam.bgColor = FlxColor.WHITE;
        bfTransform.alpha = 1;
        panelCam.zoom = 0.9;
        FlxTween.tween(panelCam, { alpha: 1 }, 0.2);
        bfTransform.screenCenter();
        FlxTween.tween(panelCam, { zoom: 0.8 }, 0.5, {ease: FlxEase.expoOut});
        panelCam.scroll.y = 200;
        panelCam.scroll.x = -350;
        FlxTween.tween(panelCam.scroll, { y : 30 }, 1, {ease: FlxEase.expoOut});
    }

    if (curStep == 1300) {
        gf.y += -200;
        FlxTween.tween(panelCam.scroll, { x : 100 }, 0.6, {ease: FlxEase.expoInOut});
        FlxTween.tween(panelCam, { zoom: 0.9 }, 0.6, {ease: FlxEase.expoInOut});
    }

    if (curStep == 1308) {
        panelCam.shake(0.01, 0.7);
    }

    if (curStep == 1314) {
        bfFly = true;
        FlxTween.tween(panelCam, { alpha: 0 }, 0.3);
        FlxTween.tween(panelCam.scroll, { y : 500 }, 0.5, {ease: FlxEase.quadIn});
    }

    if (curStep == 1320) {
        panelCam.bgColor = FlxColor.TRANSPARENT;
        bfTransform.alpha = 0;
        panelCam.alpha = 1;
        white.alpha = 0;
    }

    if (curStep == 1349){
        white.alpha = 1;
        panelCam.alpha = 0;
        panelCam.bgColor = FlxColor.WHITE;
        tartarSauce.alpha = 1;
        panelCam.zoom = 0.9;
        FlxTween.tween(panelCam, { alpha: 1 }, 0.2);
        tartarSauce.screenCenter();
        FlxTween.tween(panelCam, { zoom: 0.85 }, 1, {ease: FlxEase.expoOut});
        panelCam.scroll.y = 300;
        panelCam.scroll.x = 0;
        FlxTween.tween(panelCam.scroll, { y : -50 }, 1, {ease: FlxEase.expoOut});
    }

    if (curStep == 1368){
        FlxTween.tween(panelCam, { alpha: 0 }, 0.3);
        FlxTween.tween(panelCam.scroll, { y : 500 }, 0.5, {ease: FlxEase.quadIn});
    }

    if (curStep == 1378) {
        panelCam.bgColor = FlxColor.TRANSPARENT;
        tartarSauce.alpha = 0;
        panelCam.alpha = 1;
        white.alpha = 0;
    }

    if (curStep == 1384)
    {
        dadSineSpeed = 6;
        dadSineAmount = 150;
    }

    if (curStep == 1622) {
        transition.alpha = 1;
        transition.y = -2000;
        FlxTween.tween(transition, {y:1000}, 1.5, {ease: FlxEase.quadInOut});
        FlxTween.num(dadBaseY, -1200, 0.7, {ease: FlxEase.backIn}, function(v:Float) {dadBaseY = v;});
        FlxTween.num(bfBaseY, -900, 0.7, {ease: FlxEase.backIn}, function(v:Float) {bfBaseY = v;});

    }

    if (curStep == 1631) {
        spaceBg1.alpha = 1;
        spaceBg2.alpha = 1;
        stars1.alpha = 1;
        stars2.alpha = 1;
        stars3.alpha = 1;
        stars4.alpha = 1;
        stars5.alpha = 1;
        stars6.alpha = 1;
        stars7.alpha = 1;
        stars8.alpha = 1;
        stars9.alpha = 1;
        stars10.alpha = 1;
        stars11.alpha = 1;
        stars12.alpha = 1;
        galaxy1.alpha = 1;
        galaxy2.alpha = 1;
        galaxy3.alpha = 1;
        galaxy4.alpha = 1;
        shine1.alpha = 0.25;
        shine2.alpha = 0.25;
        darkLights.alpha = 0.3;
        foreground.alpha = 0;
        luno.alpha = 1;
        gf.y = -1350;
        gf.x -= 200;
    }

    if (curStep == 1857) {
        FlxTween.tween(luno, {y:1000}, 2);
    }

    if (curStep == 1878) {
        gf.x += 200; 
        FlxTween.tween(camGame, {zoom: 2.5}, 0.8, {
            ease: FlxEase.expoIn,
            onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(camGame, {zoom: 0.6}, 0.7, {
                    ease: FlxEase.expoOut
                });
            }
        });
    }

    if (curStep == 1888) {
        targetAngle = 0;
        bfFly = false;
        dad.visible = false;
        boyfriend.x = 0;
        boyfriend.y = 0;
        freezeCam = true;
        gfPrevx = gf.x;
        gfPrevy = gf.y;
        gf.y = -160;
        gf.x = -350;
    }
    
    if (curStep == 2144) {
        bfFly = true;
        dad.visible = true;
        freezeCam = false;
        gf.y = gfPrevy;
        gf.x = gfPrevx;
    }

    if (curStep == 2144 + 128) {
        targetAngle = 10;
    }

    if (curStep == 2208 + 128) {
        targetAngle = -10;
    }

    if (curStep == 2240 + 128) {
        targetAngle = 0;
    }

    if (curStep == 2272 + 128)
    {
        dadSineSpeed = 5;
        dadSineAmount = 50;
    }

    if (curStep == 2584 + 128) {
        bobFly = false;
        emerald.alpha = 0;
        cave.alpha = 0;
        floor.alpha = 0;
        patrisio.alpha = 0;
        foreground.alpha = 0;
        boyfriend.alpha = 0;
        spaceBg1.alpha = 0;
        spaceBg2.alpha = 0;
        stars1.alpha = 0;
        stars2.alpha = 0;
        stars3.alpha = 0;
        stars4.alpha = 0;
        stars5.alpha = 0;
        stars6.alpha = 0;
        stars7.alpha = 0;
        stars8.alpha = 0;
        stars9.alpha = 0;
        stars10.alpha = 0;
        stars11.alpha = 0;
        stars12.alpha = 0;
        galaxy1.alpha = 0;
        galaxy2.alpha = 0;
        galaxy3.alpha = 0;
        galaxy4.alpha = 0;
        shine1.alpha = 0;
        shine2.alpha = 0;
        luno.alpha = 0;
    }
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

//Codego epspacio

function getHeight(spr) {
    return spr.frameHeight * spr.scale.y;
}

function moveLayerVertical(layer, elapsed) {

    var h = layer.height;
    var n = layer.sprites.length;
    var speed = spaceSpeed * layer.speedFactor;

    for (spr in layer.sprites)
        spr.y += speed * elapsed;

    for (i in 0...n) {

        var spr = layer.sprites[i];

        if (speed < 0) {
            if (spr.y + h < -h - spaceLoopOffset)
                spr.y += h * n;
        } else {
            if (spr.y > FlxG.height + h + spaceLoopOffset)
                spr.y -= h * n;
        }

    }
}

function setSpaceSpeed(value, time) {
    value = Std.parseFloat(value);
    time = Std.parseFloat(time);

    FlxTween.num(spaceSpeed, value, time, { ease: FlxTween.quadOut }, function(v:Float) {
        spaceSpeed = v;
    });
}
