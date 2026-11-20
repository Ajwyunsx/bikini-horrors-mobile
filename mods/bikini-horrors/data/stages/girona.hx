var canShake:Bool;
var verySHAKE:Bool;
public var nick:FlxSprite;

var dadBaseY:Float = 0;
var dadSineTime:Float = 2;
var dadSineAmount:Float = 10;
var dadSineSpeed:Float = 4;
var bobFly:Bool = false;

var palabras:Array<FlxSprite> = [];

var patras:Bool = false;

var blackOverlay;

import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitterMode;

import funkin.game.PlayState;
import funkin.backend.utils.CoolUtil;

var skyEmitter:FlxTypedEmitter;
var totalImagenes:Int = 2;
var burgerScales:Array<Float> = [];

var bolaOriginalX:Float = 0;
var bolaOriginalY:Float = 0;
var bolaTween:FlxTween = null;

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 3, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
}


function postCreate()
{
    camZooming = true;

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    gf.alpha = 0;
    trueno_left.alpha = 0;
    trueno_right.alpha = 0;
    hankBoom.alpha = 0;

    cielo_hank.alpha = 0;
    edificio.alpha = 0;
    fog.alpha = 0;
    suelo2.alpha = 0;

    cielo_hank2.alpha = 0;
    tren.alpha = 0;
    hellclown.alpha = 0.01;
    daimago.alpha = 0;

    cielo_hellclown.alpha = 0;
    rempalago.alpha = 0;
    tentaculos.alpha = 0;
    fuego_hellclown.alpha = 0;
    tentaculos_hellclown.alpha = 0;
    suelo_hellclown.alpha = 0;
    pakmabg.alpha = 0;

    bola.alpha = 0; 

    cielo_expurgation.alpha = 0;

    estatic.alpha = 0;
    cudao.alpha = 0;

    fakebaby.alpha = 0;
    improbable.alpha = 0;
    madness.alpha = 0;
    michael.alpha = 0;
    no_fun.alpha = 0;
    tmm.alpha = 0;





    marco.cameras = [camHUD];
    cudao.cameras = [camHUD];


    skyEmitter = new FlxTypedEmitter(0, 750);

    skyEmitter.width = 1280;
    skyEmitter.height = 10;
    skyEmitter.launchMode = FlxEmitterMode.SQUARE;

    skyEmitter.velocity.set(-15, -260, 15, -180);
    skyEmitter.alpha.set(1, 1, 1, 1);
    skyEmitter.lifespan.set(20, 40);

    skyEmitter.maxSize = 30;

    for (i in 0...skyEmitter.maxSize)
    {
        var particle:FlxParticle = new FlxParticle();

        var idAleatorio:Int = FlxG.random.int(0, totalImagenes - 1);
        var frames = Paths.getSparrowAtlas('stages/rumbeling/fase5/pajaro' + idAleatorio);
        particle.frames = frames;

        particle.animation.addByPrefix("fly", "pajaro", 24, true);
        particle.animation.play("fly");

        particle.ID = i;

        var escalaUniforme:Float = FlxG.random.float(0.05, 0.2);
        burgerScales.push(escalaUniforme);

        particle.scale.set(escalaUniforme, escalaUniforme);

        particle.scrollFactor.set(0, 0);
        particle.cameras = [camHUD];   

        skyEmitter.add(particle);
    }

    add(skyEmitter);

    palabras = [fakebaby, improbable, madness, michael, no_fun, tmm];

    if (bola != null) {
        bolaOriginalX = bola.x;
        bolaOriginalY = bola.y;
    }

    scoreTxt.fieldWidth = 0;
    accuracyTxt.fieldWidth = 0;
    missesTxt.fieldWidth = 0;

    scoreTxt.alignment = "left";
    accuracyTxt.alignment = "left";
    missesTxt.alignment = "left";

    scoreTxt.y = 50;
    accuracyTxt.y = 80;
    missesTxt.y = 110;

    

}


function lanzarBola()
{
    if (bola == null) return;

    if (bolaTween != null) {
        bolaTween.cancel();
    }

    bola.x = bolaOriginalX;
    bola.y = bolaOriginalY;
    bola.alpha = 1;

    var haciaLaDerecha:Bool = FlxG.random.bool(50);

    var destinoX:Float = haciaLaDerecha ? bolaOriginalX + 2400 : bolaOriginalX - 1500;
    
    var destinoY:Float = bolaOriginalY - 400; 

    bolaTween = FlxTween.tween(bola, {x: destinoX, y: destinoY}, 0.5, {
        ease: FlxEase.quartInOut, 
        onComplete: function(twn:FlxTween) {
            bola.alpha = 0;
        }
    });
}


function imagenStatic(duracion:Float) {
    if (palabras == null || palabras.length == 0) return;

    var imagenSeleccionada:FlxSprite = FlxG.random.getObject(palabras);

    if (imagenSeleccionada != null) {
        var originalX:Float = imagenSeleccionada.x;
        var originalY:Float = imagenSeleccionada.y;

        imagenSeleccionada.alpha = 1;

        var shakeTween = FlxTween.num(0, 1, duracion, {
            onUpdate: function(tween:FlxTween) {
                imagenSeleccionada.x = originalX + FlxG.random.float(-5, 5);
                imagenSeleccionada.y = originalY + FlxG.random.float(-5, 5);
            }
        });

        new FlxTimer().start(duracion, function(tmr:FlxTimer) {
            imagenSeleccionada.alpha = 0;
            
            if (shakeTween != null) shakeTween.cancel(); 
            
            imagenSeleccionada.x = originalX;
            imagenSeleccionada.y = originalY;
        });
    }
}



function boostAlpha(sprite:FlxSprite, targetAlpha:Float, duration:Float)
{
    var oldAlpha = sprite.alpha;

    sprite.alpha = targetAlpha;

    new FlxTimer().start(duration, function(timer:FlxTimer)
    {
        sprite.alpha = oldAlpha;
    });
}



function update(elapsed:Float) 
{
    if (!patras && skyEmitter != null) {
        if (FlxG.state.members.indexOf(skyEmitter) != -1) {
            FlxG.state.remove(skyEmitter, true);
            FlxG.state.insert(0, skyEmitter);
            patras = true;
        }
    }

    if (skyEmitter != null) {
        for (particle in skyEmitter.members) {
            if (particle != null && particle.alive) {
                var miEscala:Float = burgerScales[particle.ID];
                particle.scale.set(miEscala, miEscala);
            }
        }
    }

    if (scoreTxt != null) scoreTxt.x = 80;
    if (accuracyTxt != null) accuracyTxt.x = 80;
    if (missesTxt != null) missesTxt.x = 80;
}


function postUpdate(elapsed:Float)
{
    if (comboGroup != null) {
        comboGroup.x = 1080;
    }
}


function floatTrain() {
        FlxTween.tween(
            vagon1,
            { y: vagon1.y + 5 }, 
            0.1,               
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            vagon2,
            { y: vagon2.y + 5 }, 
            0.08,              
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            vagon3,
            { y: vagon3.y + 5 }, 
            0.09,                
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            vagon4,
            { y: vagon4.y + 5 }, 
            0.11,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            hankBoom,
            { y: hankBoom.y + 5 }, 
            0.08,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
        FlxTween.tween(
            dad,
            { y: dad.y + 5 }, 
            0.1,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
}



function stepHit(step:Int) {

    if (curStep == 10) {
        floatTrain(true);

        FlxTween.tween(cielo, { y: cielo.y + 500 }, 110);
    }
    

    if ([198, 224, 240, 246, 280, 348, 432, 462, 542, 590, 692, 712, 716, 720, 782, 808, 974, 986, 998, 1038, 1050, 1062, 1102, 1136, 1160, 1166, 1178, 1486, 1560, 1592].contains(curStep)) {
        boostAlpha(estatic, 1, 0.2);
        FlxG.sound.play(Paths.sound("estatica"), 0.7);
        imagenStatic(0.2);
    }

    if (curStep == 1700) {
        estatic.alpha = 0;
    }

    if (curStep == 160) {
        trueno_right.alpha = 1;
        trueno_right.playAnim("trueno2 instancia 1");
        FlxG.sound.play(Paths.sound("thunder"), 1);
    }

    if (curStep == 168) {
        trueno_right.alpha = 0;
    }

    if (curStep == 416) {
        trueno_left.alpha = 1;
        trueno_left.playAnim("trueno1 instancia 1");
        FlxG.sound.play(Paths.sound("thunder"), 1);
    }

    if (curStep == 424) {
        trueno_left.alpha = 0;
    }

    if (curStep == 944) {
        trueno_right.alpha = 1;
        trueno_right.playAnim("trueno2 instancia 1");
        FlxG.sound.play(Paths.sound("thunder"), 1);
    }

    if (curStep == 952) {
        trueno_right.alpha = 0;
    }

    if (curStep == 1200) {
        FlxTween.tween(marco, {alpha: 0}, 1);
    }

    if (curStep == 1464) {
        FlxTween.tween(marco, {alpha: 1}, 1);
    }

    if (curStep == 1551) {
        hankBoom.alpha = 1;
        hankBoom.playAnim("idle");
    }

    if (curStep == 1552) {
        hankBoom.playAnim("hankboom");
    }

    if (curStep == 1616) {
        marco.alpha = 0;
    }

    if (curStep == 1676) {
        marco.alpha = 1;
    }

    if (curStep == 1632) {
        floatTrain(false);

        remove(pacma_fire);
        pacma_fire.destroy();
        remove(nieve);
        nieve.destroy();
        remove(cielo);
        cielo.destroy();
        remove(suelo1);
        suelo1.destroy();
        remove(vagon4);
        vagon4.destroy();
        remove(vagon3);
        vagon3.destroy();
        remove(vagon2);
        vagon2.destroy();
        remove(vagon1);
        vagon1.destroy();
        remove(hankBoom);
        hankBoom.destroy();
    }

    if (curStep == 1660) {

        cielo_hank.alpha = 1;
        edificio.alpha = 1;
        fog.alpha = 1;
        suelo2.alpha = 1;
    }

    if (curStep == 1746 && FlxG.save.data.mech != true) {
        cudao.alpha = 1;
        cudao.playAnim("idle");
    }

    if (curStep == 1747 && FlxG.save.data.mech != true) {
        cudao.playAnim("SANDY CHEEKS1");
    }

    if (curStep == 1996) {
        remove(cielo_hank);
        cielo_hank.destroy();
        remove(edificio);
        edificio.destroy();
        remove(fog);
        fog.destroy();
        remove(suelo2);
        suelo2.destroy();
    }

    if (curStep == 1998) {
        cielo_hank2.alpha = 1;
        tren.alpha = 1;


        boyfriend.alpha = 0;
    }

    if (curStep == 2504) {
        hellclown.alpha = 1;
        hellclown.playAnim("idle");
    }

    if (curStep == 2527) {
        daimago.alpha = 1;
        daimago.playAnim("idle");
    }

    if (curStep == 2528) {
        daimago.playAnim("daimashow");
    }

    if (curStep == 2560) {
        marco.alpha = 0;
    }

    if (curStep == 2693) {
        FlxTween.tween(marco, {alpha: 1}, 1);
    }

    if (curStep == 2608) {

        remove(cielo_hank2);
        cielo_hank2.destroy();
        remove(tren);
        tren.destroy();
        remove(daimago);
        daimago.destroy();
        remove(hellclown);
        hellclown.destroy();

        boyfriend.alpha = 1;
    }

    if (curStep == 2654) {
        cielo_hellclown.alpha = 1;
        fuego_hellclown.alpha = 1;
        tentaculos_hellclown.alpha = 1;
        suelo_hellclown.alpha = 1;
        pakmabg.alpha = 1;
    }

    if ([2733, 2777, 2849, 3105, 3153, 3161, 3198].contains(curStep)) {
        lanzarBola();
        boyfriend.playAnim("lanzar");
        FlxG.sound.play(Paths.sound("kiblast"), 1);
    }

    if (curStep == 2989) {
        rempalago.alpha = 1;
        FlxG.sound.play(Paths.sound("thunder"), 1);
    }

    if (curStep == 2993) {
        rempalago.alpha = 0;
    }

    if (curStep == 3117) {
        rempalago.alpha = 1;
        FlxG.sound.play(Paths.sound("thunder"), 1);
    }

    if (curStep == 3121) {
        rempalago.alpha = 0;
    }

    if (curStep == 3181) {
        tentaculos.alpha = 1;
        tentaculos.playAnim("idle");
    }

    if (curStep == 3182) {
        tentaculos.playAnim("tentaculo");
    }

    if (curStep == 3269) {

        remove(cielo_hellclown);
        cielo_hellclown.destroy();
        remove(rempalago);
        rempalago.destroy();
        remove(fuego_hellclown);
        fuego_hellclown.destroy();
        remove(tentaculos_hellclown);
        tentaculos_hellclown.destroy();
        remove(suelo_hellclown);
        suelo_hellclown.destroy();
        remove(pakmabg);
        pakmabg.destroy();
        remove(tentaculos);
        tentaculos.destroy();
    }

    if (curStep == 3273) {
        iconP1.visible = false;
        iconP2.y = iconP2 - 20;

        cielo_expurgation.alpha = 1;

        boyfriend.alpha = 0;
    }

    if (curStep == 3341) {
        skyEmitter.start(false, 2, 0);
    }

    if (curStep == 3565) {
        remove(skyEmitter);
        marco.alpha = 0;
    }

    if (curStep == 3616) {
        FlxG.switchState(new ModState("AfterRumbelingState"));
    }
}

function onGameOver(event)
{
    event.cancel();

    PlayState.loadSong("spongefunkin", "hard", false, false);

    PlayState.switchToPlayState();

}
