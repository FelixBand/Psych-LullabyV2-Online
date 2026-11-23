local lastGlitch = 0
function onEvent(eventName, value1, value2)
    if eventName=='MissingnoPlayRandom' then
        local Anim={'LEFT','DOWN','UP','RIGHT'}
        local glitch = getRandomInt(1, 4, tostring(lastGlitch))
        playAnim('boyfriend','sing'..Anim[glitch], true)
        lastGlitch=glitch
        setProperty('boyfriend.holdTimer',0)
    end
end