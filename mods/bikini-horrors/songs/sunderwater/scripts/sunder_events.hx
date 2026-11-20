// Script by Chezzar
import openfl.display.BlendMode;
var blackOverlay;
var backShader:CustomShader = null;
var fishEyeShader:CustomShader = null;
var water:CustomShader = null;
var bgCam = new FlxCamera();
var shaderTime:Float = 0;
public var nick:FlxSprite;


function postCreate() {
    WindowUtils.winTitle = window.title = "HI I'M SPRINGRGBUD!!!!";
}

function onSongEnd() {
    WindowUtils.winTitle = window.title = "BIKINI HORRORS";
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 2, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
}

function create() {
    if (Options.shaderQualityAllows(1)) {
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
}

function postCreate() {
    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay); 
}

function stepHit(curStep:Int) {
    if (curStep == 733) {

        stage.getSprite("darkLights").blend = BlendMode.MULTIPLY;
        stage.getSprite("luz").blend = blend = BlendMode.ADD;
        stage.getSprite("niebla").alpha = 0.6;
        boyfriend.y -= 70;
        dad.y -= 70;
    }
    if (curStep == 1807) {
        stage.getSprite("cielo").alpha = 0;
        stage.getSprite("fondo").alpha = 0;
        stage.getSprite("niebla").alpha = 0;
        stage.getSprite("luz").alpha = 0;
        stage.getSprite("front").alpha = 0;
        stage.getSprite("atras").alpha = 0;
        stage.getSprite("fondoFinal").alpha = 1;
        stage.getSprite("montanaOne").alpha = 1;
        stage.getSprite("montanaTwo").alpha = 1;
        stage.getSprite("calle").alpha = 1;
        stage.getSprite("edificio").alpha = 1;
        dad.x += 200;
        dad.y -= 450;
        boyfriend.x += -1150;
        boyfriend.y += 450;
        boyfriend.scrollFactor.x = 1.5;
        boyfriend.scrollFactor.y = 1.5;
        //if (Options.gameplayShaders) {
        if (!Options.shaderQualityAllows(2)) return;
        fishEyeShader = new CustomShader("fishEye");
        fishEyeShader.intensity = 0.1;
        fishEyeShader.zoom = 0.9;
        camGame.addShader(fishEyeShader);
        //}
    }

}


var tottalTimer:Float = FlxG.random.float(100, 1000);

function update(elapsed:Float) {
    shaderTime += elapsed;
    water?.time = (tottalTimer += elapsed);

    if (backShader != null && Options.shaderQualityAllows(1)) {
        backShader.resolution = [FlxG.width, FlxG.height];
        backShader.time = shaderTime;
    }
}

// If someone wants this function, don't delete I might need it for other mods

/*function spawnDadTrail() {
    var xOffset = FlxG.random.float(-34, 34);
    var yOffset = FlxG.random.float(-34, 34);
    var trail = new FlxSprite(dad.x + xOffset, dad.y + yOffset);

    trail.frames = dad.frames;
    trail.animation.copyFrom(dad.animation);
    trail.animation.play(dad.animation.name, true);
    trail.animation.curAnim.curFrame = dad.animation.curAnim.curFrame;
    trail.scale.set(dad.scale.x, dad.scale.y);
    trail.offset.set(dad.offset.x, dad.offset.y);
    trail.updateHitbox();
    trail.alpha = 0.6;
    trail.angle = dad.angle;
    trail.flipX = dad.flipX;
    trail.cameras = [camGame];
    trail.scrollFactor.set(dad.scrollFactor.x, dad.scrollFactor.y);
    insert(members.indexOf(dad), trail);

    dadTrails.push(trail);

    FlxTween.tween(trail, {alpha: 0}, 0.3, {
        onComplete: function(twn:FlxTween) {
            trail.kill();
            remove(trail, true);
            dadTrails.remove(trail);
            trail.destroy();
        }
    });
}*/
