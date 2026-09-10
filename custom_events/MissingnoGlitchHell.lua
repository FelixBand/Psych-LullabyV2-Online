local glitchActive = false;

function onCreatePost()
    makeLuaSprite('missingnoGlitchFilter');

    if shadersEnabled then
        runHaxeCode([[ 
            var shaderName = 'glitch';
            game.initLuaShader(shaderName);
            var shader = game.createRuntimeShader(shaderName);
            var gameFilters = game.camGame.flashSprite.filters;
            var hudFilters = game.camHUD.flashSprite.filters;
            gameFilters.push(new ShaderFilter(shader));
            hudFilters.push(new ShaderFilter(shader));
            game.camGame.setFilters(gameFilters);
            game.camHUD.setFilters(hudFilters);
            game.getLuaObject('missingnoGlitchFilter').shader = shader;
        ]]);
    end
end

function onEvent(name, value1, value2)
    if name ~= 'MissingnoGlitchHell' or not shadersEnabled then
        return;
    end

    local flags = stringSplit(value1, '/');
    glitchActive = flags[1] == 'true';

    if flags[2] == 'true' then
        setShaderFloat('missingnoGlitchFilter', 'time', getSongPosition() / 1000);
    end
    if value2 ~= '' then
        setShaderFloat('missingnoGlitchFilter', 'prob', tonumber(value2) or 0);
    end
end

function onUpdate()
    if shadersEnabled and glitchActive then
        setShaderFloat('missingnoGlitchFilter', 'time', getSongPosition() / 1000);
    end
end

function onGameOver()
    if shadersEnabled then
        runHaxeCode([[ 
            game.camGame.setFilters([]);
            game.camHUD.setFilters([]);
        ]]);
    end
end