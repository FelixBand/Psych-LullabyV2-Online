local playedNoise = false

function onCreate()
    addLuaScript('pendulum')
end

function onEndSong()
	if not playedNoise and isStoryMode then
		playedNoise = true
		setProperty('camGame.visible', false)
		setProperty('camHUD.visible', false)
		setProperty('camOther.visible', false)
		playSound('transitionSplatter', 1)

		cleanup()
		runTimer('next', 2)

		return Function_Stop
	end

	return Function_Continue
end