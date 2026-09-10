function onCreate()
	makeAnimatedLuaSprite('bg1', 'stages/shitty-cave/images/BG_shitno', -740, 0)
	addAnimationByPrefix('bg1', 'idle', 'BG_shitno_01', 1, false)
	scaleObject('bg1', 6.5, 6.5)
	setProperty('bg1.antialiasing', false)
	addLuaSprite('bg1')

	makeAnimatedLuaSprite('bg2', 'stages/shitty-cave/images/BG_shitno', -740, 0)
	addAnimationByPrefix('bg2', 'idle', 'BG_shitno_02', 1, false)
	scaleObject('bg2', 6.5, 6.5)
	setProperty('bg2.antialiasing', false)
	addLuaSprite('bg2')
end

function onCreatePost()
	setProperty('boyfriend.visible', false)
end