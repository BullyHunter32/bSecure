
function bSecure.Steam.FormatURL( SteamID )
    return ("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s"):format(bSecure.Steam.Config.APIKey, SteamID)
end

bSecure.Steam.CachedData = {}

function bSecure.Steam.ValidateSteamID( SteamID64 )
    if not SteamID64 then return false end
    return string.sub(SteamID64,1,4) == "7656"
end

function bSecure.Steam.DownloadData( Data ) 
    if Data == nil then return end
    local SteamID = Data
    if bSecure.isPlayer( Data ) then
        SteamID = Data:SteamID64()
    end
    if not bSecure.Steam.ValidateSteamID( SteamID ) then
        bSecure.PrintError("Failed to validate steamid: ", SteamID)
        return
    end
    if bSecure.Steam.CachedData[SteamID] then
        return bSecure.Steam.CachedData[SteamID]
    end 
    http.Fetch(bSecure.Steam.FormatURL(SteamID), function(body)
        local tData = util.JSONToTable(body)
        tData = tData and tData["response"] and tData["response"]["players"] and tData["response"]["players"][1]
        if not tData then
            bSecure.PrintError("Failed to fetch steam data for ", Data,". Is the API key valid?")
            return
        end
        bSecure.Print("Successfully returned and cached Steam data for ", Data )
        bSecure.Steam.CachedData[SteamID] = tData
    end)
end

function bSecure.Steam.GetPlayerData( SteamID, Select )
    if not bSecure.Steam.CachedData[SteamID] then return end
    if not Select then return bSecure.Steam.CachedData[SteamID] end
    return bSecure.Steam.CachedData[SteamID][string.lower(Select)]
end


function bSecure.Steam.ScanData( tData, shouldBroadcast ) -- shouldBroadcast is false by default, allows for rcon using n what not without admins getting spammed
    if not tData then return end
    if tData.profilestate == 0 then
        bSecure.PrintDetection(tData.personaname.." has not set up their community profile.")
        if bSecure.Steam.Config["AlertAdminsUnSetup"] and shouldBroadcast then
            bSecure.BroadcastAdminChat(tData.personaname.." has not set up their community profile.")
        end
    end
    if tData.communityvisibilitystate == 1 then
        return -- no further useful info can be used because their profile is private.
    end
    local age = (os.time() - tData.timecreated)
    if age < 604800 then
        bSecure.PrintDetection(tData.personaname.. "'s account is younger than a week. (" ..bSecure.TimeSince(tData.timecreated) .. " old)" )
        if bSecure.Steam.Config["AlertAdminsYoung"] and shouldBroadcast then
            bSecure.BroadcastAdminChat(tData.personaname.. "'s account is younger than a week. (" ..bSecure.TimeSince(tData.timecreated) .. " old)")
        end
    end 
end

hook.Add("PlayerInitialSpawn", "bSecure.DownloadData", function(pPlayer)
    if bSecure.Steam.Config.APIKey == "" then return end
    local cachedData = bSecure.Steam.DownloadData( pPlayer:SteamID64() )
    if not cachedData then
        timer.Simple(7,function()
            cachedData = bSecure.Steam.CachedData[pPlayer:SteamID64()]
            bSecure.Steam.ScanData( cachedData, true )
        end)
    else
        bSecure.Steam.ScanData( cachedData, true )
    end
end)