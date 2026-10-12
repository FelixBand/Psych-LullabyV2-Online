function onCreate()
    setPropertyFromClass('PauseSubState', 'songName', 'LullabyPause')
end

function onUpdate()
    debugPrint(getProperty('camFollowPos.x') .. ' y: ' .. getProperty('camFollowPos.y'))
end