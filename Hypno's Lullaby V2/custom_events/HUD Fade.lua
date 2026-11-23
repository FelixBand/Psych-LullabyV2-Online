function onEvent(name, value1, value2)
    if name == 'HUD Fade' then
        if getProperty('camHUD.alpha') == 1 then
            doTweenAlpha('hudOut', 'camHUD', 0, 0.1, 'linear');
        else
            doTweenAlpha('hudIn', 'camHUD', 1, 0.1, 'linear');
        end
    end
end