function onCreate()
    makeAnimatedLuaSprite('pokeball', 'characters/shinto/shitno_pokeball', 400, 600)
    addAnimationByPrefix('pokeball', 'idle', 'shitno_pokeballend', 24, false)
    scaleObject('pokeball', 5, 5)
    setProperty('pokeball.antialiasing', false)
    setProperty('pokeball.alpha', 0.001)
    addLuaSprite('pokeball')

    setProperty('skipCountdown', true);
end

function onEvent(name, value1, value2)
    if name == 'Shinto End' then
        playAnim('pokeball', 'idle', true)
        setProperty('pokeball.alpha', 1)
        triggerEvent('Alt Idle Animation', 'dad', '-disabled')
        triggerEvent('Play Animation', 'end', 'dad')
    end
end