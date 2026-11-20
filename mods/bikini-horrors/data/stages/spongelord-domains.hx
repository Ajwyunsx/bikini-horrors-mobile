// Script by Chezzar and Meiart
var water:CustomShader = null;
var bgCam = new FlxCamera();
var screenVignette:FlxSprite;
var blackOverlay;
public var nick:FlxSprite;

function create() {
    bgCam.bgColor = 0x00000000; 

    if (Options.shaderQualityAllows(1)) {
        water = new CustomShader("waterDistortion");
        water.strength = Options.shaderQualityAllows(2) ? 1 : 0.24;
        water.detail = Options.shaderQualityAllows(2) ? 30.0 : 14.0;
        bgCam.addShader(water);
    }

    bgCam.zoom = 0.35;
    camGame.bgColor = 0x000000FF;

    FlxG.cameras.remove(camGame, false);
    FlxG.cameras.remove(camHUD, false);

    FlxG.cameras.add(bgCam, false);
    FlxG.cameras.add(camGame, true);
    FlxG.cameras.add(camHUD, false);

    nick = new FlxSprite();
    nick.loadGraphic(Paths.image('logos/fiff'));
    nick.scale.set(0.3, 0.3);
    nick.updateHitbox();
    nick.scrollFactor.set(0, 0);
    nick.cameras = [camHUD];

    nick.x = FlxG.width - nick.width - 30;
    nick.y = FlxG.height - nick.height - 30;


    add(nick);

}

function onSongStart() {
    robot.alpha = 0;
    robot_2.alpha = 0;
    montanas.alpha = 0;
    poste_1.alpha = 0;
    poste_2.alpha = 0;
    poste_3.alpha = 0;
    poste_4.alpha = 0;
    poste_5.alpha = 0;
    poste_1_2.alpha = 0;
    poste_2_2.alpha = 0;
    poste_3_2.alpha = 0;
    poste_4_2.alpha = 0;
    poste_5_2.alpha = 0;
    suelo.alpha = 0;
    poste.alpha = 0;
    mar.alpha = 0;
    mar_guapo.alpha = 0;
    ancla.alpha = 0;

    FlxTween.tween(blackOverlay, {alpha: 0}, 5, {
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

    add(screenVignette);
    screenVignette.cameras = [camHUD];

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
    
    mar.camera = bgCam;
    lugar.camera = bgCam;
    mar_guapo.camera = bgCam;
}

function stepHit(curStep:Int) {
    
    if(curStep == 396) {
        FlxTween.tween(lugar, {alpha: 0}, 0.2);
    }

    if(curStep == 400) {
        FlxTween.tween(suelo, {alpha: 1}, 0.05);
        FlxTween.tween(poste, {alpha: 1}, 0.025);
        FlxTween.tween(mar, {alpha: 1}, 2);
    }

    if(curStep == 401) {
        FlxTween.tween(poste_1, {alpha: 1}, 0.025);
        FlxTween.tween(poste_2, {alpha: 1}, 0.05);
    }

    if(curStep == 402) {
        FlxTween.tween(poste_3, {alpha: 1}, 0.025);
        FlxTween.tween(poste_4, {alpha: 1}, 0.05);
    }

    if(curStep == 403) {
        FlxTween.tween(poste_5, {alpha: 1}, 0.025);
        FlxTween.tween(montanas, {alpha: 1}, 0.05);
    }

    if(curStep == 404) {
        FlxTween.tween(robot, {alpha: 1}, 0.05);
    }

    if(curStep == 532) {
        robot.alpha = 0;
        montanas.alpha = 0;
        poste_1.alpha = 0;
        poste_2.alpha = 0;
        poste_3.alpha = 0;
        poste_4.alpha = 0;
        poste_5.alpha = 0;
        suelo.alpha = 0;
        poste.alpha = 0;

        manos_delante.alpha = 1;
        manos_detras.alpha = 1;
        plataforma.alpha = 1;
        montanas_2.alpha = 1;
        ancla.alpha = 1;
        gf.alpha = 1;
    }

    if(curStep == 784) {
        FlxTween.tween(gf, {
            y: gf.y + 900}, 3, {ease: FlxEase.quartOut});
    }

    if(curStep == 1040) {
        FlxTween.tween(ancla, {alpha: 0}, 2);
        FlxTween.tween(montanas_2, {alpha: 0}, 2);
        FlxTween.tween(manos_delante, {alpha: 0}, 2);
        FlxTween.tween(manos_detras, {alpha: 0}, 2);
        FlxTween.tween(plataforma, {alpha: 0}, 2);
        FlxTween.tween(mar, {alpha: 0}, 2);
    }

    if(curStep == 1058) {
        FlxTween.tween(gf, {alpha: 0}, 2);
    }

    if(curStep == 1072) {
        FlxTween.tween(suelo, {alpha: 1}, 0.1);
        FlxTween.tween(poste, {alpha: 1}, 0.1);
        FlxTween.tween(mar, {alpha: 1}, 1);
        FlxTween.tween(poste_1, {alpha: 1}, 0.1);
        FlxTween.tween(poste_2, {alpha: 1}, 0.1);
        FlxTween.tween(poste_3, {alpha: 1}, 0.1);
        FlxTween.tween(poste_4, {alpha: 1}, 0.1);
        FlxTween.tween(poste_5, {alpha: 1}, 0.1);
        FlxTween.tween(robot, {alpha: 1}, 0.1);
        FlxTween.tween(montanas, {alpha: 1}, 0.1);
    }

    if(curStep == 1227) {
        FlxTween.tween(camera, {zoom: camera.zoom + 0.2}, 9.64, {ease: FlxEase.quartIn});
        FlxTween.tween(camGame.scroll, {x: camGame.scroll.x + 200}, 9.64, {ease: FlxEase.quartIn});
        FlxTween.tween(mar, {alpha: 0}, 9.64, {ease: FlxEase.quartIn});
    }

    if(curStep == 1324) {
        FlxTween.tween(camera, {zoom: camera.zoom}, 0.05);
        FlxTween.tween(camGame.scroll, {x: camGame.scroll.x - 200}, 0.05);
    }

    if(curStep == 1328) {
        robot.alpha = 0;
        poste_1.alpha = 0;
        poste_2.alpha = 0;
        poste_3.alpha = 0;
        poste_4.alpha = 0;
        poste_5.alpha = 0;
        mar_guapo.alpha = 1;
        robot_2.alpha = 1;
        poste_1_2.alpha = 1;
        poste_2_2.alpha = 1;
        poste_3_2.alpha = 1;
        poste_4_2.alpha = 1;
        poste_5_2.alpha = 1;
    }

    if(curStep == 1584) {
        FlxTween.tween(mar_guapo, {alpha: 0}, 2);
    }

    if(curStep == 1712) {
        FlxTween.tween(robot_2, {alpha: 0}, 0.5);
        FlxTween.tween(lugar, {alpha: 1}, 5);
    }

    if(curStep == 1726) {
        FlxTween.tween(montanas, {alpha: 0}, 0.5);
    }

    if(curStep == 1742) {
        FlxTween.tween(poste_5_2, {alpha: 0}, 0.5);
    }

    if(curStep == 1758) {
        FlxTween.tween(poste_4_2, {alpha: 0}, 0.5);
    }

    if(curStep == 1776) {
        FlxTween.tween(poste_3_2, {alpha: 0}, 0.5);
    }

    if(curStep == 1784) {
        FlxTween.tween(camera, {zoom: camera.zoom - 0.2}, 10, {ease: FlxEase.sineIn});
    }

    if(curStep == 1792) {
        FlxTween.tween(poste_2_2, {alpha: 0}, 0.5);
    }

    if(curStep == 1808) {
        FlxTween.tween(poste_1_2, {alpha: 0}, 0.5);
    }

    if(curStep == 1824) {
        FlxTween.tween(suelo, {alpha: 0}, 0.5);
        FlxTween.tween(poste, {alpha: 0}, 0.5);
    }

    if(curStep == 1864) {
        FlxTween.tween(camera, {zoom: camera.zoom}, 0.05);
    }
}

// This function is by LunarClient

var tottalTimer:Float = FlxG.random.float(100, 1000);

function update(elapsed:Float) {
    water?.time = (tottalTimer += elapsed);
}
