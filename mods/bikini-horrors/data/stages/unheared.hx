var whiteOverlay;

var blackOverlay;
public var nick:FlxSprite;

var leftSpeed = -2000;
var leftLayers = [];
var leftLoopOffset:Float = -2000;

var rightSpeed = 2000;
var rightLayers = [];
var rightLoopOffset:Float = -2000;

var fallingSpeed = 2000;
var fallingLayers = [];
var fallingLoopOffset:Float = -2000;

function hudVisibility(val:Bool, time:Float){
        var alphaValue = 0;
        if (val)
            alphaValue = 1;
        FlxTween.tween(healthBar, {alpha:alphaValue}, time);
        FlxTween.tween(healthBarBG, {alpha:alphaValue}, time);
        FlxTween.tween(iconP1, {alpha:alphaValue}, time);
        FlxTween.tween(iconP2, {alpha:alphaValue}, time);
        FlxTween.tween(scoreTxt, {alpha:alphaValue}, time);
        FlxTween.tween(missesTxt, {alpha:alphaValue}, time);
        FlxTween.tween(accuracyTxt, {alpha:alphaValue}, time);
        setHudArrowsAlpha(alphaValue, time);
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 2, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
}

function postCreate()
{
    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    
    whiteOverlay = new FunkinScreenOverlay(FlxColor.WHITE);
    whiteOverlay.scale.x = 5;
    whiteOverlay.scale.y = 5;
    whiteOverlay.alpha = 1;
    whiteOverlay.cameras = [camGame];
    insert(0, whiteOverlay);
    add(whiteOverlay);

    gf.alpha = 0;
    boyfriend.alpha = 0;
    dad.alpha = 0;

    cielo.alpha = 0;
    monte.alpha = 0;
    suelo.alpha = 0;

    vacio.alpha = 0;
    bf_fall.alpha = 0;

    baldosas.alpha = 0;
    stars.alpha = 0;
    papeles.alpha = 0;

    game.alpha = 0;
    breaker.alpha = 0;

    chispotas.alpha = 0;

    fb1.alpha = 0;
    fb2.alpha = 0;
    fb3.alpha = 0;
    fb4.alpha = 0;
    fb5.alpha = 0;
    fb6.alpha = 0;
    fb7.alpha = 0;

    papers1.alpha = 0;
    papers2.alpha = 0;
    falling1.alpha = 0;
    falling2.alpha = 0;
    foreground1.alpha = 0;
    foreground2.alpha = 0;
    otro1.alpha = 0;
    otro2.alpha = 0;

    retrospective.alpha = 0;

    FlxTween.color(dad, 0.2, 0xFF303492, FlxColor.BLACK);
    FlxTween.color(boyfriend, 0.2, 0xFF303492, FlxColor.BLACK);
    
    leftLayers = [
        {
            sprites: [papers1, papers2],
            width: 0,
            speedFactor: 0.7,
            startX: papers1.x
        },
        {
            sprites: [otro1, otro2],
            width: 0,
            speedFactor: 0.8,
            startX: otro1.x
        },
    ];

    for (layer in leftLayers) {

        layer.width = getWidth(layer.sprites[0]);

        for (i in 0...layer.sprites.length) {
            layer.sprites[i].x = layer.startX + layer.width * i;
        }
    }

    rightLayers = [
        {
            sprites: [foreground1, foreground2],
            width: 0,
            speedFactor: 0.9,
            startX: foreground1.x
        },
    ];

    for (layer in rightLayers) {

        layer.width = getWidth(layer.sprites[0]);

        for (i in 0...layer.sprites.length) {
            layer.sprites[i].x = layer.startX + layer.width * i;
        }
    }

    fallingLayers = [
        {
            sprites: [falling1, falling2],
            height: 0,
            speedFactor: 0.6,
            startY: falling1.y
        }
    ];

    for (layer in fallingLayers) {

        layer.height = layer.sprites[0].frameHeight * layer.sprites[0].scale.y;

        for (i in 0...layer.sprites.length) {
            layer.sprites[i].y = layer.startY + layer.height * i;
        }
    }
}

function update(elapsed:Float) {

    for (layer in leftLayers)
        moveLayerHorizontal(layer, elapsed, leftSpeed);

    for (layer in rightLayers)
        moveLayerHorizontal(layer, elapsed, rightSpeed);

    for (layer in fallingLayers)
        moveLayerVertical(layer, elapsed, fallingSpeed);
}

function stepHit() { 

    if (curStep == 1) {
        boyfriend.alpha = 0;
        dad.alpha = 0;
    
        hudVisibility(false, 0.7);
    }

    if (curStep == 4) {
        setHudArrowsAlpha(0);
    }

    if (curStep == 32) {
        FlxTween.tween(dad, {alpha: 1}, 0.6);
    }

    if (curStep == 88) {
        setHudArrowsAlpha(1, 0.3);
    }

    if (curStep == 96) {
        FlxTween.tween(boyfriend, {alpha: 1}, 0.6);
    }

    if (curStep == 152) {
        FlxTween.tween(camera, {zoom: camera.zoom + 0.8}, 0.8, {ease: FlxEase.quintIn});
        game.alpha = 1;

        FlxTween.tween(game, {x: game.x - 12}, 0.02, {
            type: FlxTween.PINGPONG
        });
        FlxTween.tween(game, {y: game.y - 12}, 0.04, {
            type: FlxTween.PINGPONG
        });
    }

    if (curStep == 156) {
        game.alpha = 0;
        breaker.alpha = 1;

        FlxTween.tween(breaker, {x: breaker.x - 12}, 0.02, {
            type: FlxTween.PINGPONG
            });
        FlxTween.tween(breaker, {y: breaker.y - 12}, 0.04, {
            type: FlxTween.PINGPONG
            });
    }

    if (curStep == 160) {
        breaker.alpha = 0;

        gf.alpha = 1;
        cielo.alpha = 1;
        monte.alpha = 1;
        suelo.alpha = 1;

        hudVisibility(true, 0.3);
    }

    if (curStep == 664) {
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y + 500}, 0.88, {ease: FlxEase.quintIn});
    }

    if (curStep == 672) {
        hudVisibility(false, 0.3);
    }

    if (curStep == 678) {
        gf.alpha = 0;
        cielo.alpha = 0;
        monte.alpha = 0;
        suelo.alpha = 0;
        boyfriend.alpha = 0;
        dad.alpha = 0;
        FlxTween.color(whiteOverlay, 0.1, FlxColor.WHITE, FlxColor.BLACK);

        vacio.alpha = 1;
        bf_fall.alpha = 1;
    }
    
    if (curStep == 679) {
        FlxTween.tween(vacio, {y: vacio.y - 300}, 40);
        FlxTween.tween(bf_fall, {y: bf_fall.y + 500}, 40);
    }

    if (curStep == 928) {
        vacio.alpha = 0;
        bf_fall.alpha = 0;
        camGame.scroll.y = camGame.scroll.y - 3000;
    }

    if (curStep == 944) {
        FlxTween.color(whiteOverlay, 1.5, FlxColor.BLACK, 0xFF1201FF);
    }

    if (curStep == 960) {
        FlxTween.tween(baldosas, {alpha: 1}, 0.6);
        FlxTween.tween(stars, {alpha: 1}, 0.6);

        hudVisibility(true, 0.3);

        gf.x = 1050;
    }

    if (curStep == 1216) {
        FlxTween.tween(papeles, {alpha: 1}, 2);
        FlxTween.tween(stars, {alpha: 0}, 2);
    }

    if (curStep == 1464) {
        FlxTween.tween(camera, {zoom: camera.zoom + 0.8}, 0.73, {ease: FlxEase.quintIn});
    }

    if (curStep == 1472) {
        baldosas.alpha = 0;
        papeles.alpha = 0;
        chispotas.alpha = 1;

        boyfriend.alpha = 0;
        dad.alpha = 0;

        hudVisibility(false, 0.3);

        FlxTween.tween(camera, {zoom: 0.2}, 0.02);

        FlxTween.color(whiteOverlay, 0.05, 0xFF1201FF, FlxColor.BLACK);

        FlxTween.tween(fb1, {alpha: 1}, 1);
        FlxTween.tween(fb1.scale, {x: 0.5, y: 0.5}, 20);
    }

    if (curStep == 1500) {
        FlxTween.tween(fb1, {alpha: 0}, 1);
    }

    if (curStep == 1504) {
        FlxTween.tween(fb2, {alpha: 1}, 1);
        FlxTween.tween(fb2.scale, {x: 0.5, y: 0.5}, 20);
    }

    if (curStep == 1532) {
        FlxTween.tween(fb2, {alpha: 0}, 1);
    }

    if (curStep == 1536) {
        FlxTween.tween(fb3, {alpha: 1}, 1);
        FlxTween.tween(fb3.scale, {x: 1.3, y: 1.3}, 20);
    }

    if (curStep == 1564) {
        FlxTween.tween(fb3, {alpha: 0}, 1);
    }

    if (curStep == 1568) {
        FlxTween.tween(fb4, {alpha: 1}, 1);
        FlxTween.tween(fb4.scale, {x: 0.5, y: 0.5}, 20);
    }

    if (curStep == 1596) {
        FlxTween.tween(fb4, {alpha: 0}, 1);
    }

    if (curStep == 1600) {
        FlxTween.tween(fb5, {alpha: 1}, 1);
        FlxTween.tween(fb5.scale, {x: 0.5, y: 0.5}, 20);
    }

    if (curStep == 1628) {
        FlxTween.tween(fb5, {alpha: 0}, 1);
    }

    if (curStep == 1632) {
        FlxTween.tween(fb6, {alpha: 1}, 1);
        FlxTween.tween(fb6.scale, {x: 0.5, y: 0.5}, 20);
    }
    
    if (curStep == 1660) {
        FlxTween.tween(fb6, {alpha: 0}, 1);
    }

    if (curStep == 1664) {
        FlxTween.tween(fb7, {alpha: 1}, 1);
        FlxTween.tween(fb7.scale, {x: 0.5, y: 0.5}, 20);
    }

    if (curStep == 1727) {
        fb7.alpha = 0;
        chispotas.alpha = 0;

        camera.zoom = 0.4;

        FlxTween.color(whiteOverlay, 0.05, FlxColor.BLACK, FlxColor.WHITE);
    }

    if (curStep == 1848) {
        FlxTween.tween(camera, {zoom: camera.zoom + 0.8}, 0.8, {ease: FlxEase.quintIn});
        game.alpha = 1;

        FlxTween.tween(game, {x: game.x - 12}, 0.02, {
            type: FlxTween.PINGPONG
        });
        FlxTween.tween(game, {y: game.y - 12}, 0.04, {
            type: FlxTween.PINGPONG
        });
    }

    if (curStep == 1852) {
        game.alpha = 0;
        breaker.alpha = 1;

        FlxTween.tween(breaker, {x: breaker.x - 12}, 0.02, {
            type: FlxTween.PINGPONG
            });
        FlxTween.tween(breaker, {y: breaker.y - 12}, 0.04, {
            type: FlxTween.PINGPONG
            });
    }

    if (curStep == 1856) {
        breaker.alpha = 0;

        papers1.alpha = 1;
        papers2.alpha = 1;
        falling1.alpha = 1;
        falling2.alpha = 1;
        foreground1.alpha = 1;
        foreground2.alpha = 1;
        otro1.alpha = 1;
        otro2.alpha = 1;

        hudVisibility(true, 0.3);

        FlxTween.color(whiteOverlay, 0.05, FlxColor.WHITE, 0xFF8C96A9);
    }

    if (curStep == 2368) {

        papers1.alpha = 0;
        papers2.alpha = 0;
        falling1.alpha = 0;
        falling2.alpha = 0;
        foreground1.alpha = 0;
        foreground2.alpha = 0;
        otro1.alpha = 0;
        otro2.alpha = 0;

        hudVisibility(false, 0.3);

        FlxTween.color(whiteOverlay, 0.05, 0xFF8C96A9, FlxColor.WHITE);
    }

    if (curStep == 2380) {
        FlxTween.tween(camera, {zoom: camera.zoom - 0.58}, 10.35);
    }

    if (curStep == 2488) {
        setHudArrowsAlpha(1, 0.3);
    }

    if (curStep == 2626) {
        setHudArrowsAlpha(1, 0.2);
    }

    if (curStep == 2496) {
        retrospective.alpha = 1;
    }

    if (curStep == 2704) {
        FlxG.switchState(new ModState("AfterUnhearedState"));
    }

}

//Soy la mayor fan de este script gracias ug32t

function getWidth(spr) {
    return spr.frameWidth * spr.scale.x;
}

function moveLayerHorizontal(layer, elapsed, speed) {

    var h = layer.width;

    for (spr in layer.sprites) {
        spr.x += speed * layer.speedFactor * elapsed;
    }

    for (spr in layer.sprites) {

        if (speed < 0) {

            // izquierda
            if (spr.x <= layer.startX - h) {

                var maxX = layer.sprites[0].x;

                for (other in layer.sprites) {
                    if (other.x > maxX)
                        maxX = other.x;
                }

                spr.x = maxX + h;
            }

        } else {

            // derecha
            if (spr.x >= layer.startX + h) {

                var minX = layer.sprites[0].x;

                for (other in layer.sprites) {
                    if (other.x < minX)
                        minX = other.x;
                }

                spr.x = minX - h;
            }
        }
    }
}

function moveLayerVertical(layer, elapsed, speed) {

    var h = layer.height;

    for (spr in layer.sprites) {
        spr.y += speed * layer.speedFactor * elapsed;
    }

    for (spr in layer.sprites) {

        if (speed > 0) {

            if (spr.y >= layer.startY + h) {

                var minY = layer.sprites[0].y;

                for (other in layer.sprites) {
                    if (other.y < minY)
                        minY = other.y;
                }

                spr.y = minY - h;
            }

        } else {

            if (spr.y <= layer.startY - h) {

                var maxY = layer.sprites[0].y;

                for (other in layer.sprites) {
                    if (other.y > maxY)
                        maxY = other.y;
                }

                spr.y = maxY + h;
            }
        }
    }
}

function setleftSpeed(value, time) {
    value = Std.parseFloat(value);
    time = Std.parseFloat(time);

    FlxTween.num(leftSpeed, value, time, { ease: FlxTween.quadOut }, function(v:Float) {
        leftSpeed = v;
    });
}

function setrightSpeed(value, time) {
    value = Std.parseFloat(value);
    time = Std.parseFloat(time);

    FlxTween.num(rightSpeed, value, time, { ease: FlxTween.quadOut }, function(v:Float) {
        rightSpeed = v;
    });
}
