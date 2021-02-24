hook.Add("PlayerInitialSpawn", "bSecure.CheckFamilyShare", function(pPlayer)
    if pPlayer:IsBot() then return end
    local serverguard_bans, ulib_bans
    local OwnerSteamID = pPlayer:OwnerSteamID64()
    if OwnerSteamID == pPlayer:SteamID64() then return end

    if serverguard then
        serverguard_bans = sql.Query(("SELECT * FROM serverguard_bans WHERE community_id='%s' OR ip_address = '%s'"):format(OwnerSteamID, bSecure.FormatIP(pPlayer:IPAddress())))
    end

    if ULib then
        ulib_bans = sql.Query(("SELECT * FROM ulib_bans WHERE steamid='%s'"):format(OwnerSteamID))
    end

    if ulib_bans and ulib_bans[1] then
        hook.Run("bSecure.FamilyShareAltDetected", pPlayer, OwnerSteamID)
        ULib.Ban(pPlayer, 0, "Bypassing a ban via an alt: " .. ulib_bans[1].reason)

    elseif serverguard_bans and serverguard_bans[1] then
        hook.Run("bSecure.FamilyShareAltDetected", pPlayer, OwnerSteamID)
        serverguard:BanPlayer(nil, pPlayer, 0, "Bypassing a ban via an alt: " .. serverguard_bans[1].reason, true, false)
        
    end
end)