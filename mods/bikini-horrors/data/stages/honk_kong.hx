var blackOverlay;
var canShake:Bool = false;
public var nick:FlxSprite;
import funkin.backend.utils.DiscordUtil;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import openfl.geom.Point;
import openfl.display.Sprite;

var discordPFP:FlxSprite;
var pfpHasBeenLoaded:Bool = false;


function marimba() {
    if (canShake == false) return;
    FlxG.camera.shake(0.005, 0.1);
}

function update(elapsed:Float) {
    marimba();

    if (!pfpHasBeenLoaded && DiscordUtil.user != null && FlxG.save.data.priv == false) {
        loadDiscordAvatar();
    }

    if (discordPFP != null && discordPFP.visible) {
        switch (boyfriend.animation.curAnim.name) {
            case "idle":
                discordPFP.x = boyfriend.x + 500;
                discordPFP.y = boyfriend.y + 530;
            case "singUP":
                discordPFP.x = boyfriend.x + 520;
                discordPFP.y = boyfriend.y + 470;
            case "singDOWN":
                discordPFP.x = boyfriend.x + 450;
                discordPFP.y = boyfriend.y + 620;
            case "singLEFT":
                discordPFP.x = boyfriend.x + 340;
                discordPFP.y = boyfriend.y + 550;
            case "singRIGHT":
                discordPFP.x = boyfriend.x + 570;
                discordPFP.y = boyfriend.y + 560;
            default:
                discordPFP.x = boyfriend.x + 500;
                discordPFP.y = boyfriend.y + 530;
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

function loadDiscordAvatar() {
    var userBitmap = DiscordUtil.user.getAvatar();
    
    if (userBitmap != null) {
        var size:Int = Std.int(Math.min(userBitmap.width, userBitmap.height));
        
        var circleBitmap:BitmapData = new BitmapData(size, size, true, 0);
        
        var shape = new Sprite();
        shape.graphics.beginFill(0xFFFFFFFF);
        shape.graphics.drawCircle(size / 2, size / 2, size / 2);
        shape.graphics.endFill();
        
        circleBitmap.draw(shape);
        circleBitmap.copyPixels(userBitmap, new Rectangle(0, 0, size, size), new Point(0, 0), circleBitmap, new Point(0, 0), true);
        

        discordPFP = new FlxSprite(boyfriend.x, boyfriend.y);
        discordPFP.pixels = circleBitmap;
        discordPFP.antialiasing = true;
        discordPFP.scale.set(.5, .5);
        discordPFP.cameras = [camGame];
        discordPFP.alpha = 0.9;
        discordPFP.updateHitbox();
        var shader = new CustomShader("discord");
        discordPFP.shader = shader;
        add(discordPFP);
        discordPFP.visible = false;
        
        pfpHasBeenLoaded = true;
    }
}


function postCreate() {
    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

}


function stepHit(curStep:Int) {
    
    if (curStep == 3) {
        FlxTween.tween(sky, {
            y: sky.y + 400}, 1);
    }

    if (curStep == 80) {
        FlxTween.tween(sky, {
            y: sky.y - 400}, 3, {ease: FlxEase.quintOut});
    }

    
    if (curStep == 2182) {
        sky_nosun.alpha = 1;
        sky.alpha = 0;
    }

    //CHEZZAR COPIA ESTO DE ABAJO MAMON
    if (curStep == 2875) {
        sky_nosun.alpha = 0;
        middle.alpha = 0;
        sim_sky.alpha = 1;
        sim_middle.alpha = 1;
        sim_sun.alpha = 1;
    }

    if (curStep == 1544) {
        canShake = true;

        FlxTween.tween(front_left, {
            y: front_left.y + 8000,
            angle: 25
        }, 10, {ease: FlxEase.quintIn, onComplete: function(twn:FlxTween) {
                canShake = false;
            }
        });

        FlxTween.tween(front_left, {x: front_left.x - 7}, 0.05, {
            type: FlxTween.PINGPONG
        });
    }

    if (curStep == 1720) {
        canShake = true;

        FlxTween.tween(front_right, {
            y: front_right.y + 8000,
            angle: -38
        }, 10, {ease: FlxEase.quintIn, onComplete: function(twn:FlxTween) {
                canShake = false;
            }
        });

        FlxTween.tween(front_right, {x: front_right.x - 7}, 0.05, {
        type: FlxTween.PINGPONG});
    }

    if (curStep == 2032) {
        canShake = true;
        
        FlxTween.tween(back_right, {
            y: back_right.y + 8000,
            angle: -41
        }, 10, {ease: FlxEase.quintIn, onComplete: function(twn:FlxTween) {
                canShake = false;
            }
        });

        FlxTween.tween(back_right, {x: back_right.x - 7}, 0.05, {
        type: FlxTween.PINGPONG});
    }

    if (curStep == 2236) {
        canShake = true;

        FlxTween.tween(back_left, {
            y: front_left.y + 8000,
            angle: 90
        }, 10, {ease: FlxEase.quintIn, onComplete: function(twn:FlxTween) {
                canShake = false;
            }
        });

        FlxTween.tween(back_left, {x: back_left.x - 7}, 0.05, {
        type: FlxTween.PINGPONG});
    }

    if (curStep == 2600) {
        canShake = true;
        
        FlxTween.tween(acantilado, {
            y: acantilado.y + 8000,
        }, 10, {ease: FlxEase.quintIn, onComplete: function(twn:FlxTween) {
                canShake = false;
            }
        });

        FlxTween.tween(acantilado, {x: acantilado.x - 7}, 0.05, {
        type: FlxTween.PINGPONG});


        FlxTween.tween(mountain_1, {
            y: mountain_1.y + 8000,
        }, 10, {ease: FlxEase.quintIn});

        FlxTween.tween(mountain_1, {x: mountain_1.x - 7}, 0.05, {
        type: FlxTween.PINGPONG});


        FlxTween.tween(mountain_2, {
            y: mountain_2.y + 8000,
        }, 10, {ease: FlxEase.quintIn});

        FlxTween.tween(mountain_2, {x: mountain_2.x - 7}, 0.05, {
        type: FlxTween.PINGPONG});
    }

    if (curStep == 2680) {
        FlxTween.tween(sky_nosun, {
            y: sky_nosun.y + 400
        }, 3, {ease: FlxEase.quintOut});
    }

    if (curStep == 3336) {
        if (discordPFP != null) {
            discordPFP.visible = true;
            FlxTween.tween(discordPFP, {alpha: 0.6}, 1.5, {type: FlxTween.PINGPONG, ease: FlxEase.sineInOut});
        }
    }
}
