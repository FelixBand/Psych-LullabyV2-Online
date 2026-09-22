strumTimes = {}
mustPresses = {}
noteDatas = {}
local whichNote = 1

local strumShakeTime = 0
local strumShakeDuration = 0.1
local strumShakeActive = false

function onCreate()
	setProperty('skipCountdown', true)
	setProperty('cameraSpeed', 100)
	setProperty('camHUD.alpha', 0.0001)

	for i = 0, getProperty('unspawnNotes.length') - 1 do
		table.insert(strumTimes, getPropertyFromGroup('unspawnNotes', i, 'strumTime'))
		table.insert(mustPresses, getPropertyFromGroup('unspawnNotes', i, 'mustPress'))
		table.insert(noteDatas, getPropertyFromGroup('unspawnNotes', i, 'noteData'))

		-- Only ignore opponent notes when playing as BF.
		if playsAsBF() and getPropertyFromGroup('unspawnNotes', i, 'mustPress') == false then
			setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
		end
	end
end

function onSongStart()
	setProperty('camZooming', true)
	triggerEvent('Camera Follow Pos', 1150, 1100)
	setProperty('boyfriend.color', 0xFFFF0000)
	setProperty('dad.color', 0xFFFF0000)
end

function onUpdate(elapsed)
	-- Only manually process opponent notes when playing as BF.
	if playsAsBF() then
		if whichNote <= #strumTimes and getSongPosition() > strumTimes[whichNote] then
			if mustPresses[whichNote] == false then
			singDirection(noteDatas[whichNote])

			strumShakeTime = strumShakeDuration
			strumShakeActive = true
		end

			whichNote = whichNote + 1
		end
	end

	-- Synchronized opponent strum shake using sprite offsets.
	if strumShakeActive then
		strumShakeTime = strumShakeTime - elapsed

		local strumCount = getProperty('opponentStrums.length')

		if strumShakeTime <= 0 then
			strumShakeTime = 0
			strumShakeActive = false

			-- Reset every strum to its normal offset.
			for i = 0, strumCount - 1 do
				setPropertyFromGroup('opponentStrums', i, 'offset.x', 23)
				setPropertyFromGroup('opponentStrums', i, 'offset.y', 23)
			end
		else
			-- One shared random offset for ALL opponent strums.
			local shakeX = getRandomInt(20, 26)
			local shakeY = getRandomInt(20, 26)

			for i = 0, strumCount - 1 do
				setPropertyFromGroup('opponentStrums', i, 'offset.x', shakeX)
				setPropertyFromGroup('opponentStrums', i, 'offset.y', shakeY)
			end
		end
	end

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

function getSingAnimation(noteData)
	local keyCount = getProperty('opponentStrums.length')

	-- 4K
	if keyCount == 4 then
		local directions = {
			'singLEFT',
			'singDOWN',
			'singUP',
			'singRIGHT'
		}

		return directions[noteData + 1]
	end

	-- 5K
	-- LEFT, DOWN, UP, UP, RIGHT
	if keyCount == 5 then
		local directions = {
			'singLEFT',
			'singDOWN',
			'singUP',
			'singUP',
			'singRIGHT'
		}

		return directions[noteData + 1]
	end

	-- 6K
	-- LEFT, DOWN, RIGHT, LEFT, UP, RIGHT
	if keyCount == 6 then
		local directions = {
			'singLEFT',
			'singDOWN',
			'singRIGHT',
			'singLEFT',
			'singUP',
			'singRIGHT'
		}

		return directions[noteData + 1]
	end

	-- Generic fallback for other key counts.
	-- Odd key counts get UP in the center.
	if keyCount % 2 == 1 then
		local center = math.floor(keyCount / 2)

		if noteData == center then
			return 'singUP'
		end

		if noteData < center then
			if noteData % 2 == 0 then
				return 'singLEFT'
			else
				return 'singDOWN'
			end
		else
			local distance = noteData - center

			if distance % 2 == 1 then
				return 'singRIGHT'
			else
				return 'singUP'
			end
		end
	end

	-- Generic fallback for even key counts.
	local directions = {
		'singLEFT',
		'singDOWN',
		'singRIGHT',
		'singUP'
	}

	return directions[(noteData % #directions) + 1]
end

function singDirection(noteData)
	callOnLuas('follow', {noteData, false, nil})
	setProperty('vocals.volume', 1)

	local animation = getSingAnimation(noteData)

	if animation ~= nil then
		triggerEvent('Play Animation', animation, 'dad')
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
				setProperty('defaultCamZoom', 1)
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
		doTweenX(
			'dadIn',
			'dadGroup',
			getProperty('dad.x') - screenWidth,
			(stepCrochet / 1000) * 12,
			'circInOut'
		)

	elseif curStep == 19 then
		doTweenX(
			'bfIn',
			'boyfriendGroup',
			getProperty('boyfriend.x') + screenWidth,
			(stepCrochet / 1000) * 12,
			'circInOut'
		)
	end

	if curStep == 272 then
		doTweenAlpha('staticIn', 'static', 0.25, 0.5, 'linear')
		doTweenAlpha('redIn', 'redStatic', 0.25, 0.5, 'linear')
	end

	if curStep == 280 then
		doTweenAlpha('redOut', 'redStatic', 0, 0.1, 'linear')
		setProperty('static.alpha', 0)
		doTweenAlpha('staticIn', 'static', 0.25, 0.5, 'linear')
	end

	if curStep == 288 then
		doTweenAlpha('staticOut', 'static', 0, 0.5, 'linear')
	end

	if curStep == 538 then
		doTweenAlpha('staticIn', 'static', 0.25, 0.5, 'linear')
		doTweenAlpha('redIn', 'redStatic', 0.5, 0.5, 'linear')
	end

	if curStep == 544 then
		doTweenAlpha('staticOut', 'static', 0.05, 0.1, 'linear')
		doTweenAlpha('redOut', 'redStatic', 0, 0.1, 'linear')
	end

	if curStep == 728 then
		doTweenX('chromUp', 'chromaticController', 15, 0.677, 'cubeIn')
		doTweenX('pincUp', 'pincushionController', 0.5, 0.677, 'cubeIn')
		doTweenAlpha('staticIn', 'static', 0.25, 0.5, 'linear')
		doTweenAlpha('redIn', 'redStatic', 0.25, 0.5, 'linear')
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

		setShaderFloat('background', 'prob', 1)
		setShaderFloat('background', 'vignetteIntensity', 1)

		triggerEvent('Camera Follow Pos', '1050', '1150')
	end

	-- Swap the strums
	if curStep == 800 then
		if not middlescroll then
			local strumCount = getProperty('opponentStrums.length')

			for i = 0, strumCount - 1 do
				noteTweenX('opponentStrumTween' .. i, i, _G['defaultPlayerStrumX' .. i], 1, 'cubeInOut')
				noteTweenX('playerStrumTween' .. i, i + strumCount, _G['defaultOpponentStrumX' .. i], 1, 'cubeInOut')
				
				noteTweenAngle('noteSpin' .. i, i, 360, 1, 'cubeInOut')
				noteTweenAngle('noteSpin' .. i + strumCount, i + strumCount, 360, 1, 'cubeInOut')
			end

		end
	end

	if curStep == 804 then
		setProperty('dadGroup.x', 160)
		setProperty('dadGroup.y', 482)

		setProperty('boyfriendGroup.x', 1540)
		setProperty('boyfriendGroup.y', 680)

		doTweenX(
			'dadSlideBack',
			'dadGroup',
			getProperty('dadGroup.x') + 1000,
			0.75,
			'quartOut'
		)

		doTweenX(
			'bfSlideBack',
			'boyfriendGroup',
			getProperty('boyfriendGroup.x') - 1000,
			0.75,
			'quartOut'
		)

		doTweenX(
			'plateLback',
			'plateL',
			getProperty('plateL.x') - 1000,
			0.75,
			'quartOut'
		)

		doTweenX(
			'plateRback',
			'plateR',
			getProperty('plateR.x') + 1000,
			0.75,
			'quartOut'
		)

		setProperty('healthBar.flipX', true)
	end

	if curStep == 809 then
		triggerEvent('Camera Follow Pos', '', '')
		doTweenX('chromUp', 'chromaticController', 15, 0.677, 'cubeIn')
		doTweenX('pincUp', 'pincushionController', 0.3, 0.677, 'cubeIn')
	end

	if curStep == 1296 then
		doTweenX('chromOff', 'chromaticController', 0, 1, 'cubeIn')
		doTweenX('pincOff', 'pincushionController', 0, 1, 'cubeIn')
		doTweenAlpha('redIn', 'redStatic', 0.75, 0.667, 'cubeIn')
		doTweenAlpha('staticIn', 'static', 0.1, 0.667, 'linear')
	end

	if curStep == 1312 then
		doTweenAlpha('redOut', 'redStatic', 0.25, 0.667, 'cubeIn')
	end

	if curStep == 2000 then
		doTweenAlpha('redIn', 'redStatic', 0.75, 2, 'cubeIn')
		doTweenAlpha('staticIn', 'static', 0.25, 1, 'cubeIn')
	end

	if curStep == 2052 then
		doTweenAlpha('camOut', 'camGame', 0, 0.75, 'cubeIn')
		doTweenAlpha('hudOut', 'camHUD', 0, 0.75, 'cubeIn')
		doTweenAlpha('redOut', 'redStatic', 0, 2, 'cubeIn')
	end

	if curStep == 2064 then
		setProperty('background.visible', false)
		doTweenAlpha('questionareIn', 'questionare', 1, 3, 'linear')
		doTweenAlpha('wigglesIn', 'wigglesEnd', 1, 3, 'linear')
	end

	if curStep == 2103 then
		doTweenAlpha('staticOut', 'static', 0, 1, 'linear')
	end
end

function onSectionHit() getPropertyFromGroup('opponentStrums', i, 'angle')
	if curSection >= 82 and curSection % 2 == 0 then
		for i = 0, getProperty('opponentStrums.length') - 1 do
			noteTweenAngle('noteSpin' .. i, i, getPropertyFromGroup('opponentStrums', i, 'angle') + 360, 1, 'cubeInOut')
			noteTweenAngle('noteSpin' .. i + getProperty('opponentStrums.length'), i + getProperty('opponentStrums.length'), getPropertyFromGroup('playerStrums', i, 'angle') + 360, 1, 'cubeInOut')
		end
	end
end

function waveStrumsY(group, defaultPrefix)
	for i = 0, getProperty(group .. '.length') - 1 do
		local wave = math.sin(
			(getSongPosition() / (stepCrochet * 8)) * math.pi
				+ (i * 75)
		) * 30

		setPropertyFromGroup(
			group,
			i,
			'y',
			_G[defaultPrefix .. i] + wave
		)
	end
end

function waveStrumsX(group, defaultPrefix)
	local wave = math.sin(
		(getSongPosition() / (stepCrochet * 16)) * math.pi
	) * 75

	for i = 0, getProperty(group .. '.length') - 1 do
		setPropertyFromGroup(
			group,
			i,
			'x',
			_G[defaultPrefix .. i]
				+ wave
		)
	end
end

function updateStrumWaves()
	if curStep >= 800 then
		waveStrumsY('opponentStrums', 'defaultOpponentStrumY')
		waveStrumsY('playerStrums', 'defaultPlayerStrumY')
	end

	if curSection >= 82 then
		if middlescroll then
			waveStrumsX('opponentStrums', 'defaultOpponentStrumX')
			waveStrumsX('playerStrums', 'defaultPlayerStrumX')
		else
			waveStrumsX('opponentStrums', 'defaultPlayerStrumX')
			waveStrumsX('playerStrums', 'defaultOpponentStrumX')
		end
	end
end

function updateHealthIcons()
	if curStep >= 804 then
		setProperty(
			'iconP1.x',
			getProperty('healthBar.x')
				+ (
					getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01
					+ (150 * getProperty('iconP1.scale.x') - 150) / 2
					- 26
				)
				- 110
		)

		setProperty('iconP1.origin.x', 240)
		setProperty('iconP1.flipX', true)

		setProperty(
			'iconP2.x',
			getProperty('healthBar.x')
				+ (
					getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01
					- (150 * getProperty('iconP2.scale.x')) / 2
					- 26 * 2
				)
				+ 110
		)

		setProperty('iconP2.origin.x', -100)
		setProperty('iconP2.flipX', true)
	end
end

function onUpdatePost()
	updateStrumWaves()
	updateHealthIcons()
end