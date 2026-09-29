local strangling=false

local NotesHell=1
function onUpdate(elapsed)
    if strangling then
        if getDataFromSave('HypnosPref','Hell mode',false) then
            if getHealth() >= 0.050 then addHealth(-(0.0035 * ((elapsed) * 120))) end
            NotesHell=math.abs(math.sin((getSongPosition() / (stepCrochet  * 16)) * math.pi))
            for i=0,getProperty('notes.length')-1 do
                if getPropertyFromGroup('notes',i,'mustPress') then
                    setPropertyFromGroup('notes',i,'multAlpha',Lerp(0.35,1,NotesHell))
                end
            end
        else
            if getHealth() >= 0.395 then addHealth(-(0.0020 * ((elapsed) * 120))) end
        end
    end
end
function Lerp(Min,Max,Ratio)
    return Min + Ratio * (Max - Min)
end