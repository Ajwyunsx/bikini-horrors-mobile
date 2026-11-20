import flixel.math.FlxRect;
import flixel.math.FlxMath;

var customHUDCamera:FlxCamera;

var customBar:FlxSprite;
var customFill:FlxSprite;
var customBG:FlxSprite;

var ulti:FlxSprite;
var ultiFill:FlxSprite;
var ultiBG:FlxSprite;

var ultiProgress:Float = 0.0;
var ultiDuration:Float = 396;
public var isTimerLocked:Bool = false;

var customBarUlti:FlxSprite;
var customFillClip:FlxRect;
var ultiFillClip:FlxRect;
var lastHealthWidth:Int = -1;
var lastUltiWidth:Int = -1;
var hudDisposed:Bool = false;
var ultiReady:Bool = false;

var fire:FlxSprite;

function postCreate()
{

    customHUDCamera = new HudCamera();
    customHUDCamera.bgColor = 0x00000000;


    customHUDCamera.zoom = camHUD.zoom;


    customHUDCamera.scroll.set(0, 0);

    FlxG.cameras.add(customHUDCamera, false);



    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.alpha = 0;
    iconP2.alpha = 0;



    scoreTxt.cameras = [customHUDCamera];
    missesTxt.cameras = [customHUDCamera];
    accuracyTxt.cameras = [customHUDCamera];



    fire = new FlxSprite(7, -110);
    fire.frames = Paths.getSparrowAtlas('game/healthbar/tot/fire');
    fire.animation.addByPrefix('idle', 'idle', 24, true);
    fire.cameras = [customHUDCamera];
    fire.scale.set(0.85, 0.85);
    fire.updateHitbox();
    fire.animation.play('idle');
    add(fire);
    fire.alpha = 0;
    fire.active = false;



    customBG = new FlxSprite(70, 20);
    customBG.loadGraphic(Paths.image("game/healthbar/tot/healthBarFondo"));
    customBG.cameras = [customHUDCamera];
    customBG.scale.set(0.85, 0.85);
    customBG.updateHitbox();
    add(customBG);


    customFill = new FlxSprite(238, 95);
    customFill.loadGraphic(Paths.image("game/healthbar/tot/healthBarFill"));
    customFill.cameras = [customHUDCamera];
    customFill.scale.set(0.85, 0.85);
    customFill.updateHitbox();
    add(customFill);


    customBar = new FlxSprite(70, 20);
    customBar.loadGraphic(Paths.image("game/healthbar/tot/healthBar"));
    customBar.cameras = [customHUDCamera];
    customBar.scale.set(0.85, 0.85);
    customBar.updateHitbox();
    add(customBar);



    ultiBG = new FlxSprite(290, 155);
    ultiBG.loadGraphic(Paths.image("game/healthbar/ulti/ultiFondo"));
    ultiBG.cameras = [customHUDCamera];
    ultiBG.scale.set(0.85, 0.85);
    ultiBG.updateHitbox();
    add(ultiBG);


    ultiFill = new FlxSprite(292, 156);
    ultiFill.loadGraphic(Paths.image("game/healthbar/ulti/ultiFill"));
    ultiFill.cameras = [customHUDCamera];
    ultiFill.scale.set(0.85, 0.85);
    ultiFill.updateHitbox();
    add(ultiFill);


    ulti = new FlxSprite(290, 155);
    ulti.loadGraphic(Paths.image("game/healthbar/ulti/ulti"));
    ulti.cameras = [customHUDCamera];
    ulti.scale.set(0.85, 0.85);
    ulti.updateHitbox();
    add(ulti);



    customBarUlti = new FlxSprite(70, 20);
    customBarUlti.loadGraphic(Paths.image("game/healthbar/tot/healthBarUlti"));
    customBarUlti.cameras = [customHUDCamera];
    customBarUlti.scale.set(0.85, 0.85);
    customBarUlti.updateHitbox();
    add(customBarUlti);
    customBarUlti.alpha = 0;



    customBar.alpha = 0;
    customFill.alpha = 0;
    customBG.alpha = 0;

    ultiBG.alpha = 0;
    ultiFill.alpha = 0;
    ulti.alpha = 0;

    scoreTxt.alpha = 0;
    missesTxt.alpha = 0;
    accuracyTxt.alpha = 0;

    restorePlayerArrows();
}

function restorePlayerArrows() {
    if (playerStrums == null)
        return;

    playerStrums.visible = true;
    playerStrums.extra.set("hudAlpha", 1);
    if (playerStrums.notes != null)
        playerStrums.notes.visible = true;

    for (strum in playerStrums.members) {
        if (strum != null) {
            strum.visible = true;
            strum.alpha = 1;
        }
    }

    for (note in playerStrums.notes) {
        if (note != null) {
            note.visible = true;
            note.applyHudAlpha(1);
        }
    }

    applyMiddlescrollPositions(true);
}


function update(elapsed)
{
    if (hudDisposed)
        return;

    var percent:Float = FlxMath.bound(health / maxHealth, 0, 1);

    if (customFillClip == null)
        customFillClip = new FlxRect(0, 0, customFill.frameWidth, customFill.frameHeight);

    var healthWidth:Int = Math.round(customFill.frameWidth * percent);
    if (healthWidth != lastHealthWidth) {
        lastHealthWidth = healthWidth;
        customFillClip.width = healthWidth;
        customFillClip.height = customFill.frameHeight;
        customFill.clipRect = customFillClip;
    }

    if (ultiProgress < 1.0 && isTimerLocked)
    {
        ultiProgress += elapsed / ultiDuration;
        ultiProgress = FlxMath.bound(ultiProgress, 0, 1);
    }

    if (ultiProgress == 1.0 && !ultiReady)
    {
        ultiReady = true;
        FlxTween.cancelTweensOf(customBar);
        customBar.alpha = 0;
        customBarUlti.alpha = 1;
        fire.alpha = 1;
        fire.active = true;
    }

    if (ultiFillClip == null)
        ultiFillClip = new FlxRect(0, 0, ultiFill.frameWidth, ultiFill.frameHeight);

    var ultiWidth:Int = Math.round(ultiFill.frameWidth * ultiProgress);
    if (ultiWidth != lastUltiWidth) {
        lastUltiWidth = ultiWidth;
        ultiFillClip.width = ultiWidth;
        ultiFillClip.height = ultiFill.frameHeight;
        ultiFill.clipRect = ultiFillClip;
    }
}

function stepHit(step:Int) {

    if (curStep == 504) {
        showHUD(0.7);
    }

    if (curStep == 5392) {
        disposeHUD();
    }

    if (curStep == 4560) {
        showHUD(0.7);
    }
}

function disposeHUD() {
    if (hudDisposed)
        return;

    // Stop updates before releasing sprites; the ending still has update ticks.
    hudDisposed = true;
    isTimerLocked = false;
    for (sprite in [customBar, customFill, customBG, ulti, ultiFill, ultiBG, fire, customBarUlti]) {
        FlxTween.cancelTweensOf(sprite);
        remove(sprite);
        sprite.destroy();
    }
    customFillClip = ultiFillClip = null;

    for (txt in [scoreTxt, missesTxt, accuracyTxt]) {
        FlxTween.cancelTweensOf(txt);
        txt.alpha = 0;
    }
}

function showHUD(duration:Float) {
    if (hudDisposed)
        return;

    restorePlayerArrows();
    var easeFunc = FlxEase.quadInOut;

    FlxTween.tween(scoreTxt, {alpha: 1}, duration, {ease: easeFunc});
    FlxTween.tween(accuracyTxt, {alpha: 1}, duration, {ease: easeFunc});
    FlxTween.tween(missesTxt, {alpha: 1}, duration, {ease: easeFunc});

    for (strum in playerStrums.members) {
        if (strum != null)
            FlxTween.tween(strum, {alpha: 1}, duration, {ease: easeFunc});
    }

    for (strum in cpuStrums.members) {
        if (strum != null)
            FlxTween.tween(strum, {alpha: 1}, duration, {ease: easeFunc});
    }

    for (strumLine in strumLines) {
        for (note in strumLine.notes) {
            FlxTween.tween(note, {alpha: 1}, duration, {ease: easeFunc});
        }
    }

    FlxTween.tween(ultiReady ? customBarUlti : customBar, {alpha: 1}, duration, {ease: easeFunc});
    FlxTween.tween(customFill, {alpha: 1}, duration, {ease: easeFunc});
    FlxTween.tween(customBG, {alpha: 1}, duration, {ease: easeFunc});

    FlxTween.tween(ultiBG, {alpha: 1}, duration, {ease: easeFunc});
    FlxTween.tween(ultiFill, {alpha: 1}, duration, {ease: easeFunc});
    FlxTween.tween(ulti, {alpha: 1}, duration, {ease: easeFunc});
}
