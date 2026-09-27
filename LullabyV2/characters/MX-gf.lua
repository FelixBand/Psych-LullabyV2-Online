function onCreate()
    local ScaleMX=0.9
    makeAnimatedLuaSprite('MXArms','characters/mx/mxfront',0,0)
    addAnimationByPrefix('MXArms','idle','IdleFront',16,false)
    addAnimationByPrefix('MXArms','singLEFT','LeftFront',24,false)
    addAnimationByPrefix('MXArms','singDOWN','DownFront',24,false)
    addAnimationByPrefix('MXArms','singUP','UpFront',24,false)
    addAnimationByPrefix('MXArms','singRIGHT','RightFront',24,false)
    addAnimationByPrefix('MXArms','Hit1','Hit1Front',24,false)
    addAnimationByPrefix('MXArms','Hit2','Hit2Front',24,false)
    scaleObject('MXArms',ScaleMX,ScaleMX)

    addOffset('MXArms','idle',60*ScaleMX, 5*ScaleMX)
    addOffset('MXArms','singLEFT',440*ScaleMX, -118*ScaleMX)
    addOffset('MXArms','singDOWN',56*ScaleMX, -124*ScaleMX)
    addOffset('MXArms','singUP',52*ScaleMX, 0*ScaleMX)
    addOffset('MXArms','singRIGHT',-9*ScaleMX, -112*ScaleMX)
    addOffset('MXArms','Hit1',111*ScaleMX, -2*ScaleMX)
    addOffset('MXArms','Hit2',132*ScaleMX, -100*ScaleMX)
    
    playAnim('MXArms','idle',true)
    
    makeAnimatedLuaSprite('POW','characters/mx/mxblock',0,0)
    addAnimationByPrefix('POW','bop','blockIdle',24,false)

    local MXOffsetY=-50
    local MXOffsetX=-72
    
    setProperty('MXArms.x',getProperty('dad.x')+MXOffsetX)
    setProperty('MXArms.y',getProperty('dad.y')+MXOffsetY)
    addLuaSprite('MXArms',true)

    setProperty('POW.x',getProperty('MXArms.x')-MXOffsetX-150)
    setProperty('POW.y',getProperty('MXArms.y')-MXOffsetY+415)
    addLuaSprite('POW',true)
    
end

function onUpdate(elapsed)
    local charAnim=getProperty('boyfriend.animation.curAnim.name')
    playAnim('MXArms',charAnim,true,false,getProperty('boyfriend.animation.curAnim.curFrame'))
end