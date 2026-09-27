--Code made by Drawoon_ - Edited by FelixBand
--if you use this please give me credit
local startReverse=0
local doReverse=false
local moveNotes={true,true,true,true}
local Patterns={
    {true,true,true,true},
    {false,false,true,true},
    {false,true,false,true},
    {true,false,true,false},
    {true,false,false,true},
    {true,false,false,false},
    {true,false,true,true},
    {true,true,false,false},
    {true,false,false,true}
}

function onEvent(eventName, value1, value2)
    if if getVar('pastaPlayer') ~= 0 then
        if eventName=='Pow' then
            startReverse=0
            doReverse=false
            if getDataFromSave('HypnosPref','Hell mode',false) then
                moveNotes=Patterns[getRandomInt(1, #Patterns)]
            end
            if luaSpriteExists('MXArms') then
                playSound('HandUp',1)
                playAnim(mxChar,'Hit1',true)
                setProperty(mxChar .. '.specialAnim',true)
            else
                dropStart()
            end
        end
    end
end

function onCreate()
    initSaveData('HypnosPref')
    isPussyMode=getDataFromSave('HypnosPref','Pussy mode',false)
    precacheSound('HandUp')
    precacheSound('POW') 
end

function onCreatePost()
    if getVar('pastaPlayer') == 0 then
        close()
    end
end

mxChar = 'dad'

function onSongStart()
    if string.sub(dadName, 1, 2) == 'MX' then
        debugPrint(string.sub(dadName, 1, 2))
        mxChar = 'dad'
    elseif string.sub(gfName, 1, 2) == 'MX' then
        debugPrint(string.sub(gfName, 1, 2))
        mxChar = 'gf'
    elseif string.sub(boyfriendName, 1, 2) == 'MX' then
        debugPrint(string.sub(boyfriendName, 1, 2))
        mxChar = 'boyfriend'
    end
    debugPrint(mxChar)
end

function onUpdate(elapsed)
    if getProperty(mxChar .. '.animation.curAnim.finished') and getProperty(mxChar .. '.animation.curAnim.name')=='Hit1' then
        playAnim(mxChar,'Hit2',true)
        setProperty(mxChar .. '.specialAnim',true)
        playAnim('MXArms','Hit2',true)
        setProperty('POW.visible',false)
        dropStart()
    end
    if getProperty(mxChar .. '.animation.curAnim.name')~='Hit2' then
        setProperty('POW.visible',true)
    end   
    
    if doReverse then
        local realbeats = (getSongPosition() / 1000) * (curBpm / 60)

        if startReverse==0 then
            startReverse = realbeats
            for i=0,getProperty('playerStrums.length')-1 do
                if moveNotes[i+1] then
                    -- Toggle downScroll for BOTH Player and Opponent strums
                    setPropertyFromGroup('playerStrums', i, 'downScroll', not getPropertyFromGroup('playerStrums', i, 'downScroll'))
                    setPropertyFromGroup('opponentStrums', i, 'downScroll', not getPropertyFromGroup('opponentStrums', i, 'downScroll'))
                end
            end
        end
        
        local perc = easeOutBounce((realbeats - startReverse) / 2.5)
        
        if perc < 1 then
            for i=0, getProperty('notes.length')-1 do
                local noteData = getPropertyFromGroup('notes', i, 'noteData')
                if moveNotes[noteData + 1] then
                    -- Invert note speed for both player and opponent notes
                    setPropertyFromGroup('notes', i, 'multSpeed', Lerp(-1, 1, perc))
                    
                    if stringEndsWith(getPropertyFromGroup('notes', i, 'animation.curAnim.name'), 'end') then
                        local isPlayer = getPropertyFromGroup('notes', i, 'mustPress')
                        local groupName = isPlayer and 'playerStrums' or 'opponentStrums'
                        
                        setPropertyFromGroup('notes', i, 'flipY', getPropertyFromGroup(groupName, noteData, 'downScroll'))
                    end
                end
            end
            
            local multi = 1
            for i=0, getProperty('playerStrums.length')-1 do
                local localPerc = perc * multi
                if localPerc > 1 then localPerc = 1 end
                
                if moveNotes[i+1] then
                    -- Update Player Strums position
                    if getPropertyFromGroup('playerStrums', i, 'downScroll') then
                        setPropertyFromGroup('playerStrums', i, 'y', Lerp(50, screenHeight - 150, localPerc))
                    else
                        setPropertyFromGroup('playerStrums', i, 'y', Lerp(screenHeight - 150, 50, localPerc))
                    end
                    
                    -- Update Opponent Strums position
                    if getPropertyFromGroup('opponentStrums', i, 'downScroll') then
                        setPropertyFromGroup('opponentStrums', i, 'y', Lerp(50, screenHeight - 150, localPerc))
                    else
                        setPropertyFromGroup('opponentStrums', i, 'y', Lerp(screenHeight - 150, 50, localPerc))
                    end
                    
                    multi = multi + 0.05
                end
            end
        end  
        
        -- Keep sustain note tails flipped properly for both sides
        for i=0, getProperty('notes.length')-1 do
            if getPropertyFromGroup('notes', i, 'isSustainNote') then
                local noteData = getPropertyFromGroup('notes', i, 'noteData')
                local isPlayer = getPropertyFromGroup('notes', i, 'mustPress')
                local groupName = isPlayer and 'playerStrums' or 'opponentStrums'
                
                setPropertyFromGroup('notes', i, 'flipY', getPropertyFromGroup(groupName, noteData, 'downScroll'))
            end
        end
    end
end

function Lerp(Min,Max,Ratio)
    return Min + Ratio * (Max - Min)
end

function easeOutBounce(x)
    local n1 = 7.5625
    local d1 = 2.75
    
    if x < 1 / d1 then
        return n1 * x * x
    end
    if x < 2 / d1 then
        return n1 * (x - 1.5 / d1) * (x - 1.5 / d1) + 0.75
    end
    if x < 2.5 / d1 then
        return n1 * (x - 2.25 / d1) * (x - 2.25 / d1) + 0.9375
    end
    return n1 * (x - 2.625 / d1) * (x - 2.625 / d1) + 0.984375
end

function dropStart()
    playSound('POW',1)
    cameraShake('game',0.05,0.5)
    doReverse=true
end