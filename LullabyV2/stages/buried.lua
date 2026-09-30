--[[
    Code made by Drawoon_
]]
local Path='stages/buried/images/'
local Scale=1
local BarsStart={}
local IsDead=false

function onCreate()
	precacheImage('Mechanics/muksludge')
	precacheSound('MukCums')
	setProperty('skipCountdown',true)
	Scale=getPropertyFromClass('PlayState','daPixelZoom')
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
	playAnim('dad','Ground',true)
	setProperty('dad.specialAnim',true)
	bfStartPosition=getProperty('boyfriend.x')
	setProperty('boyfriend.x',getProperty('boyfriend.x')+screenWidth*2)
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

--function onSoundFinished(tag)
    --if tag == 'vine boom' then
		--debugPrint('boom')
	--end
--end