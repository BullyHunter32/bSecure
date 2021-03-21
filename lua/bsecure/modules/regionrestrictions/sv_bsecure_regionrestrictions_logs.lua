hook.Add("bLogs_FullyLoaded", "bSecure.FamilyShareModule", function()
	bSecure.FamilyShare.bLogs = bLogs:Module()

	bSecure.FamilyShare.bLogs.Category = "bSecure"
	bSecure.FamilyShare.bLogs.Name     = "Region Restictions"
	bSecure.FamilyShare.bLogs.Colour   = Color(40,90,140)
	
	bLogs:AddModule(bSecure.FamilyShare.bLogs)


	hook.Add("bSecure.FamilyShareAltDetected", "bSecure.FamilyShare.bLog", function(pPlayer, OwnerSteamID)
		bSecure.FamilyShare.bLogs:Log( bLogs:FormatPlayer(pPlayer).." is an alt of banned user (".. OwnerSteamID .. ")" )
	end)
end)

local FamilyShare = bSecure.Logs.CreateModule("FamilyShare Alts")
FamilyShare:Hook("bSecure.FamilyShareAltDetected", "bSecure.Logs", function(pPlayer, OwnerSteamID)
	self:Log("%s is an alt of banned user (%s)", bSecure.FormatPlayer(pPlayer), OwnerSteamID)
end)
