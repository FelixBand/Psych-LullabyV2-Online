function onCreate()
    setProperty('camHUD.alpha', 0.0001)
    setProperty('skipCountdown', true)
end

function onCreatePost()
    removeLuaScript('scripts/camFollow')
end

local xx2 = 1310
local yy2 = 680
local ofs = 20
local followchars = true

function onUpdate()
    if followchars then -- camfollow script
        if getProperty('boyfriend.animation.curAnim.name') == 'singLEFT' then
            triggerEvent('Camera Follow Pos',xx2-ofs,yy2)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singRIGHT' then
            triggerEvent('Camera Follow Pos',xx2+ofs,yy2)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singUP' then
            triggerEvent('Camera Follow Pos',xx2,yy2-ofs)
        elseif getProperty('boyfriend.animation.curAnim.name') == 'singDOWN' then
            triggerEvent('Camera Follow Pos',xx2,yy2+ofs)
	    else
            triggerEvent('Camera Follow Pos',xx2,yy2)
        end
    end
end

-- local cutscened = false
-- function onEndSong()
--     if not cutscened and isStoryMode then
-- 		doTweenAlpha('hudout', 'camHUD', 0, 1, 'linear')
--         playSound('death', 1)
--         cutscened = true
--         return Function_Stop
--     end
-- return Function_Continue
-- end