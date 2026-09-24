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
end

function onUpdatePost()
	setShaderFloat('vignetteGlitchController', 'time', os.clock())
	if curSection >= 68 then
		setShaderFloat('dad', 'amount', getProperty('chromaticController.x'))
	end

    setProperty('iconP1.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') *        getProperty('healthBar.percent') * 0.01) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26) - 110)
    setProperty('iconP1.origin.x',240)
    setProperty('iconP1.flipX',true)
    setProperty('iconP2.x',getProperty('healthBar.x') + ((getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2) + 110)
    setProperty('iconP2.origin.x',-100)
    setProperty('iconP2.flipX',true)
end

function onCreatePost()
	setProperty('camZoomingMult', 0);
	setProperty('healthBar.flipX', true)

	for i = 0, getProperty('unspawnNotes.length') - 1 do -- allow bf's throw animation to play uninterrupted
		local strumTime = getPropertyFromGroup('unspawnNotes', i, 'strumTime')
		local mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')

		if mustPress and strumTime >= 85452 and strumTime <= 86728 then
			setPropertyFromGroup('unspawnNotes', i, 'noAnimation', true)
		end
	end
end

function onEvent(name, value1, value2)
	if name == 'Change Character' and value2 == 'glitchy-red-mad' then
		makeLuaSprite('chromaticController', '', 0, 0);
		initLuaShader('redAberration')
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