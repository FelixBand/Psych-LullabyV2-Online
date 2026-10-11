local doCharacterZoom = true

function onCreate()
    if getModSetting('mechanics') == 'Hell' then
		precacheImage('UI/base/hypno/Extras')
		precacheImage('UI/base/hypno/StaticHypno')
		precacheImage('UI/base/hypno/Pendelum_Phase2')
		precacheImage('UI/base/hypno/Psyshock')
	end

	setProperty('skipCountdown', true)
end

function onCreatePost()
	setObjectOrder('gfGroup', getObjectOrder('boyfriendGroup') + 1)
	setProperty('gfGroup.alpha', 0.001)
	setProperty('dadGroup.alpha', 0.001)
	setProperty('camHUD.alpha', 0)
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
	if name == 'Add Pendulum' then
		if getModSetting('mechanics') == 'Hell' then
			addLuaScript('pendulum')
			setProperty('pendulum.alpha', 0.0001)
			setProperty('pendulum.y', -300)
			setVar('pausePendulum', true)
			setVar('swingTime', 2)
			doTweenY('pendSlideIn', 'pendulum', 0, 2, 'circOut')
			doTweenAlpha('pendFadeIn', 'pendulum', 1, 2, 'circOut')
		end
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
        cameraSetTarget('dad')
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
            doCharacterZoom = false
			triggerEvent('Camera Follow Pos', '980', '1190')
            setProperty('defaultCamZoom', 1.2)
		end
		if value1 == 'turn back' and value2 == 'dad' then
            doCharacterZoom = true
            triggerEvent('Camera Follow Pos', '', '')
            cameraSetTarget('boyfriend')
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

function onTweenCompleted(tag)
	if tag == 'pendFadeIn' then
		setVar('pausePendulum', false)
	end
end

function onSongStart()
	doTweenAlpha('bgStaticIn', 'staticbg', 1, 5, 'linear')
end

function onMoveCamera(focus)
    if doCharacterZoom then
        if focus == 'boyfriend' then
            setProperty('defaultCamZoom', 0.75)
        elseif focus == 'dad' then
            setProperty('defaultCamZoom', 0.8)
        end
    end
end