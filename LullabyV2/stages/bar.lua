--Code made by Drawoon_
--if you use this please give me credit
local Path='stages/bar/images/'
function onCreate()
	addHaxeLibrary('FlxRect','flixel.math')
    consistentPosition= {-625, -100}
	consistentSize= 1.25
	isDead=false
	pastaBoppers={'Widemouth','Mousetable','Jack','Jeff','JeffArm','Squid','Herobrine','SquidHead','CoronationPeach','Shinto','POW'}
	setProperty('skipCountdown',true)
	addLuaScript('scripts/Stuff/PlayStuff.lua')
    makeLuaSprite('ShaderObj')
    
makeLuaSprite('Sky',Path..'SKY',consistentPosition[1]+914*consistentSize,consistentPosition[2]+263*consistentSize)
setScrollFactor('Sky',0.9, 0.9)
scaleObject('Sky',consistentSize+0.1,consistentSize+0.1)
addLuaSprite('Sky',false)

makeLuaSprite('Shine',Path..'shine',consistentPosition[1]+916*consistentSize,consistentPosition[2]+265*consistentSize)
setScrollFactor('Shine',0.9, 0.9)
scaleObject('Shine',consistentSize,consistentSize)
addLuaSprite('Shine',false)

makeLuaSprite('Bar',Path..'bar',consistentPosition[1],consistentPosition[2])
setScrollFactor('Bar',0.9, 0.9)
scaleObject('Bar',consistentSize,consistentSize)
addLuaSprite('Bar',false)

makeLuaSprite('Holder',Path..'holder',consistentPosition[1]+1180*consistentSize,consistentPosition[2]+228*consistentSize)
setScrollFactor('Holder',0.9, 0.9)
scaleObject('Holder',consistentSize,consistentSize,false)
addLuaSprite('Holder',false)

makeAnimatedLuaSprite('Saled',Path..'SFingers',consistentPosition[1]+1050*consistentSize,math.floor(consistentPosition[2]+390*consistentSize)-1)
addAnimationByPrefix('Saled','bop','SFingers',24,true)
setScrollFactor('Saled',0.9, 0.9)
scaleObject('Saled',consistentSize,consistentSize,false)
addLuaSprite('Saled',false)
setProperty('Saled.x',getProperty('Saled.x')-getProperty('Saled.width')/2)
setProperty('Saled.y',getProperty('Saled.y')-getProperty('Saled.height')+10)

makeAnimatedLuaSprite('Widemouth',Path..'MrWidemouth',consistentPosition[1]+1150*consistentSize,consistentPosition[2] + 390 * consistentSize)
addAnimationByPrefix('Widemouth','bop','MrWidemouth instance 1',24,false)
setScrollFactor('Widemouth',0.9, 0.9)
scaleObject('Widemouth',consistentSize,consistentSize,false)
addLuaSprite('Widemouth',false)
setProperty('Widemouth.x',getProperty('Widemouth.x')-getProperty('Widemouth.width')/2)
setProperty('Widemouth.y',getProperty('Widemouth.y')-getProperty('Widemouth.height')+8)

makeLuaSprite('Machine',Path..'Machine',200, 70)
setScrollFactor('Machine',0.9, 0.9)
scaleObject('Machine',consistentSize* 0.35,consistentSize* 0.35,false)
addLuaSprite('Machine',false)

makeAnimatedLuaSprite('Herobrine',Path..'brian_idle',315,308)
addAnimationByPrefix('Herobrine','bop','brian idle ',24,false)
setScrollFactor('Herobrine',0.9, 0.9)
scaleObject('Herobrine',consistentSize,consistentSize,false)
addLuaSprite('Herobrine',false)

makeAnimatedLuaSprite('CoronationPeach',Path..'CoronationPeach',490, 279)
addAnimationByPrefix('CoronationPeach','bop','CoronationPeach',24,false)
setScrollFactor('CoronationPeach',0.9, 0.9)
scaleObject('CoronationPeach',consistentSize* 0.5,consistentSize* 0.5,false)

makeAnimatedLuaSprite('Shinto',Path..'ShintoPastaNight',610, 312)
addAnimationByPrefix('Shinto','bop','Shitno',24,false)
setScrollFactor('Shinto',0.9, 0.9)
scaleObject('Shinto',consistentSize* 0.5,consistentSize* 0.5,false)
addLuaSprite('Shinto',false)

addLuaSprite('CoronationPeach',false)

makeAnimatedLuaSprite('Jack',Path..'Jack',100, 180)
addAnimationByPrefix('Jack','bop','Body with tar instance 1',24,false)
setScrollFactor('Jack',0.9, 0.9)
scaleObject('Jack',consistentSize* 0.64,consistentSize* 0.64,false)
addLuaSprite('Jack',false)

makeLuaSprite('OtherTable',Path..'TableMisc',595,355)
setScrollFactor('OtherTable',0.9, 0.9)
scaleObject('OtherTable',consistentSize* 0.5,consistentSize* 0.5,false)


makeAnimatedLuaSprite('SlenderBitch',Path..'Buds_Slender_Effects',735,35)
addAnimationByPrefix('SlenderBitch','bop','Slenderman Full',24,true)
setScrollFactor('SlenderBitch',0.9, 0.9)
scaleObject('SlenderBitch',consistentSize* 0.55,consistentSize* 0.55,false)
addLuaSprite('SlenderBitch',false)

makeAnimatedLuaSprite('Ben',Path..'Ben_Drowned_BG',1145,175)
addAnimationByPrefix('Ben','idle','ben drowned0',24,false)
addAnimationByPrefix('Ben','look','ben drowned looking',24,false)
setScrollFactor('Ben',0.9, 0.9)
scaleObject('Ben',consistentSize* 0.55,consistentSize* 0.55,false)
addLuaSprite('Ben',false)
playAnim('Ben','idle')

makeAnimatedLuaSprite('Squid',Path..'Squirtward',750,210)
addAnimationByPrefix('Squid','bop','Squidward_idleBody',24,false)
setScrollFactor('Squid',0.9, 0.9)
scaleObject('Squid',consistentSize* 0.6,consistentSize* 0.6,false)
addLuaSprite('Squid',false)


makeAnimatedLuaSprite('SquidHead',Path..'Squirtward',750,210)
addAnimationByPrefix('SquidHead','bop','Squidward_idleHead',24,false)
setScrollFactor('SquidHead',0.9, 0.9)
scaleObject('SquidHead',consistentSize* 0.6,consistentSize* 0.6,false)
addLuaSprite('SquidHead',false)

addLuaSprite('OtherTable',false)

makeAnimatedLuaSprite('Jeff',Path..'Jeff',472, 305)
addAnimationByPrefix('Jeff','bop','mynamejeff instance 1',24,false)
setScrollFactor('Jeff',0.9, 0.9)
scaleObject('Jeff',consistentSize* 0.78,consistentSize* 0.78,false)
addLuaSprite('Jeff',false)

makeAnimatedLuaSprite('Mousetable',Path..'Mousetable',consistentPosition[1] + 900 * consistentSize, consistentPosition[2] + 750 * consistentSize)
addAnimationByPrefix('Mousetable','bop','Mousetable',24,false)
setScrollFactor('Mousetable',0.9, 0.9)
scaleObject('Mousetable',consistentSize* 0.5,consistentSize* 0.5,false)
addLuaSprite('Mousetable',false)
setProperty('Mousetable.x',getProperty('Mousetable.x')-getProperty('Mousetable.width')/2)
setProperty('Mousetable.y',getProperty('Mousetable.y')-getProperty('Mousetable.height'))

makeAnimatedLuaSprite('JeffArm',Path..'JeffArm',500, 445)
addAnimationByPrefix('JeffArm','bop','Only the arm shit instance 1',24,false)
setScrollFactor('JeffArm',0.9, 0.9)
scaleObject('JeffArm',consistentSize* 0.78,consistentSize* 0.78,false)
addLuaSprite('JeffArm',false)

    makeAnimatedLuaSprite('Gb',Path..'GB_PastaNight_Assets',25000, 350)
    addAnimationByPrefix('Gb','idle','GBWalkPioladepana',24,true)
    setScrollFactor('Gb',0.9, 0.9)
    scaleObject('Gb',1.65,1.65,false)
    addLuaSprite('Gb',false)

	makeAnimatedLuaSprite('Gold',Path..'GOLD_PASTA_NIGHT',10000, 50)
    addAnimationByPrefix('Gold','idle','GOLD PASTA NIGHT instance 1',24,true)
    setScrollFactor('Gold',0.9, 0.9)
    scaleObject('Gold',1.65,1.65,false)
    addLuaSprite('Gold',false)


	makeLuaSprite('CHAIRS',Path..'CHAIRS',getProperty('Mousetable.x')- 535,getProperty('Mousetable.y')+ 65)
	scaleObject('CHAIRS',consistentSize*0.75,consistentSize*0.75,false)
	setScrollFactor('CHAIRS',0.9, 0.9)
	--addLuaSprite('CHAIRS',false)

    makeLuaSprite('Table',Path..'TABLE',0,0)
	scaleObject('Table',0.75,0.75)
	screenCenter('Table','xy')
	setProperty('Table.x',getProperty('Table.x')-50)
	setProperty('Table.y',getProperty('Table.y')+750)
	setObjectOrder('Table',40)
	addLuaSprite('Table',false)

	setObjectOrder('boyfriendGroup',getObjectOrder('Table')-1)
    setObjectOrder('dadGroup',getObjectOrder('Table')-1)
    setObjectOrder('gfGroup',getObjectOrder('Table')+1)

	runHaxeCode([[
		var saled=game.getLuaObject("Saled");
		var swagRect=new FlxRect(0, 0, saled.width, saled.height - 16);
	    saled.clipRect = swagRect;
	]])
end

function onBeatHit()
	if curBeat % 2 == 0 then
		for i=0,#pastaBoppers do
			playAnim(pastaBoppers[i],'bop')
		end 
	end
	if curBeat >= 84 then
		playAnim('Ben','look')
	end
	
end
function onUpdate(elapsed)
	if shadersEnabled then setShaderFloat('ShaderObj','iTime',getSongPosition() / 1000) end

	if luaSpriteExists('Gold') and SongStarter then
		setProperty('Gold.x',getProperty('Gold.x')-elapsed / (0.25 / 60))
	end
	if luaSpriteExists('Gb') and SongStarter then
		setProperty('Gb.x',getProperty('Gb.x')-elapsed / (0.25 / 60))
	end
end
function onCreatePost()
	if shadersEnabled then
	runHaxeCode([[
        var shaderName = "old";
        
        game.initLuaShader(shaderName);
        
        var shader0 = game.createRuntimeShader(shaderName);
        game.camGame.setFilters([new ShaderFilter(shader0)]);
        game.getLuaObject("ShaderObj").shader = shader0;
        shader0.setFloat('iTime', 1);
    ]])
	end
	setGlobalFromScript('scripts/Stuff/CameraMove','ManualPos',{getCharacterX('gf')+264.5-50,getCharacterY('gf')+245-200})
	setGlobalFromScript('scripts/Stuff/CameraMove','ForceCamPos',true)
	setGlobalFromScript('scripts/Stuff/CameraMove','CamMove',false)
end

function addLuaSpriteSubstate(tag)
    runHaxeCode([[
        CustomSubstate.instance.add(game.getLuaObject("]]..tag..[["));
    ]])
end



