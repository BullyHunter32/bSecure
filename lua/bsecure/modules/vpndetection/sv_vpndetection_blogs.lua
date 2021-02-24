hook.Add("bLogs_FullyLoaded", "bSecure.VPNModule", function()
	bSecure.VPN.bLogs = bLogs:Module()

	bSecure.VPN.bLogs.Category = "bSecure"
	bSecure.VPN.bLogs.Name     = "VPN Detections"
	bSecure.VPN.bLogs.Colour   = Color(160,200,80)
	
	bLogs:AddModule(bSecure.VPN.bLogs)


    hook.Add("bSecure.OnVPNDetected", "bSecure.VPN.bLog", function(pPlayer, IP)
        if not pPlayer then return end
        bSecure.VPN.bLogs:Log( bLogs:FormatPlayer(pPlayer).." has connected with a VPN @ ".. IP )
    end)
end)
