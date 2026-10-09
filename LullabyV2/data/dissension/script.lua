local lowHealthFX = false
local pussyMode = false
local strangleHealthDrain = 0.02

function onCreate()
	setProperty('skipCountdown',true)

	pussyMode = getModSetting('mechanics') == 'Pussy'

	if getModSetting('mechanics') == 'Hell' then
		strangleHealthDrain = 0.035
	end

    -- gameover stuff
    makeAnimatedLuaSprite('mikeDies', 'characters/death/mike/Red_Game_Over_Assets_culosfortnite', 0, 0)
    addAnimationByPrefix('mikeDies', 'firstDeath', 'Death', 24, false)
    addAnimationByPrefix('mikeDies', 'deathLoop', 'Dead Loop', 24, false)
    addAnimationByPrefix('mikeDies', 'confirm', 'Confirm', 24, false)
    scaleObject('mikeDies', 1.2, 1.2)
    setProperty('mikeDies.alpha', 0.0001)
    addLuaSprite('mikeDies', true)
end

function onCreatePost()
    setProperty('boyfriend.visible',false)
	setObjectOrder('boyfriendGroup',getObjectOrder('laalmuada')+1)
	setProperty('cameraSpeed', 1000)
	setProperty('camGame.alpha', 0.0001)
	setProperty('camHUD.alpha', 0.0001)
	setProperty('gf.alpha', 0.0001)
	setObjectOrder('gfGroup', getObjectOrder('boyfriendGroup') + 1)

	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'mustPress') and not getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
			setPropertyFromGroup('unspawnNotes', i, "hitHealth", 0.035)
		end
	end
end

function onUpdate(elapsed)
    if lowHealthFX then
		cameraShake('hud',0.0015, 0.01)
		cameraShake('game',0.0015, 0.01)
	end
end

function onEvent(eventName, value1, value2)
    --debugPrint('name: '..eventName..' value1: '..value1..' value2: '..value2)
	if eventName=='Fade In Intro' then
		doTweenAlpha('gameIn', 'camGame', 1, 3, 'linear')
		doTweenZoom('camZoom', 'camGame', 1, 5, 'cubeOut')
		setProperty('defaultCamZoom', 1)
		setProperty('cameraSpeed', 1)
	end
	if eventName=='Mike Strangle Scene' then
		setProperty('defaultCamZoom', 0.9)
		triggerEvent('Camera Follow Pos', '400', '650')
		setProperty('cameraSpeed', 1000)

        setProperty('camGame.zoom',getProperty('camGame.zoom')+2.5)
        removeLuaSprite('background')
        removeLuaSprite('portrait')
        removeLuaSprite('lacama')
        removeLuaSprite('laalmuada')
        if not pussyMode then
            strangling = true
        end
        
        setProperty('camGame.alpha',0)
        Set('dadGroup','',-300,400)
        Set('boyfriendGroup','',400,100)
        setProperty('dadGroup.y',800)
        setProperty('boyfriendGroup.y',-300)
        doTweenAlpha('camIn','camGame',1,6,'quadOut')
        doTweenY('MikeY','boyfriendGroup',100,6,'quadOut')
        doTweenY('StevenY','dadGroup',400,6,'quadOut')
    end
	if eventName == 'Chomatic Riser' and value1 == '0.25' and value2 == '10' then
		setProperty('cameraSpeed', 1)
	end
    if eventName=='Steven Goodbye' then
		lowHealthFX = not lowHealthFX

		if lowHealthFX then
			setProperty('camGame.visible',false)
			
			setProperty('healthBar.visible', false)
			setProperty('timeBar.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('scoreTxt.visible', false)
			setProperty('iconP1.visible', false)
			setProperty('iconP2.visible', false)

            runTimer('Spawn',1)

			setProperty('dad.alpha',0.45)
			setProperty('boyfriend.alpha',0.45)
			setProperty('gf.alpha',1)
		else
			doTweenAlpha('redOverlay','redOverlay',0,1.5,'quadInOut')
		end
	end
	if eventName=='Mike Change Scene' then
		setProperty('camHUD.alpha', 1)
        setProperty('camGame.zoom',getProperty('camGame.zoom')+2.5)
		setProperty('defaultCamZoom', 1.2)
        setProperty('boyfriend.visible',true)
        setProperty('background.alpha', 1)
        setProperty('portrait.alpha', 1)
        setProperty('lacama.alpha', 1)
        setProperty('laalmuada.alpha', 1)
        setProperty('iconP1.visible', true)
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag=='Spawn' then
		setProperty('camGame.visible',true)
		setProperty('healthBar.visible', true)
		setProperty('timeBar.visible', true)
		setProperty('timeTxt.visible', true)
		setProperty('scoreTxt.visible', true)
		setProperty('iconP1.visible', true)
		setProperty('iconP2.visible', true)
	end
    if tag == 'restart' then
        restartSong()
    end
end

function onBeatHit()
    if lowHealthFX then
        setProperty('redOverlay.alpha',0.85)
		doTweenAlpha('redOverlay','redOverlay',0.65,0.25,'quadInOut')
	end
end

function onStepHit()
	if strangling then
		if getProperty('health') > 0.395 then
			setProperty('health', getProperty('health') - strangleHealthDrain)
		end
	end
end

function Set(tag,Var,X,Y)
    if X~=nil then
        setProperty(tag..Var..'.x',X)
    end
    if Y~=nil then
        setProperty(tag..Var..'.y',Y)
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote) -- sync the two Stevens
	triggerEvent('Play Animation', getProperty('singAnimations')[direction+1], 'gf')
end

function onGameOver()
	isDead = true
	openCustomSubstate('gameover', true)

	return Function_Stop
end

function onCustomSubstateCreate(name)
	if name == 'gameover' then
		insertToCustomSubstate('mikeDies')

		playAnim('mikeDies', 'firstDeath', true)
        setProperty('mikeDies.alpha', 1)

		cameraFlash('other', 'red', 0.5, true)
		setProperty('camGame.visible', false)
		setProperty('camHUD.visible', false)

        playSound('DissensionDeath')
	end
end

function onCustomSubstateUpdate(name, elapsed)
	if name == 'gameover' then
		if not pressedRetry and keyJustPressed('accept') then
			pressedRetry = true
			playMusic('gameOverEnd', 1)
            playAnim('mikeDies', 'confirm', true)

			runTimer('restart', 2)
		end
		if keyJustPressed('back') then
			exitSong()
		end
		if getProperty('mikeDies.animation.curAnim.name') == 'firstDeath' and getProperty('mikeDies.animation.curAnim.finished') then
			playAnim('mikeDies', 'deathLoop', true)
		end
	end
end