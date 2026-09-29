local timestep=0
local newZoom=0
local SongStart=false
function onEvent(eventName, value1, value2)
    if eventName=='MissingnoZoomIn' then
        runTimer('Delay',(((timestep / 4) * stepCrochet) / 1000))
    end
end
function onTimerCompleted(tag, loops, loopsLeft)
    if tag=='Delay' then
        doTweenY('Ins','CameraSpeedZoomIns',newZoom,((timestep * (3 / 4)) * stepCrochet) / 1000,'expoIn')
        doTweenX('Desaturation','Desaturation',newZoom,((timestep * (3 / 4)) * stepCrochet) / 1000,'expoIn')
    end
end
function onTweenCompleted(tag)
    if tag=='Desaturation' then
        setProperty('defaultCamZoom',0.8)
        setShaderFloat('FiltreRef','intensityChromatic',0)
        setProperty('CameraSpeedZoomIns.y',0)
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
    setShaderFloat('FiltreRef','intensityChromatic',getProperty('CameraSpeedZoomIns.y'))
    setShaderFloat('missingnoOcean','desaturationAmount',getProperty('Desaturation.x'))
  end

end
