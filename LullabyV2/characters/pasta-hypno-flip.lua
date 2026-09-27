function onCreate()
    local HypnoScale=1
    makeAnimatedLuaSprite('HypnoArms','characters/hypno/PASTA_HYPNO')
    addAnimationByPrefix('HypnoArms','idle','Hypno Idle Front',24,false)
    addAnimationByPrefix('HypnoArms','singLEFT','Hypno Left Front',24,false)
    addAnimationByPrefix('HypnoArms','singDOWN','Hypno Down Front',24,false)
    addAnimationByPrefix('HypnoArms','singUP','Hypno Up Front',24,false)
    addAnimationByPrefix('HypnoArms','singRIGHT','Hypno Right Front',24,false)
    scaleObject('HypnoArms',1.5,1.5)

    addOffset('HypnoArms','idle',-64, -172)
    addOffset('HypnoArms','singLEFT',44, 93)
    addOffset('HypnoArms','singDOWN',-134, -155)
    addOffset('HypnoArms','singUP',67, 319)
    addOffset('HypnoArms','singRIGHT',-101, -94)

    playAnim('HypnoArms','idle',true)

    setProperty('HypnoArms.x',getProperty('boyfriend.x')+40)
    setProperty('HypnoArms.y',getProperty('boyfriend.y')+135)
    addLuaSprite('HypnoArms',true)
    

end
function onUpdate(elapsed)
    local charAnim=getProperty('dad.animation.curAnim.name')
    playAnim('HypnoArms',charAnim,true,false,getProperty('dad.animation.curAnim.curFrame'))
end