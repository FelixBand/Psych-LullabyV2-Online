function onEvent(eventName, value1, value2)
    if eventName=='Missingno' then
        if not lowQuality then
            setShaderFloat('FiltreRef','prob',0.25)
            setShaderFloat('FiltreRef','time',getSongPosition()/ 1000)
        end
        if not isPussy then
            for i=0,3 do
                setPropertyFromGroup('strumLineNotes',i,'alpha',0)
            end
    
            local isDownscroll=getRandomBool(50)
            for i=4,7 do
                setPropertyFromGroup('strumLineNotes',i,'downScroll',isDownscroll)
            end
            for i=4,7 do
                if i==4 then
                setPropertyFromGroup('strumLineNotes',i,'x',getRandomInt(100, screenWidth / 3)- 25)
                if isDownscroll then
                    setPropertyFromGroup('strumLineNotes',i,'y',getRandomInt(screenHeight / 2,screenHeight-200))
                else
                    setPropertyFromGroup('strumLineNotes',i,'y',getRandomInt(100, 300))
                end
                else
                    local futurex = getRandomInt(getPropertyFromGroup('strumLineNotes',i-1,'x') + 80,getPropertyFromGroup('strumLineNotes',i-1,'x')+400)
                    if futurex>screenWidth-100 then
                        futurex=screenWidth-100
                    end
                    setPropertyFromGroup('strumLineNotes',i,'x',futurex)
                    setPropertyFromGroup('strumLineNotes',i,'y',getRandomInt(getPropertyFromGroup('strumLineNotes',4,'y')- 100,getPropertyFromGroup('strumLineNotes',4,'y')+ 100))
                end
    
            end
        end

    end
end
function onUpdate(elapsed)
    for i=0,getProperty('notes.length')-1 do
        if getPropertyFromGroup('notes',i,'mustPress') then
            if getPropertyFromGroup('notes',i,'isSustainNote') then
                setPropertyFromGroup('notes',i,'flipY',getPropertyFromGroup('playerStrums',getPropertyFromGroup('notes',i,'noteData'),'downScroll'))
            end
        end
    end
end
function onCreate()
    initSaveData('HypnosPref')
    isPussy=getDataFromSave('HypnosPref','Pussy mode',false)
    --callOnLuas('SetShader')
end
