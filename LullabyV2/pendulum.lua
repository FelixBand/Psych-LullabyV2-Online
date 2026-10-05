local swingTime = 4
local hitWindow = 12
local mechanics = 'Normal'

local canHit = false
local cutscened = false

function onCreate()
	mechanics = getModSetting('mechanics')

	if mechanics == 'Pussy' then
		close()
		return
	elseif mechanics == 'Hell' then
		swingTime = 2
		if songName == 'Brimstone' then
			swingTime = 4
		end
	end

	makeAnimatedLuaSprite('pendulumTrail', 'UI/base/hypno/Pendelum_Phase2', 0, 0)
	addAnimationByPrefix('pendulumTrail', 'idle', 'pendulum Phase 2', 24, true)
	updateHitbox('pendulumTrail')
	setObjectCamera('pendulumTrail', 'other')
	setProperty('pendulumTrail.origin.x', 65)
	setProperty('pendulumTrail.origin.y', 0)
	setProperty('pendulumTrail.x', (screenWidth / 2) - (getProperty('pendulumTrail.width') / 2))
	setProperty('pendulumTrail.y', 0)
	addLuaSprite('pendulumTrail', true)
	setProperty('pendulumTrail.alpha', 0)

	makeAnimatedLuaSprite('pendulum', 'UI/base/hypno/Pendelum_Phase2', 0, 0)
	addAnimationByPrefix('pendulum', 'idle', 'pendulum Phase 2', 24, true)
	updateHitbox('pendulum')
	setObjectCamera('pendulum', 'other')
	setProperty('pendulum.origin.x', 65)
	setProperty('pendulum.origin.y', 0)
	setProperty('pendulum.x', (screenWidth / 2) - (getProperty('pendulum.width') / 2))
	setProperty('pendulum.y', 0)
	addLuaSprite('pendulum', true)

	makeLuaSprite('daFlash', '', 0, 0)
	makeGraphic('daFlash', screenWidth, screenHeight, 'FFAFC1')
	setObjectCamera('daFlash', 'other')
	addLuaSprite('daFlash')
	setProperty('daFlash.alpha', 0)

	makeAnimatedLuaSprite('trance', 'UI/base/hypno/StaticHypno', -5, 0)
	addAnimationByPrefix('trance', 'idle', 'StaticHypno', 24, true)
	setObjectCamera('trance', 'other')
	setProperty('trance.alpha', 0)
	scaleObject('trance', 0.56, 0.49)
	addLuaSprite('trance')

	makeAnimatedLuaSprite('psyshockParticle', 'UI/base/hypno/Psyshock', 1250, 400)
	addAnimationByPrefix('psyshockParticle', 'spark', 'Full Psyshock Particle', 24, false)
	setProperty('psyshockParticle.alpha', 0.0001)
	addLuaSprite('psyshockParticle')

	makeAnimatedLuaSprite('tutorial', 'UI/base/hypno/Extras', 0, 0)
	addAnimationByPrefix('tutorial', 'tap', 'Spacebar', 24, false)
	setObjectCamera('tutorial', 'other')
	screenCenter('tutorial', 'xy')
	setProperty('tutorial.y', getProperty('tutorial.y') + 60)
	setProperty('tutorial.alpha', 0.0001)
	addLuaSprite('tutorial')

	makeAnimatedLuaSprite('pendFeedback', 'UI/base/hypno/Extras', 0, 0)
	addAnimationByPrefix('pendFeedback', 'nice', 'Checkmark', 24, false)
	addAnimationByPrefix('pendFeedback', 'bad', 'X finished', 24, false)
	setObjectCamera('pendFeedback', 'other')
	screenCenter('pendFeedback', 'xy')
	setProperty('pendFeedback.y', getProperty('pendFeedback.y') + 60)
	setProperty('pendFeedback.alpha', 0.0001)
	addLuaSprite('pendFeedback')
end

function reset()
	if cutscened then
		return
	end

	cancelTween('pend0')
	cancelTween('pend1')
	cancelTween('pend2')
	cancelTween('pend3')

	setProperty('pendulum.angle', 0)
	doTweenAngle('pend1', 'pendulum', 30, (stepCrochet / 1000) * swingTime, 'quadOut')
end

function onBeatHit()
	if curBeat % swingTime == 0 then
		reset()
	end

	if curBeat % (swingTime / 2) == 0 then
		playAnim('tutorial', 'tap', true)
	end
end

function pendFeedback(feedback)
	setProperty('pendFeedback.alpha', 1)

	if feedback == 0 then
		playAnim('pendFeedback', 'nice', true)
	else
		playAnim('pendFeedback', 'bad', true)
	end
end

function onTweenCompleted(tag)
	if tag == 'pend0' then
		doTweenAngle('pend1', 'pendulum', getProperty('pendulum.angle') + 30, (stepCrochet / 1000) * swingTime, 'quadOut')
	elseif tag == 'pend1' then
		doTweenAngle('pend2', 'pendulum', getProperty('pendulum.angle') - 30, (stepCrochet / 1000) * swingTime, 'quadIn')

		if canHit then
			lose()
			pendFeedback(1)
		end

		canHit = true
	elseif tag == 'pend2' then
		doTweenAngle('pend3', 'pendulum', getProperty('pendulum.angle') - 30, (stepCrochet / 1000) * swingTime, 'quadOut')
	elseif tag == 'pend3' then
		doTweenAngle('pend0', 'pendulum', getProperty('pendulum.angle') + 30, (stepCrochet / 1000) * swingTime, 'quadIn')

		if canHit then
			lose()
			pendFeedback(1)
		end

		canHit = true
	end
end

function lose()
	if cutscened then
		return
	end

	local alpha = getProperty('trance.alpha') + 0.05
	setProperty('trance.alpha', alpha)

	if alpha > 0.8 then
		triggerEvent('Alt Idle Animation', 'bf', '-alt2')
	elseif alpha > 0.4 then
		triggerEvent('Alt Idle Animation', 'bf', '-alt')
	end

	if alpha >= 1 then
		setProperty('health', 0)
	end

	tranceSound()
end

function tranceSound()
	stopSound('trance')
	playSound('TranceStatic', (getProperty('trance.alpha') * 1.1) - 0.35, 'trance')
end

function onSongStart()
	doTweenAlpha('tutorialIn', 'tutorial', 1, 0.5, 'linear')
	runTimer('tutorialFadeOut', (stepCrochet * 64) / 1000)

	doTweenAngle('pend1', 'pendulum', 30, (stepCrochet / 1000) * swingTime, 'quadOut')

	runTimer('psyshock', getRandomInt(5, 15))
	playSound('TranceStatic', 0, 'trance')
end

function onTimerCompleted(tag)
	if tag == 'psyshock' and not cutscened then
		runTimer('psyshock', getRandomInt(5, 15))
		playSound('Psyshock', 1)

		setProperty('daFlash.alpha', 1)
		doTweenAlpha('flashOut', 'daFlash', 0, 1, 'linear')

		setProperty('psyshockParticle.alpha', 1)
		playAnim('psyshockParticle', 'spark', true)

		lose()
	elseif tag == 'tutorialFadeOut' then
		doTweenAlpha('tutorialOut', 'tutorial', 0, 0.5, 'linear')
	end
end

function onUpdate(elapsed)
	if not getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') or curBeat <= 0 then
		return
	end

	local angle = getProperty('pendulum.angle')

	if angle > -hitWindow and angle < hitWindow then
		setProperty('pendulumTrail.angle', angle)
		setProperty('pendulumTrail.alpha', 1)
		doTweenAlpha('trailFade', 'pendulumTrail', 0, 0.15, 'linear')

		local alpha = getProperty('trance.alpha') - 0.075
		setProperty('trance.alpha', alpha)

		if alpha < 0.4 then
			triggerEvent('Alt Idle Animation', 'bf', '')
		end

		tranceSound()
		canHit = false
		pendFeedback(0)
	else
		lose()
		pendFeedback(1)
	end
end

function onGameOver()
	stopSound('trance')
end

function onPause()
	stopSound('trance')
end

function onResume()
	tranceSound()
end

function destroyPendulum()
	removeLuaSprite('pendulum', true)
	removeLuaSprite('pendulumTrail', true)
	removeLuaSprite('daFlash', true)
	removeLuaSprite('trance', true)
	removeLuaSprite('psyshockParticle', true)
	removeLuaSprite('tutorial', true)
	removeLuaSprite('pendFeedback', true)
end

function onEndSong()
	destroyPendulum()

	close()
end