local flaggedStrings = bSecure.ArrayToList({
    "your ac owned - methamphetamine.solutions",
    "god, you're sad - methamphetamine.solutions",
    "should have bought meth - methamphetamine.solutions",
    "now rewritten! - methamphetamine.solutions",
    "should have used a condom - methamphetamine.solutions",
    "addicting the innocent since 2018 - methamphetamine.solutions",
    "#1 garry's mod cheat - methamphetamine.solutions",
    "your cheat will never compare - methamphetamine.solutions",
    "godlike glua loader! - methamphetamine.solutions",
    "superior auto wall - methamphetamine.solutions",
    "meth solutions is the best cheat money can buy\" - laxol - methamphetamine.solution", -- wolfie fucked up on this one 
})

local config = {} or bSecure.ACP.AntiMethChatSpam
local strictnessLevel = config.StrictnessLevel
local shouldBan = config.ShouldBan

local tIntTranslation = {
    {"0","o"},
    {"1","i"},
    {"3","e"},
    {"4","a"},
    {"5","s"}
}

hook.Add("PlayerSay", "bSecure.CheckMethamphetaminePhrase", function(pPlayer, strText)
    if strictnessLevel == 1 then
        if flaggedStrings[strText] then
            bSecure.PrintDetection(("Detected malicious message by %s[%s]: \"%s\""):format(
                pPlayer.SteamName and pPlayer:SteamName() or pPlayer:Nick(),
                pPlayer:SteamID64(),
                strText
            ))
            hook.Run("bSecure.MaliciousChatSent", pPlayer, strText)
            if config.ShouldBan then
                Secure.BanPlayer(pPlayer, "Malicious message detected", 0)
            end
            return ""
        end
        return
    end

    -- level 2 strictness level --
    if flaggedStrings[strText] then
        bSecure.PrintDetection("Detected malicious text sent by ".. bSecure.FormatPlayer(pPlayer) .. ": ".. strText)
        return ""
    end
    local iWebStart = string.find(strText,"- methamphetamine.solutions")
    if !iWebStart then return end
    local strNewText = string.sub(strText,1,iWebStart-1)
    local strSubText = strNewText
    for k,v in ipairs(tIntTranslation) do
        strSubText = strSubText:gsub(v[1],v[2])
    end
    local strFull = strSubText .. " - methamphetamine.solutions"
    if flaggedStrings[strFull] then
        bSecure.PrintDetection("Detected suspicious text ", strText , " -> ", strFull)
        return ""
    end
end)