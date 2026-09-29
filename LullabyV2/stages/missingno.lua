local Path='stages/missingno/images/'
function onCreate()
	setProperty('skipCountdown',true)
	local resizeBG=6
	local consistentPosition={-670, -240}
	
	initLuaShader('glitch')
	initLuaShader('individualGlitches')

	makeAnimatedLuaSprite('background',Path..'bg', consistentPosition[1]+30, consistentPosition[2]-2)
	setScrollFactor('background', 0.3, 0.3);
	addAnimationByPrefix('background','idle', 'sky', 24, true)
	scaleObject('background',resizeBG,resizeBG)
	setProperty('background.antialiasing',false)

	makeAnimatedLuaSprite('missingnoOcean',Path..'BG_Assets', consistentPosition[1], consistentPosition[2])
	setScrollFactor('missingnoOcean', 0.4, 0.4);
	addAnimationByPrefix('missingnoOcean','idle', 'Bg Ocean', 24, true)
	scaleObject('missingnoOcean',resizeBG,resizeBG)
	setProperty('missingnoOcean.antialiasing',false)

	makeAnimatedLuaSprite('ground',Path..'BG_Assets', consistentPosition[1], consistentPosition[2]+10)
	addAnimationByPrefix('ground','idle', 'Bg Wave', 24, true)
	scaleObject('ground',resizeBG,resizeBG)
	setProperty('ground.antialiasing',false)

	makeAnimatedLuaSprite('groundNoShadow',Path..'noshadow', consistentPosition[1], consistentPosition[2]+10)
	addAnimationByPrefix('groundNoShadow','idle', 'Bg Wave', 24, true)
	scaleObject('groundNoShadow',resizeBG,resizeBG)
    setProperty('groundNoShadow.antialiasing',false)

	addLuaSprite('background', false)
	addLuaSprite('missingnoOcean', false)
	addLuaSprite('ground', false)
	addLuaSprite('groundNoShadow', false)

	setPropertyFromClass('GameOverSubstate', 'characterName', 'bf-Missingno-dead')
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-pixel')
    setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'MissingnoDeath')
    setPropertyFromClass('GameOverSubstate', 'endSoundName', 'MissingnoDone')

	precacheSound('missingnospawn')

	initLuaShader('individualGlitches')
	SetShader()
end

function onCreatePost()
	setProperty('dad.visible',false)
	setSpriteShader('boyfriend','individualGlitches')
	setShaderFloat('boyfriend','binaryIntensity',1000)

	setProperty('iconP2.visible',false)
	for i = 0,getProperty('opponentStrums.length') - 1 do
        setPropertyFromGroup('strumLineNotes',i,'visible',false)
    end
end

local dadY=nil
local Change=false
local LetterCrazy=false
local curFrame=0
local endGlitching=false
local startGlitching=false
local glitchAmount=0
function onUpdate(elapsed)
	if curBeat < 100 then
		setProperty('camZooming', false)
	end


	if dadY~= nil then
		setProperty('dad.y',dadY + ((math.sin((getSongPosition() / 16000) * (180 / math.pi))) * 5))
	else
		dadY=getProperty('dad.y')
	end
    if elapsed>0 then
		setProperty('groundNoShadow.visible',not getProperty('dad.visible'))
		glitchAmount=getProperty('Glitch.x')
		if startGlitching then
			if not lowQuality then
				if not LetterCrazy then
					LetterCrazy=true
					callScript('scripts/Stuff/PlayStuff.lua','SongNameShit')
				end
				setShaderFloat('background','prob',glitchAmount / 4)
				if not endGlitching then
					setShaderFloat('background','time',(math.floor((getSongPosition() / crochet)) * crochet) / 1000)
				end
		
				setShaderFloat('FiltreRef','prob',0.25 - (glitchAmount / 8))
			end
	
			if not endGlitching then
				setShaderFloat('FiltreRef','time',(math.floor((getSongPosition() / crochet)) * crochet) / 1000)
			end
			setShaderFloat('dad','binaryIntensity',(10 - ((math.floor(glitchAmount / 20) * 20) * 9)) / 8)
		end
		curFrame=curFrame+1
	end
end

function onEvent(eventName, value1, value2)
	if eventName=='MissingnoIntro' then
        setProperty('dad.visible',true)
        playSound('missingnospawn',1)
        playAnim('dad','Intro',true)
        setProperty('dad.specialAnim',true)
        for i = 0,getProperty('opponentStrums.length') - 1 do
            setPropertyFromGroup('strumLineNotes',i,'visible',true)
        end
    end

	if eventName=='Missingno Tempo Change' then
        
        setSpriteShader('dad','individualGlitches Missingno')
        setSpriteShader('ground','individualGlitches Missingno')
        setShaderFloat('dad','binaryIntensity',0)
        if not lowQuality then
            setSpriteShader('background','glitch')
            setShaderFloat('background','prob',0)
           
        end
        makeLuaSprite('Glitch',nil,0,0)
        doTweenX('Glitch','Glitch',1,(stepCrochet * 56) / 1000,'cubeInOut')
        
    end
	if eventName == 'MissingnoZoomIn' then
		debugPrint('I am zooming right now')
		doTweenZoom('camIn','camGame', 1, 28, 'expoIn')
	end
    if eventName=='Missingno Tempo Change' then
		startGlitching=true
	end
	if eventName=='MissingnoPlayRandom' then
		runTimer('PlayRandom',crochet / 1000)
		setShaderFloat('boyfriend','binaryIntensity',1/getRandomInt(1,4))
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag=='PlayRandom' then
		setShaderFloat('boyfriend','binaryIntensity',1000)
	end
end

function SetShader()
	makeLuaSprite('FiltreRef')
	if shadersEnabled and not lowQuality then
		runHaxeCode([[
			var shaderName = "glitch";
    
			var shader0 = game.createRuntimeShader(shaderName);
			game.camGame.setFilters([new ShaderFilter(shader0)]);
			game.getLuaObject("FiltreRef").shader = shader0;
		]])
	end
end

function onTweenCompleted(tag)
    if tag=='Glitch' then
        endGlitching=true
    end
end