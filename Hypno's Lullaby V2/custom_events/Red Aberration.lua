local falseIntensity = 0;
local intensity = 0;
local initial = 0;

function onEvent(name, value1, value2)
    if name ~= 'Red Aberration' then
        return;
    end

    intensity = tonumber(value1) or 0;
    initial = tonumber(value2) or 0;

    if shadersEnabled then
        initLuaShader('isotope/redAberration');
        setSpriteShader('dad', 'isotope/redAberration');
    end
end

function onUpdate(elapsed)
    if shadersEnabled then
        falseIntensity = falseIntensity + (0 - falseIntensity) * math.min(1, elapsed * 2);
        setShaderFloat('dad', 'intensity', falseIntensity);
        setShaderFloat('dad', 'initial', initial);
    end
end