sql.Query("CREATE TABLE IF NOT EXISTS bsecure_vpn_whitelist( steamid64 TEXT, admin_name TEXT, admin_steamid TEXT )")

function bSecure.VPN.RefreshWhitelists()
    local query = sql.Query("SELECT steamid64 FROM bsecure_vpn_whitelist") or {}
    local whitelists = {}

    for k, v in ipairs(query) do
        whitelists[v.steamid64] = true
    end

    bSecure.VPN.Whitelist = whitelists
end

bSecure.VPN.RefreshWhitelists()

hook.Add("bSecure.ShouldCheckVPN", "bSecure.Whitelist", function(pPlayer)
    if bSecure.VPN.Whitelist[pPlayer:SteamID64()] then return false end
end)

bSecure.VPN.AddWhitelist = function(SteamID, adminName, adminSteamID)
    if sql.Query(("SELECT * FROM bsecure_vpn_whitelist WHERE steamid64='%s'"):format(SteamID)) then
        bSecure.Print(SteamID .. " is already whitelisted!")
        return
    end

    sql.Query(("INSERT INTO bsecure_vpn_whitelist( steamid64, admin_name, admin_steamid ) VALUES( '%s', %s, '%s' )"):format(SteamID, sql.SQLStr(adminName), adminSteamID))
    bSecure.Print(adminName .. "[" .. adminSteamID .. "] has whitelisted " .. SteamID .. " to the vpn detector!")
    bSecure.VPN.Whitelist[SteamID] = true
    
    local tRecipients = bSecure.FetchAdmins(true)
    net.Start("bSecure.VPN.Whitelist")
    for k,v in pairs(bSecure.VPN.Whitelist) do
        net.WriteString(k)
    end
    net.Send(tRecipients)
end

bSecure.VPN.RemoveWhitelist = function(SteamID, adminName, adminSteamID)
    sql.Query(("DELETE FROM bsecure_vpn_whitelist WHERE steamid64='%s'"):format(SteamID))
    bSecure.Print(adminName .. "[" .. adminSteamID .. "] has removed " .. SteamID .. " from the vpn detector whitelist!")
    bSecure.VPN.Whitelist[SteamID] = nil

    local tRecipients = bSecure.FetchAdmins(true)
    net.Start("bSecure.VPN.Whitelist")
    for k,v in pairs(bSecure.VPN.Whitelist) do
        net.WriteString(k)
    end
    net.Send(tRecipients)
end

bSecure.ConCommandAdd("addvpnwhitelist", function(pPlayer, CMD, tArgs)
    local adminName,adminSteamID
    if not pPlayer == NULL then
        if not pPlayer:IsSuperAdmin() then return end
        if not tArgs[2] or tArgs[2]:match("%a") or string.sub(string.lower(tArgs[2]), 1, 5) == "steam" then
            bSecure.ChatPrint(pPlayer,"You must provide a SteamID64!")
            return
        end
        adminName = pPlayer.SteamName and pPlayer:SteamName() or pPlayer:Nick()
        adminSteamID = pPlayer:SteamID64()
    else
        if not tArgs[2] or tArgs[2]:match("%a") or string.sub(string.lower(tArgs[2]), 1, 5) == "steam" then
            bSecure.PrintError("You must provide a SteamID64!")
            return
        end
        adminName = "Console"
        adminSteamID = "Console"
    end
    bSecure.VPN.AddWhitelist(tArgs[2], adminName, adminSteamID)
end)

bSecure.ConCommandAdd("removevpnwhitelist", function(pPlayer, CMD, tArgs)
    if not pPlayer == NULL and not pPlayer:IsSuperAdmin() then return end

    if not tArgs[2] or tArgs[2]:match("%a") or string.sub(string.lower(tArgs[2]), 1, 5) == "steam" then
        if pPlayer ~= NULL then bSecure.ChatPrint(pPlayer,"You must provide a SteamID64!") return end
        if pPlayer == NULL then bSecure.PrintError("You must provide a SteamID64!") return end
    end

    bSecure.VPN.RemoveWhitelist(tArgs[2], pPlayer.SteamName and pPlayer:SteamName() or pPlayer:Nick(), pPlayer:SteamID64())
end)

util.AddNetworkString("bSecure.VPN.Whitelist")
hook.Add("PlayerInitialSpawn", "bSecure.SendWhitelist", function(pPlayer)
    if not pPlayer:IsSuperAdmin() then return end
    timer.Simple(2, function()
    net.Start("bSecure.VPN.Whitelist")
        for k,v in pairs(bSecure.VPN.Whitelist) do
            net.WriteString(k)
        end
        net.Send(pPlayer)
    end)
end)