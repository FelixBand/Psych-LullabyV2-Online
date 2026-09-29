local isPussy = false

function onCreate()
	initSaveData('HypnosPref')
	isPussy = getDataFromSave('HypnosPref', 'Pussy mode', false)
end

function onEvent(eventName, value1, value2)
	if eventName ~= 'Missingno' then
		return
	end

	-- Shader glitch
	if not lowQuality then
		setShaderFloat('FiltreRef', 'prob', 0.25)
		setShaderFloat('FiltreRef', 'time', getSongPosition() / 1000)
	end

	if isPussy then
		return
	end

	-- Determine which strum group is actually playable.
	local playerGroup

	if playsAsBF() then
		playerGroup = 'playerStrums'
	else
		playerGroup = 'opponentStrums'
	end

	local keyCount = getProperty(playerGroup .. '.length')

	-- Hide the other side.
	local otherGroup

	if playsAsBF() then
		otherGroup = 'opponentStrums'
	else
		otherGroup = 'playerStrums'
	end

	for i = 0, getProperty(otherGroup .. '.length') - 1 do
		setPropertyFromGroup(otherGroup, i, 'alpha', 0)
	end

	-- Random downscroll state for the playable side.
	local isDownscroll = getRandomBool(50)

	for i = 0, keyCount - 1 do
		setPropertyFromGroup(
			playerGroup,
			i,
			'downScroll',
			isDownscroll
		)
	end

	-- Randomize the playable strums.
	for i = 0, keyCount - 1 do

		-- First key gets a completely random starting position.
		if i == 0 then
			local randomX = getRandomInt(100, screenWidth / 3) - 25
			local randomY

			if isDownscroll then
				randomY = getRandomInt(
					screenHeight / 2,
					screenHeight - 200
				)
			else
				randomY = getRandomInt(100, 300)
			end

			setPropertyFromGroup(playerGroup, i, 'x', randomX)
			setPropertyFromGroup(playerGroup, i, 'y', randomY)

		else
			-- Each following key is placed somewhere to the
			-- right of the previous key.
			local previousX = getPropertyFromGroup(
				playerGroup,
				i - 1,
				'x'
			)

			local futureX = getRandomInt(
				previousX + 80,
				previousX + 400
			)

			if futureX > screenWidth - 100 then
				futureX = screenWidth - 100
			end

			local firstY = getPropertyFromGroup(
				playerGroup,
				0,
				'y'
			)

			local randomY = getRandomInt(
				firstY - 100,
				firstY + 100
			)

			setPropertyFromGroup(
				playerGroup,
				i,
				'x',
				futureX
			)

			setPropertyFromGroup(
				playerGroup,
				i,
				'y',
				randomY
			)
		end
	end
end

function onUpdate(elapsed)
	local playableMustPress = playsAsBF()

	for i = 0, getProperty('notes.length') - 1 do
		local mustPress = getPropertyFromGroup('notes', i, 'mustPress')

		if mustPress == playableMustPress
			and getPropertyFromGroup('notes', i, 'isSustainNote') then

			local noteData = getPropertyFromGroup(
				'notes',
				i,
				'noteData'
			)

			local strumGroup = playsAsBF()
				and 'playerStrums'
				or 'opponentStrums'

			setPropertyFromGroup(
				'notes',
				i,
				'flipY',
				getPropertyFromGroup(
					strumGroup,
					noteData,
					'downScroll'
				)
			)
		end
	end
end