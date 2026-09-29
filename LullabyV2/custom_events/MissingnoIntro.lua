function onEvent(eventName, value1, value2)
    if eventName=='MissingnoIntro' then
        setProperty('dad.visible',true)
        playSound('missingnospawn',1)
        playAnim('dad','Intro',true)
        setProperty('dad.specialAnim',true)
        doTweenAlpha('IconP2','MissingnoIcon',1,1,'Linear')
        callScript('scripts/Stuff/HypnosPauseState.lua','ChangeVisible',{'left',true})
        for i=0,3 do
            setPropertyFromGroup('strumLineNotes',i,'visible',true)
        end
    end
end
function onCreatePost()
    precacheSound('missingnospawn')
    setProperty('MissingnoIcon.alpha',0)

end
function onSongStart()
    setPropertyFromGroup('strumLineNotes',0,'visible',false)
    setPropertyFromGroup('strumLineNotes',1,'visible',false)
    setPropertyFromGroup('strumLineNotes',2,'visible',false)
    setPropertyFromGroup('strumLineNotes',3,'visible',false)
end