function onCreatePost()
    if getProperty('playerStrums.length') == 5 then -- if 5 key
        setPropertyFromGroup('playerStrums', 2, 'useRGBShader', false)


        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if getPropertyFromGroup('unspawnNotes', i, 'mustPress')
                and getPropertyFromGroup('unspawnNotes', i, 'noteData') == 7 then

                setPropertyFromGroup('unspawnNotes', i, 'rgbShader.enabled', false)
            end
        end
    end
end