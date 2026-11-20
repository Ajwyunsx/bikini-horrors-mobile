import flixel.math.FlxRect;
import flixel.addons.text.FlxTypeText;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.system.FunkinMobileScaleMode;

var shader = new CustomShader('saturation');
shader.sat = 1;
shader.contrast = 1;

var video = true;

var watermark:FlxSprite;
var bgBlack:FlxSprite;
var overBlack:FlxSprite;
var backBobs = [];
var frontBobs = [];
var phonks = [];
var ais:FlxSprite;
var sasterCam:FlxCamera;
var stageOverlayCam:HudCamera;
var startBlack:FlxSprite;

var spots = [];
var tempGroot;
var tempKomni;

var pixelCam:FlxCamera;
var pixelGroot:Character;
var pixelKomni:Character;
var aura2:FlxSprite;

var daters = [];
var komniDate:Character;
var cutePhonk:FlxSprite;
var cuteGroot:FlxSprite;
var sky:FlxSprite;
var dialogue:FlxTypeText;

var fours = [];
var kevin4:Character;
var groot4:Character;

function create()
{
    sasterCam = new HudCamera();
    sasterCam.bgColor = 0x0;
    sasterCam.pixelPerfectRender = true;
    FlxG.cameras.add(sasterCam, false);

    stageOverlayCam = new HudCamera();
    stageOverlayCam.bgColor = 0x0;
    stageOverlayCam.pixelPerfectRender = true;
    FlxG.cameras.insert(stageOverlayCam, FlxG.cameras.list.indexOf(camHUD), false);

    bgBlack = new FlxSprite().makeGraphic(1280/0.3, 720/0.3, FlxColor.BLACK);
    bgBlack.screenCenter();
    bgBlack.scrollFactor.set();
    bgBlack.alpha = 0.75;

    for(i in 0...6)
    {
        var phonk1 = new FlxSprite(-1450 + (520 * i), -300 - ((i >= 3 ? (5 - i) : i)) * 140);
        phonk1.frames = Paths.getSparrowAtlas('stages/geometry/1/phonk1');
        phonk1.animation.addByIndices('idle1', 'phonk1 dance', [0,1,2,3,4,5], '', 24, false);
        phonk1.animation.addByIndices('idle2', 'phonk1 dance', [6,7,8,9,10,11,12,13], '', 24, false);
        phonk1.scale.set(0.65, 0.65);
        phonk1.updateHitbox();
        phonk1.scrollFactor.set(0.8,1.2);
        phonk1.flipX = i <= 2;
        insert(members.indexOf(platform), phonk1);

        var phonk2 = new FlxSprite(-2280 + (610 * i), 190 + ((i >= 3 ? (5 - i) : i)) * 225);
        phonk2.frames = Paths.getSparrowAtlas('stages/geometry/1/phonkbob2');
        phonk2.animation.addByIndices('idle1', 'phonkbob2 dance', [0,1,2,3,4,5], '', 24, false);
        phonk2.animation.addByIndices('idle2', 'phonkbob2 dance', [6,7,8,9,10,11,12,13], '', 24, false);
        phonk2.scale.set(0.825, 0.825);
        phonk2.updateHitbox();
        phonk2.flipX = i >= 3;
        phonk2.scrollFactor.set(1.45,1);
        add(phonk2);

        backBobs.push(phonk1);
        frontBobs.push(phonk2);
    }
    for(i in backBobs)
    {
        i.y += 300;
        i.alpha = 0.0;
        phonks.push(i);
    }
    for(i in frontBobs)
    {
        i.alpha = 0;
        phonks.push(i);
    }

    ais = new FlxSprite();
    ais.frames = Paths.getSparrowAtlas('stages/geometry/ais');
    ais.animation.addByPrefix('claude', 'claude', 24, true);
    ais.animation.addByPrefix('meta', 'meta', 24, true);
    ais.animation.addByPrefix('sora', 'sora', 24, true);
    ais.animation.addByPrefix('gemini', 'gemini', 24, true);
    ais.animation.play('claude');
    ais.setGraphicSize(650,650);
    ais.updateHitbox();
    ais.screenCenter(FlxAxes.Y);
    ais.x = 480;
    ais.alpha = 0;
    insert(members.indexOf(glow) + 1, ais);

    var mult = new FlxSprite().makeGraphic(1280 / 0.3, 720 / 0.3, 0xFFFEC8D6);
    mult.screenCenter();
    mult.scrollFactor.set();
    mult.blend = BlendMode.MULTIPLY;
    add(mult);

    watermark = new FlxSprite().loadGraphic(Paths.image('stages/geometry/SASTER'));
    watermark.setPosition(FlxG.width - watermark.width - 5, FlxG.height - watermark.height - 5);
    watermark.camera = sasterCam;
    watermark.alpha = 0.3;
    add(watermark);

    stageOverlayCam.bgColor = 0xFFFFE8E8;

    tempGroot = cpu.characters[1];
    tempKomni = player.characters[1];

    tempGroot.camera = stageOverlayCam;
    tempGroot.setPosition(100,-60);
    tempGroot.scale.set(0.375, 0.375);
    tempGroot.updateHitbox();

    tempKomni.camera = stageOverlayCam;
    tempKomni.setPosition(650, 45);
    tempKomni.scale.set(0.375, 0.375);
    tempKomni.updateHitbox();

    for(i in 0...2)
    {
        var spot = new FlxSprite().loadGraphic(Paths.image('stages/geometry/fgucking fuck'));
        spot.x = 1280 - (1280 / (i + 1));
        spot.camera = stageOverlayCam;
        insert(members.indexOf(tempGroot) + 2, spot);
        spots.push(spot);
    }
    stageOverlayCam.onViewportResize = layoutSpots;
    layoutSpots();

    pixelCam = new FlxCamera();
    pixelCam.pixelPerfectRender = true;
    pixelCam.zoom = 2.7;
    pixelCam.scroll.x = -252.5;
    pixelCam.scroll.y = -140;
    FlxG.cameras.insert(pixelCam, FlxG.cameras.list.indexOf(camHUD), false);

    var phonk1 = new FlxBackdrop(null,FlxAxes.X);
    phonk1.frames = Paths.getSparrowAtlas('stages/geometry/2/phonkbobs_bg');
    phonk1.animation.addByIndices('idle1', 'dance', [0,1,2,3], '', 10, false);
    phonk1.animation.addByIndices('idle2', 'dance', [4,5,6,7], '', 10, false);
    phonk1.camera = pixelCam;
    phonk1.y = 100;
    phonk1.velocity.x = 55;
    phonk1.antialiasing = false;
    add(phonk1);
    phonks.push(phonk1);

    pixelGroot = new Character(275,180,'grootbob_pixel');
    pixelGroot.camera = pixelCam;
    add(pixelGroot);

    pixelKomni = new Character(425,165,'komni_pixel',true);
    pixelKomni.camera = pixelCam;
    add(pixelKomni);

    var phonk2 = new FlxBackdrop(null,FlxAxes.X);
    phonk2.frames = Paths.getSparrowAtlas('stages/geometry/2/phonkbobs_fg');
    phonk2.animation.addByIndices('idle1', 'dance', [0,1,2,3], '', 10, false);
    phonk2.animation.addByIndices('idle2', 'dance', [4,5,6,7], '', 10, false);
    phonk2.camera = pixelCam;
    phonk2.y = 260;
    phonk2.velocity.x = -40;
    phonk2.antialiasing = false;
    add(phonk2);
    phonks.push(phonk2);

    var poop = new FlxSprite(157,85).loadGraphic(Paths.image('stages/geometry/2/grootbob_text1'));
    poop.camera = pixelCam;
    poop.antialiasing = false;
    add(poop);

    aura1 = new FlxSprite(150,90).loadGraphic(Paths.image('stages/geometry/2/AURA_bar EMPTY'));
    aura1.camera = pixelCam;
    aura1.antialiasing = false;
    add(aura1);

    aura2 = new FlxSprite(150,90).loadGraphic(Paths.image('stages/geometry/2/AURA_bar FULL'));
    aura2.camera = pixelCam;
    aura2.clipRect = new FlxRect(0, 200, aura2.width, aura2.height);
    aura2.antialiasing = false;
    add(aura2);

    pixelBlack = new FlxSprite().makeGraphic(1200,600,FlxColor.BLACK);
    pixelBlack.scrollFactor.set();
    pixelBlack.camera = pixelCam;
    add(pixelBlack);

    sky = new FlxSprite(115,70).loadGraphic(Paths.image('stages/geometry/3/trees'));
    sky.camera = pixelCam;
    sky.scale.set(1.2,1.2);
    sky.updateHitbox();
    sky.antialiasing = false;
    add(sky);

    komniDate = new Character(sky.x+35,sky.y-5,'komni_pixel_2');
    komniDate.camera = pixelCam;
    komniDate.scale.set(1.2,1.2);
    komniDate.updateHitbox();
    add(komniDate);

    kasakuas = new FlxSprite(sky.x + 30, sky.y + 70).loadGraphic(Paths.image('stages/geometry/3/kasakuas'));
    kasakuas.scale.set(1.2,1.2);
    kasakuas.updateHitbox();
    kasakuas.camera = pixelCam;
    kasakuas.visible = false;
    add(kasakuas);

    cutePhonk = new FlxSprite(sky.x+240,sky.y+77);
    cutePhonk.frames = Paths.getSparrowAtlas('stages/geometry/3/Phonkbob_date');
    for(i in ['idle', 'pose', 'laugh', 'eyes', 'cry', 'blush'])
        cutePhonk.animation.addByPrefix(i, i, 24, false);
    cutePhonk.animation.play('idle');
    cutePhonk.camera = pixelCam;
    cutePhonk.scale.set(1.2,1.2);
    cutePhonk.updateHitbox();
    cutePhonk.x += 225;
    cutePhonk.antialiasing = false;
    cutePhonk.visible = false;
    add(cutePhonk);

    cuteGroot = new FlxSprite(sky.x+250,sky.y+90);
    cuteGroot.frames = Paths.getSparrowAtlas('stages/geometry/3/GROOT_date');
    for(i in ['angry', 'eyes', 'laugh'])
        cuteGroot.animation.addByPrefix(i, i, 24, false);
    cuteGroot.animation.play('angry');
    cuteGroot.camera = pixelCam;
    cuteGroot.scale.set(1.2,1.2);
    cuteGroot.updateHitbox();
    cuteGroot.antialiasing = false;
    add(cuteGroot);


    borders = new FlxSprite(sky.x,sky.y).loadGraphic(Paths.image('stages/geometry/3/top'));
    borders.camera = pixelCam;
    borders.scale.set(1.2,1.2);
    borders.updateHitbox();
    borders.antialiasing = false;
    add(borders);

    dialogue = new FlxTypeText(sky.x + 80,sky.y + 220, 950,'ASJKDHASJKLDHSALJKDHjSAUJIKLDHLAKJSDHFLJKASDHFLKJDHSALJKFHASJKLDFHJAKSDHJFJLKASHDFJKLHSAJKLDFHAJSKLDHFJKLASDHFLKJASH');
    dialogue.setFormat(Paths.font('SASTUR.ttf'), 48, FlxColor.WHITE);
    // dialogue.start();
    dialogue.scale.set(0.4,0.4);
    dialogue.updateHitbox();
    dialogue.camera = pixelCam;
    add(dialogue);

    daters = [pixelBlack, sky, komniDate, borders, dialogue, cuteGroot];
    for(i in daters)
        i.alpha = 0;

    glow.alpha = 0;
    pixelCam.alpha = 0;

    banner = new FlxSprite().loadGraphic(Paths.image('stages/geometry/4/banner1'));
    banner.visible = false;
    // add(banner);
    insert(999,banner);
    // insert(;0, banner);
//
    bg4 = new FlxSprite().loadGraphic(Paths.image('stages/geometry/4/bg'));
    bg4.screenCenter();
    bg4.x -= 500;
    add(bg4);

    komni4 = new FlxSprite(bg4.x+720,bg4.y+80);
    komni4.frames = Paths.getSparrowAtlas('stages/geometry/4/komniF');
    komni4.animation.addByPrefix('idle', 'idle', 24, true);
    komni4.animation.play('idle');
    add(komni4);

    kevin4 = new Character(bg4.x + 450, bg4.y,'kevin_kek');
    add(kevin4);

    groot4 = new Character(bg4.x-5,bg4.y + 315,'groot_4');
    add(groot4);

    fours = [bg4, komni4, kevin4, groot4];
    for(i in fours)
        i.visible = false;

    sunset = new FlxSprite().loadGraphic(Paths.image('stages/geometry/4/Bv'));
    sunset.camera = stageOverlayCam;
    sunset.screenCenter();
    insert(0, sunset);

    end = new FlxSprite();
    end.frames = Paths.getSparrowAtlas('stages/geometry/4/sunset');
    end.animation.addByPrefix('idle', 'sunset sunset', 24, true);
    end.animation.play('idle');
    end.camera = stageOverlayCam;
    end.setPosition(sunset.x + 330, sunset.y + 310);
    insert(1, end);

    sunset.visible = end.visible = false;

    startBlack = new FunkinScreenOverlay(FlxColor.BLACK);
    startBlack.camera = sasterCam;
    add(startBlack);


    if(video)
    {
        camGame.alpha = 0;
        camHUD.alpha = 0;
        stageOverlayCam.alpha = 0;
        tempGroot.alpha = 0;
        tempKomni.alpha = 0;
        for(i in spots)
            i.alpha = 0;
    } else {
        tempGroot.alpha = 0;
        tempKomni.alpha = 0;
        for(i in spots)
            i.alpha = 0;
        stageOverlayCam.bgColor = 0x0;
    }
}

function layoutSpots() {
    for (i in 0...spots.length) {
        var spot = spots[i];
        if (FunkinMobileScaleMode.isAdaptive()) {
            spot.scrollFactor.set(0, 0);
            stageOverlayCam.layoutViewportTile(spot, i, spots.length);
        } else {
            spot.scrollFactor.set(1, 1);
            spot.scale.set(1, 1);
            spot.updateHitbox();
            spot.setPosition(FlxG.width * i / spots.length, 0);
        }
    }
}

function postCreate()
{

    FlxG.cameras.remove(stageOverlayCam, false);
    FlxG.cameras.insert(stageOverlayCam, FlxG.cameras.list.indexOf(camHUD), false);

    if (camHUD.filters != null)
        stageOverlayCam.setFilters(camHUD.filters.copy());
}

function onSongStart()
{
    FlxTween.tween(startBlack, {alpha: 0}, 1, {ease: FlxEase.linear, onComplete: function(twn:FlxTween) {
        remove(startBlack);
        startBlack.destroy();
        startBlack = null;
    }});
}

function pixelStuff()
{
    pixelCam.alpha = 1;
    cpu.characters.push(pixelGroot);
    player.characters.push(pixelKomni);
    player.characters.push(komniDate);

    healthBar.visible = false;
    healthBarBG.visible = false;
    iconP1.visible = false;
    iconP2.visible = false;


    for(i in cpuStrums.members)
        i.x -= 720;
}

function update(e)
{
    FlxG.cameras.list[2].alpha = video ? 1 : 0;
    banner.camera = FlxG.cameras.list[2];

    aura2.clipRect.y = aura2.height * (1-(health/2));

    dialogue.updateHitbox();
}

function postUpdate(e)
{
    stageOverlayCam.x = camHUD.x;
    stageOverlayCam.y = camHUD.y;
    stageOverlayCam.angle = camHUD.angle;
    stageOverlayCam.scroll.set(camHUD.scroll.x, camHUD.scroll.y);
}

var alt = 1;
function beatHit(beat:Int)
{
    alt *= -1;
    for(phonk in phonks)
        phonk.animation.play('idle' + (alt == 1 ? '1' : '2'), true);

    cuteGroot.y = sky.y + 95;
    FlxTween.tween(cuteGroot, {y: sky.y + 90}, 0.3);

    cutePhonk.y = sky.y + 82;
    FlxTween.tween(cutePhonk, {y: sky.y + 77}, 0.3);
}

function ai(anim:String)
{
    // ais.animation.play(anim);
    ais.screenCenter(FlxAxes.Y);
    FlxTween.tween(ais, {alpha: 0, y: ais.y + 150}, 2, {ease: FlxEase.circIn, onComplete: ()->{
        ais.animation.play(anim, true);
        ais.screenCenter(FlxAxes.Y);
        ais.y -= 150;
        FlxTween.tween(ais, {alpha: 1, y: ais.y + 150}, 2, {ease: FlxEase.quadOut});
    }});
}

function stepHit(curStep:Int)
{
    switch(curStep)
    {
        case 144:
            camHUD.flash(FlxColor.WHITE, 0.3);
            stageOverlayCam.flash(FlxColor.WHITE, 0.3);
            camHUD.alpha = 1;
            stageOverlayCam.alpha = 1;
            camGame.alpha = 1;
            tempGroot.alpha = 1;
            tempKomni.alpha = 1;
            for(i in spots)
                i.alpha = 1;
        case 272:
            camHUD.flash(FlxColor.WHITE, 0.6);
            stageOverlayCam.flash(FlxColor.WHITE, 0.6);
            FlxTween.tween(bgBlack, {alpha: 0}, 0.3);
            for(i in spots)
                i.alpha = 0;
            tempKomni.alpha = tempGroot.alpha = 0;
            stageOverlayCam.bgColor = 0x0;
        case 656:
            camGame.flash(FlxColor.WHITE, 0.6);

            for(i in backBobs)
                FlxTween.tween(i, {alpha: 1.0, y: i.y - 300}, 1.3, {ease: FlxEase.quintOut});
            for(i in frontBobs)
                i.alpha = 1;

            FlxTween.cancelTweensOf(bgBlack);
            bgBlack.alpha = 0.5;
            remove(bgBlack);
            insert(members.indexOf(platform) - 6, bgBlack);
        case 944:
            for(i in backBobs)
                FlxTween.tween(i, {alpha: 0.0, y: i.y + 300}, 1.3, {ease: FlxEase.quintIn});
            for(i in frontBobs)
                FlxTween.tween(i, {alpha: 0.0, y: i.y + 300}, 1.3, {ease: FlxEase.quintIn});
            FlxTween.tween(bgBlack, {alpha: 0}, 2);
        case 1190:
            remove(bgBlack);
            insert(999, bgBlack);
            FlxTween.tween(bgBlack, {alpha: 1}, 1);
        case 1208:
            FlxTween.cancelTweensOf(bgBlack);
            FlxTween.tween(bgBlack, {alpha: 0}, 1);
            glow.alpha = 1;

            // FlxTimer.wait(2, ()->{ ai('gemini'); });
            ai('gemini');
        case 1270:
            ai('meta');

        case 1336:
            ai('claude');
        case 1430:
            ai('sora');
        case 1488:
            ais.screenCenter(FlxAxes.Y);
            FlxTween.tween(ais, {alpha: 0, y: ais.y + 150}, 2, {ease: FlxEase.circIn});

        case 1510:
            FlxTween.tween(bgBlack, {alpha: 1}, 1);

        case 1520:
            pixelStuff();
            pixelCam.flash(FlxColor.WHITE, 0.8);
            health = video ? 0.125 : 1;
        case 1648:
            FlxTween.tween(pixelCam, {zoom: 2.4}, 2, {ease: FlxEase.quadInOut});
            for(i in daters)
                FlxTween.tween(i, {alpha: 1}, 2);
        case 1744:
            cuteGroot.animation.play('laugh', true);
        case 1800:
            FlxTimer.wait(0.1, ()->{
                cutePhonk.visible = true;

            });

            FlxTween.tween(cutePhonk, {x: cutePhonk.x - 225}, 0.25, {onComplete: ()->{
                pixelCam.shake(0.005, 0.12);
                cuteGroot.animation.play('eyes', true);
                FlxTween.tween(cuteGroot, {x: cuteGroot.x - 190}, 0.25, {onComplete: ()->{cuteGroot.visible = false;}});
            }});
        case 2080:
            kasakuas.visible = true;
            FlxTween.tween(kasakuas, {x: kasakuas.x + 80}, 0.075, {onComplete: ()->{
                // FlxTween.tween(cutePhonk, {x: cutePhonk.x + 20}, 0.075, {ease: FlxEase.bounceOut});
                pixelCam.shake(0.005, 0.1);
                cutePhonk.animation.play('eyes');

                cuteGroot.flipX = true;
                cuteGroot.animation.play('eyes');
                FlxTween.tween(cuteGroot, {x: cuteGroot.x + 130}, 0.1, {onComplete: ()->{cuteGroot.visible = false;}});
            }});
        case 2096:
            video = true;

            final vidCam = FlxG.cameras.list[2];
            vidCam.zoom += 0.1;
            FlxTween.tween(vidCam, {zoom: 1}, 1, {ease: FlxEase.circOut});

            banner.visible = true;
            camHUD.visible = false;
            pixelCam.visible = false;

            cpu.characters = [groot4];
            player.characters = [kevin4];
            for(i in fours)
                i.visible = true;

            FlxTimer.wait(1.8, ()->{
                FlxTween.tween(banner, {alpha: 0}, 1);
                FlxTween.tween(bgBlack, {alpha: 0}, 1, {startDelay: 0.5});

                camHUD.visible = true;
                camHUD.alpha = 0;
                FlxTween.tween(camHUD, {alpha: 1}, 1, {startDelay: 1});
            });
        case 2448:
            sunset.visible = end.visible = true;
            FlxTween.cancelTweensOf(stageOverlayCam);
            stageOverlayCam.zoomMultiplier = 1;
            stageOverlayCam.zoom = 1.3;
            FlxTween.tween(stageOverlayCam, {zoom: 1}, (Conductor.stepCrochet / 1000) * 256, {ease: FlxEase.linear});
            camHUD.flash(FlxColor.WHITE, 0.5);
            stageOverlayCam.flash(FlxColor.WHITE, 0.5);
            watermark.loadGraphic(Paths.image('stages/geometry/KEVIN'));
            watermark.setPosition(FlxG.width - watermark.width - 5, FlxG.height - watermark.height - 5);
        case 2704:
            banner.loadGraphic(Paths.image('stages/geometry/4/banner2'));
            banner.setGraphicSize(1280,720);
            banner.updateHitbox();
            banner.screenCenter();
            banner.alpha = 1;
            stageOverlayCam.flash(FlxColor.WHITE, 0.2);

            FlxTimer.wait(4, ()->{
                sasterCam.fade(FlxColor.BLACK, 2);
            });
            FlxTween.tween(camHUD, {alpha: 0}, 3);
            FlxTween.tween(sunset, {alpha: 0}, 3);
            FlxTween.tween(end, {alpha: 0}, 3);
        case 2758:
            FlxG.sound.play(Paths.sound('FUCK'));
    }
}

function onEvent(e)
{
    switch(e.event.name)
    {
        case 'WHO':
            dialogue.resetText(e.event.params[0]);
            dialogue.start();
            dialogue.delay = 0.05;

            cutePhonk.animation.play(e.event.params[1]);

            cutePhonk.centerOffsets();
            switch(e.event.params[1])
            {
                case 'laugh':
                    cutePhonk.offset.y -= 5;
            }

            if(e.event.params[0] == '')
            {
                cuteGroot.visible = true;
                cuteGroot.animation.play('laugh', true);
                FlxTween.tween(cuteGroot, {x: cuteGroot.x + 120}, 0.2, {onComplete: ()->{
                    FlxTween.tween(cutePhonk, {x: cutePhonk.x + 60}, 0.09);
                    // cutePhonk.animation.play('eyes');
                }});
            }
    }
}
