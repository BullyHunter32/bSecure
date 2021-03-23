function bSecure.VPN.FormatURL(IPAddress)
    return ("https://ipqualityscore.com/api/json/ip/%s/%s"):format((bSecure.VPN.Config.APIKey == "" or not bSecure.VPN.Config.APIKey) and "error", IPAddress)
end

function bSecure.CheckVPN(Data)
    local IPAddress
    local pPlayer
    if bSecure.isPlayer(Data) then
        IPAddress = bSecure.FormatIP(Data:IPAddress())
        pPlayer = Data
    else
        IPAddress = bSecure.FormatIP(Data)
    end

    http.Fetch(bSecure.VPN.FormatURL(IPAddress), function(body)
        local tData = util.JSONToTable(body)
        if not tData.success then return bSecure.PrintError("Failed to lookup ", Data, "\n\t", tData.message) end

        if tData.vpn or tData.tor or tData.proxy or tData.active_vpn or tData.active_proxy then
            hook.Run("bSecure.OnVPNDetected", pPlayer, IPAddress)

            if bSecure.isPlayer(Data) then
                bSecure.PrintDetection(bSecure:GetPhrase("player_connected_vpn", {["player_name"] = bSecure.FormatPlayer(Data)}))

                if bSecure.VPN.Config.ShouldAlertAdmins then
                    bSecure.AlertAdmins(bSecure:GetPhrase("player_connected_vpn", {["player_name"] = bSecure.FormatPlayer(Data)}), bSecure.VPN.Config.AlertOnlySuperadmins)
                end

                if bSecure.VPN.Config.ShouldKick then
                    Data:Kick(bSecure.VPN.Config.KickReason)
                end
            else
                bSecure.PrintDetection(bSecure:GetPhrase("detected_ip_vpn", {["ip_address"] = IPAddress}))
            end

            return
        else
            if bSecure.isPlayer(Data) then
                bSecure.Print(bSecure:GetPhrase("player_connected_no_vpn", {["player_name"] = bSecure.FormatPlayer(Data)}))
            else
                bSecure.Print(bSecure:GetPhrase("player_connected_no_vpn", {["ip_address"] = bSecure.FormatPlayer(Data)}), bSecure.VPN.Config.AlertOnlySuperadmins)
            end
        end
    end)
end

function bSecure.CheckPlayerVPN(pPlayer)
    return bSecure.CheckVPN(pPlayer)
end

hook.Add("PlayerInitialSpawn", "bSecure.CheckVPN", function(pPlayer)
    if game.SinglePlayer() or pPlayer:IsBot() or pPlayer:IPAddress() == "loopback" or bSecure.VPN.Config.APIKey == "" then return end -- checks whether or not the game is P2P or singleplayer
    local val = hook.Run("bSecure.ShouldCheckVPN", pPlayer)

    if val == nil or val == true then -- checks whether or not a hook is returning false, otherwise it will run
        bSecure.Print("checking " .. pPlayer:Nick() .. "[" .. pPlayer:SteamID() .. "] for a vpn")
        bSecure.CheckPlayerVPN(pPlayer)
    end
end)
