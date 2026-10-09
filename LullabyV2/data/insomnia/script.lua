local minAccuracy = 0.9 

function onCreate()
    setProperty('camHUD.alpha', 0.0001)
    setProperty('skipCountdown', true)

    makeAnimatedLuaSprite('feraligatr_death', 'characters/death/feraligatr', 0, 0)
    addAnimationByPrefix('feraligatr_death', 'chomp', 'feraligatr', 24, false)
    setObjectCamera('feraligatr_death', 'other')
    setProperty('feraligatr_death.alpha', 0.0001)
    addLuaSprite('feraligatr_death')

    if getModSetting('mechanics') == 'Hell' then
        minAccuracy = 0.98
    end
end

function onCreatePost()
    removeLuaScript('scripts/camFollow')
end

local xx2 = 1310
local yy2 = 680
local ofs = 20
local followchars = true
local zoomin = false

function onUpdate()
    if rating < minAccuracy and totalPlayed > 0 then
        followchars = false
        triggerEvent('Camera Follow Pos', '800', '400')
        if getProperty('vocals.volume', 1) then
            setProperty('vocals.volume', 0.5)
        end
        runHaxeCode([[FlxG.sound.music.volume = 0.5;]])
        if not zoomin then
            doTweenZoom('feraligatr', 'camGame', 1.4, 10, 'smoothStepIn')
            playSound('feraligatrWakes')
            zoomin = true
        end
    else
        cancelTween('feraligatr')
        zoomin = false
        followchars = true
        runHaxeCode([[FlxG.sound.music.volume = 1;]])
    end


    if followchars then -- camfollow script
        if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
            triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
            triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
            triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
            triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
	    else
            triggerEvent('Camera Follow Pos',xx2,yy2)
        end
    end
end

local isDead = false

function onGameOver()
	isDead = true
	openCustomSubstate('gameover', true)

	return Function_Stop
end

function onCustomSubstateCreate(name)
	if name == 'gameover' then
		setProperty('camGame.visible', false)
		setProperty('camHUD.visible', false)
        insertToCustomSubstate('feraligatr_death')
        setProperty('feraligatr_death.alpha', 1)
        playAnim('feraligatr_death', 'chomp', true)
        playSound('feraligatr')
	end
end

function onCustomSubstateUpdate(name, elapsed)
	if name == 'gameover' then
		if not pressedRetry and keyJustPressed('accept') then
			pressedRetry = true
			playMusic('gameOverEnd', 1)
			doTweenAlpha('camOtherOut', 'camOther', 0, 3, 'cubeIn')
		end
		if keyJustPressed('back') then
			exitSong()
		end
	end
end

function onTweenCompleted(tag)
    if tag == 'feraligatr' then
		setProperty('health', -1)
	end
	if tag == 'camOtherOut' then
		restartSong()
	end
end

-- local cutscened = false
-- function onEndSong()
--     if not cutscened and isStoryMode then
-- 		doTweenAlpha('hudout', 'camHUD', 0, 1, 'linear')
--         playSound('death', 1)
--         cutscened = true
--         return Function_Stop
--     end
-- return Function_Continue
-- end