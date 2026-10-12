function onCreate()
    makeLuaSprite('shitnoJumpscare', 'jumpscares/Shitno', 0, 0)
    setObjectCamera('shitnoJumpscare', 'other')
    setProperty('shitnoJumpscare.alpha', 0.0001)
    addLuaSprite('shitnoJumpscare')

    makeLuaSprite('pincushionController', '', 0, 0)
    makeLuaSprite('chromaticController', '', 0, 0)
    setProperty('pincushionController.alpha', 0)
    setProperty('chromaticController.alpha', 0)

    doTheShaders()
end

function doTheShaders()
    runHaxeCode([[
        game.initLuaShader('pincushion');
        game.initLuaShader('custom/chromaticAberration');
        
        var pincushionShader = game.createRuntimeShader('pincushion');
        var chromaticShader = game.createRuntimeShader('custom/chromaticAberration');

        game.getLuaObject('pincushionController').shader = pincushionShader;
        game.getLuaObject('chromaticController').shader = chromaticShader;

        game.camOther.setFilters([
            new ShaderFilter(pincushionShader),
            new ShaderFilter(chromaticShader),
        ]);
        game.camGame.setFilters([
            new ShaderFilter(pincushionShader),
            new ShaderFilter(chromaticShader),
        ]);
    ]])
end

local function updateShaders()
    setShaderFloat('chromaticController', 'amount', getProperty('chromaticController.x'))
    setShaderFloat('pincushionController', 'distort', getProperty('pincushionController.x'))
end

function onUpdate(elapsed)
    updateShaders()
end

function onCreatePost()
    if playsAsBF() then
        for i = 0,getProperty('opponentStrums.length') - 1 do
            setPropertyFromGroup('opponentStrums', i, 'x', -5000);
        end
    end
    setProperty('iconP2.alpha', 0.0001);
    setProperty('dadGroup.alpha', 0.0001);
end

function onEvent(name, value1, value2)
    local eventActions = {
        ['Grey Turn Around'] = function()
            triggerEvent('Change Character', 'bf', 'grey')
            triggerEvent('Play Animation', 'turn', 'bf')
            runTimer('bfSlide', 0.86)
        end,
        ['Shitno Laugh'] = function()
            setProperty('dadGroup.alpha', getProperty('dadGroup.alpha') + 0.15)
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
        ['Chromatic Riser'] = function()
            setProperty('chromaticController.x', 20)
            setProperty('pincushionController.x', 0.15)
            doTweenX('chromDown', 'chromaticController', 0, 1, 'cubeIn')
            doTweenX('pincDown', 'pincushionController', 0, 1, 'cubeIn')
        end
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

function onGameOver()
    openCustomSubstate('gameover', true)
    return Function_Stop
end

function onCustomSubstateCreate(name)
    if name == 'gameover' then
        setProperty('camGame.visible', false)
        setProperty('camHUD.visible', false)

        doTheShaders()

        insertToCustomSubstate('shitnoJumpscare')
        insertToCustomSubstate('pincushionController')
        insertToCustomSubstate('chromaticController')
        runTimer('jumpscare', 2)
    end
end

function onCustomSubstateUpdate(name, elapsed)
    if name == 'gameover' then
        updateShaders()
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'jumpscare' then
        setProperty('shitnoJumpscare.alpha', 1)
        cameraShake('other', 0.015, 5)
        playSound('Shitno-Death')
        runTimer('disappear1', 1.1)
        runTimer('gameoverRestart', 1.8)
    end
    if tag == 'disappear1' then
        setProperty('shitnoJumpscare.visible', false)
        runTimer('reappear1', 0.2)
    end
    if tag == 'reappear1' then
        setProperty('chromaticController.x', 10)
        setProperty('pincushionController.x', 0.4)
        setProperty('shitnoJumpscare.visible', true)
        runTimer('disappear2', 0.2)
    end
    if tag == 'disappear2' then
        setProperty('shitnoJumpscare.visible', false)
        runTimer('reappear2', 0.2)
    end
    if tag == 'reappear2' then
        setProperty('chromaticController.x', 20)
        setProperty('pincushionController.x', 1)
        setProperty('shitnoJumpscare.visible', true)
    end
    if tag == 'gameoverRestart' then
        removeLuaSprite('shitnoJumpscare')
        restartSong()
    end
end