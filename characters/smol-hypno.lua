-- Animated winning/losing/neutral icons script by FelixBand
--==================================================
-- SETTINGS
--==================================================

-- Neutral animation
local neutralFrames = {0}
local neutralFPS = 12

-- Losing animation
local losingFrames = {1, 2, 3, 4}
local losingFPS = 12

-- Winning animation
local winningFrames = {0}
local winningFPS = 12


-- Health thresholds
-- P1:
--   health < playerLosingHealth = losing
--   health > playerWinningHealth = winning
--
-- P2:
--   health > opponentLosingHealth = losing
--   health < opponentWinningHealth = winning

local playerLosingHealth = 0.5
local playerWinningHealth = 1.5

local opponentLosingHealth = 1.5
local opponentWinningHealth = 0.5


--==================================================
-- INTERNAL VARIABLES
--==================================================

local iconFrame = 0
local iconTimer = 0
local animationIndex = 1
local currentAnimation = nil
local player = 0

-- Used only when both characters are the same
local iconFrameP1 = 0
local iconTimerP1 = 0
local animationIndexP1 = 1
local currentAnimationP1 = nil

local iconFrameP2 = 0
local iconTimerP2 = 0
local animationIndexP2 = 1
local currentAnimationP2 = nil

-- thisCharacter should be scriptName, except the folder path to it cut off.
-- So mods/modname/characters/yourcharacter.lua would be just "yourcharacter".
local thisCharacter = string.sub(scriptName, string.find(scriptName, "[^/\\]+$"))
thisCharacter = string.gsub(thisCharacter, "%.lua$", "")

local initialized = false

-- DETECT WHICH CHARACTER WE ARE
function onCreatePost()
    if boyfriendName == dadName then
        -- Same character on both sides
        player = 3

    elseif thisCharacter == boyfriendName then
        -- This character is the player
        player = 1

    elseif thisCharacter == dadName then
        -- This character is the opponent
        player = 2
    end

    debugPrint("LOADED " .. thisCharacter)

    initialized = true
end


--==================================================
-- APPLY ANIMATION - NORMAL
--==================================================

function setAnimation(frames, fps, elapsed)

    if #frames == 0 then
        return
    end

    if currentAnimation ~= frames then
        currentAnimation = frames
        animationIndex = 1
        iconTimer = 0
        iconFrame = frames[1]
    end

    iconTimer = iconTimer + elapsed

    if iconTimer >= 1 / fps then
        iconTimer = iconTimer - 1 / fps

        animationIndex = animationIndex + 1

        if animationIndex > #frames then
            animationIndex = 1
        end

        iconFrame = frames[animationIndex]
    end
end


--==================================================
-- APPLY ANIMATION - DUPLICATE CHARACTER
--==================================================

function setAnimationP1(frames, fps, elapsed)

    if #frames == 0 then
        return
    end

    if currentAnimationP1 ~= frames then
        currentAnimationP1 = frames
        animationIndexP1 = 1
        iconTimerP1 = 0
        iconFrameP1 = frames[1]
    end

    iconTimerP1 = iconTimerP1 + elapsed

    if iconTimerP1 >= 1 / fps then
        iconTimerP1 = iconTimerP1 - 1 / fps

        animationIndexP1 = animationIndexP1 + 1

        if animationIndexP1 > #frames then
            animationIndexP1 = 1
        end

        iconFrameP1 = frames[animationIndexP1]
    end
end


function setAnimationP2(frames, fps, elapsed)

    if #frames == 0 then
        return
    end

    if currentAnimationP2 ~= frames then
        currentAnimationP2 = frames
        animationIndexP2 = 1
        iconTimerP2 = 0
        iconFrameP2 = frames[1]
    end

    iconTimerP2 = iconTimerP2 + elapsed

    if iconTimerP2 >= 1 / fps then
        iconTimerP2 = iconTimerP2 - 1 / fps

        animationIndexP2 = animationIndexP2 + 1

        if animationIndexP2 > #frames then
            animationIndexP2 = 1
        end

        iconFrameP2 = frames[animationIndexP2]
    end
end


--==================================================
-- UPDATE
--==================================================

function onUpdatePost(elapsed)
    if not initialized then
        return
    end


    --==================================================
    -- IF BOTH SIDES USE THE SAME CHARACTER
    --==================================================

    if player == 3 then

        -- P1: less health = losing
        local p1Losing = getProperty('health') < playerLosingHealth
        local p1Winning = getProperty('health') > playerWinningHealth

        if p1Losing then
            setAnimationP1(losingFrames, losingFPS, elapsed)

        elseif p1Winning then
            setAnimationP1(winningFrames, winningFPS, elapsed)

        else
            setAnimationP1(neutralFrames, neutralFPS, elapsed)
        end


        -- P2: more health = losing
        local p2Losing = getProperty('health') > opponentLosingHealth
        local p2Winning = getProperty('health') < opponentWinningHealth

        if p2Losing then
            setAnimationP2(losingFrames, losingFPS, elapsed)

        elseif p2Winning then
            setAnimationP2(winningFrames, winningFPS, elapsed)

        else
            setAnimationP2(neutralFrames, neutralFPS, elapsed)
        end


        runHaxeCode([[
            game.iconP1.frame = game.iconP1.frames.frames[]] .. iconFrameP1 .. [[];
            game.iconP2.frame = game.iconP2.frames.frames[]] .. iconFrameP2 .. [[];
        ]])

        return
    end


    --==================================================
    -- NORMAL: CHARACTER IS ONLY ON ONE SIDE
    --==================================================

    local losing = false
    local winning = false

    if player == 1 then
        -- Player:
        -- less health = losing
        -- more health = winning

        losing = getProperty('health') < playerLosingHealth
        winning = getProperty('health') > playerWinningHealth

    elseif player == 2 then
        -- Opponent:
        -- more health = losing
        -- less health = winning

        losing = getProperty('health') > opponentLosingHealth
        winning = getProperty('health') < opponentWinningHealth
    end


    if losing then
        setAnimation(losingFrames, losingFPS, elapsed)

    elseif winning then
        setAnimation(winningFrames, winningFPS, elapsed)

    else
        setAnimation(neutralFrames, neutralFPS, elapsed)
    end


    runHaxeCode([[
        game.iconP]] .. player .. [[.frame = game.iconP]] .. player .. [[.frames.frames[]] .. iconFrame .. [[];
    ]])
end