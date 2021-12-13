local FamilyShare = bSecure.Logs.CreateModule("FamilyShare Alts")
hook.Add("bSecure.FamilyShareAltDetected", "bSecure.Logs", function(pPlayer, OwnerSteamID)
	FamilyShare:Log("%s is an alt of banned user (%s)", bSecure.FormatPlayer(pPlayer), OwnerSteamID)
end)
