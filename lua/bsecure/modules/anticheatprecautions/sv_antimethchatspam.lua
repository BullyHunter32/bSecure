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

hook.Add("PlayerSay", "bSecure.CheckMethamphetaminePhrase", function(pPlayer, strText)
    if flaggedStrings[strText] then
        -- If people get banned after doing it once, there will 100% be trolling
        pPlayer.iFlaggedMessages = pPlayer.iFlaggedMessages

        if pPlayer.iFlaggedMessages >= 4 then
            bSecure.PrintDetection(("Detected malicious message by %s[%s]: \"%s\""):format(
                pPlayer.SteamName and pPlayer:SteamName() or pPlayer:Nick(),
                pPlayer:SteamID64(),
                strText
            ))
            bSecure.BanPlayer(pPlayer, "Malicious message detected", 0)
        end
       
        pPlayer.iFlaggedMessages = pPlayer.iFlaggedMessages + 1
        hook.Run("bSecure.MaliciousChatSent", pPlayer, strText)
        return ""
    end
end)
