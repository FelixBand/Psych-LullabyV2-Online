function onCreate()
    setProperty('dad.alpha', 0.0001);

    makeLuaSprite('bfded', 'characters/bf/dead_ass_bitch_LMAOOOO', -55, 1273);
    scaleObject('bfded', 0.76, 0.76);
    setProperty('bfded.alpha', 0.0001);
    addLuaSprite('bfded');

    makeAnimatedLuaSprite('hypnoEntrance', 'characters/hypno/ABOMINATION_HYPNO_ENTRANCE', getProperty('dad.x') - 260, getProperty('dad.y') + 43);
    addAnimationByPrefix('hypnoEntrance', 'entrance', 'Entrance instance', 24, false);
    setProperty('hypnoEntrance.alpha', 0.0001);
    addLuaSprite('hypnoEntrance');

    makeAnimatedLuaSprite('ending', 'characters/hypno/hypno_ending_sequence', getProperty('dad.x') - 510, getProperty('dad.y') - 10);
    addAnimationByPrefix('ending', 'end', 'Ending instance 1', 24, false);
    scaleObject('ending', 0.7, 0.7);
    setProperty('ending.alpha', 0.0001);
    addLuaSprite('ending');

    setProperty('skipCountdown', true);
end

function onCreatePost()
    -- swap strum positions
	for i = 0,getProperty('playerStrums.length') - 1 do
		setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i]);
	end
	for i = 0,getProperty('opponentStrums.length') - 1 do
		setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i]);
	end

    -- Hide opponent strums off screen somewhere
	for i = 0,getProperty('opponentStrums.length') - 1 do
		setPropertyFromGroup('opponentStrums', i, 'x', -5000);
	end
    
    setProperty('camZooming', true);
end

function onEvent(name, value1, value2)
    if name == 'Change Character' and value1 == 'bf' then
        setProperty('bfded.alpha', 1);
    end
end

function onUpdatePost()
	if curBeat >= 80 then -- flip healthbar after beat 80
		setProperty('iconP1.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') *        getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26) - 110)
		setProperty('iconP1.origin.x',240)
		setProperty('iconP1.flipX',true)
		setProperty('iconP2.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2) + 110)
		setProperty('iconP2.origin.x',-100)
		setProperty('iconP2.flipX',true)
	end
end

function onStepHit()
    if curStep == 304 then
        setProperty('defaultCamZoom', 0.5);
        setProperty('hypnoEntrance.alpha', 1);
        playAnim('hypnoEntrance', 'entrance', true);
        doTweenAlpha('hudOut', 'camHUD', 0, 0.1, 'linear');
    elseif curStep == 320 then
        for i = 0,getProperty('opponentStrums.length') - 1 do
            setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i]);
        end
        triggerEvent('Change Character', 'dad', 'abomination-hypno');
        removeLuaSprite('hypnoEntrance', true);
        setProperty('dad.alpha', 1);
        setProperty('healthBar.flipX', true)
        doTweenAlpha('hudIn', 'camHUD', 1, 0.25, 'linear');
    elseif curStep == 2128 then
        setProperty('ending.alpha', 1);
        playAnim('ending', 'end', true);
        setProperty('dad.alpha', 0);
    end
end