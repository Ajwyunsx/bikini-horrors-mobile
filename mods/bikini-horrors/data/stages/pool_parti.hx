static var subaru:Character;
static var squid:Character;
static var krabity:Character;

var blackOverlay;
var canShake:Bool;
var verySHAKE:Bool;
var bgCanvas:FlxSprite;
var bgShader:CustomShader = null;
var fishEyeShader:CustomShader = null;
var dadSineTime:Float = 2;
var dadSineAmount:Float = 160;
var dadSineSpeed:Float = 2;
var bobFly:Bool = false;
var dadBaseY:Float = 0;
var dadBaseX:Float = 0;
var isDownscroll:Bool = camHUD.downscroll;

var camTween:FlxTween;

var skySpeed = 6000;
var motoSpeed = -5000;
var skyLayers = [];
var motoLayers = [];
var skyLoopOffset:Float = -2000;



function postCreate()
{
    camZooming = true;
    canShake = false;

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    josejuanlike.cameras = [camHUD];
    josejuanlike.scrollFactor.set(0, 0);
    josejuanlike.scale.set(0.8, 0.8);

    if (isDownscroll) {
        josejuanlike.screenCenter(0x01);
        josejuanlike.y = -580;
    } 
    else {
        josejuanlike.angle = 0;
        josejuanlike.flipY = false;
        josejuanlike.screenCenter(0x01);
        josejuanlike.y = 180;
    }

    gf.visible = false;
    barnacles.alpha = 0;
    Field.alpha = 0;
    Satan.alpha = 0;
    sp_plataforma.alpha = 0;
    sw_plataforma.alpha = 0;

    kenny.alpha = 0;
    bobTriste.alpha = 0;
    spongebud.alpha = 0;
    spongelord.alpha = 0;
    bros_pl.alpha = 0;
    triste_pl.alpha = 0;
    bud_pl.alpha = 0;
    lord_pl.alpha = 0;

    temu.alpha = 0;
    doll.alpha = 0;
    dvd.alpha = 0;
    ketchup.alpha = 0;
    mermaid.alpha = 0;
    sanded.alpha = 0;
    usa.alpha = 0;
    gnomo.alpha = 0;
    crisbobalpoolparty.alpha = 0;

    cielo.alpha = 0;
    isla.alpha = 0;
    plataformas.alpha = 0;
    luz.alpha = 0;

    skyLayers = [
        { sprites: [phase2_01, phase2_02], height: 0, speedFactor: 0.3 },
        { sprites: [phase2_11, phase2_12], height: 0, speedFactor: 0.4 },
        { sprites: [phase2_21, phase2_22], height: 0, speedFactor: 0.5 }
    ];

    motoLayers = [
        { sprites: [phase3_0, phase3_01], width: 0, speedFactor: 0.1, startX: phase3_0.x },
        { sprites: [phase3_1, phase3_11], width: 0, speedFactor: 0.15, startX: phase3_0.x },
        { sprites: [phase3_2, phase3_21], width: 0, speedFactor: 0.2, startX: phase3_0.x },
        { sprites: [phase3_3, phase3_31], width: 0, speedFactor: 0.25, startX: phase3_0.x },
        { sprites: [phase3_4, phase3_41], width: 0, speedFactor: 0.25, startX: phase3_0.x },
        { sprites: [phase3_4_5, phase3_4_51], width: 0, speedFactor: 0.25, startX: phase3_0.x },
        { sprites: [phase3_5, phase3_51], width: 0, speedFactor: 0.4, startX: phase3_0.x },
        { sprites: [phase3_6, phase3_61], width: 0, speedFactor: 0.8, startX: phase3_0.x },
        { sprites: [phase3_7, phase3_71], width: 0, speedFactor: 0.8, startX: phase3_0.x }
    ];

    for (layer in skyLayers) {

        layer.height = getHeight(layer.sprites[0]);

        for (i in 0...layer.sprites.length) {
            layer.sprites[i].y = layer.sprites[0].y + layer.height * i;
        }
    }

    for (layer in motoLayers) {

        layer.width = getWidth(layer.sprites[0]);

        for (i in 0...layer.sprites.length) {
            layer.sprites[i].x = layer.startX + layer.width * i;
        }
    }

   subaru = new Character(boyfriend.x - 38, boyfriend.y + 83, "subaru_phase4", true);
   subaru.alpha = 0;
   add(subaru);

   krabity = new Character(boyfriend.x - 38, boyfriend.y + 83, "krabitipatiti_phase4", true);
   krabity.alpha = 0;
   add(krabity);

   squid = new Character(boyfriend.x - 38, boyfriend.y + 83, "squidwirdy_phase4", true);
   squid.alpha = 0;
   add(squid);

   if (Options.shaderQualityAllows(2)) {
        bgCanvas = new FunkinSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
        bgCanvas.scrollFactor.set(0, 0);
        bgShader = new CustomShader("livinglavidaloca");
        bgShader.data.u_time.value = [0.0];
        bgCanvas.zoomFactor = 0;
        bgCanvas.shader = bgShader;

        fishEyeShader = new CustomShader("fishEye");
        fishEyeShader.intensity = 0.0;
        fishEyeShader.zoom = 1.0;
    }

   ogStrumX = [];
    for (strum in playerStrums.members) {
        ogStrumX.push(strum.x);
    }

}

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

function floatV3() {
        FlxTween.tween(
            dvd,
            { y: dvd.y + 30 }, 
            2.2,               
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            doll,
            { y: doll.y + 30 }, 
            2.1,              
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            ketchup,
            { y: ketchup.y + 30 }, 
            1.9,                
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            temu,
            { y: temu.y + 30 }, 
            2,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            mermaid,
            { y: mermaid.y + 30 }, 
            1.8,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            usa,
            { y: usa.y + 30 }, 
            2.1,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            gnomo,
            { y: gnomo.y + 30 }, 
            2,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            crisbobalpoolparty,
            { y: crisbobalpoolparty.y + 30 }, 
            2,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            sanded,
            { y: sanded.y + 30 }, 
            1.9,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
}

function chaosTween() {
    var randomAngle:Float = FlxG.random.float(-2, 2);
    var randomTime:Float = FlxG.random.float(0.4, 1);

    camTween = FlxTween.tween(camGame, {angle: randomAngle}, randomTime, {
        ease: FlxEase.sineInOut,
        onComplete: function(twn:FlxTween) {
            chaosTween();
        }
    });
}

function update(elapsed:Float) {


    for (layer in skyLayers)
        moveLayerVertical(layer, elapsed);

    for (layer in motoLayers)
        moveLayerHorizontal(layer, elapsed, motoSpeed);


    if (bgShader != null) {
        bgShader.u_time += elapsed;
    }

    if (bobFly) {
        dadSineTime += elapsed * dadSineSpeed;
        dad.y = dadBaseY + Math.sin(dadSineTime) * dadSineAmount;
        dad.x = dadBaseX + Math.cos(dadSineTime / 2) * 1.5 * dadSineAmount;
        dad.angle = Math.cos(dadSineTime / 2) * dadSineAmount / 50;
    }
}

function onDadHit() {
    if (canShake == true)
        if (verySHAKE == false)
            FlxG.camera.shake(0.004, 0.1);
        else
            FlxG.camera.shake(0.004, 0.1);
}


function stepHit(step:Int) {

    if(curStep == 1) {
        blackOverlay.alpha = 0;
    }

    if (curStep == 500) {
        kenny.y = 1300;
        bobTriste.y = 1345;
        spongebud.y = 1313;
        spongelord.y = 1309;
        bros_pl.y = 1340;
        triste_pl.y = 1163;
        bud_pl.y = 1248;
        lord_pl.y = 1422;
    }

    if (curStep == 512) {
        canShake = true;
        sp_plataforma.alpha = 1;
        sw_plataforma.alpha = 1;

        kenny.alpha = 1;
        bobTriste.alpha = 1;
        spongebud.alpha = 1;
        spongelord.alpha = 1;
        bros_pl.alpha = 1;
        triste_pl.alpha = 1;
        bud_pl.alpha = 1;
        lord_pl.alpha = 1;
        

        FlxTween.tween(phase1_0, {
            y: phase1_0.y + 1300,
        }, 1.4, {ease: FlxEase.quadOut
        });

        FlxTween.tween(phase1_1, {
            y: phase1_1.y + 1300,
        }, 1.4, {ease: FlxEase.quadOut
        });

        FlxTween.tween(phase1_2, {
            y: phase1_2.y + 1300,
        }, 1.4, {ease: FlxEase.quadOut
        });

        FlxTween.tween(phase1_4, {
            y: phase1_4.y + 1300,
        }, 1.4, {ease: FlxEase.quadOut
        });

        FlxTween.tween(phase1_5, {
            y: phase1_5.y + 1300,
        }, 1.4, {ease: FlxEase.quadOut
        });

        FlxTween.tween(phase1_6, {
            y: phase1_6.y + 1300,
        }, 1.4, {ease: FlxEase.quadOut
        });

        FlxTween.tween(phase1_7, {
            y: phase1_7.y + 1300,
        }, 1.4, {ease: FlxEase.quadOut
        });

        FlxTween.tween(cartel, {
            y: cartel.y + 1300,
        }, 1.4, {ease: FlxEase.quadOut
        });

        FlxTween.tween(boyfriend, {
            x: boyfriend.x + 300,
        }, 1.6, {ease: FlxEase.quintOut
        });

        FlxTween.tween(sw_plataforma, {
            x: sw_plataforma.x + 300,
        }, 1.6, {ease: FlxEase.quintOut
        });

        FlxTween.tween(sp_mano, {
            x: sp_mano.x - 300,
        }, 1.6, {ease: FlxEase.quintOut
        });

        FlxTween.tween(underguater_lover, {
            x: underguater_lover.x - 300,
        }, 1.6, {ease: FlxEase.quintOut
        });

        FlxTween.tween(dad, {
            x: dad.x - 300,
        }, 1.6, {ease: FlxEase.quintOut
        });

        FlxTween.tween(sp_plataforma, {
            x: sp_plataforma.x - 300,
        }, 1.6, {ease: FlxEase.quintOut
        });
    }
    
    if (curStep == 768) {
        FlxTween.tween(kenny, {
            y: kenny.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });

        FlxTween.tween(bros_pl, {
            y: bros_pl.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });
    }

    if (curStep == 896) {
        FlxTween.tween(bobTriste, {
            y: bobTriste.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });

        FlxTween.tween(triste_pl, {
            y: triste_pl.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });
    }

    if (curStep == 1024) {
        FlxTween.tween(spongebud, {
            y: spongebud.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });

        FlxTween.tween(bud_pl, {
            y: bud_pl.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });
    }

    if (curStep == 1152) {
        FlxTween.tween(spongelord, {
            y: spongelord.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });

        FlxTween.tween(lord_pl, {
            y:lord_pl.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });
    }

    if (curStep == 1296) {
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y - 1600}, 1.5, {ease: FlxEase.quintIn});

        hudVisibility(false, 0.7);
    }

    if (curStep == 1308) {
        canShake = false;
    }

    if (curStep == 1311) {
        dad.y = dad.y + 1100;
        gf.y = gf.y + 1100;

        dvd.y = dvd.y + 1100;
        temu.y = temu.y + 1100;
        ketchup.y = ketchup.y + 1100;
        mermaid.y = mermaid.y + 1100;
        doll.y = doll.y + 1100;
        sanded.y = sanded.y + 1100;
        usa.y = usa.y + 1100;
        gnomo.y = gnomo.y + 1100;
        crisbobalpoolparty.y = crisbobalpoolparty.y + 1100;

        dad.x = -100;

        Field.y = Field.y + 1100;
        Satan.y = Satan.y + 1100;

        barnacles.y = barnacles.y + 1100;

        Field.alpha = 1;
        Satan.alpha = 1;
    }

    if (curStep == 1312) {
        hudVisibility(true, 0.7);

        boyfriend.x = 1418;

        FlxTween.tween(dad, {
            y: dad.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });

        FlxTween.tween(Field, {
            y: Field.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });

        sp_plataforma.alpha = 0;
        sw_plataforma.alpha = 0;

        gf.visible = true;

        barnacles.alpha = 1;
        phase2_0.alpha = 1;
        phase2_1.alpha = 1;
        phase2_2.alpha = 1;

        temu.alpha = 1;
        doll.alpha = 1;
        dvd.alpha = 1;
        ketchup.alpha = 1;
        mermaid.alpha = 1;
        sanded.alpha = 1;
        usa.alpha = 1;
        gnomo.alpha = 1;
        crisbobalpoolparty.alpha = 1;

        phase1_0.alpha = 0;
        phase1_1.alpha = 0;
        phase1_2.alpha = 0;
        phase1_4.alpha = 0;
        phase1_5.alpha = 0;
        phase1_6.alpha = 0;
        phase1_7.alpha = 0;
        cartel.alpha = 0;
        sp_mano.alpha = 0;
        underguater_lover.alpha = 0;
        kenny.alpha = 0;
        bobTriste.alpha = 0;
        spongebud.alpha = 0;
        spongelord.alpha = 0;
        bros_pl.alpha = 0;
        triste_pl.alpha = 0;
        bud_pl.alpha = 0;
        lord_pl.alpha = 0;

        health = 1;

    }

    if (curStep == 1312) {
        var center = FlxG.width / 2;
        tweenPlayerStrumlineCustom(center, [
            -300,
            -150,
            150,
            300
        ], 1, FlxEase.quadOut);
    }

    if (curStep == 1440) {
        FlxTween.tween(gf, {
            y: gf.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });

        FlxTween.tween(Satan, {
            y: Satan.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });
    }

    if (curStep == 1550) {
        FlxTween.tween(barnacles, {
            y: barnacles.y - 1100,
        }, 1.8, {ease: FlxEase.quadOut
        });
    }

    if (curStep == 1568) {
        FlxTween.tween(doll, {
            y: doll.y - 1100,
        }, 3, {ease: FlxEase.quintOut
        });

        FlxTween.tween(dvd, {
            y: dvd.y - 1100,
        }, 3.1, {ease: FlxEase.quintOut
        });

        FlxTween.tween(ketchup, {
            y: ketchup.y - 1100,
        }, 2.9, {ease: FlxEase.quintOut
        });

        FlxTween.tween(mermaid, {
            y: mermaid.y - 1100,
        }, 3, {ease: FlxEase.quintOut
        });

        FlxTween.tween(temu, {
            y: temu.y - 1100,
        }, 3.2, {ease: FlxEase.quintOut
        });

        FlxTween.tween(usa, {
            y: usa.y - 1100,
        }, 3.2, {ease: FlxEase.quintOut
        });

        FlxTween.tween(gnomo, {
            y: gnomo.y - 1100,
        }, 3.2, {ease: FlxEase.quintOut
        });

        FlxTween.tween(crisbobalpoolparty, {
            y: crisbobalpoolparty.y - 1100,
        }, 3.2, {ease: FlxEase.quintOut
        });

        FlxTween.tween(sanded, {
            y: sanded.y - 1100,
        }, 3.2, {ease: FlxEase.quintOut
        });
    }

    if (curStep == 1600) {
        floatV3(true);
    }

    if (curStep == 2084) {
        floatV3(false);

        FlxTween.tween(doll, {
            y: doll.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(dvd, {
            y: dvd.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(ketchup, {
            y: ketchup.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(mermaid, {
            y: mermaid.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(temu, {
            y: temu.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(barnacles, {
            y: barnacles.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(usa, {
            y: usa.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(sanded, {
            y: sanded.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(gnomo, {
            y: gnomo.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(crisbobalpoolparty, {
            y: crisbobalpoolparty.y + 1100,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(phase2_0, {
            y: phase2_0.y + 700,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(phase2_1, {
            y: phase2_1.y + 700,
        }, 2, {ease: FlxEase.quadIn
        });

        FlxTween.tween(phase2_2, {
            y: phase2_2.y + 700,
        }, 2, {ease: FlxEase.quadIn
        });
    }
    
    if (curStep == 2088) {
        FlxTween.tween(camera, {zoom: camera.zoom + 1.5}, 0.8, {ease: FlxEase.quintIn});
        //game.alpha = 1;
    }

    if (curStep == 2096) {
        chaosTween();

        phase2_01.alpha = 1;
        phase2_02.alpha = 1;
        phase2_11.alpha = 1;
        phase2_12.alpha = 1;
        phase2_21.alpha = 1;
        phase2_22.alpha = 1;

        FlxG.camera.shake(0.003, 100000);

        temu.alpha = 0;
        doll.alpha = 0;
        dvd.alpha = 0;
        ketchup.alpha = 0;
        mermaid.alpha = 0;
        sanded.alpha = 0;
        usa.alpha = 0;
        gnomo.alpha = 0;
        crisbobalpoolparty.alpha = 0;
    }

    if (curStep == 2344) {
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y - 500}, 0.88, {ease: FlxEase.quadIn});
    }

    if (curStep == 2352) {
        FlxG.camera.shake(0, 0, null, true); 

        if (camTween != null) {
            camTween.cancel();
            FlxTween.tween(camGame, {angle: 0}, 0.5, {ease: FlxEase.cubeOut});
        }

        Field.alpha = 0;
        Satan.alpha = 0;

        phase2_01.alpha = 0;
        phase2_02.alpha = 0;
        phase2_11.alpha = 0;
        phase2_12.alpha = 0;
        phase2_21.alpha = 0;
        phase2_22.alpha = 0;

        cielo.alpha = 1;
        isla.alpha = 1;
        plataformas.alpha = 1;
        luz.alpha = 1;
    }

    if (curStep == 2752) {
        FlxTween.tween(gf, {
            y: gf.y - 2000,
        }, 4, {ease: FlxEase.quadInOut
        });

        FlxTween.tween(plataformas, {
            y: plataformas.y - 2000,
        }, 4, {ease: FlxEase.quadInOut
        });

            FlxTween.tween(dad, {
            y: dad.y - 2000,
        }, 4, {ease: FlxEase.quadInOut
        });
    
    }

    if (curStep == 2896) {
        phase2_0.alpha = 0;
        phase2_1.alpha = 0;
        phase2_2.alpha = 0;
        cielo.alpha = 0;
        isla.alpha = 0;
        plataformas.alpha = 0;
        luz.alpha = 0;
        barnacles.alpha = 0;

        dad.y += 2400;
        dad.x = -900;
        gf.y += 2000;
        gf.x = 100;
        gf.alpha = 0;
        boyfriend.y -= 200;
    
        phase3_0.alpha = 1;
        phase3_01.alpha = 1;
        phase3_1.alpha = 1;
        phase3_11.alpha = 1;
        phase3_2.alpha = 1;
        phase3_21.alpha = 1;
        phase3_3.alpha = 1;
        phase3_31.alpha = 1;
        phase3_4.alpha = 1;
        phase3_41.alpha = 1;
        phase3_4_5.alpha = 1;
        phase3_4_51.alpha = 1;
        phase3_5.alpha = 1;
        phase3_51.alpha = 1;
        phase3_6.alpha = 1;
        phase3_61.alpha = 1;
        phase3_7.alpha = 1;
        phase3_71.alpha = 1;
        moto.alpha = 1;

        resetPlayerStrumline(0.03);

    }

    if (curStep == 2990) {
        FlxTween.tween(dad, {x: 100}, 4, {ease: FlxEase.cubeOut});
    }

    if (curStep == 3648) {
        josejuanlike.alpha = 1;
        josejuanlike.playAnim("josejuan", false);
    }

    if (curStep == 4000) {
        phase3_0.alpha = 0;
        phase3_01.alpha = 0;
        phase3_1.alpha = 0;
        phase3_11.alpha = 0;
        phase3_2.alpha = 0;
        phase3_21.alpha = 0;
        phase3_3.alpha = 0;
        phase3_31.alpha = 0;
        phase3_4.alpha = 0;
        phase3_41.alpha = 0;
        phase3_4_5.alpha = 0;
        phase3_4_51.alpha = 0;
        phase3_5.alpha = 0;
        phase3_51.alpha = 0;
        phase3_6.alpha = 0;
        phase3_61.alpha = 0;
        phase3_7.alpha = 0;
        phase3_71.alpha = 0;
        moto.alpha = 0;

        bgChains.alpha = 1;
        chains.alpha = 1;
        phase4_shine.alpha = 1;
        boyfriend.x -= 1500;
        boyfriend.y -= 600;
        dad.alpha = 0;
        var center = FlxG.width / 2;

        tweenPlayerStrumlineCustom(center, [
            -300,
            -150,
            150,
            300
        ], 1, FlxEase.quadOut);
    }

    if (curStep == 4704) {

        bgChains.alpha = 0;
        chains.alpha = 0;
        phase4_shine.alpha = 0;
        dad.alpha = 1;
        dad.y += 325;
        dad.x -= 200;
        boyfriend.alpha = 0;
        bgPacma.alpha = 1;
        swPacma.alpha = 1;

        resetPlayerStrumline(0.03);

    }

    if (curStep == 4737) {
        boyfriend.alpha = 1;
        boyfriend.x += 1000;
        boyfriend.y += 400;
        dad.x -= 800;
        dad.y -= 1600;
        dadBaseX = dad.x;
        dadBaseY = dad.y;
        bobFly = true;
        bgPacma.alpha = 0;
        swPacma.alpha = 0;
        phase4Platform.alpha = 1;

        subaru.alpha = 1;
        subaru.x = boyfriend.x - 170;
        subaru.y = boyfriend.y - 270;

        squid.alpha = 1;
        squid.x = boyfriend.x - 15;
        squid.y = boyfriend.y - 600;

        krabity.alpha = 1;
        krabity.x = boyfriend.x + 500;
        krabity.y = boyfriend.y - 300;

        var targetIndex = members.indexOf(phase4Platform) + 1;
        remove(subaru, true);
        insert(targetIndex, subaru);

        remove(krabity, true);
        insert(targetIndex, krabity);

        remove(squid, true);
        insert(targetIndex, squid);

        if (bgCanvas != null)
            insert(members.indexOf(phase4Platform) -1, bgCanvas);
    }

    if (curStep == 5201 && fishEyeShader != null) {
        camGame.addShader(fishEyeShader);
        FlxTween.num(0, 0.3, 1, null, function(v:Float) {
            if (fishEyeShader != null) fishEyeShader.intensity = v;
        });

        FlxTween.num(1, 1.4, 1, null, function(v:Float) {
            if (fishEyeShader != null) fishEyeShader.zoom = v;
        });
    }

    if (curStep == 5218 && fishEyeShader != null) {
        camGame.removeShader(fishEyeShader);
        fishEyeShader = null;
    }

    if (curStep == 5250) {
        canShake = true;
    }
}

//UG32T TE AMO

function getHeight(spr) {
    return spr.frameHeight * spr.scale.y;
}

function getWidth(spr) {
    return spr.frameWidth * spr.scale.x;
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

function moveLayerHorizontal(layer, elapsed, speed) {
    var w = layer.width;
    var n = layer.sprites.length;
    var totalSpeed = speed * layer.speedFactor;

    for (spr in layer.sprites) {
        spr.x += totalSpeed * elapsed;
    }

    for (spr in layer.sprites) {
        if (totalSpeed < 0) {
            if (spr.x + w < layer.startX) {
                spr.x += w * n;
            }
        } else {
            if (spr.x >= layer.startX + (w * n)) {
                spr.x -= w * n;
            }
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

function tweenPlayerStrumlineCustom(
    centerX:Float,
    offsets:Array<Float>,
    duration:Float = 0.5,
    ease = FlxEase.expoOut
) {
    var firstStrum = playerStrums.members[0];
    if (firstStrum == null) return;

    var leftEdge:Float = Math.POSITIVE_INFINITY;
    var rightEdge:Float = Math.NEGATIVE_INFINITY;

    for (i in 0...offsets.length) {
        var strum = playerStrums.members[i];
        if (strum == null) continue;

        var left = offsets[i];
        var right = offsets[i] + strum.width;

        if (left < leftEdge) leftEdge = left;
        if (right > rightEdge) rightEdge = right;
    }

    var visualCenter = (leftEdge + rightEdge) / 2;
    var correction = centerX - visualCenter;

    for (i in 0...playerStrums.members.length) {
        var strum = playerStrums.members[i];
        if (strum == null || offsets[i] == null) continue;

        FlxTween.tween(strum, {
            x: offsets[i] + correction
        }, duration, { ease: ease });
    }
}

function resetPlayerStrumline(duration:Float = 0.5, ease = FlxEase.expoOut) {
    if (ogStrumX.length < 4) return;

    for (i in 0...playerStrums.members.length) {
        var strum = playerStrums.members[i];
        if (strum == null) continue;

        FlxTween.tween(strum, {
            x: ogStrumX[i]
        }, duration, { ease: ease });
    }
}


function resetStrumXByID(id:Int, duration:Float = 0.2) {
    if (ogStrumX[id] == null) return;

    tweenStrumByID(id, ogStrumX[id], -1, duration);
}
