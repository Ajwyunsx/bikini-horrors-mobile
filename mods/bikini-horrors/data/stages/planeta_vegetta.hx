var crt:CustomShader = null;
var tottalTimer:Float = FlxG.random.float(20, 100);

function create() {
    camGame.pixelPerfectRender = true;

    if (Options.shaderQualityAllows(1)) {
        var highShaders:Bool = Options.shaderQualityAllows(2);
        crt = new CustomShader('staticScanlines');

        crt.staticAmount = highShaders ? 0.6 : 0.18;
        crt.staticScale = highShaders ? 30.5 : 18;
        crt.staticSpeed = 0.5;

        if (highShaders)
            camHUD.addShader(crt);
        camGame.addShader(crt);
    }

    pixelScript = scripts.getByName("pixel.hx");
    if (pixelScript == null) return;

    pixelScript.set("enablePixelUI", false);
    pixelScript.set("enableCameraHacks", false);
    pixelScript.set("enablePauseMenu", false);
    pixelScript.set("pixelNotesForDad", false);
}



function postCreate() {

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    gf.alpha = 0;
}


function update(elapsed:Float) {
    if (crt != null) {
        crt.time = (tottalTimer += elapsed);
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

    }
}
