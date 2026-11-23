local playedNoise = false

function onCreate()
	addLuaScript('pendulum')
end

function onEndSong()
	if isStoryMode and not playedNoise then
		playedNoise = true

		setProperty('camGame.visible', false)
		setProperty('camHUD.visible', false)
		setProperty('camOther.visible', false)

		playSound('transitionSplatter', 1)
		runTimer('next', 2)

		return Function_Stop
	end

	return Function_Continue
end

function onTimerCompleted(tag)
	if tag == 'next' then
		endSong()
	end
end