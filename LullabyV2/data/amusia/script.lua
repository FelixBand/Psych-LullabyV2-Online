strumTimes = {}
mustPresses = {}
noteDatas = {}
local whichNote = 1
local dialogueText = ''
local visibleDialogue = ''
local dialogueLetter = 1
local dialogueTimer = 0
local dialogueActive = false
local questionActive = false
local selectedAnswer = 1
local responseLines = {}
local responseIndex = 1
local endingStarted = false
local jumpscareShown = false

local strumShakeTime = 0
local strumShakeDuration = 0.1
local strumShakeActive = false

function onCreate()
	setProperty('skipCountdown', true)
	setProperty('cameraSpeed', 100)
	setProperty('camHUD.alpha', 0.0001)

	makeLuaSprite('amusiaTextBox', 'UI/base/amusia/questionareTextBox', 170, 500)
	setObjectCamera('amusiaTextBox', 'other')
	setProperty('amusiaTextBox.antialiasing', false)
	setProperty('amusiaTextBox.visible', false)

	local answerBoxX = 170 + getProperty('amusiaTextBox.width') + 20
	makeLuaSprite('amusiaAnswerBox', 'UI/base/amusia/questionareAnswerBox', answerBoxX, 500)
	setObjectCamera('amusiaAnswerBox', 'other')
	setProperty('amusiaAnswerBox.antialiasing', false)
	setProperty('amusiaAnswerBox.visible', false)

	makeLuaText('amusiaDialogueText', '', 680, 205, 540)
	setTextFont('amusiaDialogueText', 'poketext.ttf')
	setTextSize('amusiaDialogueText', 24)
	setTextColor('amusiaDialogueText', '000000')
	setTextBorder('amusiaDialogueText', 0, '000000')
	setTextAlignment('amusiaDialogueText', 'left')
	setObjectCamera('amusiaDialogueText', 'other')
	setProperty('amusiaDialogueText.visible', false)

	makeLuaSprite('amusiaSelector', 'UI/pixel/selector', answerBoxX + 28, 540)
	scaleObject('amusiaSelector', 2, 2)
	setObjectCamera('amusiaSelector', 'other')
	setProperty('amusiaSelector.antialiasing', false)
	setProperty('amusiaSelector.visible', false)

	makeAnimatedLuaSprite('amusiaWigglesClose', 'stages/disabled/images/Givemeyoursing', 0, 0)
	addAnimationByPrefix('amusiaWigglesClose', 'glitch', 'Upfront', 24, false)
	addAnimationByPrefix('amusiaWigglesClose', 'loop', 'stareLoop', 24, true)
	screenCenter('amusiaWigglesClose', 'xy')
	setProperty('amusiaWigglesClose.x', getProperty('amusiaWigglesClose.x') + 50)
	setProperty('amusiaWigglesClose.y', getProperty('amusiaWigglesClose.y') - 100)
	setObjectCamera('amusiaWigglesClose', 'other')
	addLuaSprite('amusiaWigglesClose', true)
	setProperty('amusiaWigglesClose.visible', false)

	makeLuaSprite('amusiaJumpscare', 'jumpscares/Wigglytuff_jumpscare', 0, 0)
	scaleObject('amusiaJumpscare', 0.3, 0.3)
	screenCenter('amusiaJumpscare', 'xy')
	setObjectCamera('amusiaJumpscare', 'other')
	addLuaSprite('amusiaJumpscare', true)
	setProperty('amusiaJumpscare.visible', false)

	addLuaSprite('amusiaTextBox', true)
	addLuaSprite('amusiaAnswerBox', true)
	addLuaSprite('amusiaSelector', true)
	addLuaText('amusiaDialogueText', true)

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
	setProperty('boyfriendGroup.color', 0xFFFF0000)
	setProperty('dadGroup.color', 0xFFFF0000)
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

	updateAmusiaDialogue(elapsed)
end

function singDirection(noteData)
	callOnLuas('follow', {noteData, false, nil})
	setProperty('vocals.volume', 1)

	triggerEvent('Play Animation', getProperty('singAnimations')[noteData+1], 'dad')
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

		setProperty('boyfriendGroup.color', 0xFFFFFFF)
		setProperty('dadGroup.color', 0xFFFFFFF)
	end

	if name == 'Progress Dialouge' and not endingStarted then
		showAmusiaDialogue(value1, value2 == 'Question')
	elseif name == 'Force dialouge end' then
		beginForcedAmusiaEnding()
	elseif name == 'Jumpscare Amusia' then
		showAmusiaJumpscare()
	end
end

local dialogueInputLocked = false

local dialogueText = ''
local visibleDialogue = ''
local dialogueLetter = 1
local dialogueTimer = 0
local dialogueActive = false
local questionActive = false
local selectedAnswer = 1

local dialogueStage = 0
-- 0 = inactive
-- 1 = question/opening
-- 2 = response dialogue

local responseLines = {}
local responseIndex = 1

function showAmusiaDialogue(text, isQuestion)
	dialogueText = text or ''
	visibleDialogue = ''
	dialogueLetter = 1
	dialogueTimer = 0
	dialogueActive = true
	questionActive = isQuestion
	selectedAnswer = 1

	setTextString('amusiaDialogueText', '')
	setProperty('amusiaTextBox.visible', true)
	setProperty('amusiaDialogueText.visible', true)
	setProperty('amusiaAnswerBox.visible', isQuestion)
	setProperty('amusiaSelector.visible', isQuestion)
	setProperty('amusiaSelector.y', 540)
end

function hideAmusiaDialogue()
	dialogueActive = false
	questionActive = false
	dialogueStage = 0

	setProperty('questionare.visible', false)
	setProperty('wigglesEnd.visible', false)
	setProperty('amusiaTextBox.visible', false)
	setProperty('amusiaDialogueText.visible', false)
	setProperty('amusiaAnswerBox.visible', false)
	setProperty('amusiaSelector.visible', false)
	setProperty('amusiaWigglesClose.visible', false)
end

function stopAmusiaAudio()
	runHaxeCode([[FlxG.sound.music.stop(); game.vocals.stop();]])
end

function beginEarlyAmusiaEnding()
	if endingStarted then
		return
	end

	endingStarted = true
	hideAmusiaDialogue()
	stopAmusiaAudio()
	runTimer('amusiaEarlyJumpscare', 5)
end

function beginForcedAmusiaEnding()
	if endingStarted then
		return
	end

	endingStarted = true
	hideAmusiaDialogue()
	stopAmusiaAudio()
	runTimer('amusiaForcedJumpscare', 0.916667)
end

function showAmusiaJumpscare()
	if jumpscareShown then
		return
	end

	jumpscareShown = true
	endingStarted = true

	cancelTimer('amusiaEarlyJumpscare')
	cancelTimer('amusiaForcedJumpscare')

	hideAmusiaDialogue()

	setProperty('amusiaJumpscare.visible', true)

	stopAmusiaAudio()

	playSound('WigglyTuffJumpscare', 1)
	cameraShake('other', 0.008, 3)

	runTimer('amusiaFinish', 3)
end

function advanceAmusiaDialogue()
	-- If the current line is still typing, Enter only
	-- completes the line. It does NOT advance the dialogue.
	if dialogueLetter <= #dialogueText then
		visibleDialogue = dialogueText
		dialogueLetter = #dialogueText + 1
		setTextString('amusiaDialogueText', visibleDialogue)
		return
	end

	-- Question handling.
	if questionActive then
		-- First answer is intentionally rejected.
		if selectedAnswer == 1 then
			playSound('errorMenu', 0.6)
			cameraFlash('other', 'red', 0.25, true)
			return
		end

		-- Accepted answer.
		questionActive = false
		dialogueStage = 2

		setProperty('amusiaAnswerBox.visible', false)
		setProperty('amusiaSelector.visible', false)

		playSound('confirmMenu', 0.6)

		responseLines = {
			'You\'re lying.',
			'You... can sing.',
			'Give me your sing.',
			'Give me your sing.',
			'Give me your sing.',
			'Sing.',
			'Sing.',
			string.rep('S', 64)
		}

		responseIndex = 1

		playAnim('wigglesEnd', 'give', true)

		-- Display the first response line.
		local firstLine = responseLines[responseIndex]
		responseIndex = responseIndex + 1

		showAmusiaDialogue(firstLine, false)
		return
	end

	-- Response dialogue.
	if dialogueStage == 2 then
		-- There are still response lines left.
		if responseIndex <= #responseLines then
			local nextLine = responseLines[responseIndex]
			responseIndex = responseIndex + 1

			if nextLine == 'You... can sing.' then
				playAnim('wigglesEnd', 'angry', true)

			elseif nextLine == 'Give me your sing.' then
				setProperty('wigglesEnd.visible', false)
				setProperty('amusiaWigglesClose.visible', true)
				playAnim('amusiaWigglesClose', 'glitch', true)
			end

			showAmusiaDialogue(nextLine, false)
			return
		end

		-- No response lines remain.
		-- The final line was already displayed and the player
		-- has pressed Enter again.
		beginEarlyAmusiaEnding()
	end
end

function updateAmusiaDialogue(elapsed)
	if jumpscareShown then
		return
	end

	-- Keep the glitch animation looping after its initial animation.
	if getProperty('amusiaWigglesClose.animation.curAnim.finished')
		and getProperty('amusiaWigglesClose.animation.curAnim.name') == 'glitch' then

		playAnim('amusiaWigglesClose', 'loop', true)
	end

	if not dialogueActive then
		return
	end

	-- Typewriter effect.
	if dialogueLetter <= #dialogueText then
		dialogueTimer = dialogueTimer + elapsed

		while dialogueTimer >= 0.06 and dialogueLetter <= #dialogueText do
			visibleDialogue = visibleDialogue .. dialogueText:sub(dialogueLetter, dialogueLetter)
			dialogueLetter = dialogueLetter + 1
			dialogueTimer = dialogueTimer - 0.06
		end

		setTextString('amusiaDialogueText', visibleDialogue)
	end

	-- Question selection.
	if questionActive and (keyJustPressed('up') or keyJustPressed('down')) then
		selectedAnswer = selectedAnswer == 1 and 2 or 1

		setProperty(
			'amusiaSelector.y',
			selectedAnswer == 1 and 540 or 570
		)

		playSound('scrollMenu', 0.6)
	end

	-- Advance dialogue.
	if keyJustPressed('accept') then
		advanceAmusiaDialogue()
	end
end

function onTimerCompleted(tag)
	if tag == 'amusiaEarlyJumpscare' or tag == 'amusiaForcedJumpscare' then
		showAmusiaJumpscare()
	elseif tag == 'amusiaFinish' then
		setProperty('camOther.visible', false)
		endSong()
	end
end

function onPause()
	if dialogueActive or endingStarted then
		return Function_Stop
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
	if not endingStarted then
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
			doTweenX('chromUp', 'chromaticController', 20, 0.677, 'cubeIn')
			doTweenX('pincUp', 'pincushionController', 0.5, 0.677, 'cubeIn')
			doTweenAlpha('staticIn', 'static', 0.25, 0.5, 'linear')
			doTweenAlpha('redIn', 'redStatic', 0.25, 0.5, 'linear')
		end

		if curStep == 736 then
			cancelTween('chromUp')
			cancelTween('pincUp')
			setProperty('chromaticController.x', 0)
			setProperty('pincushionController.x', 0)
			doTweenAlpha('staticOut', 'static', 0.05, 0.1, 'linear')
		end

		if curStep == 791 then
			doTweenX('dadSlideRight', 'dadGroup', getProperty('dadGroup.x') + 1100, 0.75, 'circIn')

			doTweenX('bfSlideLeft', 'boyfriendGroup', getProperty('boyfriend.x') - 1100, 0.75, 'circIn')

			doTweenX('plateLright', 'plateL', getProperty('plateL.x') + 1100, 0.75, 'circIn')

			doTweenX('plateRleft', 'plateR', getProperty('plateR.x') - 1100, 0.75, 'circIn')

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
			setProperty('dadGroup.x', 60)
			setProperty('dadGroup.y', 482)

			setProperty('boyfriendGroup.x', 1640)
			setProperty('boyfriendGroup.y', 680)

			doTweenX(
				'dadSlideBack',
				'dadGroup',
				getProperty('dadGroup.x') + 1100,
				0.75,
				'quartOut'
			)

			doTweenX(
				'bfSlideBack',
				'boyfriendGroup',
				getProperty('boyfriendGroup.x') - 1100,
				0.75,
				'quartOut'
			)

			doTweenX(
				'plateLback',
				'plateL',
				getProperty('plateL.x') - 1100,
				0.75,
				'quartOut'
			)

			doTweenX(
				'plateRback',
				'plateR',
				getProperty('plateR.x') + 1100,
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