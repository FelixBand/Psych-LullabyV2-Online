function onCreatePost()
    initSaveData('HypnosPref')
    makeLuaSprite('FiltreRef')
	if shadersEnabled and getDataFromSave('HypnosPref','Hell mode',false) then
		runHaxeCode([[
			var shaderName = "glitch";
    
			var shader0 = game.createRuntimeShader(shaderName);
            var FiltrersGame=game.camGame.flashSprite.filters;
            FiltrersGame.push(new ShaderFilter(shader0));
            var FiltrersHUD=game.camHUD.flashSprite.filters;
            FiltrersHUD.push(new ShaderFilter(shader0));
            game.camGame.setFilters(FiltrersGame);
			game.camHUD.setFilters(FiltrersHUD);
			game.getLuaObject("FiltreRef").shader = shader0;
		]])
	end
end
local UpdateGlitch=false
function onUpdate(elapsed)
    if UpdateGlitch then 
        setShaderFloat('FiltreRef','time',(math.floor((getSongPosition() / crochet)) * crochet) / 1000)
    end
end
--Value1:Update time/Set Actual Time
--Value2:Set Prop
function onEvent(eventName, value1, value2)
    if eventName=='MissingnoGlitchHell' and getDataFromSave('HypnosPref','Hell mode',false) then
        local Result=stringSplit(value1,'/')
        if Result[1]=='true' then
            UpdateGlitch=true
        else
            UpdateGlitch=false
        end
        if Result[2]=='true' then
            setShaderFloat('FiltreRef','time',(math.floor((getSongPosition() / crochet)) * crochet) / 1000)
        end
        
        if value2=='' then
            
        else
            setShaderFloat('FiltreRef','prob',tonumber(value2))
        end
    end
end
function onGameOver()
    if shadersEnabled and getDataFromSave('HypnosPref','Hell mode',false) then
		runHaxeCode([[
            game.camGame.setFilters([]);
			game.camHUD.setFilters([]);
		]])
	end
end

--MissingnoGlitchHell