local Path='stages/missingno/images/'
function onCreate()
	setProperty('skipCountdown',true)
	local resizeBG=6
	local consistentPosition={-670, -240}
	
	
	addLuaScript('scripts/Stuff/PlayStuff.lua')
	--addLuaScript('scripts/Stuff/OverWorld')
	callScript('scripts/Stuff/LuaHypnosRating','SetOffsets',{250, 100})
	callScript('scripts/Stuff/PlayStuff.lua','SetSongName',{"????????"})
	callScript('scripts/Stuff/HypnosPauseState.lua','ChangeVisible',{'left',false})
	
	initLuaShader('glitch')
	initLuaShader('individualGlitches')
	
	setGlobalFromScript('scripts/Stuff/CameraMove','cameraCentred',true)
	setGlobalFromScript('scripts/Stuff/CameraMove','OffsetCam',{0,-80})
	setGlobalFromScript('scripts/Stuff/CameraMove.lua','DADZoom',-0.15)
	

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


	SetShader()
end

function onCreatePost()
	setProperty('dad.visible',false)
	setSpriteShader('boyfriend','individualGlitches')
	setShaderFloat('boyfriend','binaryIntensity',1000)

    

	makeAnimatedLuaSprite('MissingnoIcon', 'icons/MissingnoIcons', 0,0)
	addAnimation('MissingnoIcon','Good', {0}, 24, true)
	addAnimation('MissingnoIcon','Bad', {1}, 24, true)
    setProperty('MissingnoIcon.antialiasing',false)
	setObjectCamera('MissingnoIcon','hud')
	addLuaSprite('MissingnoIcon',false)
	setProperty('iconP2.visible',false)
	setObjectOrder('MissingnoIcon',getObjectOrder('iconP2'))

end
local dadY=nil
local Change=false
local LetterCrazy=false
local curFrame=0
local endGlitching=false
local startGlitching=false
local glitchAmount=0
function onUpdate(elapsed)
	if dadY~= nil then
		setProperty('dad.y',dadY + ((math.sin((getSongPosition() / 16000) * (180 / math.pi))) * 5))
	else
		dadY=getProperty('dad.y')
	end
    if elapsed>0 then
		setProperty('groundNoShadow.visible',not getProperty('dad.visible'))
		glitchAmount=getProperty('Glitch.x')
		scaleObject('MissingnoIcon',getProperty('iconP2.scale.x'),getProperty('iconP2.scale.y'))
		setProperty('MissingnoIcon.x',getProperty('iconP2.x')+30)
		setProperty('MissingnoIcon.y',getProperty('iconP2.y'))
		if getHealth()>1.6 then
			playAnim('MissingnoIcon','Bad')
		else
			playAnim('MissingnoIcon','Good')
		end
		if not getProperty('dad.visible') and not luaSpriteExists('BF') then
			changePresence('Freeplay', "? ("..difficultyName..")")
		elseif getProperty('dad.visible') and not Change then
			Change=true
			callScript('scripts/Stuff/PlayStuff.lua','SetSongName',{songName})
		end
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