local dir = 'stages/disabled/images/'

function onCreate()
    setProperty('skipCountdown', true)

    makeAnimatedLuaSprite('static', dir .. 'static', -3, -3)
    addAnimationByPrefix('static', 'idle', 'static', 8, true)
    scaleObject('static', 1.35, 1.35)
    setObjectCamera('static', 'other')
    setProperty('static.alpha', 0.0001)
    addLuaSprite('static')

    makeAnimatedLuaSprite('redStatic', dir .. 'static-overlay', -3, -3)
    addAnimationByPrefix('redStatic', 'idle', 'static-overlay', 8, true)
    scaleObject('redStatic', 1.35, 1.35)
    setObjectCamera('redStatic', 'other')
    setProperty('redStatic.alpha', 0.0001)
    addLuaSprite('redStatic')

    makeLuaSprite('background', dir .. 'background', 0, 200)
    scaleObject('background', 1.5, 1.5)
    setScrollFactor('background', 0.125, 0.5)
    addLuaSprite('background')

    precacheImage(dir .. 'background2')

    makeLuaSprite('plateL', dir .. 'Purple_place', 500, 1240)
    scaleObject('plateL', 0.75, 0.75)
    addLuaSprite('plateL')

    makeLuaSprite('plateR', dir .. 'Purple_place', 1090, 1040)
    scaleObject('plateR', 0.5, 0.5)
    addLuaSprite('plateR')

    makeLuaSprite('white', '', 460, 750)
    makeGraphic('white', 1280, 720, 'FFFFFF')
    setObjectCamera('white', 'game')
    addLuaSprite('white')
    
    makeLuaSprite('black', '', 460, 750)
    makeGraphic('black', 1280, 720, '000000')
    setObjectCamera('black', 'game')
    addLuaSprite('black')

    if shadersEnabled then
        makeLuaSprite('pincushionController', '', 0, 0)
        makeLuaSprite('chromaticController', '', 0, 0);

        initLuaShader('vignetteGlitch')
        initLuaShader('pincushion')

        setSpriteShader('background', 'vignetteGlitch')
        setSpriteShader('background', 'pincushion')

        setShaderFloat('background', 'prob', 0.01)
        setShaderFloat('background', 'distort', 1)
        setShaderFloat('background', 'vignetteIntensity', 0.01)

        runHaxeCode([[
            game.initLuaShader('custom/pincushion');
            game.initLuaShader('custom/chromaticAberration');

            var pincushionShader = game.createRuntimeShader('pincushion');
            var chromaticShader = game.createRuntimeShader('custom/chromaticAberration');

            game.getLuaObject('pincushionController').shader = pincushionShader;
            game.getLuaObject('chromaticController').shader = chromaticShader;

            game.camGame.setFilters([
                new ShaderFilter(pincushionShader),
                new ShaderFilter(chromaticShader),
            ]);
        ]]);
    end
end

function onUpdate(elapsed)
    if shadersEnabled then
        setShaderFloat('background', 'time', os.clock())
    end
    setShaderFloat('chromaticController', 'amount', getProperty('chromaticController.x'))
    setShaderFloat('pincushionController', 'distort', getProperty('pincushionController.x'))
end

function onEvent(name, value1, value2)
    if name == 'Amusia Background Change' then
		loadGraphic('background', dir .. 'background2')
        setShaderFloat('background', 'prob', 0.75)
        setShaderFloat('background', 'vignetteIntensity', 0.75)
	end
    if name == 'Change Character' then
        if curBeat < 134 then
            if value1 == 'dad' then
                if value2 == 'wigglytuff' then
                    setShaderFloat('background', 'prob', 0.01)
                    setShaderFloat('background', 'vignetteIntensity', 0.01)
                end
                if value2 == 'wigglytuff-decay1' then
                    setShaderFloat('background', 'prob', 0.05)
                    setShaderFloat('background', 'vignetteIntensity', 0.05)
                end
                if value2 == 'wigglytuff-decay2' then
                    setShaderFloat('background', 'prob', 0.25)
                    setShaderFloat('background', 'vignetteIntensity', 0.25)
                end
                if value2 == 'wigglytuff-stare' then
                    setShaderFloat('background', 'prob', 0.75)
                    setShaderFloat('background', 'vignetteIntensity', 0.75)
                end
            end
        end
    end
end

function onMoveCamera(focus)
    if focus == 'boyfriend' then
        setProperty('defaultCamZoom', 1.2)

    elseif focus == 'dad' then
        local zoomValues = {
            ['wigglytuff'] = 1.1,
            ['wigglytuff-decay1'] = 1.125,
            ['wigglytuff-decay2'] = 1.15,
            ['wigglytuff-stare'] = 1.175
        }
        local glitchIntensity = {
            ['wigglytuff'] = {0.01, 0.01},
            ['wigglytuff-decay1'] = {0.025, 0.025},
            ['wigglytuff-decay2'] = {0.05, 0.05},
            ['wigglytuff-stare'] = {0.1, 0.1}
        }

        local zoom = zoomValues[getProperty('dad.animation.curAnim.name')]

        if zoom ~= nil then
            setProperty('defaultCamZoom', zoom)
        end
    end
end