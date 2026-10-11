function onCreate()
    setProperty('skipCountdown', true)
    setProperty('camGame.alpha', 0.0001)
    setProperty('camHUD.alpha', 0.0001)
    setProperty('cameraSpeed', 100)

    makeLuaSprite('ground', 'stages/shitno/images/floor', 745, 1075)
    scaleObject('ground', 0.9, 0.9)
    setScrollFactor('ground', 0.95, 0.95)
    setProperty('ground.alpha', 0.0001)
    addLuaSprite('ground')
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('defaultCamZoom', 1)
	elseif focus == 'dad' then
		setProperty('defaultCamZoom', 1.1)
	end
end