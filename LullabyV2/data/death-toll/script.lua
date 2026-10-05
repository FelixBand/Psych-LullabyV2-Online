local opponentLaneMap = {0, 1, 3, 4}

local centerShift = 80
local rightShift = 50
local centerDown = 20

function remapOpponentStrums()
	local leftX = getPropertyFromGroup('opponentStrums', 0, 'x')
	local rightX = getPropertyFromGroup('opponentStrums', 4, 'x')

	local spacing = (rightX - leftX) / 4
	local centerX = (leftX + rightX) / 2

	for lane = 0, 3 do
		local strum = opponentLaneMap[lane + 1]

		setPropertyFromGroup(
			'opponentStrums',
			strum,
			'x',
			centerX + (lane - 1.5) * spacing
		)
	end
end

function setupStrums()
	if getProperty('playerStrums.length') ~= 5 then
		return
	end

	-- Swap strum positions
	if not middlescroll then
		for i = 0, getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup(
				'playerStrums',
				i,
				'x',
				_G['defaultOpponentStrumX' .. i]
			)

			setPropertyFromGroup(
				'opponentStrums',
				i,
				'x',
				_G['defaultPlayerStrumX' .. i]
			)
		end

		-- Move center to the right.
		setPropertyFromGroup(
			'playerStrums',
			2,
			'x',
			getPropertyFromGroup('playerStrums', 2, 'x') + centerShift
		)

		-- Move UP and RIGHT further right.
		for i = 3, 4 do
			setPropertyFromGroup(
				'playerStrums',
				i,
				'x',
				getPropertyFromGroup('playerStrums', i, 'x')
					+ centerShift
					+ rightShift
			)
		end
	else
		-- Middlescroll
		for i = 0, 1 do
			setPropertyFromGroup(
				'playerStrums',
				i,
				'x',
				getPropertyFromGroup('playerStrums', i, 'x') - centerShift
			)
		end

		-- Center
		setPropertyFromGroup(
			'playerStrums',
			2,
			'x',
			getPropertyFromGroup('playerStrums', 2, 'x') + 20
		)

		-- UP/RIGHT
		for i = 3, 4 do
			setPropertyFromGroup(
				'playerStrums',
				i,
				'x',
				getPropertyFromGroup('playerStrums', i, 'x') + centerShift
			)
		end
	end

	if playsAsBF() then
		for i = 0, getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', -5000)
		end
	else
		remapOpponentStrums()

		setPropertyFromGroup(
			'opponentStrums',
			2,
			'x',
			-5000
		)
	end

	setPropertyFromGroup(
		'playerStrums',
		2,
		'y',
		getPropertyFromGroup('playerStrums', 2, 'y') + centerDown
	)

	if getProperty('playerStrums.length') == 5 then -- if 5 key

		setPropertyFromGroup('playerStrums', 2, 'useRGBShader', false)

		-- Disable RGB shader on the player's special center lane.

        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress')
                and getPropertyFromGroup('unspawnNotes', i, 'noteData') == 2 then

				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
				setPropertyFromGroup('unspawnNotes', i, "missHealth", 0.25)

                -- Disable the note RGB shader.
                setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false)

                -- Disable note splash completely.
                setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.disabled', true)

                -- Disable RGB on the splash too.
                setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.useRGBShader', false)
            end

			-- Beelze plays his alt animations from this point onward
			if getPropertyFromGroup('unspawnNotes', i, 'strumTime') >= 102127 and not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
				setPropertyFromGroup('unspawnNotes', i, 'noteType', 'Alt Animation')
			end
        end
	end
	doTweenAlpha('hudFadeIn', 'camHUD', 1, 0.5, 'linear')
end

local allowCountdown = false

function onStartCountdown()
	if not allowCountdown then
		allowCountdown = true

		return Function_Stop
	end

	runTimer('FUCKING RUN THE FUCKING CODE BRO??', 0.01)
	return Function_Continue
end

function onCreate()
	makeLuaSprite('whiteFlash', '', 0, 0)
	makeGraphic('whiteFlash', screenWidth, screenHeight, 'FFFFFF')
	setObjectCamera('whiteFlash', 'hud')
	setProperty('whiteFlash.alpha', 0)
	addLuaSprite('whiteFlash')

	makeLuaSprite('ds', 'UI/base/hellbell/ds_01', 0, 0)
	scaleObject('ds', (screenWidth / 1920) + 0.05, (screenHeight / 1080) + 0.05)
	setObjectCamera('ds', 'other')
	screenCenter('ds', 'xy')
	addLuaSprite('ds')

	makeLuaSprite('dsgradient', 'UI/base/hellbell/dsgradient', 229, 133)
	scaleObject('dsgradient', 0.63, 0.635)
	setObjectCamera('dsgradient', 'other')
	setProperty('dsgradient.color', '000000')
	addLuaSprite('dsgradient')

	makeLuaSprite('bfReflection', 'UI/base/hellbell/ds_03', 0, 0)
	scaleObject('bfReflection', (screenWidth / 1920) + 0.05, (screenHeight / 1080) + 0.05)
	setObjectCamera('bfReflection', 'other')
	screenCenter('bfReflection', 'xy')
	setProperty('bfReflection.alpha', 0.0001)
	addLuaSprite('bfReflection')

	makeAnimatedLuaSprite('bimbembo', 'UI/base/hellbell/bimbembo', 315, 130)
	addAnimationByPrefix('bimbembo', 'intro', 'dsintro', 24, false)
	scaleObject('bimbembo', 0.7, 0.7)
	setObjectCamera('bimbembo', 'other')
	setProperty('bimbembo.alpha', 0.0001)
	addLuaSprite('bimbembo')

	runTimer('dsIntro', 1)
end

function onCreatePost()
	setProperty('camHUD.zoom', 0.6)
	setProperty('camGame.zoom', 0.55)
	setProperty('camHUD.alpha', 0.0001)
	setProperty('gfGroup.alpha', 0.0001)
	setObjectOrder('gfGroup', getObjectOrder('boyfriendGroup') + 1)
	setProperty('healthBar.flipX', true)
	setProperty('camFollowPos.x', 1000)
	setProperty('camFollowPos.y', 500)
end

function onSpawnNote(id) -- Disable RGB shader on middle lane
	if getPropertyFromGroup('notes', id, 'mustPress')
		and getPropertyFromGroup('notes', id, 'noteData') == 2 then

		setPropertyFromGroup('notes', id, 'rgbShader.enabled', false)
		setPropertyFromGroup('notes', id, 'noteSplashData.disabled', true)
		setPropertyFromGroup('notes', id, 'noteSplashData.useRGBShader', false)
	end
end

function onUpdatePost() -- Flip healthbar logic
    setProperty('iconP1.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') *        getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26) - 110)
    setProperty('iconP1.origin.x',240)
    setProperty('iconP1.flipX',true)
    setProperty('iconP2.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2) + 110)
    setProperty('iconP2.origin.x',-100)
    setProperty('iconP2.flipX',true)
end

local singAlt = false
local bfIdle = ''

function goodNoteHit(id, direction, noteType, isSustainNote) -- this whole system for manually animating p3 could've been entirely avoided if there was a note type for BF and GF to sing simultaneously
	if noteType == 'Bell' then
		singAlt = true
		bfIdle = '-alt'
		runTimer('bell', 0.5)
		if not isSustainNote then
			triggerEvent('Play Animation', 'cover', 'bf')
			triggerEvent('Play Animation', 'cover', 'gf')
		end
		triggerEvent('Alt Idle Animation', 'bf', '-alt')
	end

	if noteType ~= 'Bell' then
		if singAlt then -- Play alt animations (covering ears) when hitting Bell notes
			triggerEvent('Play Animation', getProperty('singAnimations')[direction+1] .. '-alt', 'bf')
			triggerEvent('Play Animation', getProperty('singAnimations')[direction+1] .. '-alt', 'gf')
		else
			triggerEvent('Play Animation', getProperty('singAnimations')[direction+1], 'gf')
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'dsIntro' then
		setProperty('dsgradient.color', getColorFromHex('FFFFFF'))
		setProperty('bimbembo.alpha', 1)
		playAnim('bimbembo', 'intro', true)
		playSound('bimbembo', 1)
		runTimer('dsFadeOut', 3)
	end
	if tag == 'dsFadeOut' then
		doTweenAlpha('bimbemboOut', 'bimbembo', 0, 0.75, 'linear')
		doTweenAlpha('gradientOut', 'dsgradient', 0, 0.75, 'linear')
		runTimer('startSong', 1)
	end
	if tag == 'startSong' then
		startCountdown()
		doTweenX('dsInX', 'ds.scale', getProperty('ds.scale.x') + 0.45, 1.5, 'backIn')
		doTweenY('dsInY', 'ds.scale', getProperty('ds.scale.y') + 0.45, 1.5, 'backIn')
		doTweenZoom('hudIn', 'camHUD', 1, 1.5, 'backIn')
		doTweenZoom('gameIn', 'camGame', 0.75, 1.5, 'backIn')
	end
	if tag == 'FUCKING RUN THE FUCKING CODE BRO??' then
		setupStrums()
	end
	if tag == 'bell' then
		singAlt = false
		triggerEvent('Alt Idle Animation', 'bf', '')
		bfIdle = ''
	end
	if tag == 'hellBellIdle' then
		playAnim('hellBell', 'idle', true)
	end
end

-- "boyfriend" is actually Dawn and "gf" is actually Boyfriend

local contractProgress = 0

function onEvent(name, value1, value2)
	if name == 'Bong' then
		playAnim('hellBell', 'bong', true)
		cameraShake('game', 0.015, 0.35)
		runTimer('hellBellIdle', 0.5)
	end
	if name == "Beelze Walk" then
		triggerEvent('Alt Idle Animation', 'dad', '-disabled')
		playAnim('dad', 'Walk', true)
	end
	if name == "Contract Appear" then
		setProperty('ContractBF.alpha', 1)
	end
	if name == "Contract Advance" then
		contractProgress = contractProgress + 1
		playAnim('ContractBF', contractProgress)
		debugPrint(contractProgress)
		if contractProgress == 10 then
			setProperty('ContractBF.color', getColorFromHex('FF0000'))
			doTweenX('contractXscale', 'ContractBF.scale', 0, 1, 'backIn')
			doTweenY('contractYscale', 'ContractBF.scale', 0, 1, 'backIn')
			doTweenAlpha('contractAlphaOut', 'ContractBF', 0, 1, 'backIn')
		end
	end
	if name == "Dawn Transform" then
		triggerEvent('Change Character', 'bf', 'dawn-fading')
		playAnim('bf', 'transmorph', true)
	end
	if name == 'Set Health Icon' then
		if value1 == '2' then
			setHealthBarColors('7E5D91', '31B0D1')
		end
	end
	if name == 'HB Ending' then
		doTweenAlpha('hudOut', 'camHUD', 0, 1, 'linear')
		doTweenZoom('gameOut', 'camGame', 0.4, 3, 'cubeOut')
		doTweenX('dsOutX', 'ds.scale', (screenWidth / 1920) + 0.05, 3, 'cubeOut')
		doTweenY('dsOutY', 'ds.scale', (screenHeight / 1080) + 0.05, 3, 'cubeOut')
	end
	if name == 'DS off' then
		setProperty('dsgradient.color', '000000')
		doTweenAlpha('gameFadeOut', 'dsgradient', 1, 1, 'linear')
		playSound('bimbembooff', 1)
	end
end

function onTweenCompleted(tag)
    if tag == 'gameFadeOut' then
        doTweenAlpha('bfRefIn', 'bfReflection', 0.2, 2, 'linear')
    end
end

function onBeatHit()
	if flashingLights then
		if curBeat == 60 or curBeat == 62 then
			setProperty('whiteFlash.alpha', 0.5)
			doTweenAlpha('flashOut', 'whiteFlash', 0, 0.5, 'linear')
		end
		if curBeat == 64 then
			setProperty('whiteFlash.alpha', 1)
			doTweenAlpha('flashOut', 'whiteFlash', 0, 1, 'linear')
		end
	end
end

function onUpdate(elapsed)
	local fadeProgress = contractProgress * contractProgress / 100
	if contractProgress > 4 then
		fadeProgress = fadeProgress + math.sin((getSongPosition() / (stepCrochet * 16)) * math.pi) * (contractProgress / 10) * 0.25
	end
	if contractProgress > 9 then
		fadeProgress = 1
	end
	fadeProgress = math.max(0, math.min(1, fadeProgress))
	setProperty('boyfriend.alpha', 1 - fadeProgress)
	setProperty('gfGroup.alpha', fadeProgress)
	setProperty('ContractBF.y', getCharacterY('dad') + 115 + math.sin(((getSongPosition() - 103404.255319149) / 2500) * math.pi) * 10)

	if curBeat > 582 or curBeat < 7 then
		setProperty('camZooming', false)
	end
end