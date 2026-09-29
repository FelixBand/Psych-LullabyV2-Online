--[[
    Code made by Drawoon_
]]
local Path='stages/buried/images/'
local Scale=1
local BarsStart={}
local IsDead=false
function onSongStart()
	setPropertyFromClass('PlayState','daPixelZoom',Scale)
end
function onCreate()
	initSaveData('HypnosPref')
	precacheImage('Mechanics/muksludge')
	precacheSound('MukCums')
	addLuaScript('scripts/Stuff/PlayStuff.lua')
	addLuaScript('scripts/Stuff/BrimstoneHUB.lua')
	setGlobalFromScript('scripts/Stuff/CameraMove','FirstPerson',true)
	callScript('scripts/Stuff/HypnosPauseState.lua','ChangeVisible',{'right',false})
	setProperty('skipCountdown',true)
	Scale=getPropertyFromClass('PlayState','daPixelZoom')
	setPropertyFromClass('PlayState','daPixelZoom',3)
	local consistentPosition={-1130, -350}
	
	
	makeLuaSprite('Back',Path..'brimstoneBack', consistentPosition[1], consistentPosition[2])
    setProperty('Back.antialiasing',false)
    scaleObject('Back',Scale,Scale)
	
	makeLuaSprite('Floor',Path..'floor', consistentPosition[1], consistentPosition[2])
	setProperty('Floor.antialiasing',false)
	scaleObject('Floor',Scale,Scale)

	makeLuaSprite('Graves',Path..'graves', consistentPosition[1], consistentPosition[2])
	setProperty('Graves.antialiasing',false)
	scaleObject('Graves',Scale,Scale)


	addLuaSprite('Back', false)
	addLuaSprite('Floor', false)
	addLuaSprite('Graves', false)

    

 

	for i=0 ,18 do
	   
	   makeLuaSprite('Bar'..i, nil, 0, (screenHeight/18)*i);
	   makeGraphic('Bar'..i, screenWidth, screenHeight/18, '000000')
	   setObjectCamera('Bar'..i,'Other')
	   addLuaSprite('Bar'..i,false)
	   table.insert(BarsStart, 'Bar'..i)


	end
end
local bfStartPosition=0
function onCreatePost()
	if getDataFromSave('HypnosPref','Hell mode',false) then
		CreatePendelum(false)
		setProperty('Pendelum.visible',false)
	end
	setPropertyFromClass('PlayState','daPixelZoom',6)
	setGlobalFromScript('scripts/Stuff/CameraMove','ManualPos',{getMidpointX('dad')+getProperty('dad.cameraPosition[0]')+150,getMidpointY('dad')+ -100+getProperty('dad.cameraPosition[1]')})
	setGlobalFromScript('scripts/Stuff/CameraMove','ForceCamPos',true)
	playAnim('dad','Ground',true)
	setProperty('dad.specialAnim',true)
	bfStartPosition=getProperty('boyfriend.x')
	setProperty('boyfriend.x',getProperty('boyfriend.x')+screenWidth*2)

	-- Change opponent (Dad) note skin texture
    for i = 0, 3 do
        setPropertyFromGroup('opponentStrums', i, 'texture', 'NOTES_buried')
    end

    -- Change player (Boyfriend) note skin texture if needed
    -- for i = 4, 7 do
    --     setPropertyFromGroup('playerStrums', i, 'texture', 'your-note-texture')
    -- end

    -- Update all upcoming unspawned notes
    for i = 0, getProperty('unspawnNotes.length') - 1 do
        -- Change for opponent notes
        if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
            setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTES_buried')
        -- Change for player notes (uncomment if needed)
        -- else
        --     setPropertyFromGroup('unspawnNotes', i, 'texture', 'your-note-texture')
        end
    end
end
local shakeProgress = {-13, 26, -16, 4, -1}
local shakeProgressFinal = {-28,52,-38,28,-21,12,-10,5,-1}
local myShake={}
local brimstoneShaking=false
function onTimerCompleted(tag, loops, loopsLeft)
    if tag=='CUm' then
	    brimstoneShaking = true
        myShake = shakeProgress
		playSound('MukCums',1)
        makeAnimatedLuaSprite('muksludge', 'Mechanics/muksludge', 0, 0)
        addAnimationByPrefix('muksludge', '0', 'Sludge_01', 24,false)
        addAnimationByPrefix('muksludge', '1', 'Sludge_02', 24,false)
        addAnimationByPrefix('muksludge', '2', 'Sludge_03', 24,false)
        setGraphicSize('muksludge', screenWidth,screenHeight)
        setProperty('muksludge.antialiasing',false)
        cancelTween('Cumleave')
        setProperty('muksludge.alpha',1)
        playAnim('muksludge',tostring(math.random(0,2)),true)
        setObjectCamera('muksludge', 'other')
        addLuaSprite('muksludge',false)
      
    end
	if tag=='Idle' then
        playAnim('Boyfriend','idle')
	end

end

function onTweenCompleted(tag)
   if tag =='Cumleave'then
removeLuaSprite('muksludge',false)
   end
end
local CumColdown=80
function onStepHit()
    if getProperty('Muk.visible') and getProperty('Muk.animation.curAnim.name')=='idle' then
        CumColdown=CumColdown-1
		if CumColdown<=0 then
			if getProperty('Muk.animation.curAnim.name')~= "Intro" then
				playAnim('Muk','Puke',true)
				setProperty('Muk.specialAnim',true)
				runTimer('CUm',(stepCrochet * 4) / 1000,1)
			end
			CumColdown=80
	    end
	end

end
local curFrame=0
function onUpdate(elapsed)
    if luaSpriteExists('muksludge') then
		if getProperty('muksludge.animation.curAnim.finished') then
			doTweenAlpha('Cumleave','muksludge',0,(stepCrochet * 4) / 1000,'linear')
		end
	end

    if curStep > 1 then
		if curFrame % math.floor(4 * ( getPropertyFromClass('flixel.FlxG','drawFramerate')/ 60)) == 0 then
		
			if curStep <= 48 then
				for i,bar in ipairs(BarsStart) do
					if i % 2 == 0 then
						setProperty(bar..'.x',getProperty(bar..'.x')+64)
					else
						setProperty(bar..'.x',getProperty(bar..'.x')-64)
					end
				end
			else 
				for i,bar in ipairs(BarsStart) do
					removeLuaSprite(bar)
				end
			end
		end
		if curFrame % math.floor(2 * (getPropertyFromClass('flixel.FlxG','drawFramerate') / 60)) == 0 then
			if curStep >= 24 then
			
				if getProperty('boyfriend.x') > bfStartPosition then
					setProperty('boyfriend.x',getProperty('boyfriend.x')-50)
				end
				if getProperty('boyfriend.x') <= bfStartPosition then
				
					setProperty('boyfriend.x',bfStartPosition)
					startingBrimstone = false;
				end
			end
		end
		if IsDead then
			gameoverBrimstoneShake()
		end
		brimstoneShakes()
		curFrame=curFrame+1
	
	end
end

local shakeProgression=0
local cameraXPlacement=0
local totalShakes=0
function brimstoneShakes()
	if curFrame % math.floor(12 * (getPropertyFromClass('flixel.FlxG','drawFramerate') / 120)) == 0 and brimstoneShaking then
		if shakeProgression==0 then
			cameraXPlacement=getProperty('camGame.scroll.x')
			runHaxeCode([[
				FlxG.camera.follow(null);
			]])
		end
		setProperty('camGame.scroll.x',getProperty('camGame.scroll.x')+myShake[shakeProgression+1]*3)
		shakeProgression=shakeProgression+1
		if shakeProgression>=#myShake-1 then
			totalShakes=totalShakes+1
			shakeProgression=0
			setProperty('camGame.scroll.x',cameraXPlacement)
			runHaxeCode([[
				FlxG.camera.follow(game.camFollowPos,null, 1);
			]])
			brimstoneShaking=false
		end
	end
end
function gameoverBrimstoneShake()
	if curFrame % math.floor(12 * (getPropertyFromClass('flixel.FlxG','drawFramerate') / 120)) == 0 then
		if shakeProgression==0 then
			cameraXPlacement=getProperty('camGame.scroll.x')
			runHaxeCode([[
				FlxG.camera.follow(null);
			]])
		end
		setProperty('camGame.scroll.x',getProperty('camGame.scroll.x')+shakeProgressFinal[shakeProgression+1]*3)
		shakeProgression=shakeProgression+1
		if shakeProgression>=#shakeProgressFinal-1 then
			setProperty('camGame.scroll.x',cameraXPlacement)
			runHaxeCode([[
				FlxG.camera.follow(game.camFollowPos,null, 1);
			]])
		end
	end
	if curFrame % math.floor(4 * (getPropertyFromClass('flixel.FlxG','drawFramerate') / 120)) == 0 then
		setProperty('boyfriend.y',getProperty('boyfriend.y')+12)
	end
end
local buriedIntroInterval = 0
local alternateBrimstone = -1
function brimstoneIntro()
	brimstoneShaking=true
	if buriedIntroInterval==2 then
		playAnim('dad', 'Scream' ,true)
		setProperty('dad.specialAnim',true)   
	end
	if buriedIntroInterval<4 then
		myShake = shakeProgress
	else
		myShake = shakeProgressFinal
	end
	buriedIntroInterval=buriedIntroInterval+1
end
function onEvent(eventName, value1, value2)
    if eventName=='brimstone Intro' then
		brimstoneIntro()
		if buriedIntroInterval == 5 then
            --debugPrint('Pause Portair Spawn')
			callScript('scripts/Stuff/HypnosPauseState.lua','ChangeVisible',{'right',true})
		end
	end
end
--GameOver
function onGameOver()
	if not IsDead then
	    playSound('buriedDeath',1,'Wait')
	    playAnim('boyfriend','Aurgh',true)
	    setProperty('boyfriend.stunned',true)
        IsDead=true
	end
    return Function_Stop
end
function addLuaSpriteSubstate(tag)
    runHaxeCode([[
        CustomSubstate.instance.add(game.getLuaObject("]]..tag..[["));
	]])
end
local GameOverStart='BA0'
local GameOverLoop='BurymanDeath'
local GameOverEnd='gameOverEnd'
function onCustomSubstateUpdate(name, elapsed)
	if name=='NewGameOverSubState' then
		if keyJustPressed('back') then
			callScript('scripts/Stuff/PlayStuff','toMenu')
		end
		if keyJustPressed('accept') and getProperty('Brain.animation.curAnim.name')~='accept'  then
			playAnim('Brain','accept',true)
			setProperty('Brain.x',getProperty('Brain.x')-19)
			setProperty('Brain.y',getProperty('Brain.y')-43)
			playMusic(GameOverEnd,1)
		end
		if getProperty('Brain.animation.curAnim.finished') then
			restartSong()
		end
	end


end
function onCustomSubstateCreate(name)
	GameOverStart='BA'..tostring(getRandomInt(0,3))
    if name=='NewGameOverSubState' then
		playSound(GameOverStart,1,'GOStart')
		makeLuaSprite('BackGameOver',nil,0,0)
		makeGraphic('BackGameOver',screenWidth,screenHeight,'000000')
		addLuaSpriteSubstate('BackGameOver')

        makeAnimatedLuaSprite('Boyfriend','characters/Death/BA_DeathRetry',0,0)
		addAnimationByPrefix('Boyfriend','idle', 'buried_death', 24, false)
		setProperty('Boyfriend.antialiasing',false)
		scaleObject('Boyfriend',3,3)
		screenCenter('Boyfriend','xy')
		setProperty('Boyfriend.y',getProperty('Boyfriend.y')+100)
		addLuaSpriteSubstate('Boyfriend')

		makeAnimatedLuaSprite('Brain','characters/Death/BA_DeathRetry',0,0)
		addAnimationByPrefix('Brain','retry', 'BA_retry0', 24, true)
		addAnimationByPrefix('Brain','accept', 'BA_retry_confirm', 24, false)
		setProperty('Brain.antialiasing',false)
		scaleObject('Brain',3,3)
		screenCenter('Brain','xy')
		playAnim("Brain", "retry", true)
		setProperty('Brain.y',getProperty('Brain.y')-200)
		addLuaSpriteSubstate('Brain')
		

		makeLuaSprite('TransicionGameOver',nil,0,0)
		makeGraphic('TransicionGameOver',screenWidth,screenHeight,'000000')
		addLuaSpriteSubstate('TransicionGameOver')
		
	end
end
function onSoundFinished(tag)
    if tag=='GOStart'then
		doTweenAlpha('Transicion','TransicionGameOver',0,3,'Linear')
        playMusic(GameOverLoop,1,true)
		playAnim('Boyfriend','idle')
		runTimer('Idle',(stepCrochet/1000)*49,0)
	end
	if tag=='Wait' then
		openCustomSubstate('NewGameOverSubState',true)
		setProperty('camGame.visible',false)
		setProperty('camHUD.visible',false)
		cameraFlash('other','000000',0.5,false)
	end
end