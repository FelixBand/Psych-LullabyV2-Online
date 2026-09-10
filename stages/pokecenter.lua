local dir = 'stages/pokecenter/images/'
local charPositions = {860,920}

function onCreate()
	makeLuaSprite('floor', dir .. '8floor', 0, 0)
	setScrollFactor('floor', 1, 1)
	addLuaSprite('floor')

	makeLuaSprite('backlayer', dir .. '7backlayer', -4, 0)
	setScrollFactor('backlayer', 0.98, 0.98)
	addLuaSprite('backlayer')

	makeLuaSprite('nursejoy', dir .. '6nursejoy', 1261, 670)
	setScrollFactor('nursejoy', 0.98, 0.98)
	setProperty('nursejoy.origin.x', 75)
	setProperty('nursejoy.origin.y', 0)
	addLuaSprite('nursejoy')

	makeLuaSprite('table', dir .. '5table', -5, -8)
	setScrollFactor('table', 0.98, 0.98)
	addLuaSprite('table')

	makeLuaSprite('obscure', dir .. 'fgObscure', 0, 0)
	setScrollFactor('obscure', 0.98, 0.98)
	addLuaSprite('obscure')

	-- characters

	makeLuaSprite('misdreavousShadow', dir .. '/characters/misdreavousEye', charPositions[1] + 90, charPositions[2] - 265)
	setScrollFactor('misdreavousShadow', 0.98, 0.98)
	setProperty('misdreavousShadow.alpha', 0.001)
	setProperty('misdreavousShadow.color', 0xFFFF0000);
	addLuaSprite('misdreavousShadow')

	makeAnimatedLuaSprite('jiggles', dir .. '/characters/Purinsoulstare', 1275, 1090)
	addAnimationByPrefix('jiggles', 'idle', 'Jigglypuff bg', 24, true)
	setProperty('jiggles.alpha', 0.001)
	addLuaSprite('jiggles')

	makeAnimatedLuaSprite('audinosShadow', dir .. '/characters/Audinos ALT', charPositions[1], charPositions[2])
	addAnimationByIndices('audinosShadow', 'idle', 'Audino shadow one', '24', 1)
	scaleObject('audinosShadow', 0.7, 0.7)
	setScrollFactor('audinosShadow', 0.98, 0.98)
	setProperty('audinosShadow.alpha', 0.001)
	setProperty('audinosShadow.color', 0xFFFF0000);
	addLuaSprite('audinosShadow')

	makeAnimatedLuaSprite('cuboneShadow', dir .. '/characters/CUBONE ALT', charPositions[1] + 225, charPositions[2] + 95)
	addAnimationByIndices('cuboneShadow', 'idle', 'CUBONE ONE SHADOW', '24', 1)
	scaleObject('cuboneShadow', 0.6, 0.6)
	setScrollFactor('cuboneShadow', 0.98, 0.98)
	setProperty('cuboneShadow.alpha', 0.001)
	setProperty('cuboneShadow.color', 0xFFFF0000);
	addLuaSprite('cuboneShadow')

	makeLuaSprite('charmanderShadow', dir .. '/characters/charmanderEyes', charPositions[1] + 475, charPositions[2] + 50)
	scaleObject('charmanderShadow', 0.7, 0.7)
	setScrollFactor('charmanderShadow', 0.98, 0.98)
	setProperty('charmanderShadow.alpha', 0.001)
	setProperty('charmanderShadow.color', 0xFFFF0000);
	addLuaSprite('charmanderShadow')

	makeLuaSprite('duskullShadow', dir .. '/characters/duskullEye', charPositions[1] + 625, charPositions[2] - 225)
	setScrollFactor('duskullShadow', 0.98, 0.98)
	setProperty('duskullShadow.alpha', 0.001)
	setProperty('duskullShadow.color', 0xFFFF0000);
	addLuaSprite('duskullShadow')

	makeLuaSprite('chanseyShadow', dir .. '/characters/chanseyEyes', charPositions[1] + 575, charPositions[2] - 120)
	scaleObject('chanseyShadow', 0.9, 0.9)
	setScrollFactor('chanseyShadow', 0.98, 0.98)
	setProperty('chanseyShadow.alpha', 0.001)
	setProperty('chanseyShadow.color', 0xFFFF0000);
	addLuaSprite('chanseyShadow')

	-- characters

	-- animated characters

	makeAnimatedLuaSprite('misdreavous', dir .. '/characters/Misdreavous', charPositions[1] + 90, charPositions[2] - 265)
	addAnimationByPrefix('misdreavous', 'idle', 'MISDREAVEOUS REA SHAKE', 24, true)
	setScrollFactor('misdreavous', 0.98, 0.98)
	setProperty('misdreavous.alpha', 0.001)
	--setProperty('misdreavous.color', 0xFFFF0000);
	addLuaSprite('misdreavous')

	makeAnimatedLuaSprite('audinos', dir .. '/characters/Audinos ALT', charPositions[1], charPositions[2])
	addAnimationByPrefix('audinos', 'idle', 'Audini shake Four', 24, true)
	scaleObject('audinos', 0.7, 0.7)
	setScrollFactor('audinos', 0.98, 0.98)
	setProperty('audinos.alpha', 0.001)
	--setProperty('audinos.color', 0xFFFF0000);
	addLuaSprite('audinos')

	makeAnimatedLuaSprite('cubone', dir .. '/characters/CUBONE ALT', charPositions[1] + 225, charPositions[2] + 95)
	addAnimationByPrefix('cubone', 'idle', 'CUBONE SHAKE TREE', 24, true)
	scaleObject('cubone', 0.6, 0.6)
	setScrollFactor('cubone', 0.98, 0.98)
	setProperty('cubone.alpha', 0.001)
	--setProperty('cubone.color', 0xFFFF0000);
	addLuaSprite('cubone')

	makeAnimatedLuaSprite('charmander', dir .. '/characters/Charmander', charPositions[1] + 475, charPositions[2] + 50)
	addAnimationByPrefix('charmander', 'idle', 'CHarmander frompokehell', 24, true)
	scaleObject('charmander', 0.7, 0.7)
	setScrollFactor('charmander', 0.98, 0.98)
	setProperty('charmander.alpha', 0.001)
	--setProperty('charmander.color', 0xFFFF0000);
	addLuaSprite('charmander')

	makeAnimatedLuaSprite('duskull', dir .. '/characters/DustskullBackground', charPositions[1] + 625, charPositions[2] - 225)
	addAnimationByPrefix('duskull', 'idle', 'DUSTSKULLHELL', 24, true)
	setScrollFactor('duskull', 0.98, 0.98)
	setProperty('duskull.alpha', 0.001)
	--setProperty('duskull.color', 0xFFFF0000);
	addLuaSprite('duskull')

	makeAnimatedLuaSprite('chansey', dir .. '/characters/Chansey', charPositions[1] + 575, charPositions[2] - 120)
	addAnimationByPrefix('chansey', 'idle', 'Chansey Normal shake', 24, true)
	scaleObject('chansey', 0.9, 0.9)
	setScrollFactor('chansey', 0.98, 0.98)
	setProperty('chansey.alpha', 0.001)
	--setProperty('chansey.color', 0xFFFF0000);
	addLuaSprite('chansey')

	-- animated characters

	makeAnimatedLuaSprite('staticbg', 'static', 900, 665)
	addAnimationByPrefix('staticbg', 'idle', 'static', 24, true)
	setProperty('staticbg.antialiasing', false)
	scaleObject('staticbg', 1, 1)
	setProperty('staticbg.alpha', 0.001)
	addLuaSprite('staticbg')

	makeAnimatedLuaSprite('staticfg', 'static', -220, -150)
	addAnimationByPrefix('staticfg', 'idle', 'static', 24, true)
	setProperty('staticfg.antialiasing', false)
	scaleObject('staticfg', 2.5, 2)
	setProperty('staticfg.alpha', 0.001)
	setScrollFactor('staticfg', 0, 0)
	addLuaSprite('staticfg', true)

	makeLuaSprite('toplayer', dir .. '4toplayer', 0, 0)
	setScrollFactor('toplayer', 1, 1)
	addLuaSprite('toplayer')

	makeLuaSprite('window', dir .. '3window', 0, 0)
	setScrollFactor('window', 1, 1)
	addLuaSprite('window')

	makeLuaSprite('painting', dir .. '2painting', 0, 0)
	setScrollFactor('painting', 1, 1)
	addLuaSprite('painting')

	makeAnimatedLuaSprite('staticbgchars', 'static', 100, 450)
	addAnimationByPrefix('staticbgchars', 'idle', 'static', 24, true)
	setProperty('staticbgchars.antialiasing', false)
	scaleObject('staticbgchars', 2.5, 2)
	setProperty('staticbgchars.alpha', 0.001)
	addLuaSprite('staticbgchars')

	makeLuaSprite('darkoverlay', dir .. '1darknessoverlay', -220, -150)
	setScrollFactor('darkoverlay', 0, 0)
	scaleObject('darkoverlay', 0.7, 0.7)
	addLuaSprite('darkoverlay')

	setProperty('skipCountdown', true)
end

function onEvent(name, value1, value2)
	if name == 'entrance' then
		doTweenAlpha('bgStaticIn', 'staticbg', 1, 1, 'linear')
		triggerEvent('Camera Follow Pos', '1350', '1100')
		triggerEvent('Play Animation', 'turned', 'bf')
		triggerEvent('Alt Idle Animation', 'bf', '-disabled')
		doTweenZoom('camZoom', 'camGame', 1.5, 5, 'cubeOut')
		doTweenAlpha('bgStaticOut', 'staticbg', 0, 1, 'linear')

		setProperty('jiggles.alpha', 1)
		setProperty('cuboneShadow.alpha', 1)
		setProperty('audinosShadow.alpha', 1)
		setProperty('duskullShadow.alpha', 1)
		setProperty('chanseyShadow.alpha', 1)
		setProperty('charmanderShadow.alpha', 1)
		setProperty('misdreavousShadow.alpha', 1)
	end
	if name == 'color tween in' then
		doTweenColor('tween'..value1, value1, 0, 1, 'linear')
		if value1 == 'duskullShadow' then
			doTweenZoom('camZoom', 'camGame', 0.9, 3, 'cubeOut')
			triggerEvent('Camera Follow Pos', '1350', '1000')
			doTweenAlpha('obscureOut', 'obscure', 0.5, 10, 'linear')
		end
	end
	if name == 'fade in' then
		doTweenAlpha('fade'..value1, value1, 1, 1, 'linear')
	end
	if name == 'fade out' then
		doTweenAlpha('fade'..value1, value1, 0, 1, 'linear')
	end
	if name == 'bgstatic in' then
		doTweenAlpha('bgStaticIn', 'staticbg', 1, 2, 'linear')
	end
	if name == 'epic start' then
		setProperty('staticbg.visible', false)
		setProperty('jiggles.visible', false)
		setProperty('dadGroup.alpha', 1)
		doTweenAlpha('camHUDIn', 'camHUD', 1, 1, 'linear')
		triggerEvent('Camera Follow Pos', '', '')
		triggerEvent('Alt Idle Animation', 'bf', '')
		triggerEvent('fade in', 'cubone', '')
		setProperty('staticfg.alpha', 1)
		doTweenAlpha('fgstaticout', 'staticfg', 0, 1, 'linear')
	end
	if name == 'Play Animation' then
		if value1 == 'turn' and value2 == 'dad' then
			doTweenAlpha('charstaticin', 'staticbgchars', 1, 1, 'linear')
			doTweenAlpha('healthbarout', 'healthBar', 0, 1, 'linear')
			doTweenAlpha('timebarout', 'timeBar', 0, 1, 'linear')
			doTweenAlpha('timetxtout', 'timeTxt', 0, 1, 'linear')
			doTweenAlpha('scoretxtout', 'scoreTxt', 0, 1, 'linear')
			doTweenAlpha('icon1out', 'iconP1', 0, 1, 'linear')
			doTweenAlpha('icon2out', 'iconP2', 0, 1, 'linear')
		end
		if value1 == 'turn back' and value2 == 'dad' then
			doTweenAlpha('charstaticout', 'staticbgchars', 0, 1, 'linear')
			doTweenAlpha('healthbarin', 'healthBar', 1, 1, 'linear')
			doTweenAlpha('timebarin', 'timeBar', 1, 1, 'linear')
			doTweenAlpha('timetxtin', 'timeTxt', 1, 1, 'linear')
			doTweenAlpha('scoretxtin', 'scoreTxt', 1, 1, 'linear')
			doTweenAlpha('icon1in', 'iconP1', 1, 1, 'linear')
			doTweenAlpha('icon2in', 'iconP2', 1, 1, 'linear')
		end
	end
	if name == 'outro' then
		setProperty('staticfg.alpha', 1)
		doTweenAlpha('fgstaticout', 'staticfg', 0, 1, 'linear')
		setProperty('dadGroup.visible', false)
		setProperty('misdreavous.visible', false)
		setProperty('staticbg.visible', true)
		doTweenAlpha('camHUDOut', 'camHUD', 0, 0.5, 'linear')

		setProperty('misdreavousShadow.color', 0xFFFF0000);
		setProperty('cuboneShadow.color', 0xFFFF0000);
		setProperty('audinosShadow.color', 0xFFFF0000);
		setProperty('duskullShadow.color', 0xFFFF0000);
		setProperty('chanseyShadow.color', 0xFFFF0000);
		setProperty('charmanderShadow.color', 0xFFFF0000);
	end
end

function onCreatePost()
	setObjectOrder('gfGroup', getObjectOrder('boyfriendGroup') + 1)
	setProperty('gfGroup.alpha', 0.001)
	setProperty('dadGroup.alpha', 0.001)
	setProperty('camHUD.alpha', 0)
end

function onSongStart()
	doTweenAlpha('bgStaticIn', 'staticbg', 1, 5, 'linear')
end

function onUpdate(elapsed)
	--nursejoy.angle = nurseangle + Math.sin((180 / Math.PI) * ((Conductor.songPosition / 1000) / 36)) * 3
	setProperty('nursejoy.angle', math.sin((180 / math.pi) * ((getSongPosition() / 1000 ) / 36)) * 3)

	if curBeat >= 460 then
		-- staticbg should pulse in and out between 0.25 and 0.6 using a sine wave based on the song position
		setProperty('staticbg.alpha', 0.625 + math.sin((180 / math.pi) * ((getSongPosition() / 1000 ) / 36)) * 0.175)
		triggerEvent('Camera Follow Pos', '1350', '1000')
		setProperty('camZooming', false)
	end
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('defaultCamZoom', 0.75)
	elseif focus == 'dad' then
		if dadName == 'jigglypuff-recolored' then
			setProperty('defaultCamZoom', 1.2)
		else
			setProperty('defaultCamZoom', 0.8)
		end
	end
end