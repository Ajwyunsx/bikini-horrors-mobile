import flixel.util.FlxGradient;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.effects.particles.FlxTypedEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitterMode;
import openfl.display.BlendMode;
import flixel.math.FlxPoint;

var blackOverlay;
var whiteOverlay:FlxSprite;
var screenVignette:FlxSprite;
var gradient:FlxSprite;
var subgradient:FlxSprite;
var textico:FlxSprite;
var noteColors:Array<FlxColor> = [0xffefbafd, 0xFFB7FFFF, 0xFFC7FCC4, 0xFFFFC7C9];
var colorTween:FlxTween;
var isColor:Bool = false;
var isSad:Bool = false;
var isMad:Bool = false;
var winkie:FlxSprite;

var lastPlayerHitStep:Int = -1;
var skyEmitter:FlxTypedEmitter;
var totalImagenes:Int = 5;
var burgerScales:Array<Float> = [];

function postCreate()
{
    camZooming = true;

    screenVignette = new FlxSprite();
    screenVignette.loadGraphic(Paths.image("vignette_super"));
    screenVignette.setGraphicSize(FlxG.width, FlxG.height, true);
    screenVignette.scrollFactor.set(0, 0);
    screenVignette.alpha = 0;
    screenVignette.color = FlxColor.BLACK;
    screenVignette.screenCenter();

    add(screenVignette);
    screenVignette.cameras = [camHUD];
    
    whiteOverlay = new FunkinScreenOverlay(FlxColor.WHITE);
    whiteOverlay.scale.x = 5;
    whiteOverlay.scale.y = 5;
    whiteOverlay.alpha = 1;
    whiteOverlay.cameras = [camGame];
    insert(0, whiteOverlay);

    textico = new FlxSprite(-600,-130);
    textico.loadGraphic(Paths.image('stages/aloha/texticoo'));
    textico.scale.x = 0.9;
    textico.scale.y = 0.9;
    textico.alpha = 0;
    textico.cameras = [camGame];
    
    gradient = FlxGradient.createGradientFlxSprite(1920, 600, [0x00FFFFFF, 0x79FFFFFF, 0xFFFFFFFF, 0x79FFFFFF, 0x00FFFFFF], 1, 90);
    gradient.cameras = [camGame];
    gradient.x = -360; 
    gradient.y = 100;
    gradient.scrollFactor.set(0, 0);
    gradient.alpha = 0;
    gradient.color = 0xFFffb0d5;

    winkie = new FlxSprite(670, 450);
    winkie.frames = Paths.getSparrowAtlas('characters/aloha/winkie');
    winkie.animation.addByPrefix('brilli', 'brilli', 24, true);
    winkie.animation.addByPrefix('ceniza', 'ceniza', 24, false);
    winkie.scale.x = 0.6;
    winkie.scale.y = 0.6;
    winkie.animation.play('brilli');
    winkie.cameras = [camGame];
    winkie.alpha = 0;
    add(winkie);
    

    add(textico);
    var textIndex = members.indexOf(whiteOverlay) + 1;
    remove(textico, true);
    insert(textIndex, textico);

    add(gradient);
    var gradientIndex = members.indexOf(whiteOverlay) + 2;
    remove(gradient, true);
    insert(gradientIndex, gradient);


    skyEmitter = new FlxTypedEmitter(0, -160);
    skyEmitter.width = 1280;
    skyEmitter.height = 1;
    skyEmitter.launchMode = FlxEmitterMode.SQUARE;

    skyEmitter.velocity.set(-40, 600, 40, 1000); 
    skyEmitter.alpha.set(1, 1, 1, 1);
    skyEmitter.lifespan.set(1.2, 1.8);
    skyEmitter.angularVelocity.set(-120, 120);
    
    skyEmitter.maxSize = 35;
    
    for (i in 0...skyEmitter.maxSize) {
        var particle:FlxParticle = new FlxParticle();
        var idAleatorio:Int = FlxG.random.int(0, totalImagenes - 1);
        particle.loadGraphic(Paths.image('stages/aloha/burger' + idAleatorio));
        particle.ID = i;

        var escalaUniforme:Float = FlxG.random.float(1.0, 2.5);
        burgerScales.push(escalaUniforme);
        
        particle.scrollFactor.set(0, 0);
        particle.cameras = [camGame];
        skyEmitter.add(particle);
    }
    add(skyEmitter);

    pinkFilter = new FlxSprite().makeGraphic(1300, 720, 0xFFFF519C);
    pinkFilter.blend = BlendMode.ADD; 
    pinkFilter.cameras = [camHUD];
    pinkFilter.alpha = 0;
    add(pinkFilter);

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    for (char in strumLines.members[3].characters) {
        char.alpha = 0;
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

function update(elapsed:Float) 
{
    if (skyEmitter != null) {
        for (particle in skyEmitter.members) {
            if (particle != null && particle.alive) {
                var miEscala:Float = burgerScales[particle.ID];
                particle.scale.set(miEscala, miEscala);
            }
        }
    }
}

function stepHit(curStep:Int) {
    switch(curStep){
        case 128:
            FlxTween.tween(gradient, {alpha: 1}, 1, {ease: FlxEase.quadOut});
		case 544:
			isColor = true;

		case 800:
			isColor = false;
            FlxTween.color(whiteOverlay, 0.5, whiteOverlay.color, 0xFF747474, {ease: FlxEase.quadOut});
        case 992:
			isColor = false;
            FlxTween.color(whiteOverlay, 0.5, whiteOverlay.color, 0xFFFFFFFF, {ease: FlxEase.quadOut});
        case 1072:
            FlxTween.tween(pinkFilter, {alpha: 0.25}, 0.5, {ease: FlxEase.quadOut});
            skyEmitter.start(false, 0.5);
        case 1344:
            FlxTween.tween(pinkFilter, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
            skyEmitter.emitting = false;
        case 1366:
            boyfriend.y -= 55;
            boyfriend.x -= 10;
        case 1392:
            winkie.alpha = 1;
            FlxTween.cubicMotion(winkie, 670, 450, 700, 420, 750, 460, 780, 400, 3.5, {
                ease: FlxEase.sineInOut
            });
        case 1440:
            dad.alpha = 0;
            boyfriend.alpha = 0;
            winkie.animation.play('ceniza');
        case 1442:
            dad.alpha = 1;
            boyfriend.alpha = 1;
        case 1462:
            boyfriend.y += 55;
            boyfriend.x += 10;
        case 1472:
            isColor = true;
            isSad = true;
        case 1604:
            isSad = false;
            isMad = true;
        case 1728:
            isColor = false;
            FlxTween.color(whiteOverlay, 0.5, whiteOverlay.color, 0xFF747474, {ease: FlxEase.quadOut});
        case 1860:
            FlxTween.color(whiteOverlay, 0.5, whiteOverlay.color, 0xFFFFFFFF, {ease: FlxEase.quadOut});
        case 1920:
            FlxTween.color(whiteOverlay, 0.5, whiteOverlay.color, 0xFF979797, {ease: FlxEase.quadOut});
        case 1936:
            FlxTween.color(gradient, 0.5, gradient.color, 0xffa52d2d, {ease: FlxEase.quadIn});
        case 1952:
            dad.y -= 700;
        case 1984:
            dad.y += 700;
            gf.y -= 250;
            gf.x -= 90;
            FlxTween.color(whiteOverlay, 0.5, whiteOverlay.color, 0xFF2B0101, {ease: FlxEase.quadOut});
            gradient.y = -500;
            gradient.height += 200;
            FlxTween.tween(screenVignette, {alpha: 0.8}, 0.5, {ease: FlxEase.quadOut});
            FlxTween.color(gradient, 0.4, gradient.color, 0xffbd2a2a, {ease: FlxEase.quadIn});
        case 2108:
            FlxTween.tween(screenVignette, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
        case 2112:
            textico.alpha = 0.8;
    }
}


function onPlayerHit(event) 
{
    if (!isColor) return;
    lastPlayerHitStep = Conductor.curStep;

    var note = event.note;
    var noteData:Int = note.noteData;
    if (noteData >= 0 && noteData < noteColors.length) 
    {
        var targetColor:FlxColor = noteColors[noteData];
        if (colorTween != null) colorTween.cancel();
        colorTween = FlxTween.color(gradient, 0.3, gradient.color, targetColor, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween) {
                colorTween = FlxTween.color(gradient, 0.4, gradient.color, 0xFFffb0d5, {ease: FlxEase.quadIn});
            }
        });
    }
}

function onDadHit(event)
{
    if (!isColor) return;
    if (Conductor.curStep == lastPlayerHitStep) return;

    var note = event.note;
    var noteData:Int = note.noteData;
    
    var targetColor:FlxColor = 0xFFFFFFFF;
    var valido:Bool = false;

    if (isSad) 
    {
        targetColor = 0xFFB7FFFF;
        valido = true;
    }

    else if (isMad) 
    {
        targetColor = 0xFFFFC7C9;
        valido = true;
    }
    else if (noteData >= 0 && noteData < noteColors.length) 
    {
        targetColor = noteColors[noteData];
        valido = true;
    }

    if (valido) 
    {
        if (colorTween != null) colorTween.cancel();
        colorTween = FlxTween.color(gradient, 0.3, gradient.color, targetColor, {
            ease: FlxEase.quadOut,
            onComplete: function(twn:FlxTween) {
                colorTween = FlxTween.color(gradient, 0.4, gradient.color, 0xFFffb0d5, {ease: FlxEase.quadIn});
            }
        });
    }
}
