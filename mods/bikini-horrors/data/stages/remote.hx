import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

var blackOverlay:FlxSprite;
var STATIC_TWEEN_TIME:Float = 1.0;

function create() {
    boyfriend.visible = false;
}

function postCreate() {
    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
}

function tweenAlpha(sprite:FlxSprite, targetAlpha:Float) {
    if (sprite == null) return;

    FlxTween.tween(sprite, { alpha: targetAlpha }, STATIC_TWEEN_TIME, {
        ease: FlxEase.quadOut
    });
}

function stepHit() {

    if (curStep == 4) {
        FlxTween.tween(blackOverlay, { alpha: 0 }, 1.5, {
            onComplete: function(twn:FlxTween) {
                remove(blackOverlay);
                blackOverlay.destroy();
            }
        });
    }

    if (curStep == 255) {
        tweenAlpha(staticsprite, 0.2);
    }

    if (curStep == 1276) {
        staticsprite.alpha = 1;
    }

    if (curStep == 1280) {
        tweenAlpha(staticsprite, 0.2);
    }

    if (curStep == 1772) {
        staticsprite.alpha = 1;
    }

    if (curStep == 1776) {
        tweenAlpha(staticsprite, 0.4);

        tweenAlpha(bossrush, 0);
        tweenAlpha(bossrush_2, 1);

        tweenAlpha(yosoyaika, 0);
        tweenAlpha(yosoyaika_2, 1);
    }

    if (curStep == 2012) {
        staticsprite.alpha = 1;
    }

    if (curStep == 2016) {
        tweenAlpha(staticsprite, 0.4);

        tweenAlpha(bossrush, 1);
        tweenAlpha(bossrush_2, 0);

        tweenAlpha(yosoyaika, 1);
        tweenAlpha(yosoyaika_2, 0);
    }

    if (curStep == 2240) {
        staticsprite.alpha = 1;
        tweenAlpha(staticsprite, 0.4);

        tweenAlpha(bossrush, 0);
        tweenAlpha(bossrush_2, 1);

        tweenAlpha(yosoyaika, 0);
        tweenAlpha(yosoyaika_2, 1);
    }

    if (curStep == 2333) {
        caca.alpha = 1;
    }

    if (curStep == 2276) {
        bossrush_2.alpha = 0;
        yosoyaika_2.alpha = 0;
        CACACA.alpha = 0;
        staticsprite.alpha = 0;
    }
}
