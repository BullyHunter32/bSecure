function bSecure.Steam.FormatURL(SteamID)
    return ("http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=%s&steamids=%s"):format(bSecure.Steam.Config.APIKey, SteamID)
end

bSecure.Steam.CachedData = {}

function bSecure.Steam.ValidateSteamID(SteamID64)
    if not SteamID64 then return false end

    return string.sub(SteamID64, 1, 4) == "7656"
end

function bSecure.Steam.DownloadData(Data)
    if Data == nil then return end
    local SteamID = Data

    if bSecure.isPlayer(Data) then
        SteamID = Data:SteamID64()
    end

    if not bSecure.Steam.ValidateSteamID(SteamID) then
        bSecure.PrintError("Failed to validate steamid: ", SteamID)

        return
    end

    if bSecure.Steam.CachedData[SteamID] then return bSecure.Steam.CachedData[SteamID] end

    http.Fetch(bSecure.Steam.FormatURL(SteamID), function(body)
        local tData = util.JSONToTable(body)
        tData = tData and tData["response"] and tData["response"]["players"] and tData["response"]["players"][1]

        if not tData then
            bSecure.PrintError("Failed to fetch steam data for ", Data, ". Is the API key valid?")

            return
        end

        bSecure.Print("Successfully returned and cached Steam data for ", Data)
        bSecure.Steam.CachedData[SteamID] = tData
    end)
end

function bSecure.Steam.GetPlayerData(SteamID, Select)
    if not bSecure.Steam.CachedData[SteamID] then return end
    if not Select then return bSecure.Steam.CachedData[SteamID] end

    return bSecure.Steam.CachedData[SteamID][string.lower(Select)]
end

local function nextSid64(SteamID64)
    if not bSecure.Steam.ValidateSteamID(SteamID64) then return end
    local num, newsid = tonumber(string.sub(SteamID64, #SteamID64 - 1)), string.sub(SteamID64, 1, #SteamID64 - 2)
    num = num + 1
    newsid = newsid .. num

    return newsid
end

local function prevSid64(SteamID64)
    if not bSecure.Steam.ValidateSteamID(SteamID64) then return end
    local num, newsid = tonumber(string.sub(SteamID64, #SteamID64 - 1)), string.sub(SteamID64, 1, #SteamID64 - 2)
    num = num - 1
    newsid = newsid .. num

    return newsid
end

local function estimateTimeCreation(SteamID64)
    local next = bSecure.Steam.GetPlayerData(nextSid64(SteamID64), "timecreated")
    local prev = bSecure.Steam.GetPlayerData(prevSid64(SteamID64), "timecreated")

    if next and not prev then
        return next
    elseif not next and prev then
        return prev
    end

    print(next, prev, "pp")

    return (next + prev) / 2
end

-- shouldBroadcast is false by default, allows for rcon using n what not without admins getting spammed
function bSecure.Steam.ScanData(tData, shouldBroadcast)
    print("SCANNING DATA ", tData)

    if istable(tData) then
        PrintTable(tData)
    end

    if not tData then return end

    if not tData.timecreated and bSecure.Steam.Config["EstimateCreationTime"] then
        bSecure.Steam.CachedData[tData.steamid]["timecreated"] = estimateTimeCreation(tData.steamid)
        tData.timecreated = bSecure.Steam.CachedData[tData.steamid]["timecreated"]
    end

    if tData.profilestate == 0 then
        bSecure.PrintDetection(tData.personaname .. " has not set up their community profile.")

        if bSecure.Steam.Config["AlertAdminsUnSetup"] and shouldBroadcast then
            bSecure.BroadcastAdminChat(tData.personaname .. " has not set up their community profile.")
        end
    end

    if not tData.timecreated then return end
    local age = (os.time() - tData.timecreated)

    if age < 604800 then
        local strAge = bSecure.TimeSince(tData.timecreated)
        bSecure.PrintDetection(tData.personaname .. "'s account is younger than a week. (" .. strAge .. " old)")

        if bSecure.Steam.Config["AlertAdminsYoung"] and shouldBroadcast then
            bSecure.BroadcastAdminChat(tData.personaname .. "'s account is younger than a week. (" .. strAge .. " old)")
        end

        hook.Run("bSecure.YoungAccountDetected", tData, tData.personaname, strAge, tData.timecreated)
    end
end

local function PlayerInitialSpawn(pPlayer)
    if bSecure.Steam.Config.APIKey == "" then return end
    local SID64 = pPlayer:SteamID64()
    local cachedData = bSecure.Steam.DownloadData(SID64)

    if not cachedData then
        -- Api delay
        timer.Simple(8, function()
            if not bSecure.Steam.GetPlayerData(SID64, "timecreated") and bSecure.Steam.Config["EstimateCreationTime"] and not bSecure.Steam.GetPlayerData(prevSid64(SID64)) then
                bSecure.Steam.DownloadData(nextSid64(SID64))
                bSecure.Steam.DownloadData(prevSid64(SID64))
            end
        end)

        -- Api delay
        timer.Simple(16, function()
            cachedData = bSecure.Steam.CachedData[SID64]
            bSecure.Steam.ScanData(cachedData, true)
        end)
    else
        bSecure.Steam.ScanData(cachedData, true)
    end
end

hook.Add("PlayerInitialSpawn", "bSecure.DownloadData", PlayerInitialSpawn)