var blackOverlay;
var dadBaseY:Float = 0;
var dadBaseX:Float = 0;
var dadSineTime:Float = 2;
var dadSineAmount:Float = 60;
var dadSineSpeed:Float = 4;
var bobFly:Bool = false;

var skySpeed = 6000;
var skyLayers = [];
var skyLoopOffset:Float = -2000;

function postCreate() {

    cielo.alpha = 0;
    montana.alpha = 0;
    nubes.alpha = 0;
    castillo.alpha = 0;
    colina3.alpha = 0;
    colina2.alpha = 0;
    colina1.alpha = 0;
    globo1.alpha = 0;
    globo2.alpha = 0;
    globo3.alpha = 0;
    globo4.alpha = 0;
    sky1.alpha = 0;
    sky2.alpha = 0;
    bluey.alpha = 0;
    amoroso.alpha = 0;
    mcqueen.alpha = 0;
    dora.alpha = 0;
    transicion.alpha = 0;
    sol.alpha = 0;
    atras.alpha = 0;
    delante.alpha = 0;
    bobosome.alpha = 0;

    dadBaseY = dad.y;
    dadBaseX = dad.x;

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    skyLayers = [
        { sprites: [sky1, sky2], height: 0, speedFactor: 0.5 },
    ];

    for (layer in skyLayers) {

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
        dad.x = dadBaseX + Math.cos(dadSineTime / 2) * 2 * dadSineAmount;
    }

    for (layer in skyLayers)
        moveLayerVertical(layer, elapsed);
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 6, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
}

function stepHit(curStep:Int) {
    
    if(curStep == 512) {
        bobFly = true;

        FlxTween.tween(cielo, {alpha: 1}, 0.4);
        FlxTween.tween(montana, {alpha: 1}, 0.4);
        FlxTween.tween(nubes, {alpha: 1}, 0.4);
        FlxTween.tween(castillo, {alpha: 1}, 0.4);
        FlxTween.tween(colina3, {alpha: 1}, 0.4);
        FlxTween.tween(colina2, {alpha: 1}, 0.4);
        FlxTween.tween(colina1, {alpha: 1}, 0.4);
    }

    if(curStep == 1008) {

        FlxTween.tween(cielo, {alpha: 0}, 1.6);
        FlxTween.tween(nubes, {alpha: 0}, 1.6);

        FlxTween.tween(castillo, {y: castillo.y + 1900,}, 1.6, {ease: FlxEase.quadIn});

        FlxTween.tween(colina3, {
            y: colina3.y + 1900,
        }, 1.6, {ease: FlxEase.quadIn});

        FlxTween.tween(colina2, {
            y: colina2.y + 1900,
        }, 1.6, {ease: FlxEase.quadIn
        });

        FlxTween.tween(colina1, {
            y: colina1.y + 1900,
        }, 1.6, {ease: FlxEase.quadIn
        });

        FlxTween.tween(nubes, {
            y: nubes.y + 100,
        }, 1.6, {ease: FlxEase.quadIn
        });

        FlxTween.tween(montana, {
            y: montana.y + 900,
        }, 1.6, {ease: FlxEase.quadIn
        });
    }

    if(curStep == 1016) {
        FlxTween.tween(camera, {zoom: camera.zoom + 0.2}, 0.8, {ease: FlxEase.quartIn});
        FlxTween.tween(cielo, {alpha: 0}, 0.8);
    }

    if(curStep == 1024) {
        castillo.alpha = 0;
        colina3.alpha = 0;
        colina2.alpha = 0;
        colina1.alpha = 0;
        montana.alpha = 0;

        FlxTween.tween(globo1, {alpha: 1}, 1);
        FlxTween.tween(globo2, {alpha: 1}, 1);
        FlxTween.tween(globo3, {alpha: 1}, 1);
        FlxTween.tween(globo4, {alpha: 1}, 1);
    }

    if(curStep == 1520) {

        FlxTween.tween(globo1, {
            y: globo1.y + 2500,
        }, 1.2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(globo2, {
            y: globo2.y + 2500,
        }, 1.2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(globo3, {
            y: globo3.y + 2500,
        }, 1.2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(globo4, {
            y: globo4.y + 3000,
        }, 1.2, {ease: FlxEase.quadIn
        });
    }

    if(curStep == 1528) {
        FlxTween.tween(camera, {zoom: camera.zoom + 0.2}, 0.8, {ease: FlxEase.quartIn});
    }

    if(curStep == 1536) {
        globo1.alpha = 0;
        globo2.alpha = 0;
        globo3.alpha = 0;
        globo4.alpha = 0;

        FlxTween.tween(sky1, {alpha: 1}, 1);
        FlxTween.tween(sky2, {alpha: 1}, 1);
    }

    if(curStep == 1792) {
        bluey.alpha = 1;
        amoroso.alpha = 1;
        mcqueen.alpha = 1;
        dora.alpha = 1;
    }

    if(curStep == 1800) {
        FlxTween.tween(dora, {x: dora.x + 200}, 30);
        FlxTween.tween(dora, {y: dora.y - 12250}, 30);
    }

    if(curStep == 1848) {
        FlxTween.tween(amoroso, {x: amoroso.x - 200}, 30);
        FlxTween.tween(amoroso, {y: amoroso.y - 12250}, 30);
    }

    if(curStep == 1895) {
        FlxTween.tween(bluey, {x: bluey.x + 200}, 30);
        FlxTween.tween(bluey, {y: bluey.y - 12250}, 30);
    }

    if(curStep == 1938) {
        FlxTween.tween(mcqueen, {x: mcqueen.x - 200}, 30);
        FlxTween.tween(mcqueen, {y: mcqueen.y - 12250}, 30);
    }

    if (curStep == 2032) {
        bobFly = false;
    }

    if (curStep == 2042) {
        transicion.alpha = 1;
        transicion.y = -2000;
        FlxTween.tween(transicion, {y:1200}, 0.9, {ease: FlxEase.quadInOut});
        dad.x = -3077;
        dad.y = -1112;

    }


    if (curStep == 2048) {
        FlxTween.tween(bobosome, {y: bobosome.y - 900}, 3, {ease: FlxEase.quadOut});

        sol.alpha = 1;
        atras.alpha = 1;
        delante.alpha = 1;
        bobosome.alpha = 1;
        sky1.alpha = 0;
        sky2.alpha = 0;
        FlxTween.tween(camera, {zoom: camera.zoom + 0.08}, 80);

        dad.y = -1242;
    }

    if (curStep == 2280) {
        FlxTween.tween(bobosome, {y: bobosome.y - 1200}, 3, {ease: FlxEase.quadIn});
    }
}


//The next code is by Ugt I just yoinked it from powerscaling

function getHeight(spr) {
    return spr.frameHeight * spr.scale.y;
}

function moveLayerVertical(layer, elapsed) {

    var h = layer.height;
    var n = layer.sprites.length;
    var speed = skySpeed * layer.speedFactor;

    for (spr in layer.sprites)
        spr.y += speed * elapsed;

    for (i in 0...n) {

        var spr = layer.sprites[i];

        if (speed < 0) {
            if (spr.y + h < -h - skyLoopOffset)
                spr.y += h * n;
        } else {
            if (spr.y > FlxG.height + h + skyLoopOffset)
                spr.y -= h * n;
        }

    }
}

function setskySpeed(value, time) {
    value = Std.parseFloat(value);
    time = Std.parseFloat(time);

    FlxTween.num(skySpeed, value, time, { ease: FlxTween.quadOut }, function(v:Float) {
        skySpeed = v;
    });
}
