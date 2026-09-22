local dir = 'stages/feralisleep/images/';
local fogCount = 6;
local insomniaFog = {};
local startingPosition = {};
local fogTimer = 0;

function onCreate()
	setProperty('boyfriendGroup.alpha', 0);

	makeLuaSprite('water', dir .. 'Lost_silver_lake', -250, 700);
	setScrollFactor('water', 1, 0.9);
	addLuaSprite('water');

	for i = 1, fogCount do
		local fog = 'fog' .. i;
		makeLuaSprite(fog, dir .. 'Lost_silver_fog', -260, 430);
		setScrollFactor(fog, 0.95, 0.9);
		if i - 1 < (fogCount / 2) - 1 then
			setProperty(fog .. '.flipX', true);
		end
		addLuaSprite(fog);
		startingPosition[i] = {x = -260, y = 430};
		insomniaFog[i] = fog;
	end

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

function onUpdate(elapsed)
	if getProperty('inCutscene') then
		fogTimer = fogTimer + elapsed * 1000;
	elseif getSongPosition() >= 0 then
		fogTimer = getSongPosition();
	end

	for i = 1, #insomniaFog do
		local zeroIndex = i - 1;
		local speedDivider = 128;
		local swirlSize = 32;
		local formulaX = math.cos((180 / math.pi) * ((fogTimer - (fogTimer * zeroIndex)) / 1000) / speedDivider) * swirlSize;
		local formulaY = math.sin((180 / math.pi) * ((fogTimer - (fogTimer * zeroIndex)) / 1000) / speedDivider) * swirlSize;
		local fog = insomniaFog[i];
		setProperty(fog .. '.x', startingPosition[i].x + (zeroIndex % 2 == 0 and formulaX or formulaY));
		setProperty(fog .. '.y', startingPosition[i].y + (zeroIndex % 2 == 0 and formulaY or formulaX));

		swirlSize = 2;
		formulaX = math.cos((180 / math.pi) * ((fogTimer - (fogTimer * zeroIndex)) / 1000) / speedDivider);
		formulaY = math.sin((180 / math.pi) * ((fogTimer - (fogTimer * zeroIndex)) / 1000) / speedDivider);
		local alpha = (zeroIndex % 2 == 0 and formulaY or formulaX) / swirlSize;
		if zeroIndex < (fogCount / 2) - 1 then
			alpha = 1 - alpha;
		end
		setProperty(fog .. '.alpha', alpha);
	end
end