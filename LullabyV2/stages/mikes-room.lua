local dir = 'stages/mikes-room/images/'

function onCreate()
	consistentResize=1
	consistentPosition={-300, 100}

	makeLuaSprite('background',dir..'back', consistentPosition[1], consistentPosition[2])
	setScrollFactor('background', 0.7, 0.7)
	StageStuff('background')

	makeLuaSprite('portrait',dir..'portrait', consistentPosition[1], consistentPosition[2])
	setScrollFactor('portrait', 0.7, 0.7)
	StageStuff('portrait')

	makeLuaSprite('lacama',dir..'bed', consistentPosition[1], consistentPosition[2])
	setScrollFactor('lacama', 0.9, 0.9)
	StageStuff('lacama')

	makeLuaSprite('laalmuada',dir..'pillow', consistentPosition[1], consistentPosition[2])
	setScrollFactor('laalmuada', 0.9, 0.9)
	StageStuff('laalmuada')

	makeLuaSprite('redOverlay',dir..'redoverlay',0,0)
	setScrollFactor('redOverlay', 0, 0)
    setObjectCamera('redOverlay','hud')
	addLuaSprite('redOverlay')
	setProperty('redOverlay.alpha',0.04)
end

function StageStuff(tag)
	scaleObject(tag,consistentResize,consistentResize)
	if tag=='lacama' or tag=='laalmuada' then
        addLuaSprite(tag,true)
	else
		addLuaSprite(tag)
    end
	setProperty(tag..'.alpha', 0.0001)
end