var crt:CustomShader = null;
var dadClone:Character = null;
var cloneTargetX:Float = 0;
var blueCloneShader:CustomShader = null;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
var clockText:FlxText;
var offsetX:Float = 20;
var offsetY:Float = 20;
var boyfriendClone:Character = null;
var boyfriendCloneTargetX:Float = 0;
import Date;
var clockTimer:Float = 0;
var char4:Character = null;
var char4BaseX:Float = 0;
var char4BaseY:Float = 0;
var kevinBaseX:Float = 0;
var kevinBaseY:Float = 0;
var char4Glitch:CustomShader = null;
var char4GlitchTimer:Float = 0;
var char4GlitchValues:Array<Float> = [0.001, 0.005, 0.01, 0.015];
var char4GlitchActive:Bool = false;
var temubobBaseX:Float = 0;
var temubobBaseY:Float = 0;
var bobdollFloatTime:Float = 0;
var bobdollFloatRadius:Float = 20;
var bobdollFloatSpeed:Float = 2;

var bobdollBaseX:Float = 0;
var bobdollBaseY:Float = 0;
var bobdoll:Character = null;
var bashiroBaseX:Float = 0;
var bashiroBaseY:Float = 0;

function create() {
    camGame.pixelPerfectRender = true;

    if (Options.shaderQualityAllows(1)) {
        var highShaders:Bool = Options.shaderQualityAllows(2);
        crt = new CustomShader('crt');

        crt.curvature = highShaders ? 0.05 : 0.02;
        crt.scanlines = highShaders ? 1 : 0.45;
        crt.rgbShift = highShaders ? 1 : 0.25;
        crt.blur = highShaders ? 0.15 : 0.0;

        if (highShaders)
            camHUD.addShader(crt);
        camGame.addShader(crt);
        if (highShaders) {
            char4Glitch = new CustomShader("glitching");
            char4Glitch.AMT = 0;
        }
    }
}

function postCreate() {
    dadClone = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone.scale.set(1, 1);
    dadClone.updateHitbox();

    dadClone.visible = true; 
    dadClone.alpha = 0;
    cloneTargetX = dad.x - 300;
    insert(members.indexOf(dad), dadClone);


    clockText = new FlxText(0, 0, 0, "");
    clockText.setFormat("assets/fonts/Camera.ttf", 32, FlxColor.WHITE, "RIGHT");

    clockText.scrollFactor.set(0, 0);
    clockText.cameras = [camHUD];

    clockText.borderSize = 2;
    clockText.borderColor = FlxColor.BLACK;

    add(clockText);

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    strumLines.members[3].characters[0].alpha = 0;


    char4 = strumLines.members[4].characters[0];

    char4BaseX = char4.x;
    char4BaseY = char4.y;

    char4.y = char4BaseY - 800; 

    kevinBaseX = kevin.x;
    kevinBaseY = kevin.y;

    kevin.y = kevinBaseY - 500;

    var temubob = stage.getSprite("temubob");

    temubobBaseX = temubob.x;
    temubobBaseY = temubob.y;

    temubob.x = temubobBaseX - 900;

    var bobdoll = stage.getSprite("bobdoll");

    bobdollBaseX = bobdoll.x;
    bobdollBaseY = bobdoll.y;

    bobdoll.x = bobdollBaseX + 1200;

    var bashiro = stage.getSprite("bashiro");

    bashiroBaseX = bashiro.x;
    bashiroBaseY = bashiro.y;

    bashiro.x = bashiroBaseX + 1200;
}



function update(elapsed:Float) {
    clockTimer += elapsed;

    if (char4Glitch != null && char4GlitchActive)
    {
        char4GlitchTimer += elapsed;

        if (char4GlitchTimer >= 0.1)
        {
            char4GlitchTimer = 0;

            var randIndex = FlxG.random.int(0, char4GlitchValues.length - 1);
            char4Glitch.AMT = char4GlitchValues[randIndex];
        }
    }

    bobdollFloatTime += elapsed;

    var floatY = Math.sin(bobdollFloatTime * bobdollFloatSpeed) * bobdollFloatRadius;

    bobdoll.y = bobdollBaseY + floatY;

    if (clockTimer >= 1) {
        clockTimer = 0;

        if (FlxG.save.data.priv == false) {
            var now = Date.now();

            var hours = now.getHours();
            var minutes = now.getMinutes();

            var ampm = (hours >= 12) ? "P.M." : "A.M.";

            hours = hours % 12;
            if (hours == 0) hours = 12;

            var minStr = (minutes < 10 ? "0" : "") + minutes;

            var months = ["Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.", "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."];

            var month = months[now.getMonth()];
            var day = now.getDate();
            var year = now.getFullYear();

            var dayStr = (day < 10 ? "0" : "") + day;

            clockText.text = hours + ":" + minStr + " " + ampm + "\n" + month + " " + dayStr + " " + year;
        } else {
            clockText.text = "9:30 P.M.\nMay 01 1999";
        }

        clockText.x = FlxG.width - clockText.width - offsetX;
        clockText.y = FlxG.height - clockText.height - offsetY;
    }
}


function syncClone(clone:Character) {
    var anim = dad.animation.curAnim;
    if (anim != null) {
        if (clone.animation.curAnim == null || clone.animation.curAnim.name != anim.name) {
            clone.animation.play(anim.name, true);
        }
        clone.animation.curAnim.curFrame = anim.curFrame;
    }
}



function stepHit(curStep:Int) {
    switch (curStep) {
        case 1:
            FlxTween.tween(blackOverlay, { alpha: 0 }, 0.5, {
                onComplete: function(twn:FlxTween) {
                    remove(blackOverlay);
                    blackOverlay.destroy();
                }
            });

        case 284:
        var temubob = stage.getSprite("temubob");

        temubob.playAnim("enter");

        FlxTween.tween(temubob, { x: temubobBaseX }, 2, {
            ease: FlxEase.linear,
            onComplete: function(twn:FlxTween)
            {
                temubob.playAnim("idle");
            }
        });

        case 300:
        bobdoll.playAnim("idle");

        FlxTween.tween(bobdoll, { x: bobdollBaseX }, 4, {
            ease: FlxEase.linear,
            onComplete: function(twn:FlxTween)
            {
                bobdoll.playAnim("idle");
            }
        });

        case 340:
        var bashiro = stage.getSprite("bashiro");

        bashiro.playAnim("enter");

        FlxTween.tween(bashiro, { x: bashiroBaseX }, 4, {
            ease: FlxEase.linear,
            onComplete: function(twn:FlxTween)
            {
                bashiro.playAnim("idle");
            }
        });


        case 664:
        FlxTween.tween(char4, { y: char4BaseY }, 3, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(char4, { y: char4BaseY - 30 }, 1.5, {
                    ease: FlxEase.sineInOut,
                    type: FlxTween.PINGPONG
                });

                FlxTween.tween(char4, { x: char4BaseX + 25 }, 2, {
                    ease: FlxEase.sineInOut,
                    type: FlxTween.PINGPONG
                });
            }
        });

        FlxTween.tween(kevin, { y: kevinBaseY }, 1.2, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween)
            {
                FlxTween.tween(kevin, { y: kevinBaseY - 30 }, 1.5, {
                    ease: FlxEase.sineInOut,
                    type: FlxTween.PINGPONG
                });

                FlxTween.tween(kevin, { x: kevinBaseX + 25 }, 2, {
                    ease: FlxEase.sineInOut,
                    type: FlxTween.PINGPONG
                });
            }
        });


        case 792:
            var bf = boyfriend;

            bf.scale.set(1, 1);
            bf.angle = 0;

            FlxTween.tween(bf.scale, { x: 0, y: 0 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(bf, { angle: 180 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(bf, { alpha: 0 }, 0.6, {
                ease: FlxEase.quadOut
            });


            var ba = bashiro;

            ba.scale.set(1, 1);
            ba.angle = 0;

            FlxTween.tween(ba.scale, { x: 0, y: 0 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(ba, { angle: 180 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(ba, { alpha: 0 }, 0.6, {
                ease: FlxEase.quadOut
            });



        case 806:
            var bf = boyfriend;

            bf.scale.set(0, 0);
            bf.angle = 180;
            bf.alpha = 0;
            bf.visible = true; 

            FlxTween.tween(bf.scale, { x: 1, y: 1 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(bf, { angle: 0 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(bf, { alpha: 1 }, 0.1, {
                ease: FlxEase.quadOut
            });

            dad.scale.set(0, 0);
            dad.angle = 180;
            dad.alpha = 0;
            dad.visible = true; 

            FlxTween.tween(dad.scale, { x: 1, y: 1 }, 0.3, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(dad, { angle: 0 }, 0.3, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(dad, { alpha: 1 }, 0.5, {
                ease: FlxEase.quadOut
            });

        case 801:
            dad.alpha = 0;

        case 800:
            char4.alpha = 0;
            dad.alpha = 0;
            suelo.alpha = 0;
            escenario.alpha = 0;
            cortina_detras.alpha = 0;
            cortina_delante.alpha = 0;
            flores.alpha = 0;
            burbujas.alpha = 0;
            coso.alpha = 0;
            bloques.alpha = 0;
            gf.alpha = 0;
            temubob.alpha = 0;
            bobdoll.alpha = 0;
            kevin.alpha = 0;
            bashiro.alpha = 0;

            fondo_l.alpha = 1;
            plataforma4_l.alpha = 1;
            montanas_l.alpha = 1;
            plataforma3_l.alpha = 1;
            plataforma2_l.alpha = 1;
            plataforma1_l.alpha = 1;
            ojos_l.alpha = 1;


        case 944:
            char4.alpha = 1;

        case 1466:
            var bf = boyfriend;

            bf.scale.set(1, 1);
            bf.angle = 0;

            FlxTween.tween(bf.scale, { x: 0, y: 0 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(bf, { angle: 180 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(bf, { alpha: 0 }, 0.6, {
                ease: FlxEase.quadOut
            });

        case 1474:
            suelo.alpha = 1;
            escenario.alpha = 1;
            cortina_detras.alpha = 1;
            cortina_delante.alpha = 1;
            flores.alpha = 1;
            burbujas.alpha = 1;
            coso.alpha = 1;
            bloques.alpha = 1;
            gf.alpha = 1;
            temubob.alpha = 1;
            bobdoll.alpha = 1;
            kevin.alpha = 1;

            fondo_l.alpha = 0;
            plataforma4_l.alpha = 0;
            montanas_l.alpha = 0;
            plataforma3_l.alpha = 0;
            plataforma2_l.alpha = 0;
            plataforma1_l.alpha = 0;
            ojos_l.alpha = 0;


        case 1477:
            var bf = boyfriend;

            bf.scale.set(0, 0);
            bf.angle = 180;
            bf.alpha = 0;
            bf.visible = true; 

            FlxTween.tween(bf.scale, { x: 1, y: 1 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(bf, { angle: 0 }, 0.4, {
                ease: FlxEase.quadOut
            });

            FlxTween.tween(bf, { alpha: 1 }, 0.1, {
                ease: FlxEase.quadOut
            });

        case 1886:
            FlxTween.tween(strumLines.members[3].characters[0], {alpha: 0.7}, 1, {
                ease: FlxEase.linear
            });

        case 1888:
            FlxTween.cancelTweensOf(char4);

            FlxTween.tween(char4, { y: char4BaseY - 120 }, 0.9, {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            });

            FlxTween.tween(char4, { x: char4BaseX + 120 }, 1, {
                ease: FlxEase.sineInOut,
                type: FlxTween.PINGPONG
            });

            temubob.playAnim("look");
            bobdoll.playAnim("look");

            if (char4Glitch != null)
            {
                char4.shader = char4Glitch;
                suelo.shader = char4Glitch;
                escenario.shader = char4Glitch;
                cortina_detras.shader = char4Glitch;
                cortina_delante.shader = char4Glitch;
                flores.shader = char4Glitch;
                burbujas.shader = char4Glitch;
                coso.shader = char4Glitch;
                bloques.shader = char4Glitch;

                char4GlitchValues = [0.1, 0.15, 0.2, 0.01];
                char4GlitchActive = true;
            }

        case 2320:
            FlxTween.tween(strumLines.members[3].characters[0], {alpha: 0}, 1, {
                ease: FlxEase.linear
            });



        case 2319:
            char4GlitchValues = [0, 0, 0, 0];
            char4.alpha = 0;
            kevin.alpha = 0;

            char4.shader = null;
            suelo.shader = null;
            escenario.shader = null;
            cortina_detras.shader = null;
            cortina_delante.shader = null;
            flores.shader = null;
            burbujas.shader = null;
            coso.shader = null;
            bloques.shader = null;

            char4GlitchActive = false;
            char4Glitch.AMT = 0;


    }
}
