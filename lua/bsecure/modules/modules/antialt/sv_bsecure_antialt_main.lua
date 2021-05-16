
util.AddNetworkString("bSecure.AltValidation")
hook.Add("PlayerInitialSpawn", "bSecure.AntiAlt", function(pPlayer)
    timer.Simple(2,function()
        net.Start("bSecure.AltValidation")
        net.Send(pPlayer)
    end)
end)

local function AltCheck(SteamID64, pPlayer)
    local serverguard_bans,ulib_bans
    if serverguard then
        serverguard_bans = sql.Query(("SELECT * FROM serverguard_bans WHERE community_id='%s'"):format(SteamID64))
    end
    if ULib then
        ulib_bans = sql.Query(("SELECT * FROM ulib_bans WHERE steamid='%s'"):format(SteamID64))
    end
    if serverguard_bans and serverguard_bans[1] then
        return bSecure.BanPlayer(pPlayer,"Bypassing a ban via an alt: ".. serverguard_bans[1].reason, 0)
    end
    if ulib_bans and ulib_bans[1] then
        return bSecure.BanPlayer(pPlayer,"Bypassing a ban via an alt: ".. ulib_bans[1].reason, 0)
    end
end

local received = {}
net.Receive("bSecure.AltValidation", function(_,pPlayer)
    received[pPlayer] = {}
    local sid = net.ReadString()
    local i = 0
    while sid ~= "" do
        i = i + 1
        received[pPlayer][i] = sid
        sid = net.ReadString()
    end
    for k,v in ipairs(received[pPlayer]) do
        AltCheck(v)
    end
end)