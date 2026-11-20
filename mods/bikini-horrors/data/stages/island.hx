var seaSpeed = -3000;
var seaLayers = [];

var hasselhoffStartY:Float;
var bfStartY:Float;
var hasselhoffSineAmmount:Float = 50;
var hasselhoffSineTime:Float = 0;
var hasselhoffSineSpeed:Float = 5;
var dadBaseY:Float = 0;
var dadSineTime:Float = 0;
var dadSineSpeed:Float = 5.0; // how fast it moves
var dadSineAmount:Float = 70;

var ogStrumX:Array<Float> = [];

var phanesFloat:Bool = false;
var warriorFloat:Bool = false;

var bgCanvas:FlxSprite;
var bgShader:CustomShader = null;
var blackOverlay:FlxSprite;

var jumpOgY:Float;
var canjump:Bool = true;

var obstacleSpawnActive:Bool = false;
var obstacleSpawnTimer:Float = 0;
var obstacles:Array<FlxSprite> = [];
var minions:Array<{spr:FlxSprite, data:{name:String, spin:Bool, goesUp:Bool}}> = [];

var minionImages:Array<{name:String, spin:Bool, goesUp:Bool}> = [
    {name:"bobdoll_brine", spin:false, goesUp:true},
    {name:"bobkiller", spin:true, goesUp:false},
    {name:"bobosome_fatal", spin:false, goesUp:true},
    {name:"buv", spin:true, goesUp:false},
    {name:"bystaxx", spin:true, goesUp:false},
    {name:"corruption", spin:false, goesUp:false},
    {name:"crisbobal", spin:true, goesUp:false},
    {name:"cucaracha", spin:true, goesUp:false},
    {name:"dpongepanti", spin:true, goesUp:false},
    {name:"dvd", spin:false, goesUp:false},
    {name:"jellyfish", spin:false, goesUp:false},
    {name:"josejuan_dbtg", spin:false, goesUp:true},
    {name:"kenny_frank", spin:false, goesUp:false},
    {name:"lover_kevin", spin:false, goesUp:true},
    {name:"luis", spin:false, goesUp:false},
    {name:"mermaid_ketchup", spin:false, goesUp:true},
    {name:"michael", spin:false, goesUp:false},
    {name:"playa", spin:false, goesUp:false},
    {name:"poja", spin:true, goesUp:false},
    {name:"popbob", spin:true, goesUp:false},
    {name:"realbob", spin:true, goesUp:false},
    {name:"retrobob", spin:true, goesUp:false},
    {name:"sanded", spin:false, goesUp:false},
    {name:"satanpants", spin:true, goesUp:false},
    {name:"spongebud", spin:false, goesUp:false},
    {name:"starved", spin:true, goesUp:false},
    {name:"temubob", spin:true, goesUp:false},
    {name:"triste_lord", spin:false, goesUp:false},
    {name:"trong", spin:true, goesUp:false},
    {name:"usa", spin:false, goesUp:false},
    {name:"void", spin:false, goesUp:true}
];

function setSeaSpeed(value, time) {
    value = Std.parseFloat(value);
    time = Std.parseFloat(time);

    FlxTween.num(seaSpeed, value, time, { ease: FlxTween.quadOut }, function(v:Float) {
        seaSpeed = v;
    });
}

function getWidth(spr) {
    return spr.frameWidth * spr.scale.x;
}

function spawnObstacle()
{
    var obs = new FlxSprite();
    obs.loadGraphic(Paths.image("obstucalo"));

    obs.x = 3000;
    obs.y = FlxG.random.float(-450, -1000);

    obs.velocity.x = FlxG.random.float(-2500, -2000);

    obs.angle = FlxG.random.float(0, 360);
    obs.angularVelocity = FlxG.random.float(-60, 60);

    insert(members.indexOf(space), obs);

    obstacles.push(obs);
}

function create() {
    nick = new FlxSprite();
    nick.loadGraphic(Paths.image('logos/nick'));
    nick.scale.set(0.08, 0.08);
    nick.updateHitbox();
    nick.alpha = 0.8;
    nick.scrollFactor.set(0, 0);
    nick.cameras = [camHUD];

    nick.x = FlxG.width - nick.width - 30;
    nick.y = FlxG.height - nick.height - 30;

    add(nick);
}

function postCreate() {
    addExtraHitboxKey("SPACE");

    camGame.bgColor = FlxColor.BLACK;
    dadBaseY = dad.y;
    hasselhoffStartY = hasselhoff.y;
    bfStartY = boyfriend.y;

    obstucalo.x += 2000;

    seaLayers = [
        { sprites: [clouds1, clouds4, clouds7], width: 500000, speedFactor: 0 },
        { sprites: [clouds2, clouds5, clouds8], width: 500000, speedFactor: 0 },
        { sprites: [clouds3, clouds6, clouds9], width: 500000, speedFactor: 0 },
        { sprites: [krusty, patrickHouse, island, pineapple], width: 5000, speedFactor: 0.5 },
        { sprites: [sea0, sea4, sea8], width: 0, speedFactor: 0.4 },
        { sprites: [sea1, sea5, sea9], width: 0, speedFactor: 0.6 },
        { sprites: [sea2, sea6, sea10], width: 0, speedFactor: 0.8 },
        { sprites: [sea3, sea7, sea11], width: 0, speedFactor: 1.0 },
        { sprites: [atardecer_clouds1, atardecer_clouds4, atardecer_clouds7], width: 500000, speedFactor: 0 },
        { sprites: [atardecer_clouds2, atardecer_clouds5, atardecer_clouds8], width: 500000, speedFactor: 0 },
        { sprites: [atardecer_krusty, atardecer_patrickHouse, atardecer_island, atardecer_pineapple], width: 5000, speedFactor: 0.5 },
        { sprites: [atardecer_sea0, atardecer_sea4, atardecer_sea8], width: 0, speedFactor: 0.4 },
        { sprites: [atardecer_sea1, atardecer_sea5, atardecer_sea9], width: 0, speedFactor: 0.6 },
        { sprites: [atardecer_sea2, atardecer_sea6, atardecer_sea10], width: 0, speedFactor: 0.8 },
        { sprites: [atardecer_sea3, atardecer_sea7, atardecer_sea11], width: 0, speedFactor: 1.0 },
        { sprites: [noche_clouds1, noche_clouds4, noche_clouds7], width: 500000, speedFactor: 0 },
        { sprites: [noche_clouds2, noche_clouds5, noche_clouds8], width: 500000, speedFactor: 0 },
        { sprites: [noche_krusty, noche_patrickHouse, noche_island, noche_pineapple], width: 5000, speedFactor: 0.5 },
        { sprites: [noche_sea0, noche_sea4, noche_sea8], width: 0, speedFactor: 0.4 },
        { sprites: [noche_sea1, noche_sea5, noche_sea9], width: 0, speedFactor: 0.6 },
        { sprites: [noche_sea2, noche_sea6, noche_sea10], width: 0, speedFactor: 0.8 },
        { sprites: [noche_sea3, noche_sea7, noche_sea11], width: 0, speedFactor: 1.0 }
    ];

    for (layer in seaLayers) {
        layer.width = getWidth(layer.sprites[0]);
        for (i in 0...layer.sprites.length)
            layer.sprites[i].x = layer.sprites[0].x + layer.width * i;
    }

    ogStrumX = [];
        for (strum in playerStrums.members) {
            ogStrumX.push(strum.x);
        }

    sea0.alpha = 0;
    sea1.alpha = 0;
    sea2.alpha = 0;
    sea3.alpha = 0;
    sea4.alpha = 0;
    sea5.alpha = 0;
    sea6.alpha = 0;
    sea7.alpha = 0;
    sea8.alpha = 0;
    sea9.alpha = 0;
    sea10.alpha = 0;
    sea11.alpha = 0;
    clouds1.alpha = 0;
    clouds2.alpha = 0;
    clouds3.alpha = 0;
    clouds4.alpha = 0;
    clouds5.alpha = 0;
    clouds6.alpha = 0;
    clouds7.alpha = 0;
    clouds8.alpha = 0;
    clouds9.alpha = 0;

    patrickHouse.alpha = 0;
    island.alpha = 0;
    pineapple.alpha = 0;
    rock.alpha = 0;

    hasselhoff.alpha = 0;
    krusty.alpha = 0;
    healthBar.alpha = 0;
    healthBarBG.alpha = 0;
    iconP1.visible = false;
    iconP2.visible = false;
    warriorFloat = true;
    red.alpha = 0;
    fondo.alpha = 0;


    atardecer_sea0.alpha = 0;
    atardecer_sea1.alpha = 0;
    atardecer_sea2.alpha = 0;
    atardecer_sea3.alpha = 0;
    atardecer_sea4.alpha = 0;
    atardecer_sea5.alpha = 0;
    atardecer_sea6.alpha = 0;
    atardecer_sea7.alpha = 0;
    atardecer_sea8.alpha = 0;
    atardecer_sea9.alpha = 0;
    atardecer_sea10.alpha = 0;
    atardecer_sea11.alpha = 0;
    atardecer_clouds1.alpha = 0;
    atardecer_clouds2.alpha = 0;
    atardecer_clouds4.alpha = 0;
    atardecer_clouds5.alpha = 0;
    atardecer_clouds7.alpha = 0;
    atardecer_clouds8.alpha = 0;
    atardecer_patrickHouse.alpha = 0;
    atardecer_island.alpha = 0;
    atardecer_pineapple.alpha = 0;
    atardecer_krusty.alpha = 0;
    atardecer_fondo.alpha = 0;
    atardecer_sol.alpha = 0;


    noche_sea0.alpha = 0;
    noche_sea1.alpha = 0;
    noche_sea2.alpha = 0;
    noche_sea3.alpha = 0;
    noche_sea4.alpha = 0;
    noche_sea5.alpha = 0;
    noche_sea6.alpha = 0;
    noche_sea7.alpha = 0;
    noche_sea8.alpha = 0;
    noche_sea9.alpha = 0;
    noche_sea10.alpha = 0;
    noche_sea11.alpha = 0;
    noche_clouds1.alpha = 0;
    noche_clouds2.alpha = 0;
    noche_clouds4.alpha = 0;
    noche_clouds5.alpha = 0;
    noche_clouds7.alpha = 0;
    noche_clouds8.alpha = 0;
    noche_patrickHouse.alpha = 0;
    noche_island.alpha = 0;
    noche_pineapple.alpha = 0;
    noche_krusty.alpha = 0;
    noche_fondo.alpha = 0;


    horror_bob.alpha = 0;

    var padding = 200;
    for (data in minionImages)
    {
        var spr = new FlxSprite();
        spr.loadGraphic(Paths.image("minions/" + data.name));


        var placed = false;
        var attempts = 0;

        while (!placed && attempts < 100)
        {
            spr.x = FlxG.random.float(-3000, 1300);

            if (!data.goesUp)
                spr.y = FlxG.random.float(-9000, -2500);
            else
                spr.y = FlxG.random.float(-500, -200);

            if (data.name == "josejuan_dbtg")
            {
                spr.x = -3000;
                spr.y = -300;
            }
            

            placed = true;

            for (other in minions)
            {
                if (spr.x < other.spr.x + other.spr.width + padding &&
                    spr.x + spr.width + padding > other.spr.x &&
                    spr.y < other.spr.y + other.spr.height + padding &&
                    spr.y + spr.height + padding > other.spr.y)
                {
                    placed = false;
                    break;
                }
            }

            attempts++;
        }

        spr.velocity.set(0, 0);

        if (data.spin)
            spr.angularVelocity = FlxG.random.float(-360, 360);
        else
        {
            spr.angularVelocity = 0;
            spr.angle = 0;
        }

        insert(members.indexOf(sea2), spr);
        spr.alpha = 0;

        minions.push({spr: spr, data: data});
    }

    bgCanvas = new FunkinSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xFFFFFFFF);
    bgCanvas.scrollFactor.set(0, 0);
    bgShader = new CustomShader("livinglavidaloca2");
    bgShader.data.u_time.value = [0.0];
    bgCanvas.zoomFactor = 0;
    bgCanvas.shader = bgShader;

    blackOverlay = new FunkinScreenOverlay(FlxColor.BLACK);
    blackOverlay.alpha = 1;
    blackOverlay.cameras = [camHUD];
    add(blackOverlay);

    jumpOgY = space.y;
    space.y += 900;
    space.alpha = 0;
        
}

function update(elapsed) {
    bgShader.u_time += elapsed;

    if (phanesFloat){
    dadSineTime += elapsed * dadSineSpeed;

    dad.y = dadBaseY + Math.sin(dadSineTime) * dadSineAmount;
    }
    for (layer in seaLayers)
        moveLayer(layer, elapsed);

    hasselhoffSineTime += elapsed * hasselhoffSineSpeed;

    hasselhoff.y = hasselhoffStartY + Math.sin(hasselhoffSineTime) * hasselhoffSineAmmount;
    hasselhoff.angle = 0 + Math.cos(hasselhoffSineTime) * 2;

    horror_bob.y = hasselhoffStartY + Math.sin(hasselhoffSineTime) * hasselhoffSineAmmount - 160;
    horror_bob.angle = 0 + Math.cos(hasselhoffSineTime) * 2;

    if (warriorFloat)
        boyfriend.y = bfStartY + Math.sin(hasselhoffSineTime) * hasselhoffSineAmmount;


    if (obstacleSpawnActive)
    {
        obstacleSpawnTimer += elapsed;

        if (obstacleSpawnTimer >= 0.25) 
        {
            obstacleSpawnTimer = 0;
            spawnObstacle();
        }
    }

    for (obs in obstacles)
    {
        if (obs.x < -obs.width - 4000)
        {
            remove(obs);
            obs.destroy();
            obstacles.remove(obs);
        }
    }

    if (canjump == true && mobileSpaceJustPressed())
    {
        boyfriend.playAnim("jump", false);
    }

}

function moveLayer(layer, elapsed) {
    var w = layer.width;
    var n = layer.sprites.length;
    var speed = seaSpeed * layer.speedFactor;

    for (spr in layer.sprites)
        spr.x += speed * elapsed;

    for (i in 0...n) {
        var spr = layer.sprites[i];

        if (speed < 0) {
            if (spr.x + w < -w)
                spr.x += w * n;
        } else {
            if (spr.x > FlxG.width + w)
                spr.x -= w * n;
        }
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

function stepHit(curStep:Int) {
    switch (curStep) {
        case 5:
            FlxTween.tween(blackOverlay, { alpha: 0 }, 1.5, {
            onComplete: function(twn:FlxTween) {
                remove(blackOverlay);
                blackOverlay.destroy();
            }
        });
            obstacleSpawnActive = false;
        var center = FlxG.width / 2;
        tweenPlayerStrumlineCustom(center, [
            -300,
            -150,
            150,
            300
        ], 1, FlxEase.quadOut);

        case 198:
            healthBar.alpha = 0;
            healthBarBG.alpha = 0;

        case 456:
            FlxTween.tween(red, {alpha:1},1, {ease : FlxEase.expoIn});
        case 472:
            resetPlayerStrumline(0.03);
            sea0.alpha = 1;
            sea1.alpha = 1;
            sea2.alpha = 1;
            sea3.alpha = 1;
            sea4.alpha = 1;
            sea5.alpha = 1;
            sea6.alpha = 1;
            sea7.alpha = 1;
            sea8.alpha = 1;
            sea9.alpha = 1;
            sea10.alpha = 1;
            sea11.alpha = 1;
            clouds1.alpha = 1;
            clouds2.alpha = 1;
            clouds3.alpha = 1;
            clouds4.alpha = 1;
            clouds5.alpha = 1;
            clouds6.alpha = 1;
            clouds7.alpha = 1;
            clouds8.alpha = 1;
            clouds9.alpha = 1;
            patrickHouse.alpha = 1;
            island.alpha = 1;
            pineapple.alpha = 1;
            rock.alpha = 0;
            hasselhoff.alpha = 1;
            krusty.alpha = 1;
            healthBar.alpha = 1;
            healthBarBG.alpha = 1;
            iconP1.visible = true;
            iconP2.visible = true;
            red.alpha = 0;
            fondo.alpha = 1;
            phanesFloat = true;
            marco.alpha = 0;

        case 1112:
            for (m in minions)
            {
                m.spr.alpha = 1;
                if (!m.data.goesUp)
                    m.spr.velocity.y = FlxG.random.float(400, 500);
                else if (m.data.name == "josejuan_dbtg")
                    m.spr.velocity.y = 0;
                else
                    m.spr.velocity.y = FlxG.random.float(-40, -100);

                if (m.data.name == "usa")
                    m.spr.velocity.x = FlxG.random.float(-50, -100);
                else if (m.data.name == "lover_kevin")
                    m.spr.velocity.x = FlxG.random.float(50, 100);
                else if (m.data.name == "josejuan_dbtg")
                    m.spr.velocity.x = 200;
                else
                    m.spr.velocity.x = FlxG.random.float(-50, 50);
            }

        case 1376:
        FlxTween.tween(space, {y: jumpOgY}, 2, {ease: FlxEase.quadInOut});
        FlxTween.tween(space, {alpha: 1}, 2, {ease: FlxEase.quadInOut});
        boyfriend.cameraOffset.x += 600;

        obstacleSpawnActive = true;

        case 1504:
            canjump = false;
            FlxTween.tween(space,
            {
                y: space.y + 150, 
                angle: 15         
            },
            4,
            {
                ease: FlxEase.quadOut
            });

        case 1552:
            FlxTween.tween(space, {alpha: 0}, 6, {ease: FlxEase.quadInOut});

        case 1624:
            FlxTween.tween(obstucalo, {x: obstucalo - 2000}, 0.8, {ease: FlxEase.linear});

        case 1632:
            obstucalo.alpha = 0;
            obstacleSpawnActive = false;
            sea0.alpha = 0;
            sea1.alpha = 0;
            sea2.alpha = 0;
            sea3.alpha = 0;
            sea4.alpha = 0;
            sea5.alpha = 0;
            sea6.alpha = 0;
            sea7.alpha = 0;
            sea8.alpha = 0;
            sea9.alpha = 0;
            sea10.alpha = 0;
            sea11.alpha = 0;
            clouds1.alpha = 0;
            clouds2.alpha = 0;
            clouds3.alpha = 0;
            clouds4.alpha = 0;
            clouds5.alpha = 0;
            clouds6.alpha = 0;
            clouds7.alpha = 0;
            clouds8.alpha = 0;
            clouds9.alpha = 0;
            patrickHouse.alpha = 0;
            island.alpha = 0;
            pineapple.alpha = 0;
            rock.alpha = 0;
            hasselhoff.alpha = 0;
            krusty.alpha = 0;
            healthBar.alpha = 0;
            healthBarBG.alpha = 0;
            red.alpha = 0;
            fondo.alpha = 0;
            phanesFloat = false;
            warriorFloat = false;
            iconP1.visible = false;
            iconP2.visible = false;

        case 2252:
            iconP1.visible = true;
            iconP2.visible = true;
            parrila2.alpha = 1;
            parrila1.alpha = 1;
            players_1.alpha = 1;
            players_2.alpha = 1;
            players_3.alpha = 1;
            insert(members.indexOf(parrila2) -1, bgCanvas);

        case 2456:
            parrila2.alpha = 0;
            parrila1.alpha = 0;
            players_1.alpha = 0;
            players_2.alpha = 0;
            players_3.alpha = 0;

            look_phanes.alpha = 1;
            look_phanes_eyes.alpha = 1;
            look_warrior.alpha = 1;
            remove(bgCanvas);

        case 2670:
            look_phanes.alpha = 0;
            look_phanes_eyes.alpha = 0;
            look_warrior.alpha = 0;
            
            healthBar.alpha = 1;
            healthBarBG.alpha = 1;
            iconP1.visible = true;
            iconP2.visible = true;
            phanesFloat = true;
            warriorFloat = true;

            atardecer_sea0.alpha = 1;
            atardecer_sea1.alpha = 1;
            atardecer_sea2.alpha = 1;
            atardecer_sea3.alpha = 1;
            atardecer_sea4.alpha = 1;
            atardecer_sea5.alpha = 1;
            atardecer_sea6.alpha = 1;
            atardecer_sea7.alpha = 1;
            atardecer_sea8.alpha = 1;
            atardecer_sea9.alpha = 1;
            atardecer_sea10.alpha = 1;
            atardecer_sea11.alpha = 1;
            atardecer_clouds1.alpha = 1;
            atardecer_clouds2.alpha = 1;
            atardecer_clouds4.alpha = 1;
            atardecer_clouds5.alpha = 1;
            atardecer_clouds7.alpha = 1;
            atardecer_clouds8.alpha = 1;
            atardecer_patrickHouse.alpha = 1;
            atardecer_island.alpha = 1;
            atardecer_pineapple.alpha = 1;
            atardecer_krusty.alpha = 1;
            atardecer_fondo.alpha = 1;
            atardecer_sol.alpha = 1;
            FlxTween.tween(atardecer_sol, {y: atardecer_sol + 300}, 120, {ease: FlxEase.linear});
            horror_bob.alpha = 1;

        case 3180:
            atardecer_sea0.alpha = 0;
            atardecer_sea1.alpha = 0;
            atardecer_sea2.alpha = 0;
            atardecer_sea3.alpha = 0;
            atardecer_sea4.alpha = 0;
            atardecer_sea5.alpha = 0;
            atardecer_sea6.alpha = 0;
            atardecer_sea7.alpha = 0;
            atardecer_sea8.alpha = 0;
            atardecer_sea9.alpha = 0;
            atardecer_sea10.alpha = 0;
            atardecer_sea11.alpha = 0;
            atardecer_clouds1.alpha = 0;
            atardecer_clouds2.alpha = 0;
            atardecer_clouds4.alpha = 0;
            atardecer_clouds5.alpha = 0;
            atardecer_clouds7.alpha = 0;
            atardecer_clouds8.alpha = 0;
            atardecer_patrickHouse.alpha = 0;
            atardecer_island.alpha = 0;
            atardecer_pineapple.alpha = 0;
            atardecer_krusty.alpha = 0;
            atardecer_fondo.alpha = 0;
            atardecer_sol.alpha = 0;
            camGame.bgColor = FlxColor.WHITE;

            noche_sea0.alpha = 1;
            noche_sea1.alpha = 1;
            noche_sea2.alpha = 1;
            noche_sea3.alpha = 1;
            noche_sea4.alpha = 1;
            noche_sea5.alpha = 1;
            noche_sea6.alpha = 1;
            noche_sea7.alpha = 1;
            noche_sea8.alpha = 1;
            noche_sea9.alpha = 1;
            noche_sea10.alpha = 1;
            noche_sea11.alpha = 1;
            noche_clouds1.alpha = 1;
            noche_clouds2.alpha = 1;
            noche_clouds4.alpha = 1;
            noche_clouds5.alpha = 1;
            noche_clouds7.alpha = 1;
            noche_clouds8.alpha = 1;
            noche_patrickHouse.alpha = 1;
            noche_island.alpha = 1;
            noche_pineapple.alpha = 1;
            noche_krusty.alpha = 1;
            noche_fondo.alpha = 1;
            obstacleSpawnActive = true;
            FlxTween.tween(horror_bob, {alpha: 0}, 2, {
                ease: FlxEase.linear
            });

        case 3248:
            FlxTween.tween(noche_patrickHouse, {alpha: 0}, 2, {
                ease: FlxEase.linear
            });

            FlxTween.tween(noche_island, {alpha: 0}, 2, {
                ease: FlxEase.linear
            });

            FlxTween.tween(noche_pineapple, {alpha: 0}, 2, {
                ease: FlxEase.linear
            });

            FlxTween.tween(noche_krusty, {alpha: 0}, 2, {
                ease: FlxEase.linear
            });

        case 3264:
            FlxTween.tween(noche_clouds8, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_clouds7, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_clouds5, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_clouds4, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_clouds2, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_clouds1, {alpha: 0}, 2, {ease: FlxEase.linear});

        case 3311:
            FlxTween.tween(noche_fondo, {alpha: 0}, 5, {ease: FlxEase.linear});

        case 3436:
            FlxTween.tween(noche_sea11, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea10, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea9, {alpha: 0}, 2, {ease: FlxEase.linear});

        case 3488:
            FlxTween.tween(noche_sea8, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea7, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea6, {alpha: 0}, 2, {ease: FlxEase.linear});

        case 3504:
            FlxTween.tween(noche_sea5, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea4, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea3, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea2, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea1, {alpha: 0}, 2, {ease: FlxEase.linear});
            FlxTween.tween(noche_sea0, {alpha: 0}, 2, {ease: FlxEase.linear});
            obstacleSpawnActive = false;

        case 3536:
            phanesFloat = false;
            warriorFloat = false;

        case 3557:
            FlxTween.tween(boyfriend, {x: boyfriend.x + 600}, 1, {ease: FlxEase.linear});

        case 3548:
            FlxTween.tween(healthBar, {alpha: 0}, 0.5, {ease: FlxEase.linear});
            FlxTween.tween(healthBarBG, {alpha: 0}, 0.5, {ease: FlxEase.linear});
            FlxTween.tween(iconP1, {alpha: 0}, 0.5, {ease: FlxEase.linear});
            FlxTween.tween(iconP2, {alpha: 0}, 0.5, {ease: FlxEase.linear});

        case 3557:
            FlxTween.tween(iconP2, {alpha: 0}, 1, {ease: FlxEase.linear});

        case 3566:
            healthBar.alpha = 0;
            healthBarBG.alpha = 0;
            
            iconP1.visible = false;
            iconP2.visible = false;

        case 3584:
            boyfriend.y = -270;
            boyfriend.x -= 600;
            dad.y = -270;

        case 3824:
            papeles.alpha = 1;

        case 4080:
            dad.cameraOffset.y -= 1400;
        case 4128:
            camGame.bgColor = FlxColor.BLACK;
            FlxG.switchState(new ModState("AfterCorreCorre"));


    }
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

function resetStrumXByID(id:Int, duration:Float = 0.2) {
    if (ogStrumX[id] == null) return;

    tweenStrumByID(id, ogStrumX[id], -1, duration);
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
