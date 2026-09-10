words = {
    "IM DEAD",
    "EERIE NOISE",
    "LEAVE HURRY",
    "HE DIED",
    "DYING",
    "PERISH SONG",
    "GOLD",
    "SILVER",
    "DONT BELONG",
    "ABANDONED",
    "BOO!",
    "UNOWN",
    "NOT WANTED",
    "TIRESOME",
    "USELESS",
    "GRUESOME",
    "NIGHTMARE",
    "GET OUT",
    "HOPELESS",
    "RUN",
    "NOT WELCOME",
    "CAN YOU SEE?",
    "WHERE?",
    "HELP",
    "RELIVE",
    "XXXXX",
    "GOODBYE",
    "CELEBI DIED",
    "IT FAILED",
    "AGONY",
    "I SEE YOU"
}

l = 0;
totalwidth = 0;
prevWidth = 0;

--[[
function onEvent(name, value1, value2)
    if name == 'Unown' then
        randomword = getRandomInt(1, 31);
        debugPrint('daWord = ' .. words[randomword]);
        for i = 1, #words[randomword] do
            l = l + 1;
            makeAnimatedLuaSprite('letter' .. l, 'UI/base/Unown_Alphabet', 0, 250);
            debugPrint(string.sub(words[randomword], i, i));
            addAnimationByPrefix('letter' .. l, 'idle', string.sub(words[randomword], i, i), 24, true);
            setObjectCamera('letter' .. l, 'hud');
            scaleObject('letter' .. l, 0.6, 0.6);
            screenCenter('letter' .. l);
            totalwidth = totalwidth + getProperty('letter' .. l .. '.width') + 10;
            setProperty('letter' .. l .. '.x', totalwidth);
            addLuaSprite('letter' .. l, true);
        end
    end
end
--]]