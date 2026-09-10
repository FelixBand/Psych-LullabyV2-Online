function onCreate()
    setProperty('skipCountdown', true);
    setProperty('camGame.alpha', 0.0001);
    setProperty('camHUD.alpha', 0.0001);
    setProperty('cameraSpeed', 100);

    makeLuaSprite('ground', 'stages/shitno/images/floor', 745, 1075);
    scaleObject('ground', 0.9, 0.9);
    setScrollFactor('ground', 0.95, 0.95);
    setProperty('ground.alpha', 0.0001);
    addLuaSprite('ground');
end

function onCreatePost()
    if playsAsBF() then
        for i = 0,getProperty('opponentStrums.length') - 1 do
            setPropertyFromGroup('opponentStrums', i, 'x', -5000);
        end
    end
    setProperty('iconP2.alpha', 0.0001);
    setProperty('dad.alpha', 0.0001);
end

function onEvent(name, value1, value2)
    local eventActions = {
        ['Grey Turn Around'] = function()
            triggerEvent('Change Character', 'bf', 'grey')
            triggerEvent('Play Animation', 'turn', 'bf')
            runTimer('bfSlide', 0.86)
        end,
        ['Shitno Laugh'] = function()
            setProperty('dad.alpha', getProperty('dad.alpha') + 0.15)
            setProperty('ground.alpha', getProperty('ground.alpha') + 0.15)
            setProperty('iconP2.alpha', 1)
        end,
        ['Fade In Intro'] = function()
            setProperty('cameraSpeed', 1)
            doTweenAlpha('camGameIn', 'camGame', 1, 2.5, 'quadInOut')
            doTweenZoom('zoomOut', 'camGame', 1, 5, 'quadInOut')
        end,
        ['Shitno End'] = function()
            doTweenAlpha('camGameOut', 'camGame', 0, 2.5, 'linear')
        end,
    }

    if eventActions[name] then
        eventActions[name]()
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'bfSlide' then
        doTweenX('bfSlide', 'boyfriendGroup', getProperty('boyfriend.x') + 350, 1.2, 'quadInOut');
    end
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('defaultCamZoom', 1);
	elseif focus == 'dad' then
		setProperty('defaultCamZoom', 1.1);
	end
end