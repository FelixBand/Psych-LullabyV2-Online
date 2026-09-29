local timestep=0
local newZoom=0
local SongStart=false
function onEvent(eventName, value1, value2)
    if eventName=='MissingnoZoomIn' then
        if value1==''  then
            newZoom=1
        else
            newZoom=tonumber(value1)
        end
        if value2=='' or tonumber(value2)<1 then
            timestep=1
        else
            timestep=tonumber(value2)
        end
        setProperty('camGame.zoom',getProperty('defaultCamZoom'))
        setProperty('cameraSpeed',0.01)
        runTimer('Delay',(((timestep / 4) * stepCrochet) / 1000))
        
       
    end
end
function onTimerCompleted(tag, loops, loopsLeft)
    if tag=='Delay' then
        
        doTweenX('CameraSpeed','CameraSpeedZoomIns',newZoom,((timestep * (3 / 4)) * stepCrochet) / 1000,'expoIn')
        doTweenZoom('Zoomasd','camGame',newZoom,((timestep * (3 / 4)) * stepCrochet) / 1000,'expoIn')
        doTweenY('Ins','CameraSpeedZoomIns',newZoom,((timestep * (3 / 4)) * stepCrochet) / 1000,'expoIn')
        doTweenX('Desaturation','Desaturation',newZoom,((timestep * (3 / 4)) * stepCrochet) / 1000,'expoIn')
    end
end
function onTweenCompleted(tag)
    if tag=='Desaturation' then
        setProperty('defaultCamZoom',0.8)
        setProperty('cameraSpeed',1)
        setShaderFloat('FiltreRef','intensityChromatic',0)
        setProperty('CameraSpeedZoomIns.y',0)
        setGlobalFromScript('scripts/Stuff/CameraMove','cameraCentred',false)
    end
end
function onSongStart()
    makeLuaSprite('CameraSpeedZoomIns',nil,0,0)
    makeLuaSprite('Desaturation',nil,0,0)
    if shadersEnabled then
    initLuaShader('desaturation')
	setSpriteShader('background', 'desaturation')
	setSpriteShader('missingnoOcean', 'desaturation')
	setSpriteShader('ground', 'desaturation')
	setSpriteShader('groundNoShadow', 'desaturation')
    setShaderFloat('missingnoOcean','desaturationAmount',0)
    setShaderFloat('missingnoOcean','amplitude',0)
    end
    SongStart=true
end
function onUpdate(elapsed)
  if SongStart then
    setProperty('cameraSpeed',getProperty('CameraSpeedZoomIns.x'))
    setShaderFloat('FiltreRef','intensityChromatic',getProperty('CameraSpeedZoomIns.y'))
    setShaderFloat('missingnoOcean','desaturationAmount',getProperty('Desaturation.x'))
  end

end
