function onCreate()
    makeLuaSprite('jumpscare', 'jumpscares/Gold', 0, 0);
    setObjectCamera('jumpscare', 'hud');
    scaleObject('jumpscare', 0.4, 0.4);
    addLuaSprite('jumpscare', true);
    setProperty('jumpscare.alpha', 0.0001);

    makeLuaSprite('jumpscareAlt', 'jumpscares/GoldAlt', 0, 0);
    setObjectCamera('jumpscareAlt', 'hud');
    scaleObject('jumpscareAlt', 0.3, 0.3);
    addLuaSprite('jumpscareAlt', true);
    setProperty('jumpscareAlt.alpha', 0.0001);
    runTimer('shake', 0.025, 0);
end

function onEvent(name, value1, value2)
    if name == 'Jumpscare' then
        if curBeat < 416 then
            setProperty('jumpscare.alpha', 1);
            doTweenAlpha('jumpscareOut', 'jumpscare', 0, 0.5, 'smoothStepIn');
        else
            setProperty('jumpscareAlt.alpha', 1);
            doTweenAlpha('jumpscareAltOut', 'jumpscareAlt', 0, 0.5, 'smoothStepIn');
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'shake' then
        setProperty('jumpscare.x', getRandomInt(-135, -145));
        setProperty('jumpscare.y', getRandomInt(-145, -135));

        setProperty('jumpscareAlt.x', getRandomInt(-160, -170));
        setProperty('jumpscareAlt.y', getRandomInt(-125, -115));
    end
end