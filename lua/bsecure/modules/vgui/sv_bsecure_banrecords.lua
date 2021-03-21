function bSecure.GetRecentBans()
    local time = os.time() - 2419200 -- 2 weeks
    if ULib then
        return sql.Query("SELECT * FROM ulib_bans ORDER BY time DESC LIMIT 30") or {}
    end
    if serverguard then
        return sql.Query("SELECT steam_id,community_id,player,reason,start_time,admin FROM serverguard_bans ORDER BY start_time DESC LIMIT 30") or {}
    end
    return {}
end

util.AddNetworkString("bSecure.WriteBanData")
util.AddNetworkString("bSecure.RequestBanData")
net.Receive("bSecure.RequestBanData", function(_,pPlayer)
    if not pPlayer:IsAdmin() then return end
    local dat = bSecure.GetRecentBans()
    timer.Simple(0.1,function()
        net.Start("bSecure.WriteBanData")
        print("Writing...")
        net.WriteTable(dat)
    net.Send(pPlayer)
    end)
end)

hook.Add("")