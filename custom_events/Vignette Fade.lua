local staticMax = 0.25;
local staticOverlayMax = 0.6;

function onEvent(name, value1, value2)
    if name ~= 'Vignette Fade' then
        return;
    end

    local amount = tonumber(value1) or 0;
    local duration = (tonumber(value2) or 0) * (stepCrochet / 1000);
    doTweenAlpha('staticFade', 'amusiaStatic', staticMax * amount, duration, 'linear');
    doTweenAlpha('staticOverlayFade', 'amusiaStaticOverlay', staticOverlayMax * amount, duration, 'linear');
end