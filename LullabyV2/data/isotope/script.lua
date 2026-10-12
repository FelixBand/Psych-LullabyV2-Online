function onCreate()
	setProperty('camHUD.alpha', 0.0001);

	makeAnimatedLuaSprite('legacyCutscene', 'stages/glitchy/images/they_took_everything_from_me', 560, -20);
	setObjectCamera('legacyCutscene', 'other');
	addAnimationByPrefix('legacyCutscene', 'speech', 'GlitchySpeak', 24, false);
	scaleObject('legacyCutscene', 1.25, 1.25);
	setProperty('legacyCutscene.alpha', 0.0001);
	addLuaSprite('legacyCutscene');

	makeLuaSprite('vignetteGlitchController', '', 0, 0)
	runHaxeCode([[
		game.initLuaShader('vignetteGlitch');

		var vignetteGlitchShader = game.createRuntimeShader('vignetteGlitch');

		game.getLuaObject('vignetteGlitchController').shader = vignetteGlitchShader;

		game.camGame.setFilters([
			new ShaderFilter(vignetteGlitchShader)
		]);
	]]);

	setShaderFloat('vignetteGlitchController', 'prob', 0)
    setShaderFloat('vignetteGlitchController', 'vignetteIntensity', 0)

	makeLuaSprite('chromaticController', '', 0, 0);
	initLuaShader('redAberration')
end


local function flipSide(arrayName, isPlayer)
    local count = getProperty(arrayName .. '.length')
    for i = 0, count - 1 do
        local icon = arrayName .. '[' .. i .. ']'
        local scaleX = getProperty(icon .. '.scale.x')
        local barX = getProperty('healthBar.x')
            + getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01
        -- small extra spread per icon so stacked ones don't sit on top of each other
        local spread = i * 40

        if isPlayer then
            setProperty(icon .. '.x', barX + (150 * scaleX - 150) / 2 - 26 - 110 - spread)
            setProperty(icon .. '.origin.x', 240)
        else
            setProperty(icon .. '.x', barX - (150 * scaleX) / 2 - 26 * 2 + 110 + spread)
            setProperty(icon .. '.origin.x', -100)
        end
        setProperty(icon .. '.flipX', true)
    end
end

function onUpdatePost()
	setShaderFloat('vignetteGlitchController', 'time', os.clock())
	if curSection >= 68 then
		setShaderFloat('dad', 'amount', getProperty('chromaticController.x'))
	end

    flipSide('iconP1s', true)
    flipSide('iconP2s', false)
end

function onCreatePost()
	setProperty('camZoomingMult', 0);
	setProperty('healthBar.flipX', true)

	for i = 0, getProperty('unspawnNotes.length') - 1 do -- allow bf's throw animation to play uninterrupted
		local strumTime = getPropertyFromGroup('unspawnNotes', i, 'strumTime')
		local mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')

		if mustPress and strumTime >= 85029 and strumTime <= 87728 then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
		end
	end

	runHaxeCode([[
        for (t in game.scoreTxtOthers) {
            if (t.offset.x < 0) {
                // was the left text: move it to the right edge
                t.alignment = 'right';
                t.offset.x = 30;
            } else {
                // was the right text: move it to the left edge
                t.alignment = 'left';
                t.offset.x = -30;
            }
        }
    ]])
end

function onEvent(name, value1, value2)
	if name == 'Change Character' and value2 == 'glitchy-red-mad' then
		setSpriteShader('dad', 'redAberration')

		setShaderFloat('vignetteGlitchController', 'prob', 0.75)
    	setShaderFloat('vignetteGlitchController', 'vignetteIntensity', 0.75)
	end
end

function onSectionHit()
	if curSection >= 68 then
		setProperty('chromaticController.x', 15)
		doTweenX('chromDown', 'chromaticController', 0, 0.5, 'linear')
	end
end

function onStepHit()
	if curStep == 1872 then
		setProperty('camGame.alpha', 0);
		runTimer('doCamThing', 1);
		runTimer('doSpeech', 1);
		playAnim('legacyCutscene', 'speech', true);
		setProperty('dadGroup.visible', false);
		setProperty('boyfriendGroup.visible', false);
		setProperty('girlTits.visible', false);

		--hud elements out
		setProperty('timeBarBG.visible', false);
		setProperty('timeBar.visible', false);
		setProperty('timeTxt.visible', false);
		setProperty('scoreTxt.visible', false);
		setProperty('healthBar.visible', false);
		setProperty('healthBarBG.visible', false);
		setProperty('iconP1.visible', false);
		setProperty('iconP2.visible', false);

		for i = 0,getProperty('playerStrums.length') - 1 do
            noteTweenAlpha('notetween' .. i, i + getProperty('opponentStrums.length'), 0, 3, 'quadInOut');
        end
	elseif curStep == 1997 then
		removeLuaSprite('legacyCutscene', true);
		setProperty('camGame.alpha', 0);
		setProperty('camZooming', true);
	elseif curStep == 2002 then
		setProperty('dadGroup.visible', true);
		setProperty('boyfriendGroup.visible', true);
		setProperty('girlTits.visible', true);
		setProperty('camGame.alpha', 1);

		--hud elements in
		setProperty('timeBarBG.visible', true);
		setProperty('timeBar.visible', true);
		setProperty('timeTxt.visible', true);
		setProperty('scoreTxt.visible', true);
		setProperty('healthBar.visible', true);
		setProperty('healthBarBG.visible', true);
		setProperty('iconP1.visible', true);
		setProperty('iconP2.visible', true);

		for i = 0,getProperty('playerStrums.length') - 1 do
			setPropertyFromGroup('playerStrums', i, 'alpha', 1);
		end
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'doCamThing' then
		doTweenAlpha('camIn', 'camGame', 0.5, 1.6, 'quadInOut');
		setProperty('camZooming', false);
	elseif tag == 'doSpeech' then
		doTweenX('cutsceneSlide', 'legacyCutscene', 410, 9, 'quadInOut');
		doTweenAlpha('cutsceneAlpha', 'legacyCutscene', 1, 9, 'quadInOut');
	end
end