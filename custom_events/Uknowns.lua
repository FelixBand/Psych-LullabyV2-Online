local AllWordsLists={}
function onCreate()
    initSaveData('HypnosPref')
    --Preparer the assets
    precacheImage('Mechanics/line')
    precacheImage('Mechanics/Unown_Alphabet')
    --Get Words
    local NormalWords=stringSplit(getTextFromFile('WordUnknow/Normal.txt'),'\n')
    local HardWords=stringSplit(getTextFromFile('WordUnknow/Hard.txt'),'\n')
    local RareWords=stringSplit(getTextFromFile('WordUnknow/Rare.txt'),'\n')
    local ImpossibleWords=stringSplit(getTextFromFile('WordUnknow/Impossible.txt'),'\n')
    local HellWords=stringSplit(getTextFromFile('WordUnknow/Hell.txt'),'\n')
    local MissingnoWords=stringSplit(getTextFromFile('WordUnknow/Missingno.txt'),'\n')
    local BrimstoneWords=stringSplit(getTextFromFile('WordUnknow/Brimstone.txt'),'\n')

    AllWordsLists={
        ['Normal']=NormalWords,
        ['Hard']=HardWords,
        ['Rare']=RareWords,
        ['Impossible']=ImpossibleWords,
        ['Hell']=HellWords,
        ['Missingno']=MissingnoWords,
        ['Brimstone']=BrimstoneWords
    }

    
    CanOpenUknowns=not getDataFromSave('HypnosPref','Pussy mode',false)
    if (songName=='Missingno' or songName=='Brimstone') and not getDataFromSave('HypnosPref','Hell mode',false) then
        CanOpenUknowns=false
    end
    UnkownBotplay=false
end
local WordLength=0
local LetterCreates=0
local UknownsOpen=false
local ActualWordObjects={}
local ActualLetter=1
local Offset=20
local Time=15
local word=''
function onEvent(eventName, value1, value2)
    if eventName=='Uknowns' and playsAsBF()then
        --Time in Steps
        if value1~='' then Time=tonumber(value1)
        else Time=15 end
        --The especific word
        if value2~='' then word=string.upper(value2)
        else word='' end

        if CanOpenUknowns then openCustomSubstate('Uknowns',false) end
    end
end
local ActualWord={}
local Difficulte='Normal'
local WasReset=false
function onCustomSubstateCreate(name)
    if name=='Uknowns' then
        setProperty('persistentUpdate',true)
        UknownsOpen=true
        WasReset=getProperty("canReset")
        setProperty('canReset',false)
        makeLuaSprite('BackUknowns',nil,0,0)
        makeGraphic('BackUknowns',screenWidth,screenHeight,'FF0000')
        setProperty('BackUknowns.alpha',0.4)
        addLuaSpriteSubstate('BackUknowns')
        if dadName=='Gold-Head' then
            Difficulte='Hard'
        else
            Difficulte='Normal'
        end
        if getRandomInt(0,10)==1 then
            Difficulte='Hard'
            if getRandomInt(0,10)==1 then
                Difficulte='Rare'
                if getRandomInt(0,10)==1 then
                    Difficulte='Impossible'
                end
            end
        end
        local randomNumber=1
        if getDataFromSave('HypnosPref','Hell mode',false) then
            if songName=='Missingno' then
                Difficulte='Missingno'
                
            elseif songName=='Brimstone' then
                Difficulte='Brimstone'
            else
                Difficulte='Hell'
            end
        end
        randomNumber=getRandomInt(1,#AllWordsLists[Difficulte])
        local finalWord='NOT FOUND'
        
        if word~='' then
            finalWord=stringTrim(word)
            
        else
            finalWord=stringTrim(AllWordsLists[Difficulte][randomNumber])
        end
        ActualWord=stringSplit(finalWord,'')
        word=''
        for i, letter in ipairs(ActualWord) do
            MakeLetter(letter)
        end
        for i=1,#ActualWordObjects do
            if luaSpriteExists(ActualWordObjects[i].Letter) then
                WordLength=WordLength+getProperty(ActualWordObjects[i].Letter..'.width')
                if i<#ActualWordObjects then WordLength=WordLength+Offset end
            end
        end
        for i=1,#ActualWordObjects do
            if luaSpriteExists(ActualWordObjects[i].Letter) then
                setProperty(ActualWordObjects[i].Letter..'.x',getProperty(ActualWordObjects[i].Letter..'.x')-WordLength/2)
                if i>1 then
                    setProperty(ActualWordObjects[i].Letter..'.x',getProperty(ActualWordObjects[i-1].Letter..'.x')+getProperty(ActualWordObjects[i-1].Letter..'.width')+Offset)
                end
                if luaSpriteExists(ActualWordObjects[i].Line) then
                    setProperty(ActualWordObjects[i].Line..'.x',getProperty(ActualWordObjects[i].Letter..'.x'))
                end
            end
        end

        makeLuaText('UnknownTimer',tostring(Time),0,0,0)
        setTextSize('UnknownTimer',32)
        screenCenter('UnknownTimer','xy')
        setTextBorder('UnknownTimer',0,'FFFFFF')
        setTextFont('UnknownTimer','metro.otf')
        setTextAlignment('UnknownTimer','center')
        runTimer('UnknownTimes',crochet/1000,Time)
        Time=15
        addLuaTextSubstate('UnknownTimer')
        LastStep=curStep

    end
end
function onTimerCompleted(tag, loops, loopsLeft)
    if tag=='UnknownTimes' then
        if loopsLeft==0 then
            closeCustomSubstate()
            setHealth(-2)
        end
        setTextString('UnknownTimer',tostring(loopsLeft))
    end
end
function onCustomSubstateUpdate(name, elapsed)
    if name=='Uknowns' then
        
        if ActualWord[ActualLetter]~=' ' then
            if keyboardJustPressed(ActualWord[ActualLetter]) and ActualWord[ActualLetter]~='?' and ActualWord[ActualLetter]~='!' then
                CorrectLetter(ActualLetter)
            else
                if ActualWord[ActualLetter]=='!' then
                    if keyboardJustPressed('ONE') and keyboardPressed('SHIFT') then
                        CorrectLetter(ActualLetter)
                    end
                elseif ActualWord[ActualLetter]=='?' then
                    if (keyboardPressed('SLASH') or keyboardPressed('MINUS')) and keyboardPressed('SHIFT') then
                        CorrectLetter(ActualLetter)
                    end
                end
                if (botPlay or UnkownBotplay) and LastStep~=curStep then
                    CorrectLetter(ActualLetter)
                    LastStep=curStep
                end
            end
        else
            ActualLetter=ActualLetter+1
        end
        if ActualLetter>#ActualWord then
            cancelTimer('UnknownTimes')
            closeCustomSubstate()
        end
        
    end
end
function onCustomSubstateDestroy(name)
    if name=='Uknowns' then
        LetterCreates=0
        for i,letter in ipairs(ActualWordObjects) do
            RemoveLuaSpriteSubstate(letter.Letter,false)
        end
        ActualWordObjects={}
        UknownsOpen=false
        WordLength=0
        ActualLetter=1
        setProperty('canReset',WasReset)
        
        
    end
end

function CorrectLetter(letter)
    RemoveLuaSpriteSubstate(ActualWordObjects[letter].Line,false)

    ActualLetter=ActualLetter+1
end
function RemoveLuaSpriteSubstate(tag,destroyIt)
    runHaxeCode([[
        var Item= game.getLuaObject("]]..tag..[[");
        if(Item!=null)
        CustomSubstate.instance.remove(Item);
    ]])
    removeLuaSprite(tag, destroyIt)
end
function onPause()
    if UknownsOpen then
        return Function_Stop
    end
end
function addLuaSpriteSubstate(tag)
    runHaxeCode([[
        var Item= game.getLuaObject("]]..tag..[[");
        if(Item!=null)
        CustomSubstate.instance.add(Item);
    ]])
end
function addLuaTextSubstate(tag)
    runHaxeCode([[
        var Item= game.getLuaObject("]]..tag..[[",true);
        if(Item!=null){
            CustomSubstate.instance.add(Item);
            Item.cameras=[FlxG.cameras.list[FlxG.cameras.list.length - 1] ];
        }
    ]])
end
function MakeLetter(Letter)
    makeAnimatedLuaSprite(Letter..LetterCreates,'Mechanics/Unown_Alphabet')
    setProperty(Letter..LetterCreates..".x", screenWidth/2)
    setProperty(Letter..LetterCreates..'.visible',true)
    addAnimationByPrefix(Letter..LetterCreates,'idle',Letter,24,true)
    addLuaSpriteSubstate(Letter..LetterCreates)
    local realScale = 1 - (0.05 * #ActualWord)
    if realScale<0.2 then realScale=0.2 end
    scaleObject(Letter..LetterCreates,realScale,realScale)
    screenCenter(Letter..LetterCreates,'y')
    setProperty(Letter..LetterCreates..'.y',getProperty(Letter..LetterCreates..'.y')-100)
    
    if Letter==' ' then
        setProperty(Letter..LetterCreates..'.visible',false)
    else
        if not luaSpriteExists('Line'..LetterCreates) then
            makeLuaSprite('Line'..LetterCreates,'Mechanics/line',0,0)
        end
        addLuaSpriteSubstate('Line'..LetterCreates)
        scaleObject('Line'..LetterCreates,realScale,realScale)
        setGraphicSize('Line'..LetterCreates,getProperty(Letter..LetterCreates..'.width'),getProperty('Line'..LetterCreates..'.height')*realScale)
        screenCenter('Line'..LetterCreates,'xy')
        setProperty('Line'..LetterCreates..'.y',getProperty('Line'..LetterCreates..'.y')+200)
    end
    LetterCreates=LetterCreates+1
    ActualWordObjects[LetterCreates]={Letter=Letter..tostring(LetterCreates-1),Line='Line'..tostring(LetterCreates-1)}

end

