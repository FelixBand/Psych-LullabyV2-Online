local dir = 'stages/feralisleep/images/';

function onCreate()
	setProperty('boyfriendGroup.alpha', 0);

	makeLuaSprite('water', dir .. 'Lost_silver_lake', -250, 700);
	setScrollFactor('water', 1, 0.9);
	addLuaSprite('water');

	makeLuaSprite('ground', dir .. 'Lost_silver_ground', -260, 730);
	setScrollFactor('ground', 0.9, 0.9);
	addLuaSprite('ground');

	makeLuaSprite('tree', dir .. 'Lost_silver_tree', -280, -280);
	setScrollFactor('tree', 0.9, 0.9);
	addLuaSprite('tree');

	makeAnimatedLuaSprite('feraligatr', 'characters/silver/Feralisleep', 400, 110);
	addAnimationByPrefix('feraligatr', 'idle', 'Feralisleep instance 1', 24, false);
	addLuaSprite('feraligatr');
end

function onCreatePost()
	if playsAsBF() then
		for i = 0,getProperty('opponentStrums.length') - 1 do
			setPropertyFromGroup('opponentStrums', i, 'x', -5000);
		end
	end
	setProperty('camZooming', true);
end

function onBeatHit()
	if getProperty('feraligatr.animation.curAnim.finished') == true then
		playAnim('feraligatr', 'idle', true);
	end
end