var dadBaseY:Float = 0;
var dadBaseX:Float = 0;
var lampBaseY:Float = 0;
var dadSineTime:Float = 0;
var dadSineSpeed:Float = 2.0;
var dadSineAmount:Float = 30;

var smashCam = new FlxCamera();
var blackCam = new FlxCamera();

var rotateLamp:Bool = false;

var beatMod:Int = 4;

var switchingSong:Bool = false;

var crt:CustomShader = null;
var tottalTimer:Float = FlxG.random.float(20, 100);
var ogStrumX:Array<Float> = [];

var brightOffsetX:Float = 0;
var brightOffsetY:Float = 0;

function create() {
    FlxG.cameras.remove(camGame, false);
    FlxG.cameras.remove(camHUD, false);

    FlxG.cameras.add(camGame, true);
    FlxG.cameras.add(camHUD, false);
    FlxG.cameras.add(blackCam, false);
    FlxG.cameras.add(smashCam, false);
    

    smashCam.bgColor = FlxColor.TRANSPARENT;
    blackCam.bgColor = FlxColor.TRANSPARENT;

    boyfriend.visible = false;

    if (Options.shaderQualityAllows(1)) {
        var highShaders:Bool = Options.shaderQualityAllows(2);
        crt = new CustomShader('staticScanlines');

        crt.staticAmount = highShaders ? 0.1 : 0.04;
        crt.staticScale = highShaders ? 30 : 18;
        crt.staticSpeed = highShaders ? 10 : 4;

        if (highShaders)
            camHUD.addShader(crt);
        camGame.addShader(crt);
    }

    pixelScript = scripts.getByName("pixel.hx");
    if (pixelScript == null) return;
}

function update(elapsed:Float) {
    dadSineTime += elapsed * dadSineSpeed;

    dad.y = dadBaseY + Math.sin(dadSineTime) * dadSineAmount;

    if (rotateLamp) {
        var beat = Conductor.songPosition / Conductor.crochet;
        jellyfish.angle = Math.cos(beat * Math.PI / beatMod) * 30;
    }

    bright.x = jellyfish.x + brightOffsetX;
    bright.y = jellyfish.y + brightOffsetY;

    bright.angle = jellyfish.angle;
}


function postCreate() {
    guiri.origin(guiri.width / 2, guiri.height / 2);
    kill.cameras = [smashCam];
    guiri.cameras = [smashCam];
    brightOffsetX = 0;
    brightOffsetY = 0;
    gf.x = 300;
    gf.alpha=0;
    gf.y = 00;
    dadBaseY = dad.y;
    lampBaseY = jellyfish.y;

    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.visible = false;
    iconP2.visible = false;
    defaultCamZoom = 0.8;
    camGame.zoom = defaultCamZoom;
    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [blackCam];
    add(blackOverlay);

    ogStrumX = [];
        for (strum in playerStrums.members) {
            ogStrumX.push(strum.x);
        }

    string0.visible = false;
    string1.visible = false;
    string2.visible = false;
    string3.visible = false;
}

function stepHit(curStep:Int) {
    switch (curStep) {
        case 10:
            var center = FlxG.width / 2;
            comboVisibility(false);

            tweenPlayerStrumlineCustom(center, [
                -300,
                -150,
                150,
                300
            ], 1, FlxEase.quadOut);

        case 64:
            FlxTween.tween(blackOverlay, { alpha: 0 }, 10);
        case 180:
            FlxTween.tween(light, { alpha: 1 }, 4);
        case 191:
            defaultCamZoom = 0.55;
            FlxTween.tween(camGame, {
                zoom: defaultCamZoom
            }, 0.5, {
                ease: FlxEase.quadOut
            });
            
        case 200:
            fadeInStrumline(1,1.0);
            comboVisibility(true, true);
        case 596:
            string0.visible = true;
            string1.visible = true;
            string2.visible = true;
            string3.visible = true;
        case 850:
            boyfriend.visible = true;
            resetPlayerStrumline(0.03);
            fadeInStrumline(0,1.0);
            healthBar.alpha = 1;
            healthBarBG.alpha = 1;
            iconP1.visible = true;
            iconP2.visible = true;
            jellyfish.alpha = 1;
            jellyfish.angle = 0;
            bright.alpha = 0.65;
            jellyfish.origin.set(jellyfish.width / 2, 0);
            bright.origin.set(bright.width / 2,0);
            hide_objects([string0,string1,string2,string3,light]);
            rotateLamp = true;
            bright.blend = "ADD";
            stagea.alpha = 1;
        case 1104:
            FlxTween.tween(camGame, {zoom: 0.9}, 5, {ease: FlxEase.quadInOut});
        case 1160:
            blackOverlay.alpha = 1;
            resetStrumXByID(0);
            beatMod = 6;
            var center = FlxG.width / 2;
            tweenPlayerStrumlineCustom(center, [-300, -150, 150, 300], 1, FlxEase.quadOut);
            fadeOutStrumline(0,1);

        case 1168:
            FlxTween.tween(blackOverlay, { alpha: 0.3 }, 4);
        case 1455:
            bright.blend = "ADD";
            bright.color = FlxColor.fromHSB(0, 1, 1);
            bright.alpha = 0.7;
            beatMod = 6;
        case 1743:
            hide_objects([jellyfish,bright,stagea]);
            FlxTween.tween(blackOverlay, { alpha: 0 }, 0.25);
            dad.visible = false;
        case 1660:
            blackOverlay.alpha = 0.4;
        case 1684:
            blackOverlay.alpha = 0.6;
        case 1708:
            blackOverlay.alpha = 0.8;
        case 1732:
            blackOverlay.alpha = 1;
            healthBar.alpha = 0;
            healthBarBG.alpha = 0;
            iconP1.visible = false;
            iconP2.visible = false;
        case 1924:
            tv.alpha = 1;
            plant.alpha = 1;
            floor.alpha = 1;
            gamecube.alpha = 1;

            resetPlayerStrumline(0.05);
            resetStrumXByID(0,0.05);
            fadeInStrumline(0,0.05);
            dad.visible = true;
            healthBar.alpha = 1;
            healthBarBG.alpha = 1;
            iconP1.visible = true;
            iconP2.visible = true;
            smash.visible = false;
        case 1888:
            smash.alpha = 0.6;
            FlxTween.tween(smash, { y: -400 }, 4, {ease: FlxEase.quadOut});
        case 2463:
            blackOverlay.alpha = 1;
        case 2479:
            blackOverlay.alpha = 0;
        case 2558:
            guiri.scrollFactor.set(0, 0);
            guiri.screenCenter();
            var wanter_pos:Float = guiri.y;
            guiri.y += 700;
            FlxTween.tween(blackOverlay,{alpha : 1}, 0.5);
            FlxTween.tween(guiri,{alpha : 1, y : wanter_pos}, 0.5,{ease: FlxEase.quadOut});
        case 2575:
            smashCam.shake(0.01, 15);
        case 2580:
            FlxG.sound.play(Paths.sound("scream"));
            kill.scrollFactor.set(0, 0);
            kill.screenCenter();

            var wanter_pos:Float = kill.y;
            kill.y += 700;

            FlxTween.tween(guiri, { alpha: 0 }, 0.25);

            FlxTween.tween(kill, { alpha: 1, y: wanter_pos }, 0.5, {
                ease: FlxEase.quadOut,
                onComplete: function(twn:FlxTween) {

                    new FlxTimer().start(1.5, function(_) {
                        FlxTween.tween(kill, { alpha: 0 }, 0.5);
                    });

                }
            });
        case 2640:
            return;

    }
}


function hide_objects(array:Array){
    for (i in array){
        i.alpha = 0;
    }
}

function tweenStrumByID(
    id:Int,
    targetX:Float,
    targetY:Float = -1,
    duration:Float = 0.5,
    ease = FlxEase.expoOut,
    ?onComplete:Void->Void
) {
    var strum = playerStrums.members[id];
    if (strum == null) return;

    var props:Dynamic = { x: targetX };
    if (targetY != -1) props.y = targetY;

    FlxTween.tween(strum, props, duration, {
        ease: ease,
        onComplete: function(_) {
            if (onComplete != null) onComplete();
        }
    });
}

function resetPlayerStrumline(duration:Float = 0.5, ease = FlxEase.expoOut) {
    if (ogStrumX.length < 4) return;

    for (i in 0...playerStrums.members.length) {
        var strum = playerStrums.members[i];
        if (strum == null) continue;

        FlxTween.tween(strum, {
            x: ogStrumX[i]
        }, duration, { ease: ease });
    }
}


function resetStrumXByID(id:Int, duration:Float = 0.2) {
    if (ogStrumX[id] == null) return;

    tweenStrumByID(id, ogStrumX[id], -1, duration);
}

function tweenPlayerStrumlineNormalized(
    normX:Float,              // 0 = left, 1 = right
    duration:Float = 0.5,
    ease = FlxEase.expoOut,
    spacing:Float = -1        // NEW: distance between strums
) {
    normX = FlxMath.bound(normX, 0, 1);

    var first = playerStrums.members[0];
    var last  = playerStrums.members[3];
    if (first == null || last == null) return;

    if (spacing <= 0) {
        spacing = playerStrums.members[1].x - first.x;
    }

    var strumWidth = spacing * (playerStrums.members.length - 1) + first.width;

    var minX = 0;
    var maxX = FlxG.width - strumWidth;

    var targetStartX = FlxMath.lerp(minX, maxX, normX);

    for (i in 0...playerStrums.members.length) {
        var strum = playerStrums.members[i];
        if (strum == null) continue;

        FlxTween.tween(strum, {
            x: targetStartX + (spacing * i)
        }, duration, { ease: ease });
    }
}

function tweenPlayerStrumlineCustom(
    centerX:Float,
    offsets:Array<Float>,
    duration:Float = 0.5,
    ease = FlxEase.expoOut
) {
    var firstStrum = playerStrums.members[0];
    if (firstStrum == null) return;

    var leftEdge:Float = Math.POSITIVE_INFINITY;
    var rightEdge:Float = Math.NEGATIVE_INFINITY;

    for (i in 0...offsets.length) {
        var strum = playerStrums.members[i];
        if (strum == null) continue;

        var left = offsets[i];
        var right = offsets[i] + strum.width;

        if (left < leftEdge) leftEdge = left;
        if (right > rightEdge) rightEdge = right;
    }

    var visualCenter = (leftEdge + rightEdge) / 2;
    var correction = centerX - visualCenter;

    for (i in 0...playerStrums.members.length) {
        var strum = playerStrums.members[i];
        if (strum == null || offsets[i] == null) continue;

        FlxTween.tween(strum, {
            x: offsets[i] + correction
        }, duration, { ease: ease });
    }
}


function fadeInStrumline(id:Int ,duration:Float = 1) {
        var line = strumLines.members[id];
        if (line == null) continue;

        line.visible = true;

        for (strum in line.members) {
            if (strum == null) continue;

            strum.visible = true;
            strum.alpha = 0;

            FlxTween.tween(strum, { alpha: 1 }, duration, {
                ease: FlxEase.quadOut
            });
        }
}

function mediumArray(arr:Array):Float {
    var total:Float = 0;
    for (v in arr) {
        total += v;
    }
    return (total /2);
}

function fadeOutStrumline(id:Int, duration:Float = 1) {
    var line = strumLines.members[id];
    if (line == null) return;

    for (strum in line.members) {
        if (strum == null) continue;

        FlxTween.tween(strum, { alpha: 0 }, duration, {
            ease: FlxEase.quadOut
        });
    }
    line.visible = false;
}

function switchSongSafe(song:String, diff:String = null) {
    if (switchingSong) return;
    switchingSong = true;

    scriptPaused = true;

    PlayState.loadSong(song, diff);

    FlxG.signals.postUpdate.addOnce(function() {
        if (PlayState.instance != null) {
            PlayState.switchToPlayState();
        }

        scriptPaused = false;
        switchingSong = false;
    });
}

function comboVisibility(val:Bool, tween:Bool = false){
        scoreTxt.visible = val;
        missesTxt.visible = val;
        accuracyTxt.visible = val;
        if (tween){
            var array:Array = [scoreTxt, missesTxt, accuracyTxt];
            if (val){
                for (text in array){
                    text.alpha = 0;
                    FlxTween.tween(text, { alpha: 1 }, 2);
                }
            }
        }
}
