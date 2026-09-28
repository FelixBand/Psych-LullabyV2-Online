local dir = "stages/hell/images/"
local contractStep=0
local percentage=0

function onCreate()
	precacheSound('bimbembooff')
	precacheSound('bimbembo')
	
	local resizeBG=0.75

    setProperty('skipCountdown',true)
	makeLuaSprite('Wall', dir..'wall', 0, 0)
	setGraphicSize('Wall',  getProperty('Wall.width')* resizeBG * 2, getProperty('Wall.height')*resizeBG*2)

	makeAnimatedLuaSprite('Lavabottom', dir..'lavabottom', -2, 1074)
    setGraphicSize('Lavabottom',  getProperty('Lavabottom.width')* resizeBG, getProperty('Lavabottom.height')*resizeBG)
    addAnimationByPrefix('Lavabottom', 'idle', 'lavabottom',24,true)
    playAnim('Lavabottom','idle')

	makeLuaSprite('Rocks',dir..'rocks', 109, 1140)
	setGraphicSize('Rocks',  getProperty('Rocks.width')* resizeBG *2, getProperty('Rocks.height')*resizeBG*2)

	makeLuaSprite('Floorbot',dir..'floorbot', 1070, 1135);
	setGraphicSize('Floorbot',  getProperty('Floorbot.width')* resizeBG *2, getProperty('Floorbot.height')*resizeBG*2)

	makeAnimatedLuaSprite('Lavatop',dir..'lavatop', -10, 1067 )
    setGraphicSize('Lavatop',  getProperty('Lavatop.width')* resizeBG, getProperty('Lavatop.height')*resizeBG)
    addAnimationByPrefix('Lavatop', 'idle', 'lavatop',24,true)
    playAnim('Lavatop','idle')

	makeAnimatedLuaSprite('Glowleft',dir..'glowleft', -403, 780 )
    setGraphicSize('Glowleft',  getProperty('Glowleft.width')* resizeBG, getProperty('Glowleft.height')*resizeBG)
    addAnimationByPrefix('Glowleft', 'idle', 'glowleft',24,true)
    playAnim('Glowleft','idle')

	makeAnimatedLuaSprite('Glowright',dir..'glowright', 1823, 653 )
    setGraphicSize('Glowright',  getProperty('Glowright.width')* resizeBG, getProperty('Glowright.height')* resizeBG)
    addAnimationByPrefix('Glowright', 'idle', 'glowright',24,true)
    playAnim('Glowright','idle')

	makeLuaSprite('Floor',dir..'floor', 2, 931);
	setGraphicSize('Floor',  getProperty('Floor.width')* resizeBG *2, getProperty('Floor.height')* resizeBG*2)

	makeLuaSprite('Roof',dir..'roof', 130, 100);
	setGraphicSize('Roof',  getProperty('Roof.width')* resizeBG *2, getProperty('Roof.height')*resizeBG*2)
	setScrollFactor('Roof',1.1, 1.1)

	makeLuaSprite('Pilfor',dir..'pilfor', 2132, 1282);
	setGraphicSize('Pilfor',  getProperty('Pilfor.width')* resizeBG *2, getProperty('Pilfor.height')*resizeBG*2)
	setScrollFactor('Pilfor',1.2, 1.2)

	makeLuaSprite('Pillar',dir..'pil',840, 553);
	setGraphicSize('Pillar',  getProperty('Pillar.width')* 0.75*2, getProperty('Pillar.height')* 0.75*2)

	makeAnimatedLuaSprite('ContractBF', 'characters/Beelze/ContractBF', getCharacterX('dad')- 232, getCharacterY('dad')+115)
    setGraphicSize('ContractBF',  getProperty('ContractBF.width')* 0.95, getProperty('ContractBF.height')* 0.95)
    addAnimationByPrefix('ContractBF', 'idle', 'ContractIdle',24,true)
	addAnimationByPrefix('ContractBF', '1', 'Contract_BF_01',24,false)
	addAnimationByPrefix('ContractBF', '2', 'Contract_BF_02',24,false)
	addAnimationByPrefix('ContractBF', '3', 'Contract_BF_03',24,false)
	addAnimationByPrefix('ContractBF', '4', 'Contract_BF_04',24,false)
	addAnimationByPrefix('ContractBF', '5', 'Contract_BF_05',24,false)
	addAnimationByPrefix('ContractBF', '6', 'Contract_BF_06',24,false)
	addAnimationByPrefix('ContractBF', '7', 'Contract_BF_07',24,false)
	addAnimationByPrefix('ContractBF', '8', 'Contract_BF_08',24,false)
	addAnimationByPrefix('ContractBF', '9', 'Contract_BF_09',24,false)
    playAnim('ContractBF','idle')



	addLuaSprite('Wall', false);
	addLuaSprite('Lavabottom', false);
	addLuaSprite('Rocks', false);
	addLuaSprite('Floorbot', false);
	addLuaSprite('Lavatop', false);
	addLuaSprite('Glowleft', false);
	addLuaSprite('Glowright', false);
	addLuaSprite('Floor', false);
	addLuaSprite('Roof', false);
	addLuaSprite('Pilfor', false);
	addLuaSprite('Pillar', false);


	lavabtmY=getProperty('Lavabottom.y')
	lavatopY=getProperty('Lavatop.y')
	glowLY=getProperty('Glowleft.y')
	glowRY=getProperty('Glowright.y')
	contractY=getProperty('ContractBF.y')
    
end

function onMoveCamera(focus)
    if focus == 'boyfriend' then
        setProperty('defaultCamZoom', 0.6)
    elseif focus == 'dad' then
       setProperty('defaultCamZoom', 0.75)
    end
end