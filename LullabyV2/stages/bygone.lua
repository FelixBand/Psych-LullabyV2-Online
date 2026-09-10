local dir = 'stages/bygone/images/';

function onCreate()
	setProperty('dadGroup.visible', false);
	setProperty('skipCountdown', true);
	setProperty('camHUD.alpha', 0.0001);

	makeLuaSprite('background', dir .. 'BG1 Clouds', -500, -300);
	scaleObject('background', 1.25, 1.25);
	setScrollFactor('background', 0.6, 0.6);
	addLuaSprite('background');

	makeLuaSprite('background2', dir .. 'BG2 Sky', -500, -300);
	scaleObject('background2', 1.25, 1.25);
	setScrollFactor('background2', 0.6, 0.6);
	setProperty('background2.alpha', 0.0001);
	addLuaSprite('background2');

	makeLuaSprite('moon', dir .. 'BG1 Moon', -440, -215);
	scaleObject('moon', 1.25, 1.25);
	setScrollFactor('moon', 0.7, 0.7);
	addLuaSprite('moon');

	makeLuaSprite('buildings', dir .. 'BG1 Buildings', 150, 100);
	scaleObject('buildings', 1.15, 1.15);
	setScrollFactor('buildings', 0.75, 0.75);
	addLuaSprite('buildings');

	makeLuaSprite('buildings2', dir .. 'BG2 Buildings', 150, 100);
	scaleObject('buildings2', 1.15, 1.15);
	setScrollFactor('buildings2', 0.75, 0.75);
	setProperty('buildings2.alpha', 0.0001);
	addLuaSprite('buildings2');

	makeLuaSprite('bridgeRope', dir .. 'BridgeRope', 930, 250);
	setScrollFactor('bridgeRope', 0.9, 0.9);
	addLuaSprite('bridgeRope');

	makeLuaSprite('bridgeRope2', dir .. 'BridgeRope2', 930, 250);
	setScrollFactor('bridgeRope2', 0.9, 0.9);
	setProperty('bridgeRope2.alpha', 0.0001);
	addLuaSprite('bridgeRope2');
	
	makeLuaSprite('bigHypno', dir .. 'BigHypno', 1105, 520);
	setScrollFactor('bigHypno', 0.9, 0.9);
	setProperty('bigHypno.alpha', 0.0001);
	addLuaSprite('bigHypno');

	makeLuaSprite('bridge', dir .. 'Bridge', 350, 400);
	setScrollFactor('bridge', 0.9, 0.9);
	addLuaSprite('bridge', true);

	makeLuaSprite('bridge2', dir .. 'Bridge2', 350, 400);
	setScrollFactor('bridge2', 0.9, 0.9);
	setProperty('bridge2.alpha', 0.0001);
	addLuaSprite('bridge2', true);
end