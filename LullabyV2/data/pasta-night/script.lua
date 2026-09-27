-- 0 = MX
-- 1 = Lord X
-- 2 = Hypno
pastaPlayer = 1

function onCreate()
	if pastaPlayer ~= 2 then
		addLuaScript('pendulum')
	end
	setVar('pastaPlayer', pastaPlayer)
end

function onCreatePost()
	removeLuaScript('scripts/camFollow')

	if pastaPlayer == 1 then
		if not middleScroll then
			for i = 0,getProperty('playerStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] - 320);
			end
			for i = 0,getProperty('opponentStrums.length') - 1 do
				setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] + 320);
			end
		end
	end
	if pastaPlayer == 0 then
		for i = 0,getProperty('playerStrums.length') - 1 do
			setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i]);
		end
	elseif pastaPlayer == 2 then
		for i = 0,getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i]);
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
		for i = 0,getProperty('playerStrums.length') - 1 do
			setPropertyFromGroup('playerStrums', i, 'x', -5000);
		end
	else
		for i = 0,getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', 5000);
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
		-- If we're playing as the opponent, swap which side belongs to us.
		if not playsAsBF() and (isMX or isLordX or isHypno) then
			local mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')
			setPropertyFromGroup('unspawnNotes', i, 'mustPress', not mustPress)
		end
	end
end

function onEvent(name, value1, value2)
	debugPrint('name: ' .. name .. ' value1: ' .. value1 .. ' value2: ' .. value2)
	debugPrint('camera')
	if name == 'Pasta Camera' then
		if value1 == '-1' then
			triggerEvent("Camera Follow Pos", "290", "500")
		elseif value1 == '' then
			triggerEvent("Camera Follow Pos", "600", "500")
		elseif value1 == '1' then
			triggerEvent("Camera Follow Pos", "850", "500")
		end
	end
end