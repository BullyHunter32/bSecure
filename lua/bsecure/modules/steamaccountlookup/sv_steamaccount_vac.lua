
bSecure.Steam = bSecure.Steam or {}

bSecure.Steam.VAC = {}
bSecure.Steam.VAC.ShouldKick = false
bSecure.Steam.VAC.VacBanThreshold = 1 -- if the player has this (or more) amount of vac bans then they get kicked
bSecure.Steam.VAC.GameBanThreshold = 1 -- if the player has this (or more) amount of game bans then they get kicked

function bSecure.Steam.VAC.FormatURL(SteamID)
    return ("http://api.steampowered.com/ISteamUser/GetPlayerBans/v1//?key=%s&steamids=%sformat=json"):format(bSecure.Steam.Config.APIKey, SteamID)
end

hook.Add("PlayerInitialSpawn", "bSecure.Steam.VAC", function(pPlayer)
    if pPlayer:IsBot() then return end
    http.Fetch(bSecure.Steam.VAC.FormatURL(pPlayer:SteamID64()), function(body)
        if !body then return end
        local tData = util.JSONToTable(body)
        if not tData or not tData.players then
            bSecure.PrintError("Failed to lookup ".. bSecure.FormatPlayer(pPlayer).."'s steam ban history.")
            return
        end
        tData = tData["players"][1]
        if tData.VACBanned then
            if bSecure.Steam.VAC.ShouldKick and tData.VACBanned and tData.NumberOfVACBans > bSecure.Steam.VAC.VacBanThreshold then
                bSecure.KickPlayer(pPlayer, "This server disallows people with "..bSecure.Steam.VAC.VacBanThreshold.." or more vac bans from playing.")
                return
            elseif bSecure.Steam.VAC.ShouldKick and tData.NumberOfGameBans > bSecure.Steam.VAC.GameBanThreshold then
                bSecure.KickPlayer(pPlayer, "This server disallows people with "..bSecure.Steam.VAC.GameBanThreshold.." or more game bans from playing.")
                return
            end
        end
    end)
end)
