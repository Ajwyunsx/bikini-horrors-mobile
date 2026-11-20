var crtUsa:CustomShader = null;

var screenVignette:FlxSprite;
var blackOverlay;
public var nick:FlxSprite;

var dadBaseX:Float = 0;
var dadSineTime:Float = 2;
var dadSineAmount:Float = 60;
var dadSineSpeed:Float = 4;
var bobCochecito:Bool = false;

var runSpeed = -2000;
var runLayers = [];
var runLoopOffset:Float = -2000;

function create() {
    if (Options.shaderQualityAllows(1)) {
        var highShaders:Bool = Options.shaderQualityAllows(2);
        crtUsa = new CustomShader('crtUsa');

        crtUsa.curvature = 0;
        crtUsa.scanlines = highShaders ? 1 : 0.45;
        crtUsa.rgbShift = highShaders ? 1 : 0.25;
        crtUsa.blur = highShaders ? 0.15 : 0.0;

        if (highShaders)
            camHUD.addShader(crtUsa);
        camGame.addShader(crtUsa);
    }
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 2, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
}


function postCreate() {
    screenVignette = new FlxSprite();
    screenVignette.loadGraphic(Paths.image("vignette"));
    screenVignette.setGraphicSize(FlxG.width, FlxG.height, true);
    screenVignette.scrollFactor.set(0, 0);
    screenVignette.alpha = 0.5;
    screenVignette.color = FlxColor.BLACK;
    screenVignette.screenCenter();

    dadBaseX = dad.x;

    add(screenVignette);
    screenVignette.cameras = [camHUD];

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);


    cielo.alpha = 0;
    flor1.alpha = 0;
    flor2.alpha = 0;
    suelo_usa.alpha = 0;
    arbusto.alpha = 0;
    montana.alpha = 0;
    integrantes.alpha = 0;
    nivel.alpha = 0;
    usa_run.alpha = 0;
    
    pacma_run.alpha = 0;
    cables.alpha = 0;
    suelo_pacma.alpha = 0;
    pacma_negro.alpha = 0;
    primos3.alpha = 0;
    primos2.alpha = 0;
    primos1.alpha = 0;

    primos31.alpha = 0;
    primos21.alpha = 0;
    primos11.alpha = 0;
    primos32.alpha = 0;
    primos22.alpha = 0;
    primos12.alpha = 0;
    
    gf.alpha = 0;
    strumLines.members[3].characters[0].alpha = 0;

    nivel1.alpha = 0;
    nivel2.alpha = 0;
    sombras1.alpha = 0;
    sombras2.alpha = 0;
    florecillas1.alpha = 0;
    florecillas2.alpha = 0;
    arbustoRun1.alpha = 0;
    arbustoRun2.alpha = 0;

    black.alpha = 0;

    get.alpha = 0;
    back.alpha = 0;
    here.alpha = 0;

    you.alpha = 0;
    know.alpha = 0;
    what.alpha = 0;
    comes.alpha = 0;
    next.alpha = 0;

    loop.alpha = 0;
    loop_red.alpha = 0;

    foto.alpha = 0;

    finale.alpha = 0;

    quesito.alpha = 0;
    tumorcindo.alpha = 0;
    abrazos_gratis.alpha = 0;
    ayuda.alpha = 0;

    runLayers = [
        { sprites: [nivel1, nivel2], width: 0, speedFactor: 0.3 },
        { sprites: [sombras1, sombras2], width: 0, speedFactor: 0.5 },
        { sprites: [florecillas1, florecillas2], width: 0, speedFactor: 0.6 },
        { sprites: [arbustoRun1, arbustoRun2], width: 0, speedFactor: 0.8 },

        { sprites: [primos11, primos12], width: 0, speedFactor: 0.7 },
        { sprites: [primos21, primos22], width: 0, speedFactor: 0.5 },
        { sprites: [primos31, primos32], width: 0, speedFactor: 0.3 },
    ];

    for (layer in runLayers) {

        layer.width = getWidth(layer.sprites[0]);

        for (i in 0...layer.sprites.length) {
            layer.sprites[i].x = layer.sprites[0].x + layer.width * i;
        }
    }


    FlxTween.tween(
            quesito,
            { y: quesito.y - 30 }, 
            2.2,               
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
    FlxTween.tween(
            tumorcindo,
            { y: tumorcindo.y - 30 }, 
            2.1,              
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
    FlxTween.tween(
            abrazos_gratis,
            { y: abrazos_gratis.y - 30 }, 
            1.9,                
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
    FlxTween.tween(
            ayuda,
            { y: ayuda.y - 30 }, 
            2,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
}

function update(elapsed:Float) {
    if (bobCochecito) {
        dadSineTime += elapsed * dadSineSpeed;
        dad.x = dadBaseX + Math.cos(dadSineTime / 2) * 1.5 * dadSineAmount;
    }

    for (layer in runLayers)
        moveLayerHorizontal(layer, elapsed);

}

function destroy() {
    FlxG.camera.setFilters([]);
}

function stepHit() { 

    

    if (curStep == 32) {
        FlxTween.tween(opening, {alpha: 0}, 0.6);
    }

     if (curStep == 688) {
        negro.alpha = 0;

        cielo.alpha = 1;
        flor1.alpha = 1;
        flor2.alpha = 1;
        suelo_usa.alpha = 1;
        arbusto.alpha = 1;
        montana.alpha = 1;
        integrantes.alpha = 1;
        nivel.alpha = 1;
    }

    if (curStep == 1488) {
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y - 1000}, 1.7, {ease: FlxEase.quintIn});
    }

    if (curStep == 1504) {
        FlxTween.tween(black, {alpha: 1}, 0.4);
    }

    if (curStep == 1508) {
        get.alpha = 1;
    }

    if (curStep == 1512) {
        bobCochecito = true;

        back.alpha = 1;

        flor1.alpha = 0;
        flor2.alpha = 0;
        suelo_usa.alpha = 0;
        arbusto.alpha = 0;
        montana.alpha = 0;
        integrantes.alpha = 0;
        nivel.alpha = 0;

        usa_run.alpha = 1;
        nivel1.alpha = 1;
        nivel2.alpha = 1;
        sombras1.alpha = 1;
        sombras2.alpha = 1;
        florecillas1.alpha = 1;
        florecillas2.alpha = 1;
        arbustoRun1.alpha = 1;
        arbustoRun2.alpha = 1;
        loop.alpha = 1;
    }

    if (curStep == 1516) {
        here.alpha = 1;
    }

    if (curStep == 1520) {
        FlxTween.tween(get, {alpha: 0}, 0.6);
        FlxTween.tween(back, {alpha: 0}, 0.6);
        FlxTween.tween(here, {alpha: 0}, 0.6);
        FlxTween.tween(black, {alpha: 0}, 0.6);
        
        camGame.scroll.y = -1000;
    }

    if (curStep == 1656) {
        FlxTween.tween(alhambrito, {x: alhambrito.x - 6000}, 2);
    }

    if (curStep == 1776) {
        FlxTween.tween(healthBar, {alpha: 0}, 0.5);
        FlxTween.tween(healthBarBG, {alpha: 0}, 0.5);
        FlxTween.tween(iconP1, {alpha: 0}, 0.5);
        FlxTween.tween(iconP2, {alpha: 0}, 0.5);
    }

    if (curStep == 1784) {
        bobCochecito = false;

        cielo.alpha = 0;

        dad.alpha = 0;

        suelo_pacma.alpha = 1;
        pacma_negro.alpha = 1;

        usa_run.alpha = 0;
        nivel1.alpha = 0;
        nivel2.alpha = 0;
        sombras1.alpha = 0;
        sombras2.alpha = 0;
        florecillas1.alpha = 0;
        florecillas2.alpha = 0;
        arbustoRun1.alpha = 0;
        arbustoRun2.alpha = 0;
        loop.alpha = 0;

        strumLines.members[3].characters[0].alpha = 1;

    }

    if (curStep == 1888) {
        dad.alpha = 0;

        dad.x = -2200;
    }

    if (curStep == 1920) {
        FlxTween.tween(healthBar, {alpha: 1}, 0.5);
        FlxTween.tween(healthBarBG, {alpha: 1}, 0.5);
        FlxTween.tween(iconP1, {alpha: 1}, 0.5);
        FlxTween.tween(iconP2, {alpha: 1}, 0.5);
    }

    if (curStep == 2040) {
        FlxTween.tween(camGame.scroll, {x: -450}, 0.8, {ease: FlxEase.circInOut});
        FlxTween.tween(camGame.scroll, {y: -81}, 0.8, {ease: FlxEase.circInOut});
    }

    if (curStep == 2048) {
        FlxTween.tween(cables, {alpha: 1}, 0.5);
        FlxTween.tween(primos3, {alpha: 1}, 0.3);
        FlxTween.tween(primos2, {alpha: 1}, 0.3);
        FlxTween.tween(primos1, {alpha: 1}, 0.3);
        FlxTween.tween(gf, {alpha: 1}, 0.5);

        strumLines.members[3].characters[0].cameraOffset.y = -440;
    }

    if (curStep == 2052) {
        dad.alpha = 0;

        dad.x = -230;
    }

    if (curStep == 2584) {
        dad.alpha = 1;

        strumLines.members[3].characters[0].y = 30;
        strumLines.members[3].characters[0].x = -10;
    }

    if (curStep == 3040) {
        black.alpha = 1;
    }

    if (curStep == 3056) {
        FlxTween.tween(foto, {alpha: 1}, 5);
        FlxTween.tween(foto.scale, {x: 0.55, y: 0.55}, 15);
    }

    if (curStep == 3176) {
        FlxTween.tween(healthBar, {alpha: 1}, 0.5);
        FlxTween.tween(healthBarBG, {alpha: 1}, 0.5);
        FlxTween.tween(iconP1, {alpha: 1}, 0.5);
        FlxTween.tween(iconP2, {alpha: 1}, 0.5);
    }

    if (curStep == 3184) {
        camGame.scroll.x =  430;
        camGame.scroll.y = -500;
        black.alpha = 0;
    }

    if (curStep == 3180) {
        foto.alpha = 0;
    }

    if (curStep == 3304) {
        FlxTween.tween(quesito, {alpha: 0.8}, 0.2);
    }

    if (curStep == 3305) {
        FlxTween.tween(tumorcindo, {alpha: 0.8}, 0.2);
    }

    if (curStep == 3306) {
        FlxTween.tween(abrazos_gratis, {alpha: 0.8}, 0.2);
    }

    if (curStep == 3307) {
        FlxTween.tween(ayuda, {alpha: 0.8}, 0.2);
    }

    if (curStep == 3552) {
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y - 1000}, 1.7, {ease: FlxEase.quintIn});
    }

    if (curStep == 3564) {
        FlxTween.tween(black, {alpha: 1}, 0.6);
    }

    if (curStep == 3564) {
        you.alpha = 1;
    }

    if (curStep == 3568) {
        know.alpha = 1;
    }

    if (curStep == 3571) {
        what.alpha = 1;
    }

    if (curStep == 3574) {
        comes.alpha = 1;
    }

    if (curStep == 3576) {
        bobCochecito = true;

        strumLines.members[3].characters[0].alpha = 0;

        pacma_run.alpha = 1;
        suelo_pacma.alpha = 0;

        primos3.alpha = 0;
        primos2.alpha = 0;
        primos1.alpha = 0;

        primos31.alpha = 1;
        primos21.alpha = 1;
        primos11.alpha = 1;
        primos32.alpha = 1;
        primos22.alpha = 1;
        primos12.alpha = 1;
        loop_red.alpha = 1;
    }

    if (curStep == 3578) {
        next.alpha = 1;
    }

    if (curStep == 3584) {
        FlxTween.tween(you, {alpha: 0}, 0.6);
        FlxTween.tween(know, {alpha: 0}, 0.6);
        FlxTween.tween(what, {alpha: 0}, 0.6);
        FlxTween.tween(comes, {alpha: 0}, 0.6);
        FlxTween.tween(next, {alpha: 0}, 0.6);
        FlxTween.tween(black, {alpha: 0}, 0.6);

        camGame.scroll.y = -1000;
    }

    if (curStep == 3863) {
        black.alpha = 1;
        finale.alpha = 1;
        FlxTween.tween(finale.scale, {x: 0.8, y: 0.8}, 3, {ease: FlxEase.quintOut});
    }

    if (curStep == 3896) {
        finale.alpha = 0;
    }
}

function getWidth(spr) {
    return spr.frameWidth * spr.scale.x;
}

function moveLayerHorizontal(layer, elapsed) {

    var h = layer.width;
    var n = layer.sprites.length;
    var speed = runSpeed * layer.speedFactor;

    for (spr in layer.sprites)
        spr.x += speed * elapsed;

    for (i in 0...n) {

        var spr = layer.sprites[i];

        if (speed < 0) {
            if (spr.x + h < -h - runLoopOffset)
                spr.x += h * n;
        } else {
            if (spr.x > FlxG.width + h + runLoopOffset)
                spr.x -= h * n;
        }

    }
}

function setRunSpeed(value, time) {
    value = Std.parseFloat(value);
    time = Std.parseFloat(time);

    FlxTween.num(runSpeed, value, time, { ease: FlxTween.quadOut }, function(v:Float) {
        runSpeed = v;
    });
}
