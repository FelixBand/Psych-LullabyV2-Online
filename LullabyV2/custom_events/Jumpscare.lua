function onCreate()
    makeLuaSprite('jumpscare', 'jumpscares/Gold', 0, 0)
    setObjectCamera('jumpscare', 'hud')
    scaleObject('jumpscare', 0.4, 0.4)
    addLuaSprite('jumpscare', true)
    setProperty('jumpscare.alpha', 0.0001)

    makeLuaSprite('jumpscareAlt', 'jumpscares/GoldAlt', 0, 0)
    setObjectCamera('jumpscareAlt', 'hud')
    scaleObject('jumpscareAlt', 0.3, 0.3)
    addLuaSprite('jumpscareAlt', true)
    setProperty('jumpscareAlt.alpha', 0.0001)
    runTimer('shake', 0.025, 0)
end

local jumpscareAltSize = 0.3
local jumpscareAltBaseX = 0
local jumpscareAltBaseY = 0

function onEvent(name, value1, value2)
    if name == 'Jumpscare' then
        if curBeat < 416 then
            setProperty('jumpscare.alpha', 1)
            doTweenAlpha('jumpscareOut', 'jumpscare', 0, 0.5, 'smoothStepIn')
        else

            scaleObject('jumpscareAlt', jumpscareAltSize, jumpscareAltSize)
            updateHitbox('jumpscareAlt')
            screenCenter('jumpscareAlt', 'xy')

            jumpscareAltBaseX = getProperty('jumpscareAlt.x')
            jumpscareAltBaseY = getProperty('jumpscareAlt.y')

            jumpscareAltSize = jumpscareAltSize + 0.025

            setProperty('jumpscareAlt.alpha', 1)
            doTweenAlpha('jumpscareAltOut', 'jumpscareAlt', 0, 0.5, 'smoothStepIn')
        end
    end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'shake' then
		setProperty('jumpscare.x', getRandomInt(-145, -135))
		setProperty('jumpscare.y', getRandomInt(-145, -135))

		setProperty(
			'jumpscareAlt.x',
			jumpscareAltBaseX + getRandomInt(-5, 5)
		)

		setProperty(
			'jumpscareAlt.y',
			jumpscareAltBaseY + getRandomInt(-5, 5)
		)
	end
end