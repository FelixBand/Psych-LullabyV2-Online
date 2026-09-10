function onCreate()
	makeLuaSprite('background', 'stages/alley/images/BACKGROUND', 0, 0);
	setLuaSpriteScrollFactor('background', 0.6, 0.6);
	scaleObject('background', 0.7, 0.7);

	makeLuaSprite('grass', 'stages/alley/images/Behind the clouds and fence', 0, 0);
	setLuaSpriteScrollFactor('grass', 0.7, 0.7);
	scaleObject('grass', 0.7, 0.7);

	makeLuaSprite('fog', 'stages/alley/images/Behind the Fence', 0, 0);
	setLuaSpriteScrollFactor('fog', 0.8, 0.8);
	scaleObject('fog', 0.7, 0.7);
	
	if string.lower(songName) == 'left-unchecked' then
		makeLuaSprite('midground', 'stages/alley/images/MIDGROUND BLOOD', 0, 0);
	else
		makeLuaSprite('midground', 'stages/alley/images/MIDGROUND', 0, 0);
	end
	setLuaSpriteScrollFactor('midground', 1, 1);
	scaleObject('midground', 0.7, 0.7);

	makeLuaSprite('stageForeground', 'stages/alley/images/FOREGROUND TREE', -50, 0);
	setLuaSpriteScrollFactor('stageForeground', 1.2, 1.2);
	scaleObject('stageForeground', 0.7, 0.7);

	addLuaSprite('background', false);
	addLuaSprite('grass', false);
	addLuaSprite('fog', false);
	addLuaSprite('midground', false);
	addLuaSprite('stageForeground', true);
end

function onCreatePost()
	debugPrint(isRoomConnected())
	if playsAsBF() then
		for i = 0,getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', -5000);
		end
	end

	setProperty('camZooming', true);
	--debugPrint(getProperty('boyfriend.cameraPosition[1]'));
end

function onMoveCamera(focus)
	if focus == 'boyfriend' then
		setProperty('defaultCamZoom', 0.7);
	elseif focus == 'dad' then
		setProperty('defaultCamZoom', 0.65);
	end
end