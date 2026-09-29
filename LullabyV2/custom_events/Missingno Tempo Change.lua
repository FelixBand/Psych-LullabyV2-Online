function onEvent(eventName, value1, value2)
    if eventName=='Missingno Tempo Change' then
        
        setSpriteShader('dad','individualGlitches Missingno')
        setSpriteShader('ground','individualGlitches Missingno')
        setShaderFloat('dad','binaryIntensity',0)
        if not lowQuality then
            setSpriteShader('background','glitch')
            setShaderFloat('background','prob',0)
           
        end
        makeLuaSprite('Glitch',nil,0,0)
        doTweenX('Glitch','Glitch',1,(stepCrochet * 56) / 1000,'cubeInOut')
        
    end
end
function onCreate()
    initLuaShader('individualGlitches Missingno')
end
