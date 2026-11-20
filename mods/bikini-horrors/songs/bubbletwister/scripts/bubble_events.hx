// Script by Chezzar
import funkin.backend.utils.WindowUtils;

var gfBaseY:Float = 0;
var floatTime:Float = 0;
var blackOverlay;
var blackBG;
var startMoving:Bool = false;
var whiteShader:CustomShader;

public var nick:FlxSprite;
var pixel:CustomShader;

function create() {
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

    whiteShader = new CustomShader("whiteShader");
}

function postCreate() {
    gf.visible = false;
    gfBaseY = -500;
    WindowUtils.winTitle = window.title = "SUBARU COME BACK";

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    blackBG = new FlxSprite(-FlxG.width, -FlxG.height);
    blackBG.makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
    blackBG.scrollFactor.set(0, 0);
    blackBG.alpha = 1;
    blackBG.cameras = [camGame];

    goodbye = new FlxSprite();
    goodbye.loadGraphic(Paths.image('goodbye'));
    goodbye.scale.set(0.67, 0.67);
    goodbye.updateHitbox();
    goodbye.alpha = 1;
    goodbye.scrollFactor.set(0, 0);
    goodbye.cameras = [camHUD];
    goodbye.screenCenter();
    add(goodbye);
    goodbye.visible = false;
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


function update(elapsed:Float) {
    if (startMoving) {
        floatTime += elapsed;

        var floatOffset = Math.sin(floatTime * Math.PI) * 20;
        gf.y = gfBaseY + floatOffset;
    }
    
}

function bringCharactersToFront() {
    if (members.indexOf(dad) > -1 && blackBG != null) {
        insert(members.indexOf(dad), blackBG); 
    }
}


function stepHit(step:Int) {
    switch (step) {
        case 1112:
            blackBG.visible = true;

            bringCharactersToFront();

            boyfriend.shader = whiteShader;
            dad.shader = whiteShader;
            gf.shader = whiteShader;

            var tweenObj = {value: -1000};
            FlxTween.tween(tweenObj, {value: -500}, 18, {
                onUpdate: function(twn:FlxTween) {
                    gfBaseY = tweenObj.value;
                    if (!startMoving) gf.y = gfBaseY;
                }
            });

        case 1304:
            blackBG.visible = false;
            boyfriend.shader = null;
            dad.shader = null;
            gf.shader = null;

            startMoving = true;

        case 3036:
            blackOverlay.alpha = 1;
            goodbye.visible = true;
    }
}
