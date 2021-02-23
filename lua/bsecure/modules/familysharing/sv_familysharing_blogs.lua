hook.Add("bLogs_FullyLoaded", "bSecure.FamilyShareModule", function()
	bSecure.FamilyShare.bLogs = bLogs:Module()

	bSecure.FamilyShare.bLogs.Category = "bSecure"
	bSecure.FamilyShare.bLogs.Name     = "FamilyShare Alts"
	bSecure.FamilyShare.bLogs.Colour   = Color(160,200,80)
	
	bLogs:AddModule(bSecure.FamilyShare.bLogs)


	hook.Add("bSecure.OnVPNDetected", "bSecure.FamilyShare.bLog", function(pPlayer, OwnerSteamID)
		bSecure.bLogs:Log( bLogs:FormatPlayer(pPlayer).." is an alt of banned user (".. OwnerSteamID .. ")" )
	end)
end)
