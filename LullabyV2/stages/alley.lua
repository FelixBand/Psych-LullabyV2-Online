local isDead = false
local pressedRetry = false

function onCreate()
	makeLuaSprite('background', 'stages/alley/images/BACKGROUND', 0, 0)
	setLuaSpriteScrollFactor('background', 0.6, 0.6)
	scaleObject('background', 0.7, 0.7)

	makeLuaSprite('grass', 'stages/alley/images/Behind the clouds and fence', 0, 0)
	setLuaSpriteScrollFactor('grass', 0.7, 0.7)
	scaleObject('grass', 0.7, 0.7)

	makeLuaSprite('fog', 'stages/alley/images/Behind the Fence', 0, 0)
	setLuaSpriteScrollFactor('fog', 0.8, 0.8)
	scaleObject('fog', 0.7, 0.7)
	
	if dadName == 'hypno-two' then
		makeLuaSprite('midground', 'stages/alley/images/MIDGROUND BLOOD', 0, 0)
	else
		makeLuaSprite('midground', 'stages/alley/images/MIDGROUND', 0, 0)
	end
	setLuaSpriteScrollFactor('midground', 1, 1)
	scaleObject('midground', 0.7, 0.7)

	makeLuaSprite('stageForeground', 'stages/alley/images/FOREGROUND TREE', -50, 0)
	setLuaSpriteScrollFactor('stageForeground', 1.2, 1.2)
	scaleObject('stageForeground', 0.7, 0.7)

	makeAnimatedLuaSprite('brimstoneHand', 'stages/alley/images/White_Hand', 1740, 550)
	addAnimationByPrefix('brimstoneHand', 'idle', 'White Hand FInished', 24, false)
	scaleObject('brimstoneHand', 0.65, 0.65)
	setProperty('brimstoneHand.alpha', 0.0001)


	addLuaSprite('background', false)
	addLuaSprite('grass', false)
	addLuaSprite('fog', false)
	addLuaSprite('midground', false)
	addLuaSprite('stageForeground', true)
	addLuaSprite('brimstoneHand')


	-- Game over screen
	makeLuaSprite('deadSky', 'characters/death/gf/sky', 0, 0)
	setObjectCamera('deadSky', 'other')
	
	makeLuaSprite('deadTrees', 'characters/death/gf/trees', -350, 50)
	setObjectCamera('deadTrees', 'other')
	scaleObject('deadTrees', 1.4, 1.4)
	
	makeLuaSprite('deadTrunk', 'characters/death/gf/trunk', 610, 0)
	setObjectCamera('deadTrunk', 'other')
	scaleObject('deadTrunk', 1.2, 1.2)
	
	makeAnimatedLuaSprite('deadGF', 'characters/death/gf/gf', 580, 80)
	addAnimationByPrefix('deadGF', 'wake', 'GF_WAKEUP instance 1', 24, false)
	addAnimationByPrefix('deadGF', 'die', 'GF_DIZZLE_OPENING instance 1', 24, false)
	addAnimationByPrefix('deadGF', 'idle', 'GF_DIZZLE_LOOP instance 1', 24, true)
	setObjectCamera('deadGF', 'other')
	
	makeAnimatedLuaSprite('claw', 'characters/death/gf/claw', -170, 100)
	addAnimationByPrefix('claw', 'idle', 'claw', 24, true)
	setObjectCamera('claw', 'other')
	scaleObject('claw', 0.8, 0.8)
	
	makeAnimatedLuaSprite('retry', 'characters/death/gf/gf_gameover', 60, 330)
	addAnimationByPrefix('retry', 'pressed', 'gameover_over instance 1', 24, false)
	addAnimationByPrefix('retry', 'idle', 'gameover_concept instance 1', 24, true)
	setObjectCamera('retry', 'other')
	scaleObject('retry', 1, 1)
	
	-- addLuaSprite('deadSky')
	-- addLuaSprite('deadTrees')
	-- addLuaSprite('deadTrunk')
	-- addLuaSprite('deadGF')
	-- addLuaSprite('claw')
	-- addLuaSprite('retry')

	-- setProperty('deadSky.visible', false)
	-- setProperty('deadTrees.visible', false)
	-- setProperty('deadTrunk.visible', false)
	-- setProperty('deadGF.visible', false)
	-- setProperty('claw.visible', false)
	-- setProperty('retry.visible', false)
end

local brimStoneHandOccured = false

function onBeatHit()
	if getRandomInt(1,10) == 1 and not brimStoneHandOccured then
		brimStoneHandOccured = true
		playAnim('brimstoneHand', 'idle', true)
		setProperty('brimstoneHand.alpha', 1)
	end
end

function onCreatePost()
	if playsAsBF() then
		for i = 0,getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', -5000)
		end
	end

	setProperty('camZooming', true)
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('defaultCamZoom', 0.7)
	elseif focus == 'dad' then
		setProperty('defaultCamZoom', 0.65)
	end
end

function onGameOver()
	isDead = true
	openCustomSubstate('gfFuckingDies', true)

	return Function_Stop
end

function onCustomSubstateCreate(name)
	if name == 'gfFuckingDies' then
		insertToCustomSubstate('deadSky')
		insertToCustomSubstate('deadTrees')
		insertToCustomSubstate('deadTrunk')
		insertToCustomSubstate('deadGF')
		insertToCustomSubstate('claw')
		insertToCustomSubstate('retry')

		playAnim('deadGF', 'die', true)
		playAnim('claw', 'idle', true)
		playAnim('retry', 'idle', true)

		cameraFlash('other', 'red', 0.5, true)
		setProperty('camGame.visible', false)
		setProperty('camHUD.visible', false)

		callOnLuas('destroyPendulum')
	end
end

function onCustomSubstateUpdate(name, elapsed)
	if name == 'gfFuckingDies' then
		if not pressedRetry and keyboardJustPressed('ENTER') or keyboardJustPressed('SPACE') then
			pressedRetry = true
			playMusic('gameOverEnd', 1)
			playAnim('deadGF', 'wake', true)
			setProperty('deadGF.offset.x', 50)

			playAnim('retry', 'pressed', true)
			setProperty('retry.offset.x', 140)
			setProperty('retry.offset.y', 62)

			doTweenAlpha('camOtherOut', 'camOther', 0, 3, 'cubeIn')
			--restartSong()
		end
		if getProperty('deadGF.animation.curAnim.name') == 'die' and getProperty('deadGF.animation.curAnim.finished') then
			playAnim('deadGF', 'idle')
		end
	end
end

function onTweenCompleted(tag)
	if tag == 'camOtherOut' then
		restartSong()
	end
end