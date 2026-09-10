local dir = 'stages/disabled/images/';

function onCreate()
    setProperty('skipCountdown', true);

    makeAnimatedLuaSprite('static', dir .. 'static', -3, -3);
    addAnimationByPrefix('static', 'idle', 'static', 8, true);
    scaleObject('static', 1.35, 1.35);
    setObjectCamera('static', 'other');
    setProperty('static.alpha', 0.0001);
    addLuaSprite('static');

    makeLuaSprite('background', dir .. 'background', 0, 200);
    scaleObject('background', 1.5, 1.5);
    setScrollFactor('background', 0.125, 0.5);
    addLuaSprite('background');

    makeLuaSprite('background2', dir .. 'background2', 0, 200);
    scaleObject('background2', 1.5, 1.5);
    setScrollFactor('background2', 0.125, 0.5);
    setProperty('background2.alpha', 0.0001);
    addLuaSprite('background2');

    makeLuaSprite('plateL', dir .. 'Purple_place', 500, 1240);
    scaleObject('plateL', 0.75, 0.75);
    addLuaSprite('plateL');

    makeLuaSprite('plateR', dir .. 'Purple_place', 1100, 1050);
    scaleObject('plateR', 0.5, 0.5);
    addLuaSprite('plateR');

    makeLuaSprite('white', '', 460, 750);
    makeGraphic('white', 1280, 720, 'FFFFFF');
    setObjectCamera('white', 'game');
    addLuaSprite('white');
    
    makeLuaSprite('black', '', 460, 750);
    makeGraphic('black', 1280, 720, '000000');
    setObjectCamera('black', 'game');
    addLuaSprite('black');

    close(true);
end

function onMoveCamera(focus)
    if focus == 'boyfriend' then
        setProperty('defaultCamZoom', 1.2);
    elseif focus == 'dad' then
        local zoomValues = {
            ['wigglytuff'] = 1.1,
            ['wigglytuff-decay1'] = 1.125,
            ['wigglytuff-decay2'] = 1.15,
            ['wigglytuff-stare'] = 1.175
        };

        setProperty('defaultCamZoom', zoomValues[getProperty('dad.animation.curAnim.name')]);
    end
end