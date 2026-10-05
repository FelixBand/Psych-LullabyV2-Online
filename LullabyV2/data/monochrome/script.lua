local playedNoise = false
local celebiNoteCount = 3

function onStartCountdown()
    if not playedNoise then
        playSound('ImDead' .. getRandomInt(1,7), 1)
        runTimer('startsong', 3.5)
        playedNoise = true
        return Function_Stop
    end
    return Function_Continue
end

function onTimerCompleted(tag)
    if tag == 'startsong' then
        startCountdown()
        setProperty('dadGroup.visible', true)
        playAnim('dad', 'fadeIn', true)
        if playsAsBF() then
            for i = 0,getProperty('opponentStrums.length') - 1 do
                setPropertyFromGroup('opponentStrums', i, 'x', -5000)
            end
        end
    end
    if tag == 'spawnCNotes' then
        spawnCelebiNotes()
	end
    if tag == 'celebiNotesFadeOut' then
        for i = 1, celebiNoteCount do
            doTweenAlpha('CnoteOut' .. i, 'celebiNote'..i, 0, 1, 'linear')
        end
	end
end

function onCreate()
    setProperty('skipCountdown', true)
    setProperty('dadGroup.visible', false)

    addCharacterToList('gold-headless', 'dad')

    makeAnimatedLuaSprite('celebi', 'characters/gold/Celebi_Assets', 570, 100)
    addAnimationByPrefix('celebi', 'idle', 'Celebi Spawn Full', 24, false)
    setProperty('celebi.alpha', 0.0001)
    addLuaSprite('celebi')

    makeAnimatedLuaSprite('celebiNoteExample', 'characters/gold/Note_asset', 600, 200)
    addAnimationByIndices('celebiNoteExample', 'idle', 'Note Full', '18', 1)
    --addLuaSprite('celebiNote', true)

    makeAnimatedLuaSprite('no more', 'characters/gold/GOLD_NO_MORE', getProperty('dadGroup.x') - 73, getProperty('dadGroup.y') - 112)
    addAnimationByPrefix('no more', 'idle', 'No More instance 1', 24, false)
    setProperty('no more.alpha', 0)
    scaleObject('no more', 1.3, 1.3)
    addLuaSprite('no more')

    makeAnimatedLuaSprite('headrip', 'characters/gold/GOLD_HEAD_RIPPING_OFF', getProperty('dadGroup.x') - 160, getProperty('dadGroup.y') - 252)
    addAnimationByPrefix('headrip', 'idle', 'Head rips_OneLayer instance 1', 24, false)
    setProperty('headrip.alpha', 0)
    scaleObject('headrip', 1.3, 1.3)
    addLuaSprite('headrip')

    -- UI
    makeLuaSprite('celebiHealth', '', getProperty('healthBar.x'), getProperty('healthBar.y'))

	makeGraphic('celebiHealth', getProperty('healthBarBG.width') - 2, getProperty('healthBarBG.height') - 2, 'FFFFFF')
    setProperty('celebiHealth.offset.x', -1)
    setProperty('celebiHealth.offset.y', -1)

	setObjectCamera('celebiHealth', 'hud')
    setObjectOrder('celebiHealth')
	setProperty('celebiHealth.alpha', 1)
	addLuaSprite('celebiHealth', true)

    if getModSetting('mechanics') == 'Hell' then
        celebiNoteCount = 6
        addLuaScript('pendulum')
    end
end

local celebiNotes = {}
local celebiNotesActive = false
local celebiNoteTime = 0
local celebiNoteStartAngle = 0
local celebiDamage = 0

function spawnCelebiNotes()
	celebiNotesActive = true
	celebiNoteTime = 0

	-- Random starting direction.
	celebiNoteStartAngle = getRandomFloat(0, math.pi * 2)

	local celebiX = getProperty('celebi.x') + 140
	local celebiY = getProperty('celebi.y') + 140

	for i = 1, celebiNoteCount do
        local tag = 'celebiNote' .. i
        removeLuaSprite(tag, true)

        makeAnimatedLuaSprite(tag, 'characters/gold/Note_asset', celebiX, celebiY)
        addAnimationByIndices(tag, 'idle', 'Note Full', '18', 1)
        scaleObject(tag, 0.75, 0.75)
        playAnim(tag, 'idle', true)
        addLuaSprite(tag, true)

        celebiNotes[i] = tag
    end

    runTimer('celebiNotesFadeOut', 1)
end

local celebiHealthSubtract = 0

function onEvent(name, value1, value2)
    if name == 'Celebi' then
        if getModSetting('mechanics') ~= 'Pussy' then
            setProperty('celebi.alpha', 1)
            setProperty('celebi.x', value2)
            playAnim('celebi', 'idle', true)
            runTimer('spawnCNotes', 0.5)

            celebiHealthSubtract = tonumber(value1)
            scale = 1 - (value1 / 2)
            scaleObject('healthBar.rightBar', scale, 1)
        end
    end
end

function onUpdate(elapsed)
    if getProperty('health') < celebiHealthSubtract then
        setProperty('health', -1)
    end


	if celebiNotesActive then
		celebiNoteTime = celebiNoteTime + elapsed

		local celebiX = getProperty('celebi.x') + 140
		local celebiY = getProperty('celebi.y') + 140

		local angleSpeed = 3.5
		local radiusSpeed = 180

		local radius = celebiNoteTime * radiusSpeed
		local angle = celebiNoteStartAngle + celebiNoteTime * angleSpeed

		for i = 1, celebiNoteCount do
            local noteAngle = angle + ((i - 1) * (math.pi * 2 / celebiNoteCount))

            local x = celebiX + math.cos(noteAngle) * radius
            local y = celebiY + math.sin(noteAngle) * radius

            setProperty(celebiNotes[i] .. '.x', x)
            setProperty(celebiNotes[i] .. '.y', y)
        end
	end
end

function onCreatePost()
    setProperty('boyfriendGroup.visible', false)
    setProperty('gfGroup.visible', false)
    setProperty('camHUD.alpha', 0.0001)

    triggerEvent('Camera Follow Pos', '300', '370')
    setProperty('camFollowPos.x', 300)
	setProperty('camFollowPos.y', 370)
    removeLuaScript('scripts/camFollow')
end

function onStepHit()
    if curStep == 1605 then
        setProperty('dadGroup.visible', false)
        setProperty('no more.alpha', 1)
        playAnim('no more', 'idle', true)
    elseif curStep == 1632 then
        removeLuaSprite('no more', true)
        setProperty('headrip.alpha', 1)
        playAnim('headrip', 'idle', true)
    elseif curStep == 1664 then
        removeLuaSprite('headrip', true)
        triggerEvent('Change Character', 'dad', 'gold-headless')
        setProperty('dadGroup.visible', true)
        setProperty('defaultCamZoom', 0.7)
    end
end

--camfollow stuff
local off = {20, 20} -- x and y movement force
local opponentNotes = false
local bfNotes = true -- change this to false if you want to trigger when player notes
local xy = {{-off[1], 0}, {0, off[2]}, {0, -off[2]}, {off[1], 0}} -- table which has the applied movement force

function goodNoteHit(i, d, n, s)
    if bfNotes and mustHitSection then
		resetCam(d)
	end
end

function opponentNoteHit(i, d, n, s)
    if opponentNotes and not mustHitSection then
		resetCam(d)
	end
end

function resetCam(d)
    runHaxeCode('game.moveCameraSection()')
    setProperty('camFollow.x', 300 + xy[d+1][1])
    setProperty('camFollow.y', 370 + xy[d+1][2])
end