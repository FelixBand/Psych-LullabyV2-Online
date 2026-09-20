strumTimes = {}
mustPresses = {}
noteDatas = {}
local whichNote = 1

local strumShakeTime = 0
local strumShakeDuration = 0.1
local strumShakeActive = false

local strumBaseX = {}
local strumBaseY = {}

function shakeOpponentNote(noteData)
	shakeNote = noteData
	shakeTime = 0.2

	local strum = 'opponentStrums.members[' .. noteData .. ']'
	shakeBaseX = getProperty(strum .. '.x')
	shakeBaseY = getProperty(strum .. '.y')
end

function onCreate()
	setProperty('skipCountdown', true)
	setProperty('cameraSpeed', 100)
	setProperty('camHUD.alpha', 0.0001)

	for i = 0, getProperty('unspawnNotes.length')-1 do
		table.insert(strumTimes, getPropertyFromGroup('unspawnNotes', i, 'strumTime'))
		table.insert(mustPresses, getPropertyFromGroup('unspawnNotes', i, 'mustPress'))
		table.insert(noteDatas, getPropertyFromGroup('unspawnNotes', i, 'noteData'))
		if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then			
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
		end
	end

	makeAnimatedLuaSprite('amusiaStatic', 'stages/disabled/images/static', -2, -2)
	setObjectCamera('amusiaStatic', 'other')
	scaleObject('amusiaStatic', 1.35, 1.35)
	addAnimationByPrefix('amusiaStatic', 'idle', 'static', 24, true)
	setProperty('amusiaStatic.alpha', 0.001)
	addLuaSprite('amusiaStatic', true)
end

function onCreatePost()
	for i = 0, 3 do
		strumBaseX[i] = getPropertyFromGroup('opponentStrums', i, 'x')
		strumBaseY[i] = getPropertyFromGroup('opponentStrums', i, 'y')
	end
end

function onSongStart()
	setProperty('camZooming', true)
	triggerEvent('Camera Follow Pos', 1150, 1100)
	setProperty('boyfriend.color', 0xFFFF0000)
	setProperty('dad.color', 0xFFFF0000)
end

whichNote = 1

function onUpdate(elapsed)
	if whichNote <= #strumTimes and getSongPosition() > strumTimes[whichNote] then
		if mustPresses[whichNote] == false then	
			singDirection(noteDatas[whichNote])

			-- Start synchronized shake
			strumShakeTime = strumShakeDuration
			strumShakeActive = true
		end

		whichNote = whichNote + 1
	end

	-- Synchronized opponent strum shake
	if strumShakeActive then
		strumShakeTime = strumShakeTime - elapsed

		if strumShakeTime <= 0 then
			strumShakeTime = 0
			strumShakeActive = false

			-- Restore exact original positions
			for i = 0, 3 do
				setPropertyFromGroup('opponentStrums', i, 'x', strumBaseX[i])
				setPropertyFromGroup('opponentStrums', i, 'y', strumBaseY[i])
			end
		else
			-- One random offset shared by ALL strums
			local shakeX = math.random(-3, 3)
			local shakeY = math.random(-3, 3)

			for i = 0, 3 do
				setPropertyFromGroup(
					'opponentStrums',
					i,
					'x',
					strumBaseX[i] + shakeX
				)

				setPropertyFromGroup(
					'opponentStrums',
					i,
					'y',
					strumBaseY[i] + shakeY
				)
			end
		end
	end

	-- Your existing note swapping
	if notesSwapped then
		for i = 0, getProperty('notes.length') - 1 do
			local noteData = getPropertyFromGroup('notes', i, 'noteData')
			local group = getPropertyFromGroup('notes', i, 'mustPress')
				and 'playerStrums'
				or 'opponentStrums'

			setPropertyFromGroup(
				'notes',
				i,
				'x',
				getPropertyFromGroup(group, noteData, 'x')
			)
		end
	end

	if curStep < 32 and curStep > 0 then
		setProperty(
			'black.alpha',
			1 - math.abs(
				math.sin(
					((getSongPosition() / (stepCrochet * 8)) * math.pi)
				) * 0.5
			)
		)
	end
end

function singDirection(direction)
	callOnLuas('follow', {direction, false, nil})
	setProperty('vocals.volume', 1)
	if direction == 0 then
		triggerEvent('Play Animation', 'singLEFT', 'dad')
	elseif direction == 1 then
		triggerEvent('Play Animation', 'singDOWN', 'dad')
	elseif direction == 2 then
		triggerEvent('Play Animation', 'singUP', 'dad')
	elseif direction == 3 then
		triggerEvent('Play Animation', 'singRIGHT', 'dad')
	end
end

function onEvent(name, value1, value2)
	if name == 'Change Character' and not mustHitSection then
		if value2 == 'wigglytuff' then
			setProperty('defaultCamZoom', 1.1)
		elseif value2 == 'wigglytuff-decay1' then
			setProperty('defaultCamZoom', 1.125)
		elseif value2 == 'wigglytuff-decay2' then
			setProperty('defaultCamZoom', 1.15)
		elseif value2 == 'wigglytuff-stare' then
			setProperty('defaultCamZoom', 1.175)
		end
	end
	if name == 'Song Start' then
		doTweenAlpha('hudIn', 'camHUD', 1, 0.5, 'linear')
		removeLuaSprite('black', true)
		setObjectCamera('white', 'other')
		setProperty('white.x', 0)
		setProperty('white.y', 0)
		doTweenAlpha('whiteOut', 'white', 0, 1, 'linear')
		setProperty('cameraSpeed', 1)
		triggerEvent('Camera Follow Pos', nil, nil)

		setProperty('boyfriend.color', 0xFFFFFFF)
		setProperty('dad.color', 0xFFFFFFF)
	end
end

function onMoveCamera(focus)
	if curStep < 791 then
		if focus == 'boyfriend' then
			setProperty('defaultCamZoom', 1.3)
		elseif focus == 'dad' then
			if dadName == 'wigglytuff' then
				setProperty('defaultCamZoom', 1.1)
			elseif dadName == 'wigglytuff-decay1' then
				setProperty('defaultCamZoom', 1.125)
			elseif dadName == 'wigglytuff-decay2' then
				setProperty('defaultCamZoom', 1.15)
			elseif dadName == 'wigglytuff-stare' then
				setProperty('defaultCamZoom', 1.175)
			end
		end
	else
		if focus == 'boyfriend' then
			setProperty('defaultCamZoom', 1.15)
		elseif focus == 'dad' then
			setProperty('defaultCamZoom', 1.25)
		end
	end
end

function onStepHit()
	if curStep == 13 then
		doTweenX('dadIn', 'dadGroup', getProperty('dad.x') - screenWidth, (stepCrochet / 1000) * 12, 'circInOut')
	elseif curStep == 19 then
		doTweenX('bfIn', 'boyfriendGroup', getProperty('boyfriend.x') + screenWidth, (stepCrochet / 1000) * 12, 'circInOut')
	end

	if curStep == 538 then
		doTweenAlpha('staticIn', 'static', 0.25, 0.5, 'linear')
		doTweenAlpha('camOut', 'camGame', 0.5, 0.5, 'linear')
	end
	if curStep == 544 then
		doTweenAlpha('staticOut', 'static', 0.05, 0.1, 'linear')
		doTweenAlpha('camIn', 'camGame', 1, 0.1, 'linear')
	end

	if curStep == 728 then
        doTweenX('chromUp', 'chromaticController', 15, 0.677, 'cubeIn')
		doTweenX('pincUp', 'pincushionController', 0.5, 0.677, 'cubeIn')
        doTweenAlpha('staticIn', 'static', 0.25, 0.5, 'linear')
    end
    if curStep == 736 then
        cancelTween('chromUp')
        setProperty('chromaticController.x', 0)
		setProperty('pincushionController.x', 0)
		doTweenAlpha('staticOut', 'static', 0.05, 0.1, 'linear')
    end

	if curStep == 791 then
        doTweenX('dadSlideRight', 'dadGroup', getProperty('dadGroup.x') + 1000, 0.75, 'circIn')
		doTweenX('bfSlideLeft', 'boyfriendGroup', getProperty('boyfriend.x') - 1000, 0.75, 'circIn')

		doTweenX('plateLright', 'plateL', getProperty('plateL.x') + 1000, 0.75, 'circIn')
		doTweenX('plateRleft', 'plateR', getProperty('plateR.x') - 1000, 0.75, 'circIn')

		triggerEvent('Camera Follow Pos', '1150', '1100')
    end
	if curStep == 804 then
		setProperty('dadGroup.x', 160)
		setProperty('dadGroup.y', 482)

		setProperty('boyfriendGroup.x', 1540)
		setProperty('boyfriendGroup.y', 680)

        doTweenX('dadSlideBack', 'dadGroup', getProperty('dadGroup.x') + 1000, 0.75, 'quartOut')
		doTweenX('bfSlideBack', 'boyfriendGroup', getProperty('boyfriendGroup.x') - 1000, 0.75, 'quartOut')

		doTweenX('plateLback', 'plateL', getProperty('plateL.x') - 1000, 0.75, 'quartOut')
		doTweenX('plateRback', 'plateR', getProperty('plateR.x') + 1000, 0.75, 'quartOut')

		setProperty('healthBar.flipX', true)
    end
	if curStep == 809 then
		triggerEvent('Camera Follow Pos', '', '')
		doTweenX('chromUp', 'chromaticController', 10, 0.677, 'cubeIn')
		doTweenX('pincUp', 'pincushionController', 0.5, 0.677, 'cubeIn')
    end
end

function onUpdatePost()
	if curStep >= 804 then
		setProperty('iconP1.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') *        getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26) - 110)
		setProperty('iconP1.origin.x',240)
		setProperty('iconP1.flipX',true)
		setProperty('iconP2.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2) + 110)
		setProperty('iconP2.origin.x',-100)
		setProperty('iconP2.flipX',true)
	end
end