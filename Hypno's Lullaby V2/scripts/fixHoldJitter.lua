-- Restores the 0.14.8 hold-note animation behaviour on Psych Online 0.14.9.
-- Put in  scripts/  (global).
--
-- 0.14.9 added Character.sustainTimer: after every sustain piece is hit, the character forces animation frame 0
-- on every update for ~1.25 steps. Flixel doesn't reset the animation's internal timer when the frame is forced,
-- so the animation keeps "ticking" to frame 1 and gets yanked back to 0, which looks like a much faster jitter
-- than the once-per-step retrigger of 0.14.8. This clears the timer right after the engine sets it, so
-- hold pieces behave like in 0.14.8 again (animation restarted once per piece, idle handled by holdTimer).

local supported = false
local aliasCache = {}

-- 0.14.9 can't resolve multiplayer tags like "characters[<sid>]" any more: register the character under a plain name
local function resolveTag(tag)
    local sid = type(tag) == 'string' and tag:match('^characters%[(.+)%]$')
    if not sid then return tag end
    if aliasCache[sid] then return aliasCache[sid] end
    if not sid:match('^[%w_%-]+$') then return tag end

    local alias = '__hf_char_' .. sid
    runHaxeCode("game.variables.set('" .. alias .. "', game.characters.get('" .. sid .. "'));")
    local ok = type(getProperty(alias .. '.curCharacter')) == 'string'
    aliasCache[sid] = ok and alias or tag
    return aliasCache[sid]
end

local function release(id, charTag)
    if not supported then return end
    charTag = resolveTag(charTag)
    local okGf, isGf = pcall(getPropertyFromGroup, 'notes', id, 'gfNote')
    if okGf and isGf then charTag = 'gf' end   -- the engine animates gf for "GF Sing" notes
    setProperty(charTag .. '.sustainTimer', 0)
end

function onCreatePost()
    -- 0.14.8 and older have no sustainTimer: nothing to fix there
    supported = type(getProperty('boyfriend.sustainTimer')) == 'number'
end

-- both callbacks run AFTER the engine has set sustainTimer for that hit
function opponentNoteHit(id, dir, noteType, isSus, charTag)
    if isSus then release(id, charTag or 'dad') end
end

function goodNoteHit(id, dir, noteType, isSus, charTag)
    if isSus then release(id, charTag or 'boyfriend') end
end

function onEvent(name)
    if name == 'Change Character' then aliasCache = {} end   -- new Character objects: re-register on next hit
end
