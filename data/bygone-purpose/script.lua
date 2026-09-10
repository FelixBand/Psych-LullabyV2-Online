function onCreate()
	makeLuaSprite('bygoneFuck', 'stages/bygone/images/AlexisTransition', 0, 0);
	setObjectCamera('bygoneFuck', 'other');
	scaleObject('bygoneFuck', 0.95, 0.95);
	screenCenter('bygoneFuck');
	setProperty('bygoneFuck.alpha', 0.0001);
	addLuaSprite('bygoneFuck');
	
	makeAnimatedLuaSprite('alexisPass', 'stages/bygone/images/GGirl Alexis Passing Spritesheet', 1630, 290);
	addAnimationByPrefix('alexisPass', 'pass', 'GGirl Passing', 24, false);
	objectPlayAnimation('alexisPass', 'pass', true);
	setProperty('alexisPass.alpha', 0.0001);
	addLuaSprite('alexisPass');

	makeAnimatedLuaSprite('gates', 'stages/bygone/images/Heavens Gate', 1565, 250);
	addAnimationByPrefix('gates', 'open', 'Heavens Gate', 24, false);
	objectPlayAnimation('gates', 'open', true);
	setProperty('gates.alpha', 0.0001);
	addLuaSprite('gates');

	for i = 0, getProperty('unspawnNotes.length') do
        setPropertyFromGroup('unspawnNotes', i, 'multSpeed', getRandomFloat(0.85, 1.4))
        if getPropertyFromGroup('unspawnNotes', i, 'isSustainNote') then
            setPropertyFromGroup('unspawnNotes', i, 'multSpeed', getPropertyFromGroup('unspawnNotes', i, 'prevNote.multSpeed'))
        end
    end
end

function onCreatePost()
	for i = 0,getProperty('playerStrums.length') - 1 do
		setPropertyFromGroup('playerStrums', i, 'x', _G['defaultOpponentStrumX'..i]);
	end
	for i = 0,getProperty('opponentStrums.length') - 1 do
		setPropertyFromGroup('opponentStrums', i, 'x', 5000);
	end

	setProperty('iconP2.visible', false);

	setProperty('camZooming', true);
end

function onStepHit()
	if curStep == 588 then
		doTweenAlpha('picture', 'bygoneFuck', 1, 6, 'linear');
	elseif curStep == 633 then
		setProperty('boyfriend.alpha', 0);
		setProperty('health', 1);
		removeLuaSprite('iconPlayer', true);
		setProperty('iconP1.visible', true);
		doTweenAlpha('picture', 'bygoneFuck', 0, 10, 'linear');
		doTweenAlpha('bgTrans1', 'bigHypno', 1, 10, 'linear');
		doTweenAlpha('bgTrans2', 'buildings2', 1, 10, 'linear');
		doTweenAlpha('bgTrans3', 'bridge2', 1, 10, 'linear');
		doTweenAlpha('bgTrans4', 'background2', 1, 10, 'linear');
		doTweenAlpha('bgTrans5', 'bridgeRope2', 1, 10, 'linear');

		doTweenAlpha('bgTrans6', 'bridge', 0, 10, 'linear');
		doTweenAlpha('bgTrans7', 'bridgeRope', 0, 10, 'linear');
	elseif curStep == 712 then
		doTweenAlpha('playerIn', 'boyfriend', 1, 2, 'quadOut');
	elseif curStep == 1236 then
		setProperty('boyfriend.visible', false);
		setProperty('alexisPass.alpha', 1);
		setProperty('gates.alpha', 1);
		objectPlayAnimation('gates', 'open', true);
		objectPlayAnimation('alexisPass', 'pass', true);
	end
end