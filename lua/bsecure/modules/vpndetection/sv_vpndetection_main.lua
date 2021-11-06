local urls = {
    {"https://ipqualityscore.com/api/json/ip/%s/%s", "Key", "IP"},
    {"https://proxycheck.io/v2/%s?vpn=1&asn=1", "IP"},
	{"http://check.getipintel.net/check.php?ip=%s&contact=%s","IP","Email"}
}
function bSecure.VPN.FormatURL(IPAddress)
    local tUrl = urls[bSecure.VPN.Config["PreferredService"]] or urls[2]
    local url = tUrl[1]
    for i = 2, #tUrl do
        local f = tUrl[i]
        if f == "Key" then
            url = url:format(bSecure.VPN.Config.APIKey, "%s", "%s", "%s")
        elseif f == "IP" then
            url = url:format(IPAddress, "%s", "%s", "%s")
        elseif f == "Email" then
            url = url:format(bSecure.VPN.Config.Email, "%s", "%s", "%s")
        end
    end

    return url
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
        if bSecure.VPN.Config["PreferredService"] == 1 then  -- IP QUALITY SCORE
            if not tData.success then return bSecure.PrintError("Failed to lookup ", Data, "\n\t", tData.message) end

            if tData.vpn or tData.tor or tData.proxy or tData.active_vpn or tData.active_proxy then
                hook.Run("bSecure.OnVPNDetected", pPlayer, IPAddress)
                bSecure.CreateDataLog{Player = pPlayer, Code = "104A", Details = "The suspect has connected with a VPN at ".. IPAddress.. ". More information can be found here, ".. bSecure.VPN.FormatURL(IPAddress)}
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
                    bSecure.Print(bSecure:GetPhrase("ip_no_vpn", {["ip_address"] = IPAddress}))
                end
            end
            -- IP QUALITY SCORE
        elseif bSecure.VPN.Config["PreferredService"] == 2 then -- proxycheck
            if tData.status ~= "ok" then
                return bSecure.PrintError("Failed to lookup ", Data..(tData.message and (" [".. tData.message .. "]["..Data.."]") or ""))
            end

            if tData[IPAddress] == nil then
                for k,v in pairs(tData) do
                    if k ~= "status" then
                        tData = v
                        break
                    end
                end
            else
                tData = tData[IPAddress]
            end

            if tData.proxy == "yes" then
                hook.Run("bSecure.OnVPNDetected", pPlayer, IPAddress)
                bSecure.CreateDataLog{Player = pPlayer, Code = "104A", Details = "The suspect has connected with a VPN at ".. IPAddress.. ". More information can be found here, ".. bSecure.VPN.FormatURL(IPAddress)}
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
                    bSecure.Print(bSecure:GetPhrase("ip_no_vpn", {["ip_address"] = IPAddress}))
                end
            end
        elseif bSecure.VPN.Config["PreferredService"] == 3 then -- getIPIntel, Free plan does NOT support HTTPS protocol without a valid EMAIL!
            if body == "1" then -- site only returns a 1/0 non JSON value for vpn checking.
                hook.Run("bSecure.OnVPNDetected", pPlayer, IPAddress)
                bSecure.CreateDataLog{Player = pPlayer, Code = "104A", Details = "The suspect has connected with a VPN at ".. IPAddress.. ". More information can be found here, ".. bSecure.VPN.FormatURL(IPAddress)}
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
            else
                if bSecure.isPlayer(Data) then
                    bSecure.Print(bSecure:GetPhrase("player_connected_no_vpn", {["player_name"] = bSecure.FormatPlayer(Data)}))
                else
                    bSecure.Print(bSecure:GetPhrase("ip_no_vpn", {["ip_address"] = IPAddress}))
                end
            end
		end
    end)
end

function bSecure.CheckPlayerVPN(pPlayer)
    return bSecure.CheckVPN(pPlayer)
end

hook.Add("PlayerInitialSpawn", "bSecure.CheckVPN", function(pPlayer)
    if game.SinglePlayer() or pPlayer:IsBot() or pPlayer:IPAddress() == "loopback" then return end -- checks whether or not the game is P2P or singleplayer
    local val = hook.Run("bSecure.ShouldCheckVPN", pPlayer)

    if val == nil or val == true then -- checks whether or not a hook is returning false, otherwise it will run
        bSecure.Print("checking " .. pPlayer:Nick() .. "[" .. pPlayer:SteamID() .. "] for a vpn")
        bSecure.CheckPlayerVPN(pPlayer)
    end
end)
