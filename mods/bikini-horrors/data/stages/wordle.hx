// Script by Chezzar and Meiart
var bgCam = new FlxCamera();
var screenVignette:FlxSprite;
var blackOverlay;
public var nick:FlxSprite;

function create() {
    bgCam.bgColor = 0x00000000; 

    bgCam.zoom = 0.35;
    camGame.bgColor = 0x000000FF;

    FlxG.cameras.remove(camGame, false);
    FlxG.cameras.remove(camHUD, false);

    FlxG.cameras.add(bgCam, false);
    FlxG.cameras.add(camGame, true);
    FlxG.cameras.add(camHUD, false);

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

function onSongStart() {
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
}


function stepHit() { 
     if (curStep == 205) {
         FlxTween.tween(amanda, {x: amanda.x - 12250}, 30);
    }
     if (curStep == 448) {
         FlxTween.tween(quetzal, {x: quetzal.x - 12250}, 30);
    }
     if (curStep == 970) {
         FlxTween.tween(romeo, {x: romeo.x - 12250}, 30);
    }
     if (curStep == 641) {
         FlxTween.tween(ulises, {x: ulises.x + 12250}, 30);
    }
     if (curStep == 1179) {
         FlxTween.tween(iniesta, {x: iniesta.x + 12250}, 30);
    }
     if (curStep == 1327) {
        fiff.alpha = 1;
    }
}
