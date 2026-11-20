var crt:CustomShader = null;
var dadClone:Character = null;
var dadClone2:Character = null;
var dadClone3:Character = null;
var dadClone4:Character = null;
var dadClone5:Character = null;
var dadClone6:Character = null;
var dadClone7:Character = null;
var dadClone8:Character = null;
var dadClone9:Character = null;

var cloneTargetX:Float = 0;
var clone2TargetX:Float = 0;
var clone3TargetX:Float = 0;
var clone4TargetX:Float = 0;
var clone5TargetX:Float = 0;
var clone6TargetX:Float = 0;
var clone7TargetX:Float = 0;
var clone8TargetX:Float = 0;
var clone9TargetX:Float = 0;
var blueCloneShader:CustomShader = null;


var boyfriendClone:Character = null;
var boyfriendCloneTargetX:Float = 0;

function create() {
    camGame.pixelPerfectRender = true;

    if (Options.shaderQualityAllows(1)) {
        var highShaders:Bool = Options.shaderQualityAllows(2);
        crt = new CustomShader('crt');

        crt.curvature = highShaders ? 0.12 : 0.04;
        crt.scanlines = highShaders ? 0.6 : 0.3;
        crt.rgbShift = highShaders ? 1 : 0.25;
        crt.blur = highShaders ? 0.15 : 0.0;

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
    dadClone = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone.scale.set(1, 1);
    dadClone.updateHitbox();

    dadClone.visible = true; 
    dadClone.alpha = 0;
    cloneTargetX = dad.x - 300;
    insert(members.indexOf(dad), dadClone);

    dadClone2 = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone2.scale.set(1, 1);
    dadClone2.updateHitbox();

    dadClone2.visible = true;
    dadClone2.alpha = 0;
    clone2TargetX = dad.x + 100;
    insert(members.indexOf(dad), dadClone2);


    dadClone3 = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone3.scale.set(1, 1);
    dadClone3.alpha = 0;
    clone3TargetX = dad.x - 500;
    insert(members.indexOf(dadClone2), dadClone3);

    dadClone4 = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone4.scale.set(1, 1);
    dadClone4.alpha = 0;
    clone4TargetX = dad.x - 700;
    insert(members.indexOf(dadClone3), dadClone4);

    blueCloneShader = new CustomShader("blueClone");
    dadClone4.shader = blueCloneShader;

    dadClone5 = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone5.scale.set(1, 1);
    dadClone5.alpha = 0;
    clone5TargetX = dad.x + 200;
    insert(members.indexOf(dadClone4), dadClone5);

    dadClone6 = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone6.scale.set(1, 1);
    dadClone6.alpha = 0;
    clone6TargetX = dad.x - 900;
    insert(members.indexOf(dadClone5), dadClone6);

    dadClone7 = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone7.scale.set(1, 1);
    dadClone7.alpha = 0;
    clone7TargetX = dad.x - 400;
    insert(members.indexOf(dadClone6), dadClone7);

    dadClone8 = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone8.scale.set(1, 1);
    dadClone8.alpha = 0;
    clone8TargetX = dad.x - 600;
    insert(members.indexOf(dadClone7), dadClone8);

    dadClone9 = new Character(dad.x, dad.y + 130, dad.curCharacter);
    dadClone9.scale.set(1, 1);
    dadClone9.alpha = 0;
    clone9TargetX = dad.x - 800;
    insert(members.indexOf(dadClone8), dadClone9);

    boyfriendClone = new Character(boyfriend.x + 30, boyfriend.y + 80, boyfriend.curCharacter);
    boyfriendClone.scale.set(1, 1);
    boyfriendClone.updateHitbox();
    boyfriendClone.visible = true;
    boyfriendClone.alpha = 0;
    boyfriendClone.flipX = false;

    boyfriendCloneTargetX = boyfriend.x + 150;

    insert(members.indexOf(boyfriend), boyfriendClone);


    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);
}

function update(elapsed:Float) {
    if (dadClone != null) syncClone(dadClone);
    if (dadClone2 != null) syncClone(dadClone2);
    if (dadClone3 != null) syncClone(dadClone3);
    if (dadClone4 != null) syncClone(dadClone4);
    if (dadClone5 != null) syncClone(dadClone5);
    if (dadClone6 != null) syncClone(dadClone6);
    if (dadClone7 != null) syncClone(dadClone7);
    if (dadClone8 != null) syncClone(dadClone8);
    if (dadClone9 != null) syncClone(dadClone9);
    if (boyfriendClone != null) syncboyfriendClone(boyfriendClone);
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

function syncboyfriendClone(clone:Character) {
    var anim = boyfriend.animation.curAnim;
    if (anim == null) return;

    var animName = anim.name;

    switch (animName) {
        case "singLEFT":
            animName = "singRIGHT";
        case "singRIGHT":
            animName = "singLEFT";
    }

    if (clone.animation.curAnim == null || clone.animation.curAnim.name != animName) {
        clone.animation.play(animName, true);
    }

    clone.animation.curAnim.curFrame = anim.curFrame;
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

        case 128:
            dadClone.x = dad.x;
            dadClone.alpha = 0;
            FlxTween.tween(dadClone, { x: cloneTargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });

        case 316:
            dadClone2.x = dad.x;
            dadClone2.alpha = 0;
            FlxTween.tween(dadClone2, { x: clone2TargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });

        case 608:
            dadClone3.x = dad.x;
            dadClone3.alpha = 0;
            FlxTween.tween(dadClone3, { x: clone3TargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });

        case 704:
            dadClone4.x = dad.x;
            dadClone4.alpha = 0;
            FlxTween.tween(dadClone4, { x: clone4TargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });

        case 800:
            dadClone5.x = dad.x;
            dadClone5.alpha = 0;
            FlxTween.tween(dadClone5, { x: clone5TargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });

        case 928:
            dadClone6.x = dad.x;
            dadClone6.alpha = 0;
            FlxTween.tween(dadClone6, { x: clone6TargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });

        case 1056:
            dadClone7.x = dad.x;
            dadClone7.alpha = 0;
            FlxTween.tween(dadClone7, { x: clone7TargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });

        case 1072:
            dadClone8.x = dad.x;
            dadClone8.alpha = 0;
            FlxTween.tween(dadClone8, { x: clone8TargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });

        case 1088:
            dadClone9.x = dad.x;
            dadClone9.alpha = 0;
            FlxTween.tween(dadClone9, { x: clone9TargetX, alpha: 1 }, 0.6, { ease: FlxEase.cubeOut });


        case 1112:
            boyfriendClone.x = boyfriend.x;
            boyfriendClone.alpha = 0;
            FlxTween.tween(
                boyfriendClone,
                { x: boyfriendCloneTargetX, alpha: 1 },
                0.6,
                { ease: FlxEase.cubeOut }
            );


        case 788:
            indexano.scale.set(1, 1);
            indexano.visible = true;
            indexano.alpha = 1;

            FlxTween.tween(indexano.scale, { x: 4.2, y: 4.2 }, 0.15, {
                ease: FlxEase.quadOut,
                onComplete: function(twn) {
                    FlxTween.tween(indexano.scale, { x: 4, y: 4 }, 0.15, { ease: FlxEase.quadIn });
                }
            });



        case 799:
            FlxTween.tween(indexano, { alpha: 0 }, 0.3, { ease: FlxEase.quadOut });
            FlxTween.tween(indexano.scale, { x: 1, y: 1 }, 0.3, { ease: FlxEase.quadOut });
            FlxTween.tween(indexano, { alpha: 0 }, 0.3, {
                onComplete: function(twn) {
                    indexano.visible = false;
                }
            });

    }
}

function onStrumCreation(event) {
    if (event.player == 1) return;

    event.cancel();

    var strum = event.strum;
    strum.loadGraphic(Paths.image('stages/fatal/ui/arrows-pixels'), true, 17, 17);
    strum.animation.add("static", [event.strumID]);
    strum.animation.add("pressed", [4 + event.strumID, 8 + event.strumID], 12, false);
    strum.animation.add("confirm", [12 + event.strumID, 16 + event.strumID], 24, false);

    strum.scale.set(daPixelZoom, daPixelZoom);
    strum.updateHitbox();
}

function onNoteCreation(event) {
    if (event.note.strumLine) return;

    event.cancel();

    var note = event.note;
    if (event.note.isSustainNote) {
        note.loadGraphic(Paths.image('stages/fatal/ui/arrowEnds'), true, 7, 6);
        note.animation.add("hold", [event.strumID]);
        note.animation.add("holdend", [4 + event.strumID]);
    } else {
        note.loadGraphic(Paths.image('stages/fatal/ui/arrows-pixels'), true, 17, 17);
        note.animation.add("scroll", [4 + event.strumID]);
    }
    note.scale.set(daPixelZoom, daPixelZoom);
    note.updateHitbox();
}
