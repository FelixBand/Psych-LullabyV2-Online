function onCreate()
    addLuaScript('pendulum')
end

local cutscened = false;
function onEndSong()
    if not cutscened and isStoryMode then
		setProperty('camGame.visible', false);
		setProperty('camHUD.visible', false);
		stopSound('trance');
        startVideo('leftunchecked');
        cutscened = true;
        return Function_Stop;
    end
return Function_Continue;
end