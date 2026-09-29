local lowHealthFX = false
local pussyMode = false
local Path = 'stages/mikes-room/images/'
function onCreate()
	setProperty('skipCountdown',true)
	consistentResize=1
	consistentPosition={-300, 100}

	makeLuaSprite('background',Path..'back', consistentPosition[1], consistentPosition[2])
	setScrollFactor('background', 0.7, 0.7)
	StageStuff('background')

	makeLuaSprite('portrait',Path..'portrait', consistentPosition[1], consistentPosition[2])
	setScrollFactor('portrait', 0.7, 0.7)
	StageStuff('portrait')

	makeLuaSprite('lacama',Path..'bed', consistentPosition[1], consistentPosition[2])
	setScrollFactor('lacama', 0.9, 0.9)
	StageStuff('lacama')

	makeLuaSprite('laalmuada',Path..'pillow', consistentPosition[1], consistentPosition[2])
	setScrollFactor('laalmuada', 0.9, 0.9)
	StageStuff('laalmuada')

	makeLuaSprite('redOverlay',Path..'redoverlay',0,0)
	setScrollFactor('redOverlay', 0, 0)
    setObjectCamera('redOverlay','hud')
	addLuaSprite('redOverlay')
	setProperty('redOverlay.alpha',0.04)

	addCharacterToList('Steven','dad')
	addCharacterToList('StevenFp','dad')
    addCharacterToList('MikeFp','bf')
end

function onCreatePost()
    setProperty('OtherSteven.visible',false)
	setPropertyFromClass('GameOverSubstate', 'characterName', 'DissensionDeath')
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'DissensionDeath')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', '')
    setProperty('boyfriend.visible',false)
	setObjectOrder('boyfriendGroup',getObjectOrder('laalmuada')+1)
	setProperty('cameraSpeed', 1000)
	setProperty('camGame.alpha', 0.0001)
	setProperty('camHUD.alpha', 0.0001)
	setProperty('gf.alpha', 0.0001)
	setObjectOrder('gfGroup', getObjectOrder('boyfriendGroup') + 1)
end

function onGameOverStart()
	addHaxeLibrary('GameOverSubstate')
	cameraFlash('game','0x6CFC0000',0.5)
    runHaxeCode([[
        GameOverSubstate.instance.boyfriend.screenCenter(XY);
	]])
end
function StageStuff(tag)
	scaleObject(tag,consistentResize,consistentResize)
	if tag=='lacama' or tag=='laalmuada' then
        addLuaSprite(tag,true)
	else
		addLuaSprite(tag)
    end
	setProperty(tag..'.visible',false)
end

function onUpdate(elapsed)
    if lowHealthFX then
		cameraShake('hud',0.0015, 0.01)
		cameraShake('game',0.0015, 0.01)
	end
end

function onUpdatePost(elapsed)
	if dadName~='StevenFp' then
		setProperty('iconP2.animation.curAnim.curFrame',0)
	else
		setProperty('iconP2.animation.curAnim.curFrame',1)
	end
end

function onEvent(eventName, value1, value2)
	if eventName=='Mike Strangle Scene' then
		setProperty('defaultCamZoom', 0.9)
		triggerEvent('Camera Follow Pos', '400', '650')
		setProperty('cameraSpeed', 1000)

        setProperty('camGame.zoom',getProperty('camGame.zoom')+2.5)
        setProperty('background.visible',false)
        setProperty('portrait.visible',false)
        setProperty('lacama.visible',false)
        setProperty('laalmuada.visible',false)
        triggerEvent('Change Character', 'dad', 'StevenFp')
        triggerEvent('Change Character', 'bf', 'MikeFp')
        if not pussyMode then
            strangling = true
        end
        
        setProperty('dad.alpha',0)
        setProperty('boyfriend.alpha',0)
        Set('dad','',-300,400)
        Set('boyfriend','',400,100)
        setProperty('dad.y',800)
        setProperty('boyfriend.y',-300)
        doTweenAlpha('MikeAlpha','boyfriend',1,6,'quadOut')
        doTweenY('MikeY','boyfriend',100,6,'quadOut')
        doTweenAlpha('StevenAlpha','dad',1,6,'quadOut')
        doTweenY('StevenY','dad',400,6,'quadOut')
    end
	if eventName == 'Chomatic Riser' and value1 == '0.25' and value2 == '10' then
		setProperty('cameraSpeed', 1)
	end
    if eventName=='Steven Goodbye' then
		lowHealthFX = not lowHealthFX

		if lowHealthFX then
			setProperty('camGame.visible',false)
			
			setProperty('healthBar.visible', false)
			setProperty('timeBar.visible', false)
			setProperty('timeTxt.visible', false)
			setProperty('scoreTxt.visible', false)
			setProperty('iconP1.visible', false)
			setProperty('iconP2.visible', false)

            runTimer('Spawn',1)

			setProperty('dad.alpha',0.45)
			setProperty('boyfriend.alpha',0.45)
			setProperty('gf.alpha',1)
		else
			doTweenAlpha('redOverlay','redOverlay',0,1.5,'quadInOut')
		end
	end
	if eventName=='Mike Change Scene' then
		setProperty('camHUD.alpha', 1)
        setProperty('camGame.zoom',getProperty('camGame.zoom')+2.5)
		setProperty('defaultCamZoom', 1.2)
        setProperty('boyfriend.visible',true)
        setProperty('background.visible',true)
        setProperty('portrait.visible',true)
        setProperty('lacama.visible',true)
        setProperty('laalmuada.visible',true)
        setProperty('iconP1.visible',true)
        for i=0,3 do
            setPropertyFromGroup('playerStrums',i,'visible',true)
        end
        triggerEvent('Change Character', 'dad', 'Steven')
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag=='Spawn' then
		setProperty('camGame.visible',true)
		setProperty('healthBar.visible', true)
		setProperty('timeBar.visible', true)
		setProperty('timeTxt.visible', true)
		setProperty('scoreTxt.visible', true)
		setProperty('iconP1.visible', true)
		setProperty('iconP2.visible', true)
	end
	if tag == 'allowGFidle' then
		triggerEvent('Alt Idle Animation', 'gf', '')
	end
end
function onBeatHit()
	if curBeat == 1 then
		doTweenAlpha('gameIn', 'camGame', 1, 3, 'linear')
		doTweenZoom('camZoom', 'camGame', 1, 5, 'cubeOut')
		setProperty('defaultCamZoom', 1)
	end
	if curBeat == 4 then
		setProperty('cameraSpeed', 1)
	end
    if lowHealthFX then
        setProperty('redOverlay.alpha',0.85)
		doTweenAlpha('redOverlay','redOverlay',0.65,0.25,'quadInOut')
	end
end

function Set(tag,Var,X,Y)
    if X~=nil then
        setProperty(tag..Var..'.x',X)
    end
    if Y~=nil then
        setProperty(tag..Var..'.y',Y)
    end
end

function opponentNoteHit(id, direction, noteType, isSustainNote) -- sync the two Stevens
	triggerEvent('Alt Idle Animation', 'gf', '-disabled')
	runTimer('allowGFidle', 0.55)
	playAnim('gf', getProperty('singAnimations')[direction+1], true)
end