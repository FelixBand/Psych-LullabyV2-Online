local playedNoise = false;
function onStartCountdown()
    if not playedNoise then
        playSound('ImDead' .. getRandomInt(1,7), 1);
        runTimer('startsong', 3.5);
        playedNoise = true;
        return Function_Stop;
    end
    return Function_Continue;
end

function onTimerCompleted(tag)
    if tag == 'startsong' then
        startCountdown()
        setProperty('dad.visible', true);
        characterPlayAnim('dad', 'fadeIn', true);
        if playsAsBF() then
            for i = 0,getProperty('opponentStrums.length') - 1 do
                setPropertyFromGroup('opponentStrums', i, 'x', -5000);
            end
        end
    end
end

function onCreate()
    setProperty('skipCountdown', true);
    setProperty('dad.visible', false);

    addCharacterToList('gold-headless', 'dad');

    makeAnimatedLuaSprite('no more', 'characters/gold/GOLD_NO_MORE', getProperty('dad.x') - 64, getProperty('dad.y') - 111);
    addAnimationByPrefix('no more', 'idle', 'No More instance 1', 24, false);
    setProperty('no more.alpha', 0);
    scaleObject('no more', 1.3, 1.3);
    addLuaSprite('no more');

    makeAnimatedLuaSprite('headrip', 'characters/gold/GOLD_HEAD_RIPPING_OFF', getProperty('dad.x') - 151, getProperty('dad.y') - 251);
    addAnimationByPrefix('headrip', 'idle', 'Head rips_OneLayer instance 1', 24, false);
    setProperty('headrip.alpha', 0);
    scaleObject('headrip', 1.3, 1.3);
    addLuaSprite('headrip');
end

function onCreatePost()
    setProperty('boyfriend.visible', false);
    setProperty('gfGroup.visible', false);
    setProperty('camHUD.alpha', 0.0001);

    triggerEvent('Camera Follow Pos', '300', '370');
    removeLuaScript('scripts/camFollow');
end

function onStepHit()
    if curStep == 1605 then
        setProperty('dad.visible', false);
        setProperty('no more.alpha', 1);
        objectPlayAnimation('no more', 'idle', true);
    elseif curStep == 1632 then
        removeLuaSprite('no more', true);
        setProperty('headrip.alpha', 1);
        objectPlayAnimation('headrip', 'idle', true);
    elseif curStep == 1664 then
        removeLuaSprite('headrip', true);
        triggerEvent('Change Character', 'dad', 'gold-headless');
        setProperty('dad.visible', true);
        setProperty('defaultCamZoom', 0.7);
    end
end

--camfollow stuff
local off = {20, 20}; -- x and y movement force
local opponentNotes = false;
local bfNotes = true; -- change this to false if you want to trigger when player notes
local xy = {{-off[1], 0}, {0, off[2]}, {0, -off[2]}, {off[1], 0}}; -- table which has the applied movement force

function goodNoteHit(i, d, n, s)
    if bfNotes and mustHitSection then
		resetCam(d);
	end
end

function opponentNoteHit(i, d, n, s)
    if opponentNotes and not mustHitSection then
		resetCam(d);
	end
end

function resetCam(d)
    runHaxeCode('game.moveCameraSection();');
    setProperty('camFollow.x', 300 + xy[d+1][1]);
    setProperty('camFollow.y', 370 + xy[d+1][2]);
end