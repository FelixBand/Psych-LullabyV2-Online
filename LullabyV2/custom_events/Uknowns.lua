local AllWordsLists = {}

local mechanics = 'Normal'
local canOpenUknowns = true

local actualWord = {}
local actualLetter = 1
local wordObjects = {}

local wordLength = 0
local letterCount = 0

local offset = 20
local timeLimit = 15

local currentWord = ''
local lastStep = -1

local difficulty = 'Normal'
local unknownsOpen = false
local wasReset = true

function onCreate()
	precacheImage('Mechanics/line')
	precacheImage('Mechanics/Unown_Alphabet')

	AllWordsLists.Normal = stringSplit(getTextFromFile('WordUnknow/Normal.txt'), '\n')
	AllWordsLists.Hard = stringSplit(getTextFromFile('WordUnknow/Hard.txt'), '\n')
	AllWordsLists.Rare = stringSplit(getTextFromFile('WordUnknow/Rare.txt'), '\n')
	AllWordsLists.Impossible = stringSplit(getTextFromFile('WordUnknow/Impossible.txt'), '\n')
	AllWordsLists.Hell = stringSplit(getTextFromFile('WordUnknow/Hell.txt'), '\n')
	AllWordsLists.Missingno = stringSplit(getTextFromFile('WordUnknow/Missingno.txt'), '\n')
	AllWordsLists.Brimstone = stringSplit(getTextFromFile('WordUnknow/Brimstone.txt'), '\n')

	mechanics = getModSetting('mechanics') or 'Normal'

	if mechanics == 'Pussy' then
		canOpenUknowns = false
	end

	if (songName == 'Missingno' or songName == 'Brimstone') and mechanics ~= 'Hell' then
		canOpenUknowns = false
	end

	UnkownBotplay = false
end

function onEvent(eventName, value1, value2)
	if eventName ~= 'Uknowns' or not playsAsBF() or not canOpenUknowns then
		return
	end

	timeLimit = tonumber(value1) or 15
	currentWord = value2 ~= '' and string.upper(stringTrim(value2)) or ''

	openUknowns()
end

function chooseDifficulty()
	if mechanics == 'Hell' then
		if songName == 'Missingno' then
			return 'Missingno'
		elseif songName == 'Brimstone' then
			return 'Brimstone'
		end

		return 'Hell'
	end

	if dadName == 'gold-headless' then
		return 'Hard'
	end

	local chance = getRandomInt(0, 10)

	if chance == 1 then
		difficulty = 'Hard'

		if getRandomInt(0, 10) == 1 then
			difficulty = 'Rare'

			if getRandomInt(0, 10) == 1 then
				difficulty = 'Impossible'
			end
		end

		return difficulty
	end

	return 'Normal'
end

function openUknowns()
	if unknownsOpen then
		return
	end

	unknownsOpen = true
	wasReset = getProperty('canReset')
	setProperty('canReset', false)

	difficulty = chooseDifficulty()

	local finalWord = currentWord

	if finalWord == '' then
		local words = AllWordsLists[difficulty]

		if words and #words > 0 then
			finalWord = stringTrim(words[getRandomInt(1, #words)])
		else
			finalWord = 'NOT FOUND'
		end
	end

	currentWord = ''

	actualWord = stringSplit(string.upper(finalWord), '')
	actualLetter = 1
	wordLength = 0
	letterCount = 0

	makeLuaSprite('BackUknowns', '', 0, 0)
	makeGraphic('BackUknowns', screenWidth, screenHeight, 'FF0000')
	setObjectCamera('BackUknowns', 'other')
	setProperty('BackUknowns.alpha', 0.4)
	addLuaSprite('BackUknowns', true)

	for i, letter in ipairs(actualWord) do
		makeLetter(letter)
	end

	positionWord()

	makeLuaText('UnknownTimer', tostring(timeLimit), 0, 0, 0)
	setTextSize('UnknownTimer', 32)
	setTextFont('UnknownTimer', 'metro.otf')
	setTextBorder('UnknownTimer', 0, 'FFFFFF')
	setTextAlignment('UnknownTimer', 'center')
	setObjectCamera('UnknownTimer', 'other')
	screenCenter('UnknownTimer', 'xy')
	addLuaText('UnknownTimer')

	lastStep = curStep
	runTimer('UnknownTimes', crochet / 1000, timeLimit)
end

function makeLetter(letter)
	local id = 'UknownLetter' .. letterCount

	makeAnimatedLuaSprite(id, 'Mechanics/Unown_Alphabet', 0, 0)
	addAnimationByPrefix(id, 'idle', letter, 24, true)
	playAnim(id, 'idle', true)
	setObjectCamera(id, 'other')

	local realScale = math.max(0.2, 1 - (0.05 * #actualWord))
	scaleObject(id, realScale, realScale)

	screenCenter(id, 'y')
	setProperty(id .. '.y', getProperty(id .. '.y') - 100)

	if letter == ' ' then
		setProperty(id .. '.visible', false)
	else
		local line = 'UknownLine' .. letterCount

		makeLuaSprite(line, 'Mechanics/line', 0, 0)
		setObjectCamera(line, 'other')
		scaleObject(line, realScale, realScale)

		local lineWidth = getProperty(id .. '.width')
		local lineHeight = getProperty(line .. '.height') * realScale

		setGraphicSize(line, lineWidth, lineHeight)
		screenCenter(line, 'xy')
		setProperty(line .. '.y', getProperty(line .. '.y') + 200)

		addLuaSprite(line, true)

		wordObjects[#wordObjects + 1] = {
			letter = id,
			line = line
		}
	end

	addLuaSprite(id, true)

	if letter == ' ' then
		wordObjects[#wordObjects + 1] = {
			letter = id,
			line = nil
		}
	end

	letterCount = letterCount + 1
end

function positionWord()
	wordLength = 0

	for i, object in ipairs(wordObjects) do
		if luaSpriteExists(object.letter) then
			wordLength = wordLength + getProperty(object.letter .. '.width')

			if i < #wordObjects then
				wordLength = wordLength + offset
			end
		end
	end

	for i, object in ipairs(wordObjects) do
		if luaSpriteExists(object.letter) then
			local x = screenWidth / 2 - wordLength / 2

			if i > 1 then
				local previous = wordObjects[i - 1].letter
				x = getProperty(previous .. '.x') + getProperty(previous .. '.width') + offset
			end

			setProperty(object.letter .. '.x', x)

			if object.line and luaSpriteExists(object.line) then
				setProperty(object.line .. '.x', x)
			end
		end
	end
end

function onUpdate(elapsed)
	if not unknownsOpen then
		return
	end

	local letter = actualWord[actualLetter]

	if not letter then
		closeUknowns()
		return
	end

	if letter == ' ' then
		actualLetter = actualLetter + 1
		return
	end

	if keyboardJustPressed(letter) and letter ~= '?' and letter ~= '!' then
		correctLetter(actualLetter)
		return
	end

	if letter == '!' then
		if keyboardJustPressed('ONE') and keyboardPressed('SHIFT') then
			correctLetter(actualLetter)
			return
		end
	elseif letter == '?' then
		if (keyboardPressed('SLASH') or keyboardPressed('MINUS')) and keyboardPressed('SHIFT') then
			correctLetter(actualLetter)
			return
		end
	end

	if (botPlay or UnkownBotplay) and lastStep ~= curStep then
		correctLetter(actualLetter)
		lastStep = curStep
	end
end

function correctLetter(letter)
	local object = wordObjects[letter]

	if object and object.line and luaSpriteExists(object.line) then
		removeLuaSprite(object.line, true)
	end

	actualLetter = actualLetter + 1

	if actualLetter > #actualWord then
		closeUknowns()
	end
end

function closeUknowns()
	if not unknownsOpen then
		return
	end

	cancelTimer('UnknownTimes')

	removeLuaSprite('BackUknowns', true)
	removeLuaText('UnknownTimer', true)

	for _, object in ipairs(wordObjects) do
		if luaSpriteExists(object.letter) then
			removeLuaSprite(object.letter, true)
		end

		if object.line and luaSpriteExists(object.line) then
			removeLuaSprite(object.line, true)
		end
	end

	wordObjects = {}
	actualWord = {}
	actualLetter = 1
	wordLength = 0
	letterCount = 0
	unknownsOpen = false

	inputLock = true
	runTimer('UnknownInputLock', 0.1)
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'UnknownInputLock' then
		setProperty('canReset', wasReset)
		return
	end

	if tag ~= 'UnknownTimes' then
		return
	end

	if loopsLeft == 0 then
		closeUknowns()
		setHealth(-2)
	else
		setTextString('UnknownTimer', tostring(loopsLeft))
	end
end

function onPause()
	if unknownsOpen then
		return Function_Stop
	end
end