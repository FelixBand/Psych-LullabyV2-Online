function onCreate()
	makeLuaSprite('bygoneFuck', 'stages/bygone/images/AlexisTransition', 0, 0)
	setObjectCamera('bygoneFuck', 'other')
	scaleObject('bygoneFuck', 0.95, 0.95)
	screenCenter('bygoneFuck')
	setProperty('bygoneFuck.alpha', 0.0001)
	addLuaSprite('bygoneFuck')
	
	makeAnimatedLuaSprite('alexisPass', 'stages/bygone/images/GGirl Alexis Passing Spritesheet', 1630, 290)
	addAnimationByPrefix('alexisPass', 'pass', 'GGirl Passing', 24, false)
	setProperty('alexisPass.alpha', 0.0001)
	addLuaSprite('alexisPass')

	makeAnimatedLuaSprite('gates', 'stages/bygone/images/Heavens Gate', 1565, 250)
	addAnimationByPrefix('gates', 'open', 'Heavens Gate', 24, false)
	setProperty('gates.alpha', 0.0001)
	addLuaSprite('gates')

	makeAnimatedLuaSprite('retry', 'characters/death/bygone/Retry')
	addAnimationByPrefix('retry', 'idle', 'Retry instance 1', 24, true)
	setObjectCamera('retry', 'other')
	setProperty('retry.scale.x', 0.7)
	setProperty('retry.scale.y', 0.7)
	screenCenter('retry', 'xy')
	setProperty('retry.alpha', 0.0001)
	addLuaSprite('retry', true)

	makeAnimatedLuaSprite('hypnoConfirm', 'characters/death/bygone/Confirm')
	addAnimationByPrefix('hypnoConfirm', 'idle', 'Confirm instance 1', 24, false)
	setObjectCamera('hypnoConfirm', 'other')
	screenCenter('hypnoConfirm', 'x')
	setProperty('hypnoConfirm.alpha', 0.0001)
	addLuaSprite('hypnoConfirm', true)

	makeAnimatedLuaSprite('girlpoof', 'characters/death/bygone/GGirl_Poof', 810, 110)
	addAnimationByPrefix('girlpoof', 'idle', 'GGirlPoof', 12, false)
	setObjectCamera('girlpoof', 'other')
	setProperty('girlpoof.alpha', 0.0001)
	addLuaSprite('girlpoof', true)

	for i = 0, getProperty('unspawnNotes.length') do
        setPropertyFromGroup('unspawnNotes', i, 'multSpeed', getRandomFloat(0.85, 1.4))
        if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
            setPropertyFromGroup('unspawnNotes', i, 'multSpeed', getPropertyFromGroup('unspawnNotes', i, 'prevNote.multSpeed'))
        end

		if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true)
        end
    end
end

function onCreatePost()
	if not middlescroll then
		for i = 0,getProperty('playerStrums.length') - 1 do
			setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
		end
	end
	if playsAsBF() then
		for i = 0,getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', 5000)
		end
	else
		for i = 0,getProperty('playerStrums.length') - 1 do
			setPropertyFromGroup('playerStrums', i, 'x', 5000)
		end
	end

	setProperty('iconP2.visible', false)

	setProperty('camZooming', true)
end

function onStepHit()
	if curStep == 588 then
		doTweenAlpha('picture', 'bygoneFuck', 1, 6, 'linear')
	elseif curStep == 632 then
		setProperty('boyfriend.alpha', 0)
	elseif curStep == 633 then
		setProperty('health', 1)
		setProperty('iconP1.visible', true)
		doTweenAlpha('picture', 'bygoneFuck', 0, 10, 'linear')
		doTweenAlpha('bgTrans1', 'bigHypno', 1, 10, 'linear')
		doTweenAlpha('bgTrans2', 'buildings2', 1, 10, 'linear')
		doTweenAlpha('bgTrans3', 'bridge2', 1, 10, 'linear')
		doTweenAlpha('bgTrans4', 'background2', 1, 10, 'linear')
		doTweenAlpha('bgTrans5', 'bridgeRope2', 1, 10, 'linear')

		doTweenAlpha('bgTrans6', 'bridge', 0, 10, 'linear')
		doTweenAlpha('bgTrans7', 'bridgeRope', 0, 10, 'linear')
	elseif curStep == 712 then
		doTweenAlpha('playerIn', 'boyfriend', 1, 2, 'quadOut')
	elseif curStep == 1236 then
		setProperty('boyfriend.visible', false)
		setProperty('alexisPass.alpha', 1)
		setProperty('gates.alpha', 1)
		playAnim('gates', 'open', true)
		playAnim('alexisPass', 'pass', true)
	end
end

function noteMiss(index, noteData, noteType, isSustain)
	if boyfriendName == 'alexis' then
		playSound('Electric_miss' .. getRandomInt(1,5))
	end
end

local pressedRetry = false

function doDeathStuff()
	doTweenAlpha('retryIn', 'retry', 1, 1, 'linear')
	if not pressedRetry then
		playMusic('bygonedeathmusic', 1, true)
	end
end

function onGameOver()
	openCustomSubstate('gameover', true)

	return Function_Stop
end

function onCustomSubstateCreate(name)
	if name == 'gameover' then
		insertToCustomSubstate('retry')
		insertToCustomSubstate('hypnoConfirm')
		insertToCustomSubstate('girlpoof')

		setProperty('camGame.visible', false)
		setProperty('camHUD.visible', false)
		if boyfriendName == 'alexis' then
			setProperty('girlpoof.alpha', 1)
			playAnim('girlpoof', 'idle', true)
			runTimer('actualdeathscreen', 2)
			playSound('bygonedeathNoise')
		else
			cameraFlash('other', 'red', 0.5, true)
			doDeathStuff()
		end
	end
end

function onCustomSubstateUpdate(name, elapsed)
	if name == 'gameover' then
		if not pressedRetry and keyJustPressed('accept') then
			pressedRetry = true
			playSound('bygoneConfirm', 1)
			playMusic('bygonedeathmusic', 0) -- how do I stop music??? ;-;

			removeLuaSprite('retry')
			setProperty('hypnoConfirm.alpha', 1)
            playAnim('hypnoConfirm', 'idle', true)

			runTimer('restart', 3)
		end
		if keyJustPressed('back') then
			exitSong()
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'actualdeathscreen' then
		doDeathStuff()
	end
	if tag == 'restart' then
		restartSong()
	end
end