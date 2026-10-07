-- i hate this fucking script ;-;

local scale = 3

function onCreate()
    if not middlescroll then
		makeAnimatedLuaSprite('bhudleft', 'UI/pixel/buried_hud', 0, 50)
		addAnimationByPrefix('bhudleft', 'idle', 'left', 1, false)
		setObjectCamera('bhudleft', 'hud')
		scaleObject('bhudleft', 3, 3)
		setProperty('bhudleft.antialiasing', false)
		addLuaSprite('bhudleft')

		makeAnimatedLuaSprite('bhudright', 'UI/pixel/buried_hud', 0, 525)
		addAnimationByPrefix('bhudright', 'idle', 'right', 1, false)
		setObjectCamera('bhudright', 'hud')
		scaleObject('bhudright', 3, 3)
		setProperty('bhudright.antialiasing', false)
		setProperty('bhudright.x', screenWidth - getProperty('bhudright.width'))
		addLuaSprite('bhudright')

		makeLuaSprite('hpBarLeft', 'UI/pixel/brimstone_healthbar', getProperty('bhudleft.x') + 128.8, getProperty('bhudleft.y') + 143.9)
		setObjectCamera('hpBarLeft', 'hud')
		setProperty('hpBarLeft.antialiasing', false)
		addLuaSprite('hpBarLeft')

		makeLuaSprite('hpBarRight', 'UI/pixel/brimstone_healthbar', getProperty('bhudright.x') + 236.9, getProperty('bhudright.y') + 144)
		setObjectCamera('hpBarRight', 'hud')
		setProperty('hpBarRight.antialiasing', false)
		addLuaSprite('hpBarRight')
	else
		makeLuaSprite('bhud', 'UI/pixel/buried_center', 0, 50)
		setObjectCamera('bhud', 'hud')
		scaleObject('bhud', 3, 3)
		setProperty('bhud.antialiasing', false)
		screenCenter('bhud', 'x')
		if not downscroll then
			setProperty('bhud.y', 50)
		else
			setProperty('bhud.y', 515)
		end
		addLuaSprite('bhud')

		makeLuaSprite('hpBarMiddle', 'UI/pixel/brimstone_healthbar', getProperty('bhud.x') + 233.8, getProperty('bhud.y') + 143.9)
		setObjectCamera('hpBarMiddle', 'hud')
		setProperty('hpBarMiddle.antialiasing', false)
		addLuaSprite('hpBarMiddle')
	end
end

function onCreatePost()
    -- ensue the note scaling/positioning spaghetti
	for i = 0, getProperty('opponentStrums.length') - 1 do
		if getPropertyFromGroup('opponentStrums', i, 'texture') == 'noteSkins/NOTE_assets-buried' then
			setPropertyFromGroup('opponentStrums', i, 'scale.x', scale)
			setPropertyFromGroup('opponentStrums', i, 'scale.y', scale)
		end
		if not middlescroll then
			if not downscroll then
				setPropertyFromGroup('opponentStrums', i, 'y', 500)
			else
				setPropertyFromGroup('opponentStrums', i, 'y', 24)
			end
		else
			for i = 0, getProperty('opponentStrums.length') - 1 do
				if getPropertyFromGroup('opponentStrums', i, 'texture') == 'noteSkins/NOTE_assets-buried' then
					setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] - 35)
					setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] - 35)

					if not downscroll then
						setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 25)
						setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 25)
					else	
						setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 80)
						setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 80)
					end
				end
			end
		end
	end
	for i = 0, getProperty('playerStrums.length') - 1 do
		if getPropertyFromGroup('playerStrums', i, 'texture') == 'noteSkins/NOTE_assets-buried' then
			setPropertyFromGroup('playerStrums', i, 'scale.x', scale)
			setPropertyFromGroup('playerStrums', i, 'scale.y', scale)
		end
	end

	-- swap strum positions
	if not middlescroll then
		if not downscroll then
			for i = 0,getProperty('opponentStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i] - 150)
				setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 85)
			end
			for i = 0,getProperty('playerStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 25)
			end
		else
			for i = 0,getProperty('opponentStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 80)
				setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] - 150)
			end
			for i = 0,getProperty('playerStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 70)
			end
		end
	end

	if not middlescroll then
		if playsAsBF() then
			if not downscroll then
				for i = 0, getProperty('opponentStrums.length') - 1 do
					setPropertyFromGroup('opponentStrums', i, 'downScroll', true)
				end
			else
				for i = 0, getProperty('opponentStrums.length') - 1 do
					setPropertyFromGroup('opponentStrums', i, 'downScroll', false)
				end
			end
		else
			if not downscroll then
				for i = 0, getProperty('playerStrums.length') - 1 do
					setPropertyFromGroup('playerStrums', i, 'downScroll', true)
				end
			else
				for i = 0, getProperty('playerStrums.length') - 1 do
					setPropertyFromGroup('playerStrums', i, 'downScroll', false)
				end
			end
		end
	end

	if downscroll then
		setProperty('scoreTxt.y', 5)
	end

	if middlescroll then
		if playsAsBF() then
			compactStrums('playerStrums')
		else
			compactStrums('opponentStrums')
		end
	else
		compactStrums('playerStrums')
		compactStrums('opponentStrums')
	end

	-- Hack fix: swap final strum positions when playing as the opponent.
	if not playsAsBF() and not middlescroll then
		local playerX = {}
		local playerY = {}
		local opponentX = {}
		local opponentY = {}

		for i = 0, getProperty('playerStrums.length') - 1 do
			playerX[i] = getPropertyFromGroup('playerStrums', i, 'x')
			playerY[i] = getPropertyFromGroup('playerStrums', i, 'y')
		end

		for i = 0, getProperty('opponentStrums.length') - 1 do
			opponentX[i] = getPropertyFromGroup('opponentStrums', i, 'x')
			opponentY[i] = getPropertyFromGroup('opponentStrums', i, 'y')
		end

		for i = 0, math.min(getProperty('playerStrums.length'), getProperty('opponentStrums.length')) - 1 do
			setPropertyFromGroup('playerStrums', i, 'x', opponentX[i])
			setPropertyFromGroup('playerStrums', i, 'y', opponentY[i])
			setPropertyFromGroup('opponentStrums', i, 'x', playerX[i])
			setPropertyFromGroup('opponentStrums', i, 'y', playerY[i])
		end
	end
    
    setProperty('healthBar.visible', false)
    setProperty('iconP2.visible', false)
    setProperty('iconP1.visible', false)
end

function onSpawnNote(a, id, c, sustain) -- no onUpdate bullshit! efficiency baby!!!
    --debugPrint(a..' '..id..' '..c)

    local n = 'notes.members[' .. a .. ']'
	
    if sustain then
        setProperty(n..'.scale.x', scale)
        setProperty(n..'.offset.x', -55)
        setProperty(n..'.offset.y', -90)

        -- Flip opponent sustains.
		if not middlescroll then
			if playsAsBF() then
				if not getPropertyFromGroup('notes', a, 'mustPress') then
					if not downscroll then
						setProperty(n..'.flipY', true)
					else
						setProperty(n..'.flipY', false)
					end
				end
			else
				if getPropertyFromGroup('notes', a, 'mustPress') then
					if not downscroll then
						setProperty(n..'.flipY', true)
					else
						setProperty(n..'.flipY', false)
					end
				end
			end
		end
    else
        scaleObject(n, scale, scale, false)
    end
end

local strumSpacing = 95 -- Smaller = more compact

function compactStrums(group)
	local count = getProperty(group .. '.length')
	if count <= 1 then return end

	local firstX = getPropertyFromGroup(group, 0, 'x')
	local lastX = getPropertyFromGroup(group, count - 1, 'x')

	local centerX = (firstX + lastX) / 2

	for i = 0, count - 1 do
		local offset = (i - (count - 1) / 2) * strumSpacing
		setPropertyFromGroup(group, i, 'x', centerX + offset)
	end
end

function onUpdatePost()
	if middlescroll then
		if playsAsBF() then -- TIL that scaleObject preserves the top-left origin point and scale.x/y doesn't
			scaleObject('hpBarMiddle', getProperty('health') / 2, 1)
		else
			scaleObject('hpBarMiddle', 1 - (getProperty('health') / 2), 1)
		end
	else
		if playsAsBF() then
			if not downscroll then
				scaleObject('hpBarLeft', getProperty('health') / 2, 1)
				scaleObject('hpBarRight', 1 - (getProperty('health') / 2), 1)
			else
				scaleObject('hpBarRight', getProperty('health') / 2, 1)
				scaleObject('hpBarLeft', 1 - (getProperty('health') / 2), 1)
			end
		else
			if not downscroll then
				scaleObject('hpBarLeft', 1 - getProperty('health') / 2, 1)
				scaleObject('hpBarRight', (getProperty('health') / 2), 1)
			else
				scaleObject('hpBarRight', 1 - getProperty('health') / 2, 1)
				scaleObject('hpBarLeft', (getProperty('health') / 2), 1)
			end
		end
	end
end

function goodNoteHit()
	fixSplashes()
end

function opponentNoteHit()
	fixSplashes()
end

function fixSplashes()
	for i = 0, getProperty('grpNoteSplashes.length')-1 do
       setPropertyFromGroup('grpNoteSplashes', i, 'scale.x', 0.75)
	   setPropertyFromGroup('grpNoteSplashes', i, 'scale.y', 0.75)

	   setPropertyFromGroup('grpNoteSplashes', i, 'offset.x', -55)
	   setPropertyFromGroup('grpNoteSplashes', i, 'offset.y', -40)
    end
end