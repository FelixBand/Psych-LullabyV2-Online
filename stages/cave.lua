local dir = 'stages/cave/images/';

function onCreate()
	makeLuaSprite('background', dir .. 'cave', -410, -150);
	addLuaSprite('background');
end

function onMoveCamera(focus)
	if curBeat >= 80 then
		if focus == 'boyfriend' then
			setProperty('defaultCamZoom', 0.75);
		elseif focus == 'dad' then
			setProperty('defaultCamZoom', 0.65);
		end
	end
end