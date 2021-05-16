local bFlaggedWords, iFlaggedWords = bSecure.ArrayToList({ -- dont use punctuation, only letters
    "nigger",
	"nigga",
    "kike",
    "coon",
})

local translations = {
    {"0", "o"},
    {"1", "i"},
    {"5", "s"},
    {"3", "e"},
    {"4", "a"},
    {"8", "b"},
    {"9", "g"},
}

local translationsLength = #translations
local function scanMessage(strText)
    if bFlaggedWords[strText] then return strText,1 end
    if (bSecure.MaliciousChat.Config.StrictnessLevel or 2) < 2 then return false end
    local resultText = strText:gsub(" ", ""):gsub("%p", "")
	print(resultText)
    for i = 1, translationsLength do
        resultText = resultText:gsub(translations[i][1], translations[i][2])
    end
    if bFlaggedWords[resultText] then return resultText, 2 end
    for k,v in ipairs(iFlaggedWords) do
        if string.find(v, resultText) then
            return resultText,2
        end 
    end
    return false
end

hook.Add("PlayerSay", "bSecure.MaliciousChatFilter", function(pPlayer, strText)
    local scannedMsg, iCode = scanMessage(strText)
    if not scannedMsg then return end
    local code = iCode == 1 and "107A" or iCode == 2 and "107B" or "Unknown Code"
    if bSecure.MaliciousChat.Config.ShouldDataLog then
        bSecure.CreateDataLog{Player = pPlayer, Code = code, Details = "Detected a flagged word.\nOriginal message: \""..strText.."\"\nInterpereted as: \""..scannedMsg.."\""}
    end
    if bSecure.MaliciousChat.Config.ShouldBan then
        bSecure.BanPlayer(pPlayer, bSecure.MaliciousChat.Config.PunishmentReason:format(code), 0)
    elseif bSecure.MaliciousChat.Config.ShouldKick then
        bSecure.KickPlayer(pPlayer, bSecure.MaliciousChat.Config.PunishmentReason:format(code), 0)
    end
end)