-- Animated winning/losing/neutral icons script by FelixBand
-- Reworked: follows Change Character events, stays idle while its character
-- isn't on screen, and handles the same character on both sides.
--
-- Save as characters/<character name>.lua (same name as the character json).

--==================================================
-- SETTINGS
--==================================================

-- Frame numbers are 0-based tiles of the icon image (0 = first tile).
-- A frame number past the end of the icon is clamped to its last tile.

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
-- P1 (boyfriend side):
--   health < playerLosingHealth = losing
--   health > playerWinningHealth = winning
--
-- P2 (dad side):
--   health > opponentLosingHealth = losing
--   health < opponentWinningHealth = winning

local playerLosingHealth = 0.4
local playerWinningHealth = 1.6

local opponentLosingHealth = 1.6
local opponentWinningHealth = 0.4


--==================================================
-- INTERNAL
--==================================================

local animations = {
    neutral = {frames = neutralFrames, fps = neutralFPS},
    losing  = {frames = losingFrames,  fps = losingFPS},
    winning = {frames = winningFrames, fps = winningFPS},
}

-- Side 1 = boyfriend / iconP1, side 2 = dad / iconP2.
-- Each side keeps its own animation state, so one script instance can drive
-- both icons (same character on both sides) or just one.
local sides = {
    {character = 'boyfriend', icon = 'iconP1'},
    {character = 'dad',       icon = 'iconP2'},
}

for _, s in ipairs(sides) do
    s.frame = 0
    s.timer = 0
    s.index = 1
    s.anim = nil
    s.active = false
end

-- thisCharacter is scriptName without the folder path and extension.
-- mods/modname/characters/yourcharacter.lua -> "yourcharacter"
local thisCharacter = scriptName:match("[^/\\]+$"):gsub("%.lua$", "")


local function pickAnimation(side, health)
    if side == 1 then
        -- Player side: less health = losing
        if health < playerLosingHealth then
            return animations.losing
        elseif health > playerWinningHealth then
            return animations.winning
        end
    else
        -- Opponent side: more health = losing
        if health > opponentLosingHealth then
            return animations.losing
        elseif health < opponentWinningHealth then
            return animations.winning
        end
    end
    return animations.neutral
end


local function stepAnimation(s, anim, elapsed)
    local frames = anim.frames
    if #frames == 0 or anim.fps <= 0 then
        return
    end

    -- Switched to a different animation (or just became active): restart it
    if s.anim ~= frames then
        s.anim = frames
        s.index = 1
        s.timer = 0
        s.frame = frames[1]
    end

    s.timer = s.timer + elapsed
    local step = 1 / anim.fps

    -- while, not if: a long frame shouldn't make the animation fall behind
    while s.timer >= step do
        s.timer = s.timer - step
        s.index = s.index + 1
        if s.index > #frames then
            s.index = 1
        end
        s.frame = frames[s.index]
    end
end


-- The game resets the icon's frame every update, so it has to be re-applied
-- every frame, after the game's own update (onUpdatePost).
local function frameCode(n, iconName, frame)
    local i = tostring(n)
    local f = tostring(math.floor(frame))
    return 'var tiles' .. i .. ' = game.' .. iconName .. '.frames.frames;'
        .. 'game.' .. iconName .. '.frame = tiles' .. i
        .. '[' .. f .. ' < tiles' .. i .. '.length ? ' .. f
        .. ' : tiles' .. i .. '.length - 1];'
end


--==================================================
-- UPDATE
--==================================================

function onUpdatePost(elapsed)
    local health = getProperty('health')
    local code = ''

    for n, s in ipairs(sides) do
        -- Ask the game who is on this side right now. This is what makes
        -- Change Character work: the answer changes when the event fires.
        local onThisSide = getProperty(s.character .. '.curCharacter') == thisCharacter

        if onThisSide then
            if not s.active then
                -- Just arrived on this side (song start or Change Character)
                s.active = true
                s.anim = nil
            end

            stepAnimation(s, pickAnimation(n, health), elapsed)
            code = code .. frameCode(n, s.icon, s.frame)
        else
            -- Not our character: leave the icon alone so the game (or another
            -- character's script) controls it.
            s.active = false
        end
    end

    if code ~= '' then
        runHaxeCode(code)
    end
end