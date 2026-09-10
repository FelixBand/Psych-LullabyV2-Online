local swingTime = 4; -- 4 = normal, 2 = hell mode, can be higher if you want, dont make lower than 2 or an odd number will prob fuck it up
local hitWindow = 12;

function onCreate()
	makeAnimatedLuaSprite('pendulumTrail', 'UI/base/hypno/Pendelum_Phase2', 0, 0);
	addAnimationByPrefix('pendulumTrail', 'idle', 'pendulum Phase 2', 24, true);
	objectPlayAnimation('pendulumTrail', 'idle');
	updateHitbox('pendulumTrail');
	setObjectCamera('pendulumTrail', 'hud');
	setProperty('pendulumTrail.origin.x', 65);
	setProperty('pendulumTrail.origin.y', 0);
	setProperty('pendulumTrail.x', (screenWidth / 2) - (getProperty('pendulumTrail.width') / 2));
	setProperty('pendulumTrail.y', 0);
	addLuaSprite('pendulumTrail', true);
	setProperty('pendulumTrail.alpha', 0);

	makeAnimatedLuaSprite('pendulum', 'UI/base/hypno/Pendelum_Phase2', 0, 0);
	addAnimationByPrefix('pendulum', 'idle', 'pendulum Phase 2', 24, true);
	objectPlayAnimation('pendulum', 'idle');
	updateHitbox('pendulum');
	setObjectCamera('pendulum', 'hud');
	setProperty('pendulum.origin.x', 65);
	setProperty('pendulum.origin.y', 0);
	setProperty('pendulum.x', (screenWidth / 2) - (getProperty('pendulum.width') / 2));
	setProperty('pendulum.y', 0);
	addLuaSprite('pendulum', true);
	
	makeLuaSprite('daFlash', '', 0, 0);
    makeGraphic('daFlash', screenWidth, screenHeight, 'FFAFC1');
    setObjectCamera('daFlash', 'other');
    addLuaSprite('daFlash');
	setProperty('daFlash.alpha', 0);

	makeAnimatedLuaSprite('trance', 'UI/base/hypno/StaticHypno', -5, 0);
	addAnimationByPrefix('trance', 'idle', 'StaticHypno', 24, true);
	setObjectCamera('trance', 'other');
	setProperty('trance.alpha', 0);
	scaleObject('trance', 0.56, 0.49);
	addLuaSprite('trance');

	makeAnimatedLuaSprite('psyshockParticle', 'UI/base/hypno/Psyshock', 1250, 400);
	addAnimationByPrefix('psyshockParticle', 'spark', 'Full Psyshock Particle', 24, false);
	addLuaSprite('psyshockParticle');
end

function reset()
	if not cutscened then
		cancelTween('pend0');
		cancelTween('pend1');
		cancelTween('pend2');
		cancelTween('pend3');
		setProperty('pendulum.angle', 0);
		doTweenAngle('pend1', 'pendulum', getProperty('pendulum.angle') + 30, (stepCrochet / 1000) * swingTime, 'quadOut');
	end
end

function onBeatHit()
	if curBeat % swingTime == 0 then 
		reset();
	end
end

function onTweenCompleted(tag)
	if tag == 'pend0' then 
		doTweenAngle('pend1', 'pendulum', getProperty('pendulum.angle') + 30, (stepCrochet / 1000) * swingTime, 'quadOut');
	elseif tag == 'pend1' then 
		doTweenAngle('pend2', 'pendulum', getProperty('pendulum.angle') - 30, (stepCrochet / 1000) * swingTime, 'quadIn');
		if canHit then
			--when the player did not hit the pendulum
			lose();
		end
		canHit = true;
	elseif tag == 'pend2' then 
		doTweenAngle('pend3', 'pendulum', getProperty('pendulum.angle') - 30, (stepCrochet / 1000) * swingTime, 'quadOut');
	elseif tag == 'pend3' then 
		doTweenAngle('pend0', 'pendulum', getProperty('pendulum.angle') + 30, (stepCrochet / 1000) * swingTime, 'quadIn');
		if canHit then
			--when the player did not hit the pendulum
			lose();
		end
		canHit = true;
	end
end

function lose()
	if not cutscened then
		--debugPrint('failed to hit, noob');
		setProperty('trance.alpha', getProperty('trance.alpha') + 0.05);
		if getProperty('trance.alpha') > 0.4 and getProperty('trance.alpha') < 0.8 then
			triggerEvent('Alt Idle Animation', 'bf', '-alt');
		elseif getProperty('trance.alpha') > 0.8 then
			triggerEvent('Alt Idle Animation', 'bf', '-alt2');
		end
		if getProperty('trance.alpha') == 1 then
			setProperty('health', 0);
		end
		tranceSound();
	end
end

function tranceSound()
	stopSound('trance');
	playSound('TranceStatic', (getProperty('trance.alpha') * 1.1) - 0.35, 'trance');
end

function onSongStart()
	doTweenAngle('pend1', 'pendulum', getProperty('pendulum.angle') + 30, (stepCrochet / 1000) * 4, 'quadOut');
	runTimer('psyshock', getRandomInt(5, 15));
	playSound('TranceStatic', 0, 'trance');
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'psyshock' and not cutscened then
		runTimer('psyshock', getRandomInt(5, 15));
		playSound('Psyshock', 1);
		setProperty('daFlash.alpha', 1);
		doTweenAlpha('flashOut', 'daFlash', 0, 1, 'linear');
		--setProperty('psyshock.visible', true);
		objectPlayAnimation('psyshockParticle', 'spark', true);
		lose();
	end
end

function onUpdate(elapsed)
	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and curBeat > 0 then
		if getProperty('pendulum.angle') > -hitWindow and getProperty('pendulum.angle') < hitWindow then
			setProperty('pendulumTrail.angle', getProperty('pendulum.angle'));
			setProperty('pendulumTrail.alpha', 1);
			doTweenAlpha('trailFade', 'pendulumTrail', 0, 0.15, 'linear');
			setProperty('trance.alpha', getProperty('trance.alpha') - 0.075);
			if getProperty('trance.alpha') < 0.4 then
				triggerEvent('Alt Idle Animation', 'bf', '');
			end
			tranceSound();
			canHit = false;
		else
			lose();
			--debugPrint('bad timing, scrub');
		end
	end
end

function onGameOver()
	stopSound('trance');
end
function onPause()
	stopSound('trance');
end
function onResume()
	tranceSound();
end

local cutscened = false;
function onEndSong()
    if not cutscened and isStoryMode then
		setProperty('camGame.visible', false);
		setProperty('camHUD.visible', false);
		setProperty('camOther.visible', false);
		stopSound('trance');
        startVideo('leftunchecked');
        cutscened = true;
        return Function_Stop;
    end
return Function_Continue;
end