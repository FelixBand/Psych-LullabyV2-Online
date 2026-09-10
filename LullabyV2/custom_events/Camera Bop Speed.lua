local bopIntensity = 0;
local bopSpeed = 0;

function onStepHit()
	if curStep % (16 / bopSpeed) == 0 and getProperty('camZooming') == true then
		triggerEvent('Add Camera Zoom', 0.015 * bopIntensity, 0.03 * bopIntensity);
	end
end

function onEvent(name, value1, value2)
	if name == 'Camera Bop Speed' then
		bopIntensity = value1;
		bopSpeed = value2;
	end
end