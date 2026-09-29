local timestep=0
local newZoom=0
local SongStart=false
function onEvent(eventName, value1, value2)
    if eventName=='MissingnoZoomIn' then
        doTweenY('Ins','CameraSpeedZoomIns', 1, 30,'expoIn')
        doTweenX('Desaturation','Desaturation', 1, 30,'expoIn')
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
