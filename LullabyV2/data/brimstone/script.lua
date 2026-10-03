local BarsStart={}

function onCreate()
	for i=0 ,18 do
	   makeLuaSprite('Bar'..i, nil, 0, (screenHeight/18)*i);
	   makeGraphic('Bar'..i, screenWidth, screenHeight/18, '000000')
	   setObjectCamera('Bar'..i,'Other')
	   addLuaSprite('Bar'..i,false)
	   table.insert(BarsStart, 'Bar'..i)
	end

	precacheImage('Mechanics/muksludge')
	precacheSound('MukCums')
	setProperty('skipCountdown', true)

	if shadersEnabled then
		makeLuaSprite('greenController', '', 0, 0)

		runHaxeCode([[
			game.initLuaShader('brimstone/gameboy');

			var gameboyShader = game.createRuntimeShader('brimstone/gameboy');

			game.getLuaObject('greenController').shader = gameboyShader;

			game.camGame.setFilters([
				new ShaderFilter(gameboyShader)
			]);

			game.camHUD.setFilters([
				new ShaderFilter(gameboyShader)
			]);
		]])

		setShaderFloat('greenController', 'interpolation', 0)
	end

	-- characters!
	makeAnimatedLuaSprite('enterGengar', 'characters/buried/enter_gengar', -320, -110)
	addAnimationByIndices('enterGengar', 'leave', 'gengar entrance', '56,55,54,53,52,51,50,49,48', 24, false)
	addAnimationByPrefix('enterGengar', 'enter', 'gengar entrance', 24, false)
	scaleObject('enterGengar', 6, 6)
	setObjectOrder('enterGengar', getObjectOrder('dadGroup') + 1)
	setProperty('enterGengar.antialiasing', false)
	setProperty('enterGengar.alpha', 0.0001)
	addLuaSprite('enterGengar')

	makeAnimatedLuaSprite('gengar', 'characters/buried/gengar_assets', 35, 142)
	addAnimationByPrefix('gengar', 'idle', 'gengar idle', 24, false)
	addAnimationByPrefix('gengar', 'singLEFT', 'gengar left', 24, false)
	addAnimationByPrefix('gengar', 'singDOWN', 'gengar down', 24, false)
	addAnimationByPrefix('gengar', 'singUP', 'gengar up', 24, false)
	addAnimationByPrefix('gengar', 'singODD', 'gengar up', 24, false)
	addAnimationByPrefix('gengar', 'singRIGHT', 'gengar right', 24, false)
	scaleObject('gengar', 6, 6)
	setObjectOrder('gengar', getObjectOrder('dadGroup') + 1)
	setProperty('gengar.antialiasing', false)
	setProperty('gengar.alpha', 0.0001)
	addLuaSprite('gengar')


	makeAnimatedLuaSprite('muk', 'characters/buried/leanmonster', 310, 250)
	addAnimationByPrefix('muk', 'idle', 'Muk_Idle', 24, false)
	addAnimationByPrefix('muk', 'singLEFT', 'Muk_Left', 24, false)
	addAnimationByPrefix('muk', 'singDOWN', 'Muk_Down', 24, false)
	addAnimationByPrefix('muk', 'singUP', 'Muk_Up', 24, false)
	addAnimationByPrefix('muk', 'singODD', 'Muk_Up', 24, false)
	addAnimationByPrefix('muk', 'singRIGHT', 'Muk_Right', 24, false)
	addAnimationByPrefix('muk', 'intro', 'Muk_Intro', 24, false)
	addAnimationByPrefix('muk', 'puke', 'Muk_Puke', 24, false)
	scaleObject('muk', 6, 6)
	setObjectOrder('muk', getObjectOrder('dadGroup') + 1)
	setProperty('muk.antialiasing', false)
	setProperty('muk.alpha', 0.0001)
	addLuaSprite('muk')
end

local bfStartPosition=0

function onCreatePost()
	playAnim('dad','Ground',true)
	setProperty('dad.specialAnim',true)
	bfStartPosition=getProperty('boyfriend.x')
	setProperty('boyfriend.x',getProperty('boyfriend.x')+screenWidth*2)
	setObjectOrder('gfGroup', getObjectOrder('boyfriendGroup') + 1)
	setProperty('gfGroup.alpha', 0.0001)

	for i = 0, getProperty('unspawnNotes.length') - 1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Gengar Sing' or getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Muk Sing' or getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Apparition Sing' then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
		end
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Gengar Sing' then
		playAnim('gengar', getProperty('singAnimations')[direction+1], true)
	end
	if noteType == 'Muk Sing' then
		playAnim('muk', getProperty('singAnimations')[direction+1], true)
	end
end

function onBeatHit()
	if curBeat % 2 == 0 then
		playIdle('gengar')
		playIdle('muk')
	end
end

function playIdle(char)
	if getProperty(char .. '.animation.curAnim.finished') then
		playAnim(char, 'idle')
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
	setShaderFloat('greenController', 'interpolation', getProperty('greenController.x'))
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

function onEvent(name, value1, value2)
    if name == 'brimstone Intro' then
		brimstoneIntro()
	end
	if name == 'Spawn' then
		if value1 == 'Gengar' then
			playAnim('enterGengar', 'enter', true)
			setProperty('enterGengar.alpha', 1)
		end
		if value1 == 'Missingno' then
			triggerEvent('Alt Idle Animation', 'bf', '-disabled')
			playAnim('boyfriend', 'throw', true)
		end
		if value1 == 'Leanmonster' then
			playAnim('muk', 'intro', true)
			setProperty('muk.alpha', 1)

			-- might as well do this here
			triggerEvent('Change Character', 'gf', 'apparition')
			setObjectOrder('gfGroup', getObjectOrder('muk'))
		end
		if value1 == 'ApparitionGF' then
			if value2 == 'Hand' then
				triggerEvent('Alt Idle Animation', 'gf', '-disabled')
				setProperty('gfGroup.x', 205)
				setProperty('gfGroup.y', -40)
				playAnim('gf', 'intro', true)
			elseif value2 == 'Apparition' then
				triggerEvent('Alt Idle Animation', 'gf', '-disabled')
				playAnim('gf', 'transform', true)
			end
		end
	end
	if name == 'Leave' then
		if value1 == 'Missingno' then
			doTweenY('missingnoDown', 'gfGroup', getProperty('gf.y') + 600, 1, 'cubeIn')
		end
		if value1 == 'Gengar' then
			playAnim('enterGengar', 'leave', true)
			setProperty('enterGengar.alpha', 1)
			removeLuaSprite('gengar', true)
		end
	end
	if name == 'Gameboy Filter' then
		doTweenX('gbFilterUp', 'greenController', tonumber(value1), tonumber(value2), 'linear')
	end
end

--function onSoundFinished(tag)
    --if tag == 'vine boom' then
		--debugPrint('boom')
	--end
--end