bSecure.VPN.APIKey = "h2hfIXk9TYzQ8VG2gZm1ddDlzXeFEKqt"

function bSecure.FormatIP( IPAddress )
    return IPAddress:match("[%d.%d]+") or "error"
end

function bSecure.VPN.FormatURL( IPAddress )
    return ("https://ipqualityscore.com/api/json/ip/%s/%s"):format( bSecure.VPN.APIKey, IPAddress )
end

function bSecure.CheckVPN( Data )
    local IPAddress
    if is(pPlayer) then
        IPAddress = bSecure.FormatIP(Data:IPAddress())
    else
        IPAddress = bSecure.FormatIP(Datta)
    end
    http.Fetch(bSecure.VPN.FormatURL(IPAddress), function(body)
        local tData = util.JSONToTable( body )
        print( tData, body )
        if istable(tData) then PrintTable(tData) end
        if not tData.success then
            return print("Failed to lookup data. IP: ", IP , "\tError: ", tData.message)
        end
        if tData.vpn or tData.tor or tData.proxy or tData.active_vpn or tData.active_proxy then
            hook.Run("bSecure.OnVPNDetected", pPlayer, IPAddress)
            print("Detected a VPN. IP: ", IP)
            return
        end
    end)
end

function bSecure.CheckPlayerVPN( pPlayer )
    return bSecure.CheckVPN( pPlayer:IPAddress(), pPlayer )
end

hook.Add("PlayerInitialSpawn", "bSecure.CheckVPN", function( pPlayer )
    if game.SinglePlayer() or pPlayer:IsBot() or pPlayer:IPAddress() == "loopback" then return end
    local val = hook.Run("bSecure.ShouldCheckVPN", pPlayer)
    if val == nil or val == true then
        print("checking "..pPlayer:Nick() .. "["..pPlayer:SteamID().."] for a vpn")
        bSecure.CheckPlayerVPN(pPlayer)
    end
end)