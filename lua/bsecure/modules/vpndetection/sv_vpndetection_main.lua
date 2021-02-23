
function bSecure.VPN.FormatURL( IPAddress )
    return ("https://ipqualityscore.com/api/json/ip/%s/%s"):format( bSecure.VPN.Config.APIKey or "error", IPAddress )
end


function bSecure.CheckVPN( Data )
    local IPAddress
    if bSecure.isPlayer(Data) then
        IPAddress = bSecure.FormatIP(Data:IPAddress())
    else
        IPAddress = bSecure.FormatIP(Data)
    end
    http.Fetch(bSecure.VPN.FormatURL(IPAddress), function(body)
        local tData = util.JSONToTable( body )
        if not tData.success then
            return bSecure.PrintError("Failed to lookup ", Data, "\n\t", tData.message)
        end
        if tData.vpn or tData.tor or tData.proxy or tData.active_vpn or tData.active_proxy then
            hook.Run("bSecure.OnVPNDetected", pPlayer, IPAddress)
            if bSecure.isPlayer(Data) then
                bSecure.PrintDetection(Data:Nick() .. "["..Data:SteamID().."] has connected with a vpn!")
                if bSecure.VPN.Config.ShouldAlertAdmins then
                    bSecure.BroadcastAdminChat(Data:Nick() .. "["..Data:SteamID().."] has connected with a vpn.", bSecure.VPN.Config.AlertOnlySuperadmins)
                end
                if bSecure.VPN.Config.ShouldKick then
                    Data:Kick( bSecure.VPN.Config.KickReason )
                end
            else
                bSecure.PrintDetection(IPAddress," is a vpn.")
            end
            return
        else
            if bSecure.isPlayer(Data) then
                bSecure.Print(Data:Nick() .. "["..Data:SteamID().."] is not using a VPN.", bSecure.VPN.Config.AlertOnlySuperadmins)
            else
                bSecure.BroadcastAdminChat(Data.. " is not a vpn.")
            end
        end
    end)
end

function bSecure.CheckPlayerVPN( pPlayer )
    return bSecure.CheckVPN( pPlayer:IPAddress() )
end

hook.Add("PlayerInitialSpawn", "bSecure.CheckVPN", function( pPlayer )
    if game.SinglePlayer() or pPlayer:IsBot() or pPlayer:IPAddress() == "loopback" then return end
    local val = hook.Run("bSecure.ShouldCheckVPN", pPlayer)
    if val == nil or val == true then
        bSecure.Print("checking "..pPlayer:Nick() .. "["..pPlayer:SteamID().."] for a vpn")
        bSecure.CheckPlayerVPN(pPlayer)
    end
end)