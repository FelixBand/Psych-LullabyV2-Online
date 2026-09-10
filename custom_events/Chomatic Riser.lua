local chromaticValue = 0;

function onCreate()
    makeLuaSprite('chomaticController');

    if shadersEnabled then
        runHaxeCode([[ 
            var shaderName = 'camEffects';
            game.initLuaShader(shaderName);
            var shader = game.createRuntimeShader(shaderName);
            var filters = game.camGame.flashSprite.filters;
            filters.push(new ShaderFilter(shader));
            game.camGame.setFilters(filters);
            game.getLuaObject('chomaticController').shader = shader;
        ]]);
    end
end

function onEvent(name, value1, value2)
    if name ~= 'Chomatic Riser' and name ~= 'Chromatic Riser' then
        return;
    end

    local target = tonumber(value1) or 0;
    local steps = tonumber(value2) or 0;
    local ease = target > chromaticValue and 'cubeIn' or 'cubeOut';
    chromaticValue = target;

    if shadersEnabled then
        doTweenX('chomaticRiser', 'chomaticController', target, (steps * stepCrochet) / 1000, ease);
    end
end

function onUpdate()
    if shadersEnabled then
        setShaderFloat('chomaticController', 'distort', getProperty('chomaticController.x'));
    end
end