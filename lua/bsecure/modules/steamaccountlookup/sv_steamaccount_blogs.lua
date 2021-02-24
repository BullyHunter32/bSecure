hook.Add("bLogs_FullyLoaded", "bSecure.SteamModule", function()
	bSecure.VPN.bLogs = bLogs:Module()

	bSecure.VPN.bLogs.Category = "bSecure"
	bSecure.VPN.bLogs.Name     = "Recently made accounts"
	bSecure.VPN.bLogs.Colour   = Color(160,200,80)
	
	bLogs:AddModule(bSecure.VPN.bLogs)

    hook.Add("bSecure.YoungAccountDetected", "bSecure.Steam.bLog", function(SteamID64, Name, strAge)
        local pPlayer = player.GetBySteamID64(SteamID64)
        bSecure.VPN.bLogs:Log(bLogs:FormatPlayer(pPlayer).." has connected with a recently created account. "..strAge.." old." )
    end)

	bSecure.VPN.bLogs = bLogs:Module()

	bSecure.VPN.bLogs.Category = "bSecure"
	bSecure.VPN.bLogs.Name     = "Unsetup accounts"
	bSecure.VPN.bLogs.Colour   = Color(160,200,80)
	
	bLogs:AddModule(bSecure.VPN.bLogs)

    hook.Add("bSecure.YoungAccountDetected", "bSecure.Steam.bLog", function(SteamID64, Name, strAge)
        local pPlayer = player.GetBySteamID64(SteamID64)
        bSecure.VPN.bLogs:Log(bLogs:FormatPlayer(pPlayer).." has connected with an unsetup community profile.")
    end)

end)