flippedHealth = false

function onCreate()
    setPropertyFromClass('PauseSubState', 'songName', 'LullabyPause')
end

function doFlipStage(flipHealth, flipScore)
    if flipHealth == nil then flipHealth = true end
    if flipScore == nil then flipScore = true end
    
    if flipHealth then
        flippedHealth = true
        setProperty('healthBar.flipX', true)
    end

    if flipScore then
        -- flip the online multiplayer score texts
        runHaxeCode([[
            for (t in game.scoreTxtOthers) {
                if (t.offset.x < 0) {
                    // was the left text: move it to the right edge
                    t.alignment = 'right';
                    t.offset.x = 30;
                } else {
                    // was the right text: move it to the left edge
                    t.alignment = 'left';
                    t.offset.x = -30;
                }
            }
        ]])
    end
end

function onUpdatePost()
    if flippedHealth then
        flipSide('iconP1s', true)
        flipSide('iconP2s', false)
    end
end

function flipSide(arrayName, isPlayer)
    local count = getProperty(arrayName .. '.length')
    for i = 0, count - 1 do
        local icon = arrayName .. '[' .. i .. ']'
        local scaleX = getProperty(icon .. '.scale.x')
        local barX = getProperty('healthBar.x')
            + getProperty('healthBar.width') * getProperty('healthBar.percent') * 0.01
        -- small extra spread per icon so stacked ones don't sit on top of each other
        local spread = i * 40

        if isPlayer then
            setProperty(icon .. '.x', barX + (150 * scaleX - 150) / 2 - 26 - 110 - spread)
            setProperty(icon .. '.origin.x', 240)
        else
            setProperty(icon .. '.x', barX - (150 * scaleX) / 2 - 26 * 2 + 110 + spread)
            setProperty(icon .. '.origin.x', -100)
        end
        setProperty(icon .. '.flipX', true)
    end
end