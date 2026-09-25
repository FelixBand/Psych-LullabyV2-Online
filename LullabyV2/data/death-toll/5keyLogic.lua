--[[

I'd prefer to keep this spaghetti in a seperate script LMAO
This fucking sucks

]]

local opponentLaneMap = {0, 1, 3, 4}

function remapOpponentStrums()
	local leftX = getPropertyFromGroup('opponentStrums', 0, 'x')
	local rightX = getPropertyFromGroup('opponentStrums', 4, 'x')

	local spacing = (rightX - leftX) / 4
	local centerX = (leftX + rightX) / 2

	-- Hide the unused center lane.
	setPropertyFromGroup('opponentStrums', 2, 'visible', false)
	setPropertyFromGroup('opponentStrums', 2, 'alpha', 0)

	-- Redistribute the four usable lanes as normal 4K.
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

function onCreatePost()
	if getProperty('playerStrums.length') == 5 then -- if 5 key
		local centerShift = 80
        local rightShift = 50
        local centerDown = 20

		setPropertyFromGroup('playerStrums', 2, 'useRGBShader', false)

        if playsAsBF() then -- Hide opponent notes when playing as P1
            for i = 0,getProperty('opponentStrums.length') - 1 do
                setPropertyFromGroup('opponentStrums', i, 'x', -5000);
            end
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

			-- Move UP and RIGHT slightly further right.
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
            -- Middlescroll:
            -- LEFT/DOWN left, CENTER near middle, UP/RIGHT right.
            for i = 0, 1 do
                setPropertyFromGroup(
                    'playerStrums',
                    i,
                    'x',
                    getPropertyFromGroup('playerStrums', i, 'x') - centerShift
                )
            end

            -- Move the center key slightly right.
            setPropertyFromGroup(
                'playerStrums',
                2,
                'x',
                getPropertyFromGroup('playerStrums', 2, 'x') + 20
            )

            for i = 3, 4 do
                setPropertyFromGroup(
                    'playerStrums',
                    i,
                    'x',
                    getPropertyFromGroup('playerStrums', i, 'x') + centerShift
                )
            end

        end

        -- Turn the opponent side into normal 4K.
		remapOpponentStrums()
        -- Opponent center lane isn't used.
        setPropertyFromGroup('opponentStrums', 2, 'x', -5000);

        setPropertyFromGroup('playerStrums', 2, 'y', getPropertyFromGroup('playerStrums', 2, 'y') + centerDown) -- shift the center key down a tad, because the texture is too high up

		-- Disable RGB shader on the player's special center lane.
        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress')
                and getPropertyFromGroup('unspawnNotes', i, 'noteData') == 2 then

                -- Disable the note RGB shader.
                setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false)

                -- Disable note splash completely.
                setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.disabled', true)

                -- Disable RGB on the splash too.
                setPropertyFromGroup('unspawnNotes', i, 'noteSplashData.useRGBShader', false)
            end
        end
	end
end

function onSpawnNote(id)
	if getPropertyFromGroup('notes', id, 'mustPress')
		and getPropertyFromGroup('notes', id, 'noteData') == 2 then

		setPropertyFromGroup('notes', id, 'rgbShader.enabled', false)
		setPropertyFromGroup('notes', id, 'noteSplashData.disabled', true)
		setPropertyFromGroup('notes', id, 'noteSplashData.useRGBShader', false)
	end
end