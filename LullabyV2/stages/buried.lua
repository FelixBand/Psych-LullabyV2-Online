--[[
    Code made by Drawoon_
]]
local Path='stages/buried/images/'
local Scale=1

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
end