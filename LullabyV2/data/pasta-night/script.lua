-- 0 = MX
-- 1 = Lord X
-- 2 = Hypno
pastaPlayer = 1

local allowCountdown = false

-- Character selector
local Selectin = true
local SelecterCharacters = {'MX', 'LordX', 'Hypno'}
local curSelect = pastaPlayer + 1
local totalElapsed = 0
local canSelecter = true

function onCreate()
	if pastaPlayer ~= 2 then
		addLuaScript('pendulum')
	end

	setVar('pastaPlayer', pastaPlayer)
end

function setupPastaPlayer()
	-- Update the shared variable after selection.
	setVar('pastaPlayer', pastaPlayer)

	removeLuaScript('scripts/camFollow')

	if pastaPlayer == 1 then
		if not middleScroll then
			for i = 0, getProperty('playerStrums.length') - 1 do
				setPropertyFromGroup(
					'playerStrums',
					i,
					'x',
					_G['defaultPlayerStrumX' .. i] - 320
				)
			end

			for i = 0, getProperty('opponentStrums.length') - 1 do
				setPropertyFromGroup(
					'opponentStrums',
					i,
					'x',
					_G['defaultOpponentStrumX' .. i] + 320
				)
			end
		end
	end

	if pastaPlayer == 0 then
		for i = 0, getProperty('playerStrums.length') - 1 do
			setPropertyFromGroup(
				'playerStrums',
				i,
				'x',
				_G['defaultOpponentStrumX' .. i]
			)
		end

	elseif pastaPlayer == 2 then
		for i = 0, getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup(
				'opponentStrums',
				i,
				'x',
				_G['defaultPlayerStrumX' .. i]
			)
		end
	end

	if not playsAsBF() and not pastaPlayer == 0 or playsAsBF() and pastaPlayer == 0 then
		triggerEvent('Change Character', 'dad', 'pasta-hypno-flip')
		triggerEvent('Change Character', 'bf', 'MX-flip')

		setProperty('dad.x', defaultBoyfriendX)
		setProperty('dad.y', defaultBoyfriendY)
		setProperty('boyfriend.x', defaultOpponentX)
		setProperty('boyfriend.y', defaultOpponentY)
	else
		triggerEvent('Change Character', 'dad', 'MX')
		triggerEvent('Change Character', 'bf', 'pasta-hypno')
	end

	if pastaPlayer == 1 then
		if playsAsBF() then
			triggerEvent('Change Character', 'gf', 'pasta-hypno-flip-gf')
			triggerEvent('Change Character', 'bf', 'lord-x-flip')

			setObjectOrder('gfGroup', getObjectOrder('gfGroup') - 1)
			setObjectOrder('boyfriendGroup', getObjectOrder('boyfriendGroup') + 3)

			setProperty('gf.x', defaultBoyfriendX)
			setProperty('gf.y', defaultBoyfriendY)
			setProperty('boyfriend.x', defaultGirlfriendX)
			setProperty('boyfriend.y', defaultGirlfriendY)

		else
			triggerEvent('Change Character', 'gf', 'pasta-hypno-flip-gf')
			triggerEvent('Change Character', 'bf', 'MX-gf')
			triggerEvent('Change Character', 'dad', 'lord-x')

			setObjectOrder('gfGroup', getObjectOrder('gfGroup') - 1)
			setObjectOrder('dadGroup', getObjectOrder('dadGroup') + 3)

			setProperty('gf.x', defaultBoyfriendX)
			setProperty('gf.y', defaultBoyfriendY)
			setProperty('boyfriend.x', defaultOpponentX)
			setProperty('boyfriend.y', defaultOpponentY)
			setProperty('dad.x', defaultGirlfriendX)
			setProperty('dad.y', defaultGirlfriendY)
		end
	end

	if not playsAsBF() then
		for i = 0, getProperty('playerStrums.length') - 1 do
			setPropertyFromGroup('playerStrums', i, 'x', -5000)
		end
	else
		for i = 0, getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', 5000)
		end
	end

	for i = 0, getProperty('unspawnNotes.length') - 1 do
		local noteType = getPropertyFromGroup('unspawnNotes', i, 'noteType')

		local isMX = noteType == 'MX Sing'
		local isLordX = noteType == 'Lord X Sing'
		local isHypno = noteType == 'Hypno Sing'

		if pastaPlayer == 0 then
			-- MX = PLAYER
			if isMX then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', true)

			-- Lord X = OPPONENT + GF Sing
			elseif isLordX then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', false)
				setPropertyFromGroup('unspawnNotes', i, 'noteType', 'GF Sing')

			-- Hypno = OPPONENT
			elseif isHypno then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', false)
			end

		elseif pastaPlayer == 1 then
			-- MX = OPPONENT
			if isMX then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', false)

			-- Lord X = PLAYER + normal note
			elseif isLordX then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', true)
				setPropertyFromGroup('unspawnNotes', i, 'noteType', '')

			-- Hypno = OPPONENT + GF Sing
			elseif isHypno then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', false)
				setPropertyFromGroup('unspawnNotes', i, 'noteType', 'GF Sing')
			end

		elseif pastaPlayer == 2 then
			-- MX = OPPONENT
			if isMX then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', false)

			-- Lord X = OPPONENT + GF Sing
			elseif isLordX then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', false)
				setPropertyFromGroup('unspawnNotes', i, 'noteType', 'GF Sing')

			-- Hypno = PLAYER
			elseif isHypno then
				setPropertyFromGroup('unspawnNotes', i, 'mustPress', true)
			end
		end

		-- Multiplayer / opponent-player mode.
		if not playsAsBF() and (isMX or isLordX or isHypno) then
			local mustPress = getPropertyFromGroup(
				'unspawnNotes',
				i,
				'mustPress'
			)

			setPropertyFromGroup(
				'unspawnNotes',
				i,
				'mustPress',
				not mustPress
			)
		end
	end
end

--------------------------------------------------
-- CHARACTER SELECTOR
--------------------------------------------------

function onStartCountdown()
	if Selectin then
		startCharacterSelector()
		return Function_Stop
	end

	if not allowCountdown then
		allowCountdown = true
		return Function_Continue
	end

	return Function_Continue
end

function startCharacterSelector()
	Selectin = true
	canSelecter = true
	totalElapsed = 0

	playMusic('PastaNightSelect', 1, true)

	setProperty('camGame.visible', false)
	setProperty('camHUD.visible', false)

	-- Selector uses camOther.
	setProperty('camOther.visible', true)

	-- Background
	makeLuaSprite('bg', 'UI/base/pasta/PastaSelect_BG')
	scaleObject('bg', 3, 3)
	setProperty('bg.antialiasing', false)

	setProperty(
		'bg.x',
		screenWidth / 2 - getProperty('bg.width') / 2
	)

	setProperty(
		'bg.y',
		screenHeight / 2 - getProperty('bg.height') / 2
	)

	setObjectCamera('bg', 'other')
	addLuaSprite('bg', true)

	-- Characters
	local DisplacementList = {-4, 2, 0}

	for i = 1, #SelecterCharacters do
		for j = 1, 3 do
			local tag = SelecterCharacters[i] .. j

			makeLuaSprite(
				tag,
				'UI/base/pasta/PastaSelect_'
					.. SelecterCharacters[i]
					.. '_0'
					.. tostring(j)
			)

			if j == 2 then
				setProperty(tag .. '.visible', false)
			end

			scaleObject(tag, 3, 3, false)
			setProperty(tag .. '.antialiasing', false)

			setProperty(
				tag .. '.x',
				getProperty('bg.x')
				+ getProperty('bg.width') / 2
				- getProperty(tag .. '.width') / 2
			)

			setProperty(
				tag .. '.y',
				(176 * 3)
				- getProperty(tag .. '.height')
				+ (DisplacementList[i] * 3)
			)

			setProperty(
				tag .. '.x',
				math.floor(
					getProperty(tag .. '.x')
					+ (i - 2) * (3 * 45)
					+ 3
				)
			)

			setObjectCamera(tag, 'other')
			addLuaSprite(tag, true)
		end
	end

	-- Arrow
	makeLuaSprite(
		'Arrow',
		'UI/base/pasta/PastaSelect_Arrow',
		0,
		124 * 3
	)

	scaleObject('Arrow', 3, 3, false)
	setProperty('Arrow.antialiasing', false)

	setObjectCamera('Arrow', 'other')
	addLuaSprite('Arrow', true)

	updateSelection(curSelect)
end

function onUpdate(elapsed)
	if Selectin then
		totalElapsed = totalElapsed + elapsed

		if keyJustPressed('left') then
			updateSelection(curSelect - 1)
		end

		if keyJustPressed('right') then
			updateSelection(curSelect + 1)
		end

		if keyJustPressed('accept') then
			canSelecter = false

			setProperty(
				SelecterCharacters[curSelect] .. '3.visible',
				false
			)

			setProperty(
				SelecterCharacters[curSelect] .. '2.visible',
				true
			)

			setProperty(
				SelecterCharacters[curSelect] .. '1.visible',
				false
			)

			runTimer('StartingSong', 0.5)
		end
	end
end

function updateSelection(pos)
	if canSelecter and curSelect ~= pos then
		if pos > #SelecterCharacters then
			pos = 1
		elseif pos < 1 then
			pos = #SelecterCharacters
		end

		curSelect = pos

		for i = 1, #SelecterCharacters do
			setProperty(
				SelecterCharacters[i] .. '3.visible',
				true
			)
		end

		setProperty(
			SelecterCharacters[curSelect] .. '3.visible',
			false
		)

		local position =
			getProperty(
				SelecterCharacters[curSelect] .. '1.x'
			)
			+ getProperty(
				SelecterCharacters[curSelect] .. '1.width'
			) / 2
			- getProperty('Arrow.width') / 2

		if curSelect == 3 then
			position = position - 12
		end

		setProperty('Arrow.x', position)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'StartingSong' then
		soundFadeOut('', 0.0001, 0)

		setProperty(
			SelecterCharacters[curSelect] .. '2.visible',
			false
		)

		setProperty(
			SelecterCharacters[curSelect] .. '1.visible',
			true
		)

		-- 1 = MX
		-- 2 = Lord X
		-- 3 = Hypno
		pastaPlayer = curSelect - 1

		if pastaPlayer ~= 2 then
			addLuaScript('pendulum')
		end

		setupPastaPlayer()

		Selectin = false

		-- Remove selector objects.
		removeLuaSprite('bg', true)
		removeLuaSprite('Arrow', true)

		for i = 1, #SelecterCharacters do
			for j = 1, 3 do
				removeLuaSprite(
					SelecterCharacters[i] .. j,
					true
				)
			end
		end

		-- Make sure the selector camera is gone visually.
		setProperty('camOther.visible', false)

		runTimer('StartPastaSong', 0.5)
	end

	if tag == 'StartPastaSong' then
		setProperty('camGame.visible', true)
		setProperty('camHUD.visible', true)
		setProperty('camOther.visible', true)

		startCountdown()
	end
end

--------------------------------------------------
-- EVENTS
--------------------------------------------------

function onEvent(name, value1, value2)
	debugPrint(
		'name: ' .. value1
		.. ' value1: ' .. value1
		.. ' value2: ' .. value2
	)

	if name == 'Pasta Camera' then
		if value1 == '-1' then
			triggerEvent(
				'Camera Follow Pos',
				'290',
				'500'
			)

		elseif value1 == '' then
			triggerEvent(
				'Camera Follow Pos',
				'600',
				'500'
			)

		elseif value1 == '1' then
			triggerEvent(
				'Camera Follow Pos',
				'850',
				'500'
			)
		end
	end
end