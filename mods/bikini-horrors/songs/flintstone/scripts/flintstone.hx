import openfl.display.BlendMode;
import flixel.math.FlxRect;

//HEALTHBAR AND HUD ELEMENTS
var notes_bg: FlxSprite = new FlxSprite(0, 0, Paths.image("stages/semen/notes_bg"));
var mud: FlxSprite = new FlxSprite(0, 0, Paths.image("stages/semen/mud"));
var healthBarFill: FlxSprite = new FlxSprite(0, 0, Paths.image("stages/semen/healthbar_fill"));
var clipRect;
//MISC
var hansPosX:Float;
var SCALE :Float = 2;
var holandesY : Int;
var holandes;
var timer : Float = 0;
var dontzoom : Bool = false;
var darkLights;
var blackOverlay;
var isDownscroll:Bool = camHUD.downscroll;

function create(){
    camZooming = true;
    notes_bg.cameras = [camHUD];
    insert(0, notes_bg);
    healthBarFill.scale.x = SCALE;
    healthBarFill.scale.y = SCALE;
    healthBarFill.y = SCALE * 84 + 0.5;
    healthBarFill.x = SCALE * 81;
    healthBarFill.cameras = [camHUD];
    healthBarFill.alpha = 1;
    insert(1, healthBarFill);


}

function postCreate(){
    if (isDownscroll){
        notes_bg.loadGraphic(Paths.image("stages/semen/notes_bg_downscroll"));
        notes_bg.scale.x = SCALE;
        notes_bg.scale.y = SCALE;
        notes_bg.y = SCALE * 25;
        notes_bg.x = SCALE * 411;
        healthBarFill.y = SCALE * 21 + 0.5;
        healthBarFill.x = SCALE * (81 + 367);
        for (strum in playerStrums.members)
        {
            strum.x += 758;
            strum.y += 16;
        }
    }
    else{
        notes_bg.scale.x = SCALE;
        notes_bg.scale.y = SCALE;
        notes_bg.y = SCALE * 34;
        notes_bg.x = SCALE * 68;
        healthBarFill.y = SCALE * 84 + 0.5;
        healthBarFill.x = SCALE * 81;
    }
    camGame.pixelPerfectRender = true;
    clipRect = new FlxRect(0, 0, healthBarFill.width, healthBarFill.height);
    camGame.target = null;
    camGame.scroll.x = -220;
    camGame.scroll.y = -160;
    strumLines.members[1].characters[0].beatInterval = 4;
    strumLines.members[2].characters[0].beatInterval = 4;
    strumLines.members[3].characters[0].beatInterval = 4;
    strumLines.members[0].characters[0].alpha = 0;
    strumLines.members[2].characters[0].alpha = 0;
    strumLines.members[3].characters[0].alpha = 0;
    strumLines.members[5].characters[0].alpha = 0;
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.visible = false;
    iconP2.visible = false;
    if (FlxG.save.data.mech == false) {
        add(mud);
        mud.scale.x = SCALE;
        mud.scale.y = SCALE;
        mud.updateHitbox();
        mud.screenCenter();
        mud.camera = camHUD;
        mud.alpha = 0;
    }
    holandesY = strumLines.members[5].characters[0].y;
    holandes =  strumLines.members[5].characters[0];

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 1:
            FlxTween.tween(blackOverlay, {alpha:0}, 1);
        case 10:
            darkLights = new FlxSprite().makeGraphic(1300, 720, 0xFFed78ff);
            darkLights.cameras = [camGame, bgCam];
            darkLights.blend = BlendMode.LIGHTEN;
            darkLights.alpha = 0;
            add(darkLights);
        case 96:
            camGame.target = camFollow;
            strumLines.members[0].characters[0].alpha = 1;
        case 908:
            strumLines.members[3].characters[0].alpha = 1;
        case 1217:
            var dvd = strumLines.members[2].characters[0];
            dvd.alpha = 1;

            // starting velocity
            var velX:Float = 450;
            var velY:Float = -600; // negative = up
            var gravity:Float = 1700;

            FlxTween.num(0, 1, 0.8, {
                onUpdate: function(t) {
                    var dt = FlxG.elapsed;

                    velY += gravity * dt;
                    velX *= Math.pow(0.9, dt * 60);
                    dvd.x += velX * dt;
                    dvd.y += velY * dt;
                },
                onComplete: function(_){
                    camGame.shake(0.012,0.1);
                    bgCam.shake(0.012,0.1);
                    dvd.playAnim("drop", true);
                    
                }
            });
        case 1368:
            camGame.shake(0.01,0.4);
            bgCam.shake(0.01,0.4);
        case 1372:
            new FlxTimer().start(0.01, function(tmr:FlxTimer)
            {
                strumLines.members[2].characters[0].playAnim("intro", true);
                
            });
        case 1760:
            FlxTween.tween(darkLights, {alpha: 0.15}, 1);
        case 2288:
            FlxTween.tween(strumLines.members[2].characters[0], {y: -300}, 1, {ease:FlxEase.quadIn});
            FlxTween.tween(darkLights, {alpha: 0}, 1, {ease:FlxEase.expoInOut});

        case 2303:
            strumLines.members[3].characters[0].alpha = 0;
        case 2602:
            strumLines.members[3].characters[0].alpha = 0.8;
        case 3136:
            strumLines.members[5].characters[0].alpha = 1;
        case 3344:
            var bubble = strumLines.members[3].characters[0];
            FlxTween.num(
                holandesY,
                bubble.y - 50,
                3,
                {ease: FlxEase.quartInOut},
                function(v:Float)
                {
                    holandesY = v;
                }
            );
            FlxTween.tween(holandes, {x: bubble.x- 20}, 3, {ease:FlxEase.quartInOut});
            FlxTween.tween(bubble, {alpha:0, y : bubble.y - 20}, 1);
            startWave();
            FlxTween.tween(this, {defaultCamZoom: 2.3}, 3, {
                ease: FlxEase.quartInOut
            });
        case 4648:
            camZooming = true;
        case 4520:
            FlxG.switchState(new ModState("AfterFlintstoneState"));
    }
}

function postUpdate(elapsed:Float)
{
	var percent = health / 2;
	percent *= 100 * SCALE;
	percent = Math.floor(percent);
	percent /= 100 *SCALE;
    if (percent < 0.5){
        strumLines.members[4].vocals.volume = 0.7;
    }
    else{
        strumLines.members[4].vocals.volume = 0;
    }

	var w = healthBarFill.width * percent;

	healthBarFill.clipRect = new FlxRect(0, 0, w, healthBarFill.height);

    timer += elapsed;
    holandes.y = holandesY + Math.sin(timer * 3) * 6;
    if (dontzoom)
        camZooming = false;
    else
        camZooming = true;
}

function createMud(){
    if (FlxG.save.data.mech == false) {
        var bubble = strumLines.members[3].characters[0].playAnim("spit", true);
        mud.screenCenter();
        mud.scale.x += 0.1;
        mud.scale.y += 0.2;
        FlxG.sound.play(Paths.sound("spit"));
        new FlxTimer().start(0.2, function(tmr:FlxTimer)
        {
            
            camGame.shake(0.01,0.1);
            bgCam.shake(0.01,0.1);
            FlxTween.tween(mud, {alpha:0.9}, 0.06, {ease:FlxEase.expoOut});
            FlxTween.tween(mud.scale, {x: SCALE, y:SCALE}, 0.5, {ease:FlxEase.expoOut});
                new FlxTimer().start(5, function(tmr:FlxTimer)
                {
                    if (isDownscroll)
                        FlxTween.tween(mud, {alpha:0, y: -80}, 4, {ease: FlxEase.quartIn});
                    else
                        FlxTween.tween(mud, {alpha:0, y: 30}, 4, {ease: FlxEase.quartIn});
                });
        });
    }
}
