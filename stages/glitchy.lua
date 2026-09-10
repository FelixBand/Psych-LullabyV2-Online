local dir = 'stages/glitchy/images/';

function onCreate()
	makeLuaSprite('bg', dir .. 'glitch_City', -500, 50);
	scaleObject('bg', 0.625, 0.625);
	setScrollFactor('bg', 0.8, 0.8);
	addLuaSprite('bg');

	makeLuaSprite('tiles', dir .. 'tiles', -475, 40);
	scaleObject('tiles', 0.625, 0.625);
	setScrollFactor('tiles', 0.9, 0.9);
	addLuaSprite('tiles');

	makeLuaSprite('haze', dir .. 'haze', -475, 40);
	scaleObject('haze', 0.625, 0.625);
	setScrollFactor('haze', 0.9, 0.9);
	addLuaSprite('haze');

	makeAnimatedLuaSprite('girlTits', dir .. 'FUCKKKKK', 825, 980);
	addAnimationByPrefix('girlTits', 'idle', 'Lmao', 24, false);
	--scaleObject('girlTits', 0.625, 0.625);
	--setScrollFactor('girlTits', 0.9, 0.9);
	addLuaSprite('girlTits');

	setProperty('skipCountdown', true);
end

function onCreatePost()
	--setProperty('camHUD.alpha', 0);
	setProperty('camZooming', true);

	-- swap strum positions
	for i = 0,getProperty('playerStrums.length') - 1 do
		setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i]);
	end
	for i = 0,getProperty('opponentStrums.length') - 1 do
		setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i]);
	end

	if playsAsBF() then
		for i = 0,getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', -5000);
		end
	end
	
	-- healthbar stuff
	setProperty('healthBar.flipX', true);
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playAnim('girlTits', 'idle', true);
	end
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('defaultCamZoom', 0.7);
	elseif focus == 'dad' then
		setProperty('defaultCamZoom', 0.85);
	end
end