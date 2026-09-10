strumTimes = {};
mustPresses = {};
noteDatas = {};
local whichNote = 1;

function onCreate()
	setProperty('cameraSpeed', 100);
	setProperty('camHUD.alpha', 0.0001);

	for i = 0, getProperty('unspawnNotes.length')-1 do
		table.insert(strumTimes, getPropertyFromGroup('unspawnNotes', i, 'strumTime'));
		table.insert(mustPresses, getPropertyFromGroup('unspawnNotes', i, 'mustPress'));
		table.insert(noteDatas, getPropertyFromGroup('unspawnNotes', i, 'noteData'));
		if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then			
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
		end
	end

	makeAnimatedLuaSprite('amusiaStatic', 'stages/disabled/images/static', -2, -2);
	setObjectCamera('amusiaStatic', 'other');
	scaleObject('amusiaStatic', 1.35, 1.35);
	addAnimationByPrefix('amusiaStatic', 'idle', 'static', 24, true);
	setProperty('amusiaStatic.alpha', 0.1);
	addLuaSprite('amusiaStatic', true);
end

function onSongStart()
	setProperty('camZooming', true);
	triggerEvent('Camera Follow Pos', 1150, 1100);
	setProperty('boyfriend.color', 0xFFFF0000);
	setProperty('dad.color', 0xFFFF0000);
end

whichNote = 1;

function onUpdate(elapsed)
	if whichNote <= #strumTimes and getSongPosition() > strumTimes[whichNote] then
		if mustPresses[whichNote] == false then	
			singDirection(noteDatas[whichNote]);
		end
		whichNote = whichNote + 1;
		--debugPrint(strumTimes[whichNote]);
	end

	if notesSwapped then
		for i = 0, getProperty('notes.length') - 1 do
			local noteData = getPropertyFromGroup('notes', i, 'noteData');
			local group = getPropertyFromGroup('notes', i, 'mustPress') and 'playerStrums' or 'opponentStrums';
			setPropertyFromGroup('notes', i, 'x', getPropertyFromGroup(group, noteData, 'x'));
		end
	end

	if curStep < 32 and curStep > 0 then
		setProperty('black.alpha', 1 - math.abs(math.sin(((getSongPosition()) / (stepCrochet * 8)) * math.pi) * 0.5));
	end
end

function singDirection(direction)
	callOnLuas('follow', {direction, false, nil})
	if direction == 0 then
		triggerEvent('Play Animation', 'singLEFT', 'dad');
	elseif direction == 1 then
		triggerEvent('Play Animation', 'singDOWN', 'dad');
	elseif direction == 2 then
		triggerEvent('Play Animation', 'singUP', 'dad');
	elseif direction == 3 then
		triggerEvent('Play Animation', 'singRIGHT', 'dad');
	end
end

function onEvent(name, value1, value2)
	if name == 'Change Character' and not mustHitSection then
		if value2 == 'wigglytuff' then
			setProperty('defaultCamZoom', 1.1);
		elseif value2 == 'wigglytuff-decay1' then
			setProperty('defaultCamZoom', 1.125);
		elseif value2 == 'wigglytuff-decay2' then
			setProperty('defaultCamZoom', 1.15);
		elseif value2 == 'wigglytuff-stare' then
			setProperty('defaultCamZoom', 1.175);
		end
	end
	if name == 'Song Start' then
		doTweenAlpha('hudIn', 'camHUD', 1, 0.5, 'linear');
		removeLuaSprite('black', true);
		setObjectCamera('white', 'other');
		setProperty('white.x', 0);
		setProperty('white.y', 0);
		doTweenAlpha('whiteOut', 'white', 0, 1, 'linear');
		setProperty('cameraSpeed', 1);
		triggerEvent('Camera Follow Pos', nil, nil);

		setProperty('boyfriend.color', 0xFFFFFFF);
		setProperty('dad.color', 0xFFFFFFF);
	elseif name == 'Amusia Background Change' then
		removeLuaSprite('background', true);
		setProperty('background2.alpha', 1);
	end
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('defaultCamZoom', 1.3);
	elseif focus == 'dad' then
		if dadName == 'wigglytuff' then
			setProperty('defaultCamZoom', 1.1);
		elseif dadName == 'wigglytuff-decay1' then
			setProperty('defaultCamZoom', 1.125);
		elseif dadName == 'wigglytuff-decay2' then
			setProperty('defaultCamZoom', 1.15);
		elseif dadName == 'wigglytuff-stare' then
			setProperty('defaultCamZoom', 1.175);
		end
	end
end

function onStepHit()
	if curStep == 13 then
		doTweenX('dadIn', 'dadGroup', getProperty('dad.x') - screenWidth, (stepCrochet / 1000) * 12, 'circInOut');
	elseif curStep == 19 then
		doTweenX('bfIn', 'boyfriendGroup', getProperty('boyfriend.x') + screenWidth, (stepCrochet / 1000) * 12, 'circInOut');
	end
end