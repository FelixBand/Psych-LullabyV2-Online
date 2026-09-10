local swingTime = 4; -- 4 = normal, 2 = hell mode, can be higher if you want, dont make lower than 2 or an odd number will prob fuck it up
local hitWindow = 12;

local angleOff = -9;

function onCreate()
	makeAnimatedLuaSprite('pendulumTrail', 'UI/base/hypno/Pendelum', 0, 0);
	addAnimationByPrefix('pendulumTrail', 'idle', 'Pendelum instance 1', 24, true);
	objectPlayAnimation('pendulumTrail', 'idle');
	scaleObject('pendulumTrail', 1.2, 1.2);
	updateHitbox('pendulumTrail');
	setProperty('pendulumTrail.origin.x', 65);
	setProperty('pendulumTrail.origin.y', 0);
	addLuaSprite('pendulumTrail', true);
	setProperty('pendulumTrail.alpha', 0);

	makeAnimatedLuaSprite('pendulum', 'UI/base/hypno/Pendelum', 1200, 500);
	addAnimationByPrefix('pendulum', 'idle', 'Pendelum instance 1', 24, true);
	objectPlayAnimation('pendulum', 'idle');
	scaleObject('pendulum', 1.2, 1.2);
	updateHitbox('pendulum');
	setProperty('pendulum.origin.x', 65);
	setProperty('pendulum.origin.y', 0);
	setProperty('pendulum.angle', angleOff);
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
	if not playedNoise then
		cancelTween('pend0');
		cancelTween('pend1');
		cancelTween('pend2');
		cancelTween('pend3');
		setProperty('pendulum.angle', angleOff);
		doTweenAngle('pend1', 'pendulum', getProperty('pendulum.angle') + (40 + angleOff), (stepCrochet / 1000) * swingTime, 'quadOut');
	end
end

function onBeatHit()
	if curBeat % swingTime == 0 then 
		reset();
	end
end

function onTweenCompleted(tag)
	if tag == 'pend0' then 
		doTweenAngle('pend1', 'pendulum', getProperty('pendulum.angle') + (40 + angleOff), (stepCrochet / 1000) * swingTime, 'quadOut');
	elseif tag == 'pend1' then 
		doTweenAngle('pend2', 'pendulum', getProperty('pendulum.angle') - (40 + angleOff), (stepCrochet / 1000) * swingTime, 'quadIn');
		if canHit then
			--when the player did not hit the pendulum
			lose();
		end
		canHit = true;
	elseif tag == 'pend2' then 
		doTweenAngle('pend3', 'pendulum', getProperty('pendulum.angle') - (40 + angleOff), (stepCrochet / 1000) * swingTime, 'quadOut');
	elseif tag == 'pend3' then 
		doTweenAngle('pend0', 'pendulum', getProperty('pendulum.angle') + (40 + angleOff), (stepCrochet / 1000) * swingTime, 'quadIn');
		if canHit then
			--when the player did not hit the pendulum
			lose();
		end
		canHit = true;
	end
end

function lose()
	if not playedNoise then
		--debugPrint('failed to hit, noob');
		setProperty('trance.alpha', getProperty('trance.alpha') + 0.05);
		if getProperty('trance.alpha') > 0.4 and getProperty('trance.alpha') < 0.8 then
			triggerEvent('Alt Idle Animation', 'bf', '-alt');
		elseif getProperty('trance.alpha') > 0.8 then
			triggerEvent('Alt Idle Animation', 'bf', '-alt2');
		end
		if getProperty('trance.alpha') == 1 and not playedNoise then
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
	doTweenAngle('pend1', 'pendulum', getProperty('pendulum.angle') + (40 + angleOff), (stepCrochet / 1000) * 4, 'quadOut');
	runTimer('psyshock', getRandomInt(5, 15));
	playSound('TranceStatic', 0, 'trance');
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'psyshock' and not playedNoise then
		runTimer('psyshock', getRandomInt(5, 15));
		playSound('Psyshock', 1);
		setProperty('daFlash.alpha', 1);
		doTweenAlpha('flashOut', 'daFlash', 0, 1, 'linear');
		--setProperty('psyshock.visible', true);
		objectPlayAnimation('psyshockParticle', 'spark', true);
		triggerEvent('Play Animation', 'psyshock', 'dad');
		lose();
	end

	if tag == 'next' then
		endSong();
	end
end

local pendX = 412;
local pendY = 440;

pendOffX = 0;
pendOffY = 0;

function onUpdate(elapsed)
	frame = getProperty('dad.animation.curAnim.curFrame');
	if getProperty('dad.animation.curAnim.name') == 'idle' then
		if frame <= 1 then
			pendOffX = 814;
			pendOffY = 264;
		elseif frame == 2 or frame == 3 then
			pendOffX = 813;
			pendOffY = 270;
		elseif frame == 4 then
			pendOffX = 813;
			pendOffY = 266;
		elseif frame == 5 then
			pendOffX = 813;
			pendOffY = 263;
		elseif frame == 6 then
			pendOffX = 814;
			pendOffY = 255
		elseif frame == 7 then
			pendOffX = 811;
			pendOffY = 251;
		elseif frame == 8 or frame == 9 then
			pendOffX = 809;
			pendOffY = 249;
		elseif frame >= 10 then
			pendOffX = 808;
			pendOffY = 248;
		end
	end
	if getProperty('dad.animation.curAnim.name') == 'singLEFT' then
		if frame == 0 then
			pendOffX = 775;
			pendOffY = 336;
		elseif frame == 1 then
			pendOffX = 790;
			pendOffY = 351;
		elseif frame == 2 then
			pendOffX = 826;
			pendOffY = 366;
		elseif frame == 3 or frame == 4 then
			pendOffX = 830;
			pendOffY = 378;
		elseif frame == 5 or frame == 6 then
			pendOffX = 831;
			pendOffY = 393;
		elseif frame >= 7 then
			pendOffX = 832;
			pendOffY = 396;
		end
	end
	if getProperty('dad.animation.curAnim.name') == 'singRIGHT' then
		if frame <= 2 then
			pendOffX = 866;
			pendOffY = 609;
		elseif frame == 3 then
			pendOffX = 858;
			pendOffY = 612;
		elseif frame == 4 then
			pendOffX = 881;
			pendOffY = 610;
		elseif frame == 5 then
			pendOffX = 901;
			pendOffY = 597;
		elseif frame == 6 then
			pendOffX = 903;
			pendOffY = 590;
		elseif frame >= 7 then
			pendOffX = 908;
			pendOffY = 586;
		end
	end
	if getProperty('dad.animation.curAnim.name') == 'singUP' then
		if frame == 0 then
			pendOffX = 638;
			pendOffY = -300;
		elseif frame == 1 then
			pendOffX = 675;
			pendOffY = -267;
		elseif frame == 2 then
			pendOffX = 681;
			pendOffY = -257;
		elseif frame == 3 then
			pendOffX = 694;
			pendOffY = -249;
		elseif frame == 4 then
			pendOffX = 696;
			pendOffY = -241;
		elseif frame == 5 then
			pendOffX = 705;
			pendOffY = -237;
		elseif frame == 6 or frame == 7 then
			pendOffX = 709;
			pendOffY = -236;
		elseif frame >= 8 then
			pendOffX = 711;
			pendOffY = -234;
		end
	end
	if getProperty('dad.animation.curAnim.name') == 'singDOWN' then
		if frame == 0 then
			pendOffX = 700;
			pendOffY = 222;
		elseif frame == 1 then
			pendOffX = 705;
			pendOffY = 237;
		elseif frame == 2 then
			pendOffX = 692;
			pendOffY = 220;
		elseif frame == 3 or frame == 4 then
			pendOffX = 687;
			pendOffY = 213;
		elseif frame == 5 then
			pendOffX = 690;
			pendOffY = 220;
		elseif frame == 6 then
			pendOffX = 689;
			pendOffY = 227;
		elseif frame == 7 then
			pendOffX = 680;
			pendOffY = 242;
		elseif frame == 8 then
			pendOffX = 679;
			pendOffY = 243;
		elseif frame >= 9 then
			pendOffX = 673;
			pendOffY = 253;
		end
	end
	if getProperty('dad.animation.curAnim.name') == 'psyshock' then
		if frame == 0 then
			pendOffX = 737;
			pendOffY = 386;
		elseif frame == 1 then
			pendOffX = 713;
			pendOffY = 396;
		elseif frame == 2 then
			pendOffX = 706;
			pendOffY = 394;
		elseif frame == 3 then
			pendOffX = 708;
			pendOffY = 392;
		elseif frame == 4 or frame == 5 then
			pendOffX = 709;
			pendOffY = 391;
		elseif frame == 6 then
			pendOffX = 709;
			pendOffY = 405;
		elseif frame >= 7 then
			pendOffX = 703;
			pendOffY = 416;
		end
	end

	setProperty('pendulum.x', pendX + pendOffX);
	setProperty('pendulum.y', pendY + pendOffY);

	if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') and curBeat > 0 then
		if (getProperty('pendulum.angle') - angleOff) > -hitWindow and (getProperty('pendulum.angle') - angleOff) < hitWindow then
			setProperty('pendulumTrail.x', getProperty('pendulum.x'));
			setProperty('pendulumTrail.y', getProperty('pendulum.y'));
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

local playedNoise = false;
function onEndSong()
	if not playedNoise and isStoryMode then
		playedNoise = true;
		stopSound('trance');
		setProperty('camGame.visible', false);
		setProperty('camHUD.visible', false);
		setProperty('camOther.visible', false);
		playSound('transitionSplatter', 1);
		runTimer('next', 2);
		return Function_Stop;
	end
	return Function_Continue;
end