-- 0 = MX
-- 1 = Lord X
-- 2 = Hypno
local pastaPlayer = 2

function onCreatePost()
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
	end
end