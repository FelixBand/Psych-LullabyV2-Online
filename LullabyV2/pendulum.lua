local hitWindow = 12
local mechanics = 'Normal'

local canHit = false
local cutscened = false
local hypnoPendulum = false

local pendOffX = 0
local pendOffY = 0

local offsets = {
	idle = {
		[0] = {814, 264},
		[1] = {814, 264},
		[2] = {813, 270},
		[3] = {813, 270},
		[4] = {813, 266},
		[5] = {813, 263},
		[6] = {814, 255},
		[7] = {811, 251},
		[8] = {809, 249},
		[9] = {809, 249}
	},

	singLEFT = {
		[0] = {775, 336},
		[1] = {790, 351},
		[2] = {826, 366},
		[3] = {830, 378},
		[4] = {830, 378},
		[5] = {831, 393},
		[6] = {831, 393},
		[7] = {832, 396}
	},

	singRIGHT = {
		[0] = {866, 609},
		[1] = {866, 609},
		[2] = {866, 609},
		[3] = {858, 612},
		[4] = {881, 610},
		[5] = {901, 597},
		[6] = {903, 590},
		[7] = {908, 586}
	},

	singUP = {
		[0] = {638, -300},
		[1] = {675, -267},
		[2] = {681, -257},
		[3] = {694, -249},
		[4] = {696, -241},
		[5] = {705, -237},
		[6] = {709, -236},
		[7] = {709, -236},
		[8] = {711, -234}
	},

	singDOWN = {
		[0] = {700, 222},
		[1] = {705, 237},
		[2] = {692, 220},
		[3] = {687, 213},
		[4] = {687, 213},
		[5] = {690, 220},
		[6] = {689, 227},
		[7] = {680, 242},
		[8] = {679, 243},
		[9] = {673, 253}
	},

	psyshock = {
		[0] = {737, 386},
		[1] = {713, 396},
		[2] = {706, 394},
		[3] = {708, 392},
		[4] = {709, 391},
		[5] = {709, 391},
		[6] = {709, 405},
		[7] = {703, 416}
	}
}

function destroyPendulum()
	stopSound('trance')

	removeLuaSprite('pendulum', true)
	removeLuaSprite('pendulumTrail', true)
	removeLuaSprite('daFlash', true)
	removeLuaSprite('trance', true)
	removeLuaSprite('psyshockParticle', true)
	removeLuaSprite('tutorial', true)
	removeLuaSprite('pendFeedback', true)
end

local function swingDuration()
	return (stepCrochet / 1000) * getVar('swingTime')
end

local function setPendulumOffset()
	if not hypnoPendulum then
		return
	end

	local anim = getProperty('dad.animation.curAnim.name')
	local frame = getProperty('dad.animation.curAnim.curFrame')
	local data = offsets[anim]

	if not data then
		return
	end

	local offset = data[frame]

	if not offset then
		local highestFrame = 0

		for frameID in pairs(data) do
			if frameID > highestFrame then
				highestFrame = frameID
			end
		end

		offset = data[highestFrame]
	end

	pendOffX = offset[1]
	pendOffY = offset[2]
end

function onCreate()
	mechanics = getModSetting('mechanics')
	setVar('swingTime', 4)

	if mechanics == 'Pussy' then
		close()
		return
	elseif mechanics == 'Hell' then
		setVar('swingTime', 2)
	end

	hypnoPendulum = dadName == 'hypno'

	local pendulumImage = hypnoPendulum and 'UI/base/hypno/Pendelum' or 'UI/base/hypno/Pendelum_Phase2'
	local pendulumAnim = hypnoPendulum and 'Pendelum instance 1' or 'pendulum Phase 2'

	makeAnimatedLuaSprite('pendulumTrail', pendulumImage, 0, 0)
	addAnimationByPrefix('pendulumTrail', 'idle', pendulumAnim, 24, true)
	objectPlayAnimation('pendulumTrail', 'idle')

	if hypnoPendulum then
		scaleObject('pendulumTrail', 1.2, 1.2)
	else
		setProperty('pendulumTrail.origin.x', 65)
		setProperty('pendulumTrail.origin.y', 0)
	end

	updateHitbox('pendulumTrail')
	setProperty('pendulumTrail.origin.x', 65)
	setProperty('pendulumTrail.origin.y', 0)

	if hypnoPendulum then
		addLuaSprite('pendulumTrail', true)
	else
		setObjectCamera('pendulumTrail', 'other')
		setProperty('pendulumTrail.x', (screenWidth / 2) - (getProperty('pendulumTrail.width') / 2))
		setProperty('pendulumTrail.y', 0)
		addLuaSprite('pendulumTrail', true)
	end

	setProperty('pendulumTrail.alpha', 0)

	makeAnimatedLuaSprite('pendulum', pendulumImage, 0, 0)
	addAnimationByPrefix('pendulum', 'idle', pendulumAnim, 24, true)
	objectPlayAnimation('pendulum', 'idle')

	if hypnoPendulum then
		scaleObject('pendulum', 1.2, 1.2)
		setProperty('pendulum.angle', -9)
		updateHitbox('pendulum')
		setProperty('pendulum.origin.x', 65)
		setProperty('pendulum.origin.y', 0)
		addLuaSprite('pendulum', true)
	else
		updateHitbox('pendulum')
		setObjectCamera('pendulum', 'other')
		setProperty('pendulum.origin.x', 65)
		setProperty('pendulum.origin.y', 0)
		setProperty('pendulum.x', (screenWidth / 2) - (getProperty('pendulum.width') / 2))
		setProperty('pendulum.y', 0)
		addLuaSprite('pendulum', true)
	end

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

	runTimer('psyshock', getRandomInt(5, 15))
end

function reset()
	if cutscened or getVar('pausePendulum') then
		return
	end

	cancelTween('pend0')
	cancelTween('pend1')
	cancelTween('pend2')
	cancelTween('pend3')

	local startAngle = hypnoPendulum and -9 or 0
	local swingAngle = hypnoPendulum and 40 + -9 or 30

	setProperty('pendulum.angle', startAngle)
	doTweenAngle('pend1', 'pendulum', startAngle + swingAngle, swingDuration(), 'quadOut')
end

function onBeatHit()
	if curBeat % getVar('swingTime') == 0 then
		reset()
	end

	if curBeat % (getVar('swingTime') / 2) == 0 then
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
	local swingAngle = hypnoPendulum and 40 + -9 or 30

	if tag == 'pend0' then
		doTweenAngle('pend1', 'pendulum', getProperty('pendulum.angle') + swingAngle, swingDuration(), 'quadOut')
	elseif tag == 'pend1' then
		doTweenAngle('pend2', 'pendulum', getProperty('pendulum.angle') - swingAngle, swingDuration(), 'quadIn')

		if canHit then
			lose()
			pendFeedback(1)
		end

		canHit = true
	elseif tag == 'pend2' then
		doTweenAngle('pend3', 'pendulum', getProperty('pendulum.angle') - swingAngle, swingDuration(), 'quadOut')
	elseif tag == 'pend3' then
		doTweenAngle('pend0', 'pendulum', getProperty('pendulum.angle') + swingAngle, swingDuration(), 'quadIn')

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

	if boyfriendName == 'gf' then
		if alpha > 0.8 then
			triggerEvent('Alt Idle Animation', 'bf', '-hypnotised2')
		elseif alpha > 0.4 then
			triggerEvent('Alt Idle Animation', 'bf', '-hypnotised1')
		end
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

	local startAngle = hypnoPendulum and -9 or 0
	local swingAngle = hypnoPendulum and 40 + -9 or 30

	doTweenAngle('pend1', 'pendulum', startAngle + swingAngle, swingDuration(), 'quadOut')

	playSound('TranceStatic', 0, 'trance')
end

function onTimerCompleted(tag)
	if tag == 'psyshock' and not cutscened then
		runTimer('psyshock', getRandomInt(5, 15))

		if not getVar('pausePendulum') then
			playSound('Psyshock', 1)

			setProperty('daFlash.alpha', 1)
			doTweenAlpha('flashOut', 'daFlash', 0, 1, 'linear')

			setProperty('psyshockParticle.alpha', 1)
			playAnim('psyshockParticle', 'spark', true)

			if hypnoPendulum then
				setProperty('psyshockParticle.x', getProperty('dad.x') + 840)
				setProperty('psyshockParticle.y', getProperty('dad.y') - 30)
				triggerEvent('Play Animation', 'psyshock', 'dad')
			end

			lose()
		end
	elseif tag == 'tutorialFadeOut' then
		doTweenAlpha('tutorialOut', 'tutorial', 0, 0.5, 'linear')
	end
end

function onUpdate(elapsed)
	if hypnoPendulum then
		setPendulumOffset()

		setProperty('pendulum.x', getProperty('dad.x') + 2 + pendOffX)
		setProperty('pendulum.y', getProperty('dad.y') + 10 + pendOffY)
	end

	if not getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') or curBeat <= 0 or getVar('pausePendulum') then
		return
	end

	local angle = getProperty('pendulum.angle')

	if hypnoPendulum then
		angle = angle - (-9)
	end

	if angle > -hitWindow and angle < hitWindow then
		if hypnoPendulum then
			setProperty('pendulumTrail.x', getProperty('pendulum.x'))
			setProperty('pendulumTrail.y', getProperty('pendulum.y'))
		end

		setProperty('pendulumTrail.angle', getProperty('pendulum.angle'))
		setProperty('pendulumTrail.alpha', 1)
		doTweenAlpha('trailFade', 'pendulumTrail', 0, 0.15, 'linear')

		local alpha = getProperty('trance.alpha') - 0.075
		setProperty('trance.alpha', alpha)

		if boyfriendName == 'gf' and alpha < 0.4 then
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

function onEndSong()
	destroyPendulum()
	close()
	return Function_Continue
end