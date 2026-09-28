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
	setProperty('healthBar.flipX', true)
	if getProperty('playerStrums.length') == 5 then -- if 5 key
		local centerShift = 80
        local rightShift = 50
        local centerDown = 20

		setPropertyFromGroup('playerStrums', 2, 'useRGBShader', false)

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

		if playsAsBF() then -- Hide opponent notes when playing as P1
            for i = 0,getProperty('opponentStrums.length') - 1 do
                setPropertyFromGroup('opponentStrums', i, 'x', -5000);
            end
		else
			-- Turn the opponent side into normal 4K.
			remapOpponentStrums()
			-- Opponent center lane isn't used.
			setPropertyFromGroup('opponentStrums', 2, 'x', -5000);
        end


        setPropertyFromGroup('playerStrums', 2, 'y', getPropertyFromGroup('playerStrums', 2, 'y') + centerDown) -- shift the center key down a tad, because the texture is too high up

		-- Disable RGB shader on the player's special center lane.
        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress')
                and getPropertyFromGroup('unspawnNotes', i, 'noteData') == 2 then

				setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)

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

function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Bell' then
		singAlt = true
		triggerEvent('Alt Idle Animation', 'bf', '-alt')
		triggerEvent('Alt Idle Animation', 'gf', '-alt')
		runTimer('bell', 0.5)
		if not isSustainNote then
			playAnim('boyfriend', 'cover', true)
			playAnim('gf', 'cover', true)
		end
	end

	playAnim('gf', getProperty('singAnimations')[direction+1], true)

	if singAlt then -- Play alt animations (covering ears) when hitting Bell notes
		if getProperty('boyfriend.animation.curAnim.name') == getProperty('singAnimations')[direction+1] then
			playAnim('boyfriend', getProperty('boyfriend.animation.curAnim.name') .. '-alt', true)
		end
		if getProperty('gf.animation.curAnim.name') == getProperty('singAnimations')[direction+1] then
			playAnim('gf', getProperty('gf.animation.curAnim.name') .. '-alt', true)
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'bell' then
		singAlt = false
		triggerEvent('Alt Idle Animation', 'bf', '')
	end
end