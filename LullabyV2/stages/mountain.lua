local dir = 'stages/mountain/images/'

function onCreate()
	makeLuaSprite('background', dir .. 'bg', -800, -300)
	setScrollFactor('background', 0.6, 0.6)
	addLuaSprite('background')

	makeLuaSprite('charizard', dir .. 'Charizard', 107, 165)
	setScrollFactor('charizard', 0.7, 0.7)
	scaleObject('charizard', 0.5, 0.5)
	addLuaSprite('charizard')

	makeLuaSprite('blastoise', dir .. 'Blastoise', -235, 362)
	setScrollFactor('blastoise', 0.8, 0.8)
	scaleObject('blastoise', 0.4, 0.4)
	addLuaSprite('blastoise')

	makeLuaSprite('pokemons', dir .. 'Pokemons', 495, 475)
	setScrollFactor('pokemons', 0.9, 0.9)
	scaleObject('pokemons', 0.25, 0.25)
	addLuaSprite('pokemons')

	makeLuaSprite('fog', dir .. 'fog', 0, 0)
	setScrollFactor('fog', 0, 0)
	scaleObject('fog', 1.25, 1.25)
	screenCenter('fog')
	addLuaSprite('fog', true)

	makeLuaSprite('introFog', '', 0, 0)
    makeGraphic('introFog', 1280, 720, 'FF0E9FB')
    setObjectCamera('introFog', 'other')
    addLuaSprite('introFog')
end

function onCreatePost()
	-- swap strum positions
	if not middlescroll then
		for i = 0,getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i])
			setPropertyFromGroup('opponentStrums', i, 'x', _G['defaultPlayerStrumX'..i])
		end
	end
end