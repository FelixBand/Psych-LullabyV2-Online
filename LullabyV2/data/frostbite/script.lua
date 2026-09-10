local painSplitChance = 0.1;
local painSplitCooldown = 30;
local inCutscene = false;
local snowAmount = 150;
local snowIntensity = 0.2;
local chromaticAmount = 0;
local coldness = 0;
local coldnessRate = 0;
local warmingCharges = 10;
local warmingCooldown = false;
local frostbiteActive = false;
local frostbiteEnded = false;
local typhlosionDead = false;

function onCreate()
    makeLuaSprite('thermometerBarBG', '', 45, 185);
    makeGraphic('thermometerBarBG', 15, 325, '133551');
    setObjectCamera('thermometerBarBG', 'hud');
    addLuaSprite('thermometerBarBG');

    makeLuaSprite('thermometerBar', '', 45, 185);
    makeGraphic('thermometerBar', 15, 325, 'AAD6FF');
    setObjectCamera('thermometerBar', 'hud');
    addLuaSprite('thermometerBar');
    setProperty('thermometerBar.visible', false);

    makeAnimatedLuaSprite('thermometer', 'UI/base/Thermometer', 10, 170);
    setObjectCamera('thermometer', 'hud');
    addAnimationByPrefix('thermometer', 'stage1', 'Therm1', 24, false);
    addAnimationByPrefix('thermometer', 'stage2', 'Therm2', 24, false);
    addAnimationByPrefix('thermometer', 'stage3', 'Therm3', 24, false);
    addLuaSprite('thermometer', true);

    makeAnimatedLuaSprite('typhlosionThermometer', 'UI/base/TyphlosionVit', 15, 116);
    addAnimationByPrefix('typhlosionThermometer', '-10', 'Typh1 instance ', 24, true);
    addAnimationByPrefix('typhlosionThermometer', '-8', 'Typh2 instance ', 24, true);
    addAnimationByPrefix('typhlosionThermometer', '-6', 'Typh3 instance ', 24, true);
    addAnimationByPrefix('typhlosionThermometer', '-4', 'Typh4 instance ', 24, true);
    addAnimationByPrefix('typhlosionThermometer', '-2', 'Typh5 instance ', 24, true);
    addAnimationByPrefix('typhlosionThermometer', '-0', 'Typh5 instance ', 24, true);
    setObjectCamera('typhlosionThermometer', 'hud');
    addLuaSprite('typhlosionThermometer');
    setObjectOrder('typhlosionThermometer', getObjectOrder('thermometer') - 1);
    playAnim('typhlosionThermometer', '-10', true);

    makeAnimatedLuaSprite('frostbiteGuide', 'UI/base/hypno/Extras', 0, 0);
    addAnimationByPrefix('frostbiteGuide', 'idle', 'Spacebar', 24, true);
    setObjectCamera('frostbiteGuide', 'hud');
    addLuaSprite('frostbiteGuide', true);
    screenCenter('frostbiteGuide', 'xy');
    setProperty('frostbiteGuide.alpha', 0.0001);

    makeLuaSprite('freakachuJumpscare', 'jumpscares/Pikachu', 0, 0);
    setObjectCamera('freakachuJumpscare', 'other');
    scaleObject('freakachuJumpscare', 0.325, 0.325);

    makeAnimatedLuaSprite('typhlosion', 'characters/gold/TYPHLOSION_MECHANIC', 150, 990);
    addAnimationByPrefix('typhlosion', 'idle', 'TYPHLOSION MECHANIC', 24, false);
    addAnimationByPrefix('typhlosion', 'fire', 'TYPHLOSION ROAR', 24, false);
    addLuaSprite('typhlosion', true);

    makeAnimatedLuaSprite('freakachu', 'characters/red/Freakachu', 698, 818);
    scaleObject('freakachu', 1.3, 1.3);
    addAnimationByPrefix('freakachu', 'idle', 'Freakachu IDLE', 24, false);
    addAnimationByPrefix('freakachu', 'painsplit', 'Freakachu PAIN SPLIT', 24, false);
    playAnim('freakachu', 'idle', true);
    setProperty('freakachu.alpha', 0.0001);
    addLuaSprite('freakachu');

    makeAnimatedLuaSprite('summonFreak', 'characters/red/freakachu_entrance', getProperty('dad.x') - 275, getProperty('dad.y') + 105);
    addAnimationByPrefix('summonFreak', 'summon', 'Freakachu entrance instance 1', 24, false);
    scaleObject('summonFreak', 0.89, 0.89);
    setProperty('summonFreak.alpha', 0.0001);
    addLuaSprite('summonFreak', true);

    setPropertyFromClass('GameOverSubstate', 'characterName', 'retry');
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx');
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'MtSilverLoop');
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'MtSilverEnd');
    setProperty('skipCountdown', true);

    if shadersEnabled then
        makeLuaSprite('pincushionController');
        makeLuaSprite('chromaticController', '', chromaticAmount);
        makeLuaSprite('snowfallController', '', snowAmount, snowIntensity);
    end

    -- healthbar flipping
	setProperty('healthBar.flipX', true)
end

function onBeatHit()
    if curBeat % 2 == 0 and getProperty('typhlosion.animation.curAnim.finished') == true then
        playAnim('typhlosion', 'idle', true);
    end
    if curBeat % 2 == 0 then
        if not inCutscene and getProperty('freakachu.animation.curAnim.name') == 'painsplit' and getProperty('freakachu.animation.curAnim.finished') or getProperty('freakachu.animation.curAnim.name') == 'idle' then
            playAnim('freakachu', 'idle', true);
        end
    end
    if curBeat > 175 then
        painSplitChance = painSplitChance + 0.1;
        painSplitCooldown = painSplitCooldown - 1;
    end
    if curBeat > 175 and not inCutscene and painSplitCooldown <= 0 and getProperty('health') >= 1.25 and getRandomInt(1,2) == 1 then
        painSplitChance = 0.5;
        painSplitCooldown = 30;

        playAnim('freakachu', 'painsplit', true);
        runTimer('painsplit', 0.46);
    end
end

function onCreatePost()
    removeLuaScript('scripts/camFollow');

    if shadersEnabled then
        runHaxeCode([[
            game.initLuaShader('custom/pincushion');
            game.initLuaShader('custom/chromaticAberration');
            game.initLuaShader('snowfall');

            var pincushionShader = game.createRuntimeShader('custom/pincushion');
            var chromaticShader = game.createRuntimeShader('custom/chromaticAberration');
            var snowfallShader = game.createRuntimeShader('snowfall');

            game.getLuaObject('pincushionController').shader = pincushionShader;
            game.getLuaObject('chromaticController').shader = chromaticShader;
            game.getLuaObject('snowfallController').shader = snowfallShader;

            game.camGame.setFilters([
                new ShaderFilter(pincushionShader),
                new ShaderFilter(chromaticShader),
                new ShaderFilter(snowfallShader)
            ]);
            game.camHUD.setFilters([
                new ShaderFilter(pincushionShader),
                new ShaderFilter(chromaticShader)
            ]);
            game.camOther.setFilters([new ShaderFilter(chromaticShader)]);
        ]]);
    end
end

local xx2 = 700;
local yy2 = 820;
local ofs = 20;
local followchars = true;

local timeValue = nil;
function onUpdate(elapsed)
    if followchars == true then -- camfollow script
        if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
            triggerEvent('Camera Follow Pos',xx2-ofs,yy2);
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
            triggerEvent('Camera Follow Pos',xx2+ofs,yy2);
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
            triggerEvent('Camera Follow Pos',xx2,yy2-ofs);
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
            triggerEvent('Camera Follow Pos',xx2,yy2+ofs);
	    else
            triggerEvent('Camera Follow Pos',xx2,yy2);
        end
    end

    if shadersEnabled then
        timeValue = getSongPosition() / (stepCrochet * 8);
        chromaticAmount = getProperty('chromaticController.x');
        setShaderFloat('pincushionController', 'distort', chromaticAmount / 3);
        setShaderFloat('chromaticController', 'amount', chromaticAmount * 10);
        setShaderFloat('snowfallController', 'time', timeValue);
        setShaderFloat('snowfallController', 'intensity', getProperty('snowfallController.y'));
        setShaderInt('snowfallController', 'amount', getProperty('snowfallController.x'));
    end

    if frostbiteActive and not frostbiteEnded then
        if keyJustPressed('space') and warmingCharges > 0 and not warmingCooldown then
            warmUp();
            doTweenAlpha('hideFrostbiteGuide', 'frostbiteGuide', 0.0001, 0.5, 'cubeInOut');
        end
        if getHealth() <= 0 then
            frostbiteEnded = true;
        end
        if not frostbiteEnded and not inCutscene and getProperty('camHUD.alpha') == 1 then
            addHealth(-((coldness / 100) * 0.0025) * (elapsed * 120));
        end
        setGraphicSize('thermometerBar', 15, 325 * (coldness / 100));
        setProperty('thermometerBar.y', 185 + 325 - getProperty('thermometerBar.height'));
        setProperty('thermometerBar.visible', coldness > 0);
        if coldness < 33 then
            playAnim('thermometer', 'stage1', true);
        elseif coldness < 66 then
            playAnim('thermometer', 'stage2', true);
        else
            playAnim('thermometer', 'stage3', true);
        end
        if coldness > 35 and getProperty('frostbiteGuide.alpha') <= 0.0001 then
            doTweenAlpha('showFrostbiteGuide', 'frostbiteGuide', 1, 0.5, 'cubeInOut');
        end
        if coldness >= 100 then
            setHealth(-1);
        end
    end

    --setProperty('thermometerBar.scale.y', getSongPosition() / 20000);
end

function onUpdatePost()
    setProperty('iconP1.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') *        getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26) - 110)
    setProperty('iconP1.origin.x',240)
    setProperty('iconP1.flipX',true)
    setProperty('iconP2.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2) + 110)
    setProperty('iconP2.origin.x',-100)
    setProperty('iconP2.flipX',true)
end

local time = 1.5;
local intensity = 0.75;

function onEvent(name, value1, value2)
    if name == 'Start Freeze' or name == 'StartFreeze' then
        if playsAsBF() then
            frostbiteActive = true;
            frostbiteEnded = false;
            coldnessRate = 0.01;
        end
    elseif name == 'Frostbite End' or name == 'End_Frostbite' then
        frostbiteEnded = true;
        frostbiteActive = false;
        coldness = 0;
        coldnessRate = 0;
        warmingCharges = -1;
        setProperty('thermometerBar.visible', false);
        if shadersEnabled then
            setProperty('snowfallController.x', 0);
            setProperty('snowfallController.y', 0);
            runHaxeCode([[
                game.camGame.setFilters([
                    new ShaderFilter(game.getLuaObject('pincushionController').shader),
                    new ShaderFilter(game.getLuaObject('chromaticController').shader)
                ]);
            ]]);
        end
    elseif name == 'Chromatic Riser' or name == 'Chomatic Riser' then
        local target = tonumber(value1) or 0;
        local steps = tonumber(value2) or 0;
        doTweenX('chromaticRiser', 'chromaticController', target, (steps * stepCrochet) / 1000, 'cubeIn');
    elseif name == 'SnowFall_amount' then
        local target = tonumber(value1) or snowAmount;
        local steps = tonumber(value2) or 0;
        if value2 == '' then
            setProperty('snowfallController.x', target);
        else
            doTweenX('snowfallAmount', 'snowfallController', target, (steps * stepCrochet) / 1000, 'linear');
        end
    elseif name == 'SnowFall_intensity' then
        local target = tonumber(value1) or snowIntensity;
        local steps = tonumber(value2) or 0;
        if value2 == '' then
            setProperty('snowfallController.y', target);
        else
            doTweenY('snowfallIntensity', 'snowfallController', target, (steps * stepCrochet) / 1000, 'linear');
        end
    end
    if name == 'Hide Fog' then
        doTweenAlpha('fogHide', 'introFog', 0, 5, 'quadIn');
    end
    if name == 'Typhlosion Cry' then
        playAnim('typhlosion', 'fire', true);
    end
    if name == 'Freakachu Summon' then
        setProperty('summonFreak.alpha', 1);
        playAnim('summonFreak', 'summon', true);
        setProperty('dad.visible', false);
        followchars = false;
        setProperty('camZooming', false);
        doTweenZoom('camIn', 'camGame', 1.6, 0.6, 'quadOut');
        triggerEvent('Camera Follow Pos', '750', '850');
        runTimer('freak', 0.86);
    end
    if name == 'Change Character' then
        followchars = true;
        setProperty('freakachu.alpha', 1);
        playAnim('freakachu', 'idle', true);
        removeLuaSprite('summonFreak', true);
        playAnim('iconOpponent', 'dying', true);
    end
    if name == 'Frostbite End' then
        inCutscene = true;
        setProperty('boyfriend.stunned', true);
        setProperty('camGame.alpha', 0);
        setProperty('camHUD.alpha', 0);
        runHaxeCode([[
            FlxG.sound.music.volume = 0;
		    vocals.volume = 0;
        ]]);
        if shadersEnabled then
            setProperty('chromaticController.x', 20);
        end
        playSound('Frostbite_ending');
        runTimer('jumpscare', 10.12);
        runTimer('jumpscareEnd', 13.2);
        runTimer('endsong', 13.540);
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'warmingCooldown' then
        warmingCooldown = false;
    end
    if tag == 'freak' then
        doTweenZoom('camIn2', 'camGame', 1.9, 0.2, 'quadOut');
        triggerEvent('Screen Shake', '0.8, 0.001', '');
        triggerEvent('Camera Follow Pos', '775', '870');
    end
    if tag == 'painsplit' then
        playSound('Frostbite_bite', 1);
        triggerEvent('Play Animation', 'singDOWNmiss', 'bf');
        setProperty('health', getProperty('health') - (0.2 + (getProperty('health') / 2.856)));
    end
    if tag == 'jumpscare' then
        addLuaSprite('freakachuJumpscare');
        if shadersEnabled then
            triggerEvent('Chromatic Riser', '50', '0');
            triggerEvent('Chromatic Riser', '0', tostring(500 / stepCrochet));
        end
        cameraShake('other', 0.008, 3.08);
    end
    if tag == 'jumpscareEnd' then
        removeLuaSprite('freakachuJumpscare', true);
    end
    if tag == 'endsong' then
        inCutscene = false;
        endSong();
    end
end

function onStepHit()
    if frostbiteActive and not frostbiteEnded and curStep % 4 == 0 then
        coldness = math.min(100, coldness + coldnessRate * 100);
    end
    if curStep == 695 then
        setProperty('dad.visible', true);
    end
end

function onGameOver()
    if curStep > 1374 then
        return Function_Stop;
    end 
end

function onPause()
    if curStep > 1374 then
        return Function_Stop;
    end
end

function onEndSong()
    if inCutscene then
        return Function_Stop;
    end
    return Function_Continue;
end

function warmUp()
    warmingCharges = warmingCharges - 1;
    warmingCooldown = true;
    playSound('TyphlosionUse', 0.5);
    playAnim('typhlosion', 'fire', true);
    coldness = math.max(0, coldness - (20 + (warmingCharges * 0.075 * 35)));
    local chargeFrame = math.max(0, math.floor(warmingCharges / 2) * 2);
    playAnim('typhlosionThermometer', '-'..chargeFrame, true);
    if warmingCharges == 0 and not typhlosionDead then
        typhlosionDead = true;
        playSound('TyphlosionDeath', 1);
        playAnim('typhlosion', 'fire', true);
        doTweenY('typhlosionDeath', 'typhlosion', getProperty('typhlosion.y') + 500, 1.5, 'quadInOut');
    end
    runTimer('warmingCooldown', 1, 1);
end