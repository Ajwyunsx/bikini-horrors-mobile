//Script by Ug32t :v
import openfl.display.BlendMode;

var isDownscroll:Bool = camHUD.downscroll;

//Glitch shader stuff
public var glitchShader:CustomShader = null;
var glitchTimer:Float = 0;
var glitchValues:Array<Float> = [0.1, 0.15, 0.2, 0.01];
var glitchActive:Bool = false;
var glitchWait:Float = 0.1;

//Pixel transition shader stuff
var pixelShader:CustomShader = null;
var pixelStrength:Float = 1;

//For manually handling cam zooms when needed
var activateCamZoom:Bool = true;

//Storing positions n all that
var flowersBaseY:Float = 0;
var povCrisBaseX: Float = 0;
var povIsaacBaseX: Float = 0;
var blackOverlay : FlxSprite;
var whiteOverlay : FlxSprite;
var notResponding : FlxSprite;

function create()
{
    if (Options.shaderQualityAllows(1))
    {
        if (Options.shaderQualityAllows(2)) {
            //glitch shader
            glitchShader = new CustomShader("glitching");
            glitchShader.AMT = 0;
        }

        //pixel shader
        pixelShader = new CustomShader("isaacPixelate");
        pixelShader.strength = 1;
        camGame.addShader(pixelShader);
    }
}

var colored:FunkinSprite;

function postCreate(){
    redTint.alpha = 0;
    redTint.blend = BlendMode.MULTIPLY;

    degradado = new FlxSprite(0,0,Paths.image("stages/basement/sad/degradado"));
    degradado.cameras = [camHUD];
    degradado.screenCenter();
    if (isDownscroll){
        degradado.y += degradado.height/2;
    }
    else{
        degradado.y -= degradado.height/2;
    }
    add(degradado);

    colored = strumLines.members[1].characters[1];
    strumLines.members[1].characters.remove(colored);
    
    //hide other characters pls thank you code
    strumLines.members[3].characters[0].alpha = 0;
    strumLines.members[4].characters[0].alpha = 0;
    strumLines.members[5].characters[0].alpha = 0;

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    remove(healthBar);
    remove(healthBarBG);
    iconP1.visible = false;
    iconP2.visible = false;
    flowersBaseY = flowersglitch.y;
    light.blend = BlendMode.ADD;
    lightGlitch.blend = BlendMode.ADD;
    downpourLight.blend = BlendMode.ADD;
    flowersglitch.blend = BlendMode.ADD;
    flowersDownpour.blend = BlendMode.ADD;
        FlxTween.tween(
            fly,
            { y: fly.y + 30 }, 
            1.1,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
    
    //For looping
    skyLayers = [
        { sprites: [columnaIzq1, columnaIzq2], height: 0, speedFactor: 1 },
        { sprites: [columnaDer1, columnaDer2], height: 0, speedFactor: -1 },
    ];

    for (layer in skyLayers) {

        layer.height = getHeight(layer.sprites[0]);

        for (i in 0...layer.sprites.length) {
            layer.sprites[i].y = layer.sprites[0].y + layer.height * i;
        }
    }

}

function update(elapsed:Float)
{
    if (activateCamZoom == false){
        camZooming = false;
    }
        
    if (pixelShader != null)
    {
        if (glitchShader != null) {
            glitchTimer += elapsed;

            if (glitchTimer >= glitchWait)
            {
                glitchTimer = 0;

                var randIndex = FlxG.random.int(0, glitchValues.length - 1);
                glitchShader.AMT = glitchValues[randIndex];
            }
        }

        pixelShader.strength = pixelStrength;
    }
    
    //for looping
    for (layer in skyLayers)
            moveLayerVertical(layer, elapsed);
}

var baseVoidX:Float=0;
var degradado:FlxSprite;

var crisGrande:FunkinSprite;
var crisNormal:FunkinSprite;

function stepHit(curStep:Int) {
    switch (curStep) {
        case 0:
            crisNormal = strumLines.members[0].characters[0];
            crisGrande = strumLines.members[0].characters[1];
            strumLines.members[0].characters.remove(crisGrande);
            crisGrande.alpha = 0.01;

            rain1.alpha = 1;
            rain2.alpha = 1;
            reflection.alpha = 1;
            ripple.alpha = 1;
            camGame.target = null;
            camGame.zoom = 1;
            camGame.scroll.x = 1100;
            camGame.scroll.y = 600;
            bg_glitch.cameras = [bgCam];
            lightGlitch.cameras = [bgCam];
            flowersglitch.cameras = [bgCam];
        case 1:
            feathers.playAnim("feathers");
            rain1.alpha = 0.05;
            rain2.alpha = 0.05;
            reflection.alpha = 0.05;
            ripple.alpha = 0.05;
            FlxTween.tween(camGame, {zoom: 0.5}, 3.25, {ease:FlxEase.quartInOut});
            FlxTween.tween(blackOverlay, {alpha:0}, 3.5);
            FlxTween.num(1, 0, 3.5,
            {
                ease: FlxEase.quadInOut
            },
            function(v:Float)
            {
                pixelStrength = v;
            });
        case 10:
            colored.alpha = 0.001;
            feathers.alpha = 0.001;
        case 32:
            camGame.target = camFollow;
        case 64:
            feathers.alpha = 1;
            colored.playAnim("wings");
        case 284:
            camZooming = false;
            activateCamZoom = false;
            FlxTween.tween(camGame, {zoom:0.9}, 3.5, {ease:FlxEase.quartInOut});
        case 320:
            camGame.zoom = 0.7;
        case 324:
            camGame.zoom = 0.6;
            FlxTween.tween(camGame, {zoom:0.55}, 0.5, {ease:FlxEase.expoIn});
        case 328:
            fly.cameras = [bgCam];
            activateCamZoom = true;
            camZooming = true;
            bg_glitch.alpha = 1;
            lightGlitch.alpha = 0.5;
            front_glitch.alpha = 1;
            bg_basement.alpha = 0;
            front.alpha = 0;
            light.alpha = 0;    
            applyGlitch(bg_glitch);
        case 332:
            remove(front);
            front.destroy();
            remove(light);
            light.destroy();
            remove(bg_basement);
            bg_basement.destroy();
        case 452:
            camGame.target = null;
            FlxTween.tween(camGame.scroll, {x:710, y:475}, 0.75, {ease:FlxEase.quartInOut});
        case 456:
            camGame.target = camFollow;
            glitchWait = 0.08;
            flowersglitch.y -= 200;
            FlxTween.tween(flowersglitch, {alpha:0.5, y: flowersBaseY}, 1, {ease: FlxEase.expoOut});
            applyGlitch(flowersglitch);
        case 700:
            notesEffectEnabled = true;
        case 712:
            glitchValues = [0.01, 0.1, 0.2, 0.3, 0.4];
            camGame.target = camFollow;
        case 708:
            camGame.target = null;
            FlxTween.tween(camGame.scroll, {x:710, y:475}, 0.75, {ease:FlxEase.quartInOut});
        case 922:
            FlxTween.cancelTweensOf(fly);
            FlxTween.tween(bg_glitch, {alpha:0, y: bg_glitch.y + 400}, 1, {ease:FlxEase.quartIn});
            FlxTween.tween(lightGlitch, {alpha:0, y: lightGlitch.y + 100}, 0.9, {ease:FlxEase.quartIn});
            FlxTween.tween(front_glitch, {alpha:0, y: front_glitch.y + 500}, 1.3, {ease:FlxEase.quartIn});
            FlxTween.tween(fly, {alpha:0, y: fly.y + 500}, 1, {ease:FlxEase.quartIn}); 
            FlxTween.tween(flowersglitch, {alpha:0, y: flowersglitch.y + 1000}, 1, {ease:FlxEase.quartIn});
            FlxTween.tween(transitionBG, {alpha:1}, 2);
        case 940:
            notesEffectEnabled = false;
            glitchValues = [0.01, 0.3, 0.5, 0.7, 1, 2];
        case 960:
            remove(bg_glitch);
            bg_glitch.destroy();
            remove(lightGlitch);
            lightGlitch.destroy();
        case 968:
            remove(front_glitch);
            front_glitch.destroy();
            remove(fly);
            fly.destroy();
            remove(flowersglitch);
            flowersglitch.destroy();
        case 971:
            downpourWalls.alpha = 1;
            downpourFloor.alpha = 1;
            reflection.alpha = 1;
            ripple.alpha = 1;
            rain1.alpha = 1;
            rain2.alpha = 1;
            rainImpact.alpha = 1;
            downpourLight.alpha = 0.5;
            downpourColumn.alpha = 1;
            flowersDownpour.alpha = 1;
        case 972:
            transitionBG.alpha = 0;

            dad.x = 821;
            dad.y = 480;

            camGame.scroll.x = 821 + 100;
            camGame.scroll.y = 480 + 70; 
        case 1090:
            glitchValues = [0.01, 0.05, 0.1, 0.15, 0.2];
        case 1096:
            applyGlitch(downpourWalls);
            applyGlitch(downpourFloor);
            applyGlitch(reflection);
            applyGlitch(ripple);
            applyGlitch(rain1);
            applyGlitch(rain2);
        case 1352:
            applyGlitch(dad);
        case 1477:
            downpourWalls.alpha = 0;
            downpourFloor.alpha = 0;
            reflection.alpha = 0;
            ripple.alpha = 0;
            rain1.alpha = 0;
            rain2.alpha = 0;
            flowersDownpour.alpha = 0;
            rainImpact.alpha = 0;
            downpourLight.alpha = 0;
            downpourColumn.alpha = 0;
            camGame.target = null;
            boyfriend.alpha = 0;
        case 1478:
            camGame.scroll.x = 421;
            camGame.scroll.y = -1778;
            columnaDer1.alpha = 1;
            columnaIzq1.alpha = 1;
            columnaDer2.alpha = 1;
            columnaIzq2.alpha = 1;
            povBg.alpha = 1;
            boyfriend.alpha = 0;
        case 1479:
            boyfriend.alpha = 0;
        case 1488:
            povIsaacBaseX = boyfriend.x;
            povCrisBaseX = dad.x;
            boyfriend.x -= 1800;
            boyfriend.alpha = 1;
        case 1510:
            FlxTween.tween(boyfriend, {x:povIsaacBaseX}, 1, {ease:FlxEase.quartInOut});
            FlxTween.tween(dad, {x:povCrisBaseX + 1800}, 1, {ease:FlxEase.quartInOut});
        case 1540:
            dad.x = povCrisBaseX - 1800;
            FlxTween.tween(dad, {x:povCrisBaseX}, 1, {ease:FlxEase.quartInOut});
            FlxTween.tween(boyfriend, {x:povIsaacBaseX+1800}, 1, {ease:FlxEase.quartInOut});
        case 1560:
            boyfriend.x = povIsaacBaseX - 1800;
            FlxTween.tween(boyfriend, {x:povIsaacBaseX}, 0.75, {ease:FlxEase.quartInOut});
            FlxTween.tween(dad, {x:povCrisBaseX + 1800}, 0.75, {ease:FlxEase.quartInOut});
        case 1580:
            dad.x = povCrisBaseX - 1800;
            FlxTween.tween(dad, {x:povCrisBaseX}, 0.5, {ease:FlxEase.quartInOut});
            FlxTween.tween(boyfriend, {x:povIsaacBaseX+1800}, 0.5, {ease:FlxEase.quartInOut});
        case 1608:
            boyfriend.x = povIsaacBaseX - 1800;
            FlxTween.tween(boyfriend, {x:povIsaacBaseX}, 1, {ease:FlxEase.quartInOut});
            FlxTween.tween(dad, {x:povCrisBaseX + 1800}, 1, {ease:FlxEase.quartInOut});
        case 1638:
            dad.x = povCrisBaseX - 1800;
            FlxTween.tween(boyfriend, {x:povIsaacBaseX + 1800}, 1, {ease:FlxEase.quartInOut});
            FlxTween.tween(dad, {x:povCrisBaseX}, 1, {ease:FlxEase.quartInOut});
        case 1668:
            boyfriend.x = povIsaacBaseX - 1800;
            FlxTween.tween(boyfriend, {x:povIsaacBaseX}, 1, {ease:FlxEase.quartInOut});
            FlxTween.tween(dad, {x:povCrisBaseX + 1800}, 1, {ease:FlxEase.quartInOut});
        case 1728:
            FlxTween.tween(blackOverlay, {alpha:1}, 0.7);
            FlxTween.num(0, 1, 0.7,
            {
                ease: FlxEase.quadInOut
            },
            function(v:Float)
            {
                pixelStrength = v;
            });
        case 1740:
            camGame.target = null;
            camGame.scroll.x = -1950;
            camGame.scroll.y = 1200;
        case 1752:
            pixelBasement.alpha = 1;
            FlxTween.tween(blackOverlay, {alpha:0}, 1.5);
            FlxTween.num(1, 0, 1.5,
            {
                ease: FlxEase.quadInOut
            },
            function(v:Float)
            {
                pixelStrength = v;
            });
            accuracyTxt.alpha = 0;
            missesTxt.alpha = 0;
            scoreTxt.alpha = 0;
        case 1800:
            FlxTween.tween(arrowsWarning, {alpha:0}, 1);
        case 2200:
            pixelBasement.alpha = 0;
            pixelEvil.alpha = 1;
        case 2250:
            whiteOverlay = new FunkinScreenOverlay(FlxColor.WHITE);
            whiteOverlay.alpha = 0;
            whiteOverlay.cameras = [camHUD];
            add(whiteOverlay);
        case 2256:
            FlxTween.tween(whiteOverlay, {alpha:0.5}, 1);
        case 2264:
            notResponding = new FlxSprite(0,0,Paths.image("sirope/not_responding"));
            notResponding.scrollFactor.set(0, 0);
            notResponding.screenCenter();
            notResponding.alpha = 0;
            notResponding.cameras = [camHUD];
            insert(members.length-1, notResponding);
            blackOverlay.alpha = 1;
            FlxTween.tween(notResponding, {alpha:1}, 0.07);
        case 2268:
            FlxTween.tween(blackOverlay, {alpha:1}, 1.5);
            FlxTween.tween(notResponding, {alpha:0}, 1.5);
            FlxTween.tween(whiteOverlay, {alpha:0}, 1.5);
        case 2293:
            remove(notResponding);
            notResponding.destroy();
            feathers.alpha = 0;
        case 2288:
            camGame.target = camFollow;
            voidBg.alpha = 1;
            isaacShadow.alpha = 1;
        case 2298:
            remove(pixelBasement);
            pixelBasement.destroy();
            pixelEvil.alpha = 0;
            hidePool();
        case 2300:
            FlxTween.tween(blackOverlay, {alpha:0}, 1);
        case 2506:
            baseVoidX = camGame.scroll.x;
            camGame.target = null;
            FlxTween.tween(camGame.scroll, {x:camGame.scroll.x + 300}, 1.5, {ease:FlxEase.quartInOut});
            FlxTween.tween(strumLines.members[3].characters[0], {alpha:1}, 1);
            FlxTween.tween(meatboyShadow, {alpha:1}, 1);
        case 2604:
            FlxTween.tween(camGame.scroll, {x:camGame.scroll.x - 600}, 1.5, {ease:FlxEase.quartInOut});
            FlxTween.tween(strumLines.members[4].characters[0], {alpha:1}, 1);
            FlxTween.tween(castleShadow, {alpha:1}, 1);
        case 2648:
            FlxTween.tween(strumLines.members[5].characters[0], {alpha:1}, 1);
            FlxTween.tween(camGame.scroll, {x:camGame.scroll.x - 1000}, 1.5, {ease:FlxEase.quartInOut});
        case 2678:
            FlxTween.tween(camGame.scroll, {x:baseVoidX}, 1.5, {ease:FlxEase.quartInOut});
        case 2690:
            activateCamZoom = false;
            FlxTween.tween(camGame.scroll, {y:camGame.scroll.y - 700}, 4, {ease:FlxEase.quartOut});
            FlxTween.tween(camGame, {zoom:0.18}, 4, {ease:FlxEase.quartOut});
        case 2696:
            FlxTween.tween(tijuana, {alpha:1}, 1);
        case 2788:
            strumLines.members[1].characters.push(colored);
            FlxTween.tween(camGame, {zoom:0.35}, 4, {ease:FlxEase.quadInOut});
            FlxTween.tween(camGame.scroll, {y:camGame.scroll.y + 700}, 4, {ease:FlxEase.quartOut});
            FlxTween.tween(tijuana, {alpha:0}, 2);
        case 2799:
            FlxTween.tween(strumLines.members[1].characters[0], {alpha:0}, 3);
            FlxTween.tween(colored, {alpha:1}, 3);
        case 2790:
            FlxTween.tween(strumLines.members[3].characters[0], {alpha:0}, 3);
            FlxTween.tween(strumLines.members[4].characters[0], {alpha:0}, 3);
            FlxTween.tween(meatboyShadow, {alpha:0}, 3);
            FlxTween.tween(castleShadow, {alpha:0}, 3);
        case 2840:
            feathers.alpha = 1;
            colored.playAnim("wings");
            feathers.playAnim("feathers");
            FlxTween.tween(isaacShadow, {alpha:0}, 2);
            columnaDer1.alpha = 0;
            columnaDer2.alpha = 0;
            columnaIzq1.alpha = 0;
            columnaIzq2.alpha = 0;
        case 2874:
            FlxTween.tween(camGame.scroll,{y: camGame.scroll.y - 1000}, 1.5, {ease:FlxEase.expoIn});
            if (isDownscroll){
                FlxTween.tween(degradado, {y:degradado.y - degradado.height / 1.5}, 2);
            }
            else{
                FlxTween.tween(degradado, {y:degradado.y - degradado.height / 1.5}, 2);
            }
        case 2904:
            voidBg.alpha = 0;
            degradado.alpha = 0;
        case 2908:
            blackOverlay.alpha = 0;
            strumLines.members[1].characters.remove(colored);
        case 3077:
            camGame.target = camFollow;
            activateCamZoom = true;
            camZooming = true;
            //applyGlitch(pillars);
            //glitchValues = [0.01, 0.05, 0.1, 0.15, 0.2];
            //glitchWait = 0.03;
        case 3501:
            dad.scale.set(1.25, 1.25);
            dad.updateHitbox();
            dad.x = 1666;
            dad.y = 1300;
        case 3513:
            dad.scale.set(1.25, 1.25);
            dad.updateHitbox();
            dad.x = 1666;
            dad.y = 1300;
        case 3587:
            redTint.alpha = 0.5;
            activateCamZoom = true;
            camZooming = true;

            dad.x = 1666;
            dad.y = 1300;
            glitchValues = [0.01, 0.1, 0.5, 0.75, 1, 2, 3];
            glitchTimer = 0.02;
            downpourWalls.alpha = 1;
            downpourFloor.alpha = 1;
            reflection.alpha = 1;
            ripple.alpha = 1;
            rain1.alpha = 1;
            rain2.alpha = 1;
            rainImpact.alpha = 1;
            downpourLight.alpha = 0.5;
            downpourColumn.alpha = 1;
        case 3752:
            dad.scale.set(1.25, 1.25);
            dad.updateHitbox();
        case 3875:
            new FlxTimer().start(0.06, function(_) {
                dad.scale.set(1.25, 1.25);
                dad.updateHitbox();
                dad.x = 1666;
                dad.y = 1300;
            });
        case 3876:
            dad.scale.set(1.25, 1.25);
            dad.updateHitbox();
            dad.x = 1666;
            dad.y = 1300;
        case 3880:
            applyGlitch(dad);
        case 3940:
            downpourWalls.alpha = 0.001;
            downpourFloor.alpha = 0.001;
            reflection.alpha = 0.001;
            ripple.alpha = 0.001;
            rain1.alpha = 0.001;
            rain2.alpha = 0.001;
            rainImpact.alpha = 0.001;
            downpourLight.alpha = 0.001;
            downpourColumn.alpha = 0.001;
        case 3944:
            downpourWalls.alpha = 1;
            downpourFloor.alpha = 1;
            reflection.alpha = 1;
            ripple.alpha = 1;
            rain1.alpha = 1;
            rain2.alpha = 1;
            rainImpact.alpha = 1;
            downpourLight.alpha = 0.5;
            downpourColumn.alpha = 1;
    }
}

function applyGlitch(obj:FlxSprite)
{
    if (glitchShader == null) return;

    obj.shader = glitchShader;
    glitchActive = true;
}

//looping code
var skySpeed = 1000;
var skyLayers = [];
var leftColOffset:Float = -3500;
var rightColOffset:Float = 0;


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
            if (spr.y + h < -h + rightColOffset)
                spr.y += h * n;
        } else {
            if (spr.y > FlxG.height + h + leftColOffset)
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
