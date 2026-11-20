import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import funkin.game.StageCharPos;
public var nick:FlxSprite;
var blackOverlay;
var gfStartY:Float;
var gfStart2Y:Float;
var gfBounceTween:FlxTween;
var canFade:Bool = true;
importScript("data/scripts/snowing-shader");

function postCreate() {
    
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

        FlxTween.tween(
            obj1,
            { y: obj2.y - 60 }, 
            6,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );

        FlxTween.tween(
            obj3,
            { y: obj3.y - 30 }, // how high it moves
            2,                  // duration (seconds)
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );

        FlxTween.tween(
            obj4,
            { y: obj4.y - 50 }, 
            4,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );


        FlxTween.tween(
            obj8,
            { x: obj8.x - 50 }, 
            4,                  
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );

        blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
        blackOverlay.alpha = 1;
        blackOverlay.cameras = [camHUD];
        add(blackOverlay);

        gfStartY = gf.y;
        gf.y += 1500;
        gfStart2Y = gf.y;

        if (snowShader != null) {
            camGame.addShader(snowShader);

            snowSpeed = 2;
            snowShader.BRIGHT = 1;
        }


}

function update(elapsed:Float) {}

var bfTween:FlxTween = null;
function onPlayerHit(event) {

    if (canFade == true)
    {
            if (bfTween != null && bfTween.active) {
            bfTween.cancel();
            bfTween = null;
        }

        boyfriend.alpha = 1;

        bfTween = FlxTween.tween(
            boyfriend,             
            { alpha: 0 },          
            0.5,                   
            {
                ease: FlxEase.linear,
            }
        );
    }

}




function stepHit(curStep:Int) {
    if(curStep == 1768) 
    {
        obj2_dark.alpha = 0;
        obj2.alpha = 1;
        obj1.alpha = 0.9;
        obj8.alpha = 1;
        obj9.alpha = 1;
        obj3.alpha = 1;
        
    }

    if (curStep == 911) {
        FlxTween.tween(
            gf,
            { y: gfStartY },
            2.3,
            {
                ease: FlxEase.sineOut
            }
        );
    }

    if (curStep == 928 && gfBounceTween == null) {
        gfBounceTween = FlxTween.tween(
            gf,
            { y: gf.y - 80 },
            4,
            {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            }
        );
    }

    if (curStep == 1297 && gfBounceTween != null) {
        gfBounceTween.cancel();
        gfBounceTween = null;
    }

    if (curStep == 1296) {
        FlxTween.tween(
            gf,
            { y: gfStart2Y },
            2.3,
            {
                ease: FlxEase.sineIn
            }
        );
    }

    if (curStep == 400) {
        snowShader.BRIGHT = 2;
        snowShader.snowSpeed = 6;
        snowSpeed = 6;
    }

    if (curStep == 1575) {
        canFade = false;
        white.alpha = 1;
        obj8.alpha = 0;
        obj9.alpha = 0;
        static_warrior.alpha = 0;
        snowShader.BRIGHT = 0;
    }

    if (curStep == 1766) {
        canFade = true;
        white.alpha = 0;
        static_warrior.alpha = 1;
        snowShader.BRIGHT = 2.5;
        snowShader.snowSpeed = 7.5;
    }

    if (curStep == 2281)  {
        snowShader.BRIGHT = 0;
        nick.alpha = 0;
    }

    if (curStep == 2320) {
        if (FlxG.save.data.unlockedV2 == false){
            FlxG.switchState(new ModState("AfterMegaMortal"));
        }  
    }
}

function onSongStart() {
    FlxTween.tween(blackOverlay, {alpha: 0}, 2, {
        onComplete: function(twn:FlxTween) {
            remove(blackOverlay);
            blackOverlay.destroy();
        }
    });
}
