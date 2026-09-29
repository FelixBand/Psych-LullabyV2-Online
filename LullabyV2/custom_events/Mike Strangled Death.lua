function onEvent(eventName, value1, value2)
    if eventName=='Mike Strangled Death' then  
        setProperty('redOverlay.alpha',1)
        doTweenAlpha('redOverlay','redOverlay',0.001,1.5,'quadInOut')
        cameraShake('game',0.008, 0.04)
        cameraShake('hud',0.008, 0.04)
        playSound('DissensionDeath')

        setGlobalFromScript('scripts/Stuff/CameraMove','ManualPos',getPositionArrayCenter())
        setGlobalFromScript('scripts/Stuff/CameraMove','ForceCamPos',true)
        playAnim('boyfriend','singUP',true)
        setHealth(0.01)
        doTweenY('MikeDeath','boyfriend',getProperty('boyfriend.y')- 750,2.5,'quadInOut')
        setProperty('camGame.zoom',getProperty('camGame.zoom')+ 0.2)
        runTimer('Death',3.5)
    end
end
function onTimerCompleted(tag, loops, loopsLeft)
    if tag=='Death' then
        setProperty('camGame.visible',false)
        setProperty('camHUD.visible',false)
    end
end
function getPositionArrayCenter() 
    local leftPosX = (getMidpointX('dad') + 100) + getProperty('dad.cameraPosition[0]')+getProperty('opponentCameraOffset[0]')
    local rightPosX = (getMidpointX('boyfriend') - 100) - getProperty('boyfriend.cameraPosition[0]')-getProperty('boyfriendCameraOffset[0]');
    local leftPosY = (getMidpointY('dad') - 100) + getProperty('dad.cameraPosition[1]')+getProperty('opponentCameraOffset[1]')
    local rightPosY = (getMidpointY('boyfriend') - 100) + getProperty('boyfriend.cameraPosition[1]')+getProperty('boyfriendCameraOffset[1]');
    return {(leftPosX + rightPosX) / 2, ((leftPosY + rightPosY) / 2) + 50}
end