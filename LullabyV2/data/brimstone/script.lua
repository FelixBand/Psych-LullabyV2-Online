local BarsStart={}

function onCreate()
	for i=0 ,18 do
	   makeLuaSprite('Bar'..i, nil, 0, (screenHeight/18)*i);
	   makeGraphic('Bar'..i, screenWidth, screenHeight/18, '000000')
	   setObjectCamera('Bar'..i,'Other')
	   addLuaSprite('Bar'..i,false)
	   table.insert(BarsStart, 'Bar'..i)
	end

	if not middlescroll then
		makeAnimatedLuaSprite('bhudleft', 'UI/pixel/buried_hud', 0, 50)
		addAnimationByPrefix('bhudleft', 'idle', 'left', 1, false)
		setObjectCamera('bhudleft', 'hud')
		scaleObject('bhudleft', 3, 3)
		setProperty('bhudleft.antialiasing', false)
		addLuaSprite('bhudleft')

		makeAnimatedLuaSprite('bhudright', 'UI/pixel/buried_hud', 0, 525)
		addAnimationByPrefix('bhudright', 'idle', 'right', 1, false)
		setObjectCamera('bhudright', 'hud')
		scaleObject('bhudright', 3, 3)
		setProperty('bhudright.antialiasing', false)
		setProperty('bhudright.x', screenWidth - getProperty('bhudright.width'))
		addLuaSprite('bhudright')
	else
		makeLuaSprite('bhud', 'UI/pixel/buried_center', 0, 50)
		setObjectCamera('bhud', 'hud')
		scaleObject('bhud', 3, 3)
		setProperty('bhud.antialiasing', false)
		screenCenter('bhud', 'x')
		if not downscroll then
			setProperty('bhud.y', 50)
		else
			setProperty('bhud.y', 515)
		end
		addLuaSprite('bhud')
	end
end

local bfStartPosition=0

function onCreatePost()
	playAnim('dad','Ground',true)
	setProperty('dad.specialAnim',true)
	bfStartPosition=getProperty('boyfriend.x')
	setProperty('boyfriend.x',getProperty('boyfriend.x')+screenWidth*2)


	-- ensue the note scaling/positioning spaghetti
	for i = 0, getProperty('opponentStrums.length') - 1 do
		if getPropertyFromGroup('opponentStrums', i, 'texture') == 'noteSkins/NOTE_assets-buried' then
			setPropertyFromGroup('opponentStrums', i, 'scale.x', 3)
			setPropertyFromGroup('opponentStrums', i, 'scale.y', 3)
		end
		if not middlescroll then
			if not downscroll then
				setPropertyFromGroup('opponentStrums', i, 'y', 500)
			else
				setPropertyFromGroup('opponentStrums', i, 'y', 24)
			end
		else
			for i = 0, getProperty('opponentStrums.length') - 1 do
				if getPropertyFromGroup('opponentStrums', i, 'texture') == 'noteSkins/NOTE_assets-buried' then
					setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] - 35)
					setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] - 35)

					if not downscroll then
						setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 25)
						setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 25)
					else	
						setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 80)
						setPropertyFromGroup('opponentStrums', i, 'y', _G['defaultOpponentStrumY'..i] - 80)
					end
				end
			end
		end
	end
	for i = 0, getProperty('playerStrums.length') - 1 do
		if getPropertyFromGroup('playerStrums', i, 'texture') == 'noteSkins/NOTE_assets-buried' then
			setPropertyFromGroup('playerStrums', i, 'scale.x', 3)
			setPropertyFromGroup('playerStrums', i, 'scale.y', 3)
		end
	end

	-- swap strum positions
	if not middlescroll then
		if not downscroll then
			for i = 0,getProperty('opponentStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i] - 150)
				setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 85)
			end
			for i = 0,getProperty('playerStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 25)
			end
		else
			for i = 0,getProperty('opponentStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'x', _G['defaultPlayerStrumX'..i] + 80)
				setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultOpponentStrumX'..i] - 150)
			end
			for i = 0,getProperty('playerStrums.length') - 1 do
				setPropertyFromGroup('playerStrums', i, 'y', _G['defaultPlayerStrumY'..i] - 70)
			end
		end
	end

	if not middlescroll then
		if playsAsBF() then
			if not downscroll then
				for i = 0, getProperty('opponentStrums.length') - 1 do
					setPropertyFromGroup('opponentStrums', i, 'downScroll', true)
				end
			else
				for i = 0, getProperty('opponentStrums.length') - 1 do
					setPropertyFromGroup('opponentStrums', i, 'downScroll', false)
				end
			end
		else
			if not downscroll then
				for i = 0, getProperty('playerStrums.length') - 1 do
					setPropertyFromGroup('playerStrums', i, 'downScroll', true)
				end
			else
				for i = 0, getProperty('playerStrums.length') - 1 do
					setPropertyFromGroup('playerStrums', i, 'downScroll', false)
				end
			end
		end
	end

	if downscroll then
		setProperty('scoreTxt.y', 5)
	end

	if middlescroll then
		if playsAsBF() then
			compactStrums('playerStrums')
		else
			compactStrums('opponentStrums')
		end
	else
		compactStrums('playerStrums')
		compactStrums('opponentStrums')
	end

	-- Hack fix: swap final strum positions when playing as the opponent.
	if not playsAsBF() and not middlescroll then
		local playerX = {}
		local playerY = {}
		local opponentX = {}
		local opponentY = {}

		for i = 0, getProperty('playerStrums.length') - 1 do
			playerX[i] = getPropertyFromGroup('playerStrums', i, 'x')
			playerY[i] = getPropertyFromGroup('playerStrums', i, 'y')
		end

		for i = 0, getProperty('opponentStrums.length') - 1 do
			opponentX[i] = getPropertyFromGroup('opponentStrums', i, 'x')
			opponentY[i] = getPropertyFromGroup('opponentStrums', i, 'y')
		end

		for i = 0, math.min(getProperty('playerStrums.length'), getProperty('opponentStrums.length')) - 1 do
			setPropertyFromGroup('playerStrums', i, 'x', opponentX[i])
			setPropertyFromGroup('playerStrums', i, 'y', opponentY[i])
			setPropertyFromGroup('opponentStrums', i, 'x', playerX[i])
			setPropertyFromGroup('opponentStrums', i, 'y', playerY[i])
		end
	end
    
    setProperty('healthBar.visible', false)
    setProperty('iconP2.visible', false)
    setProperty('iconP1.visible', false)
end

local scale = 3

function onSpawnNote(a, id, c, sustain) -- no onUpdate bullshit! efficiency baby!!!
    --debugPrint(a..' '..id..' '..c)

    local n = 'notes.members[' .. a .. ']'
	
    if sustain then
        setProperty(n..'.scale.x', scale)
        setProperty(n..'.offset.x', -55)
        setProperty(n..'.offset.y', -90)

        -- Flip opponent sustains.
		if not middlescroll then
			if playsAsBF() then
				if not getPropertyFromGroup('notes', a, 'mustPress') then
					if not downscroll then
						setProperty(n..'.flipY', true)
					else
						setProperty(n..'.flipY', false)
					end
				end
			else
				if getPropertyFromGroup('notes', a, 'mustPress') then
					if not downscroll then
						setProperty(n..'.flipY', true)
					else
						setProperty(n..'.flipY', false)
					end
				end
			end
		end
    else
        scaleObject(n, scale, scale, false)
    end
end

local strumSpacing = 95 -- Smaller = more compact

function compactStrums(group)
	local count = getProperty(group .. '.length')
	if count <= 1 then return end

	local firstX = getPropertyFromGroup(group, 0, 'x')
	local lastX = getPropertyFromGroup(group, count - 1, 'x')

	local centerX = (firstX + lastX) / 2

	for i = 0, count - 1 do
		local offset = (i - (count - 1) / 2) * strumSpacing
		setPropertyFromGroup(group, i, 'x', centerX + offset)
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