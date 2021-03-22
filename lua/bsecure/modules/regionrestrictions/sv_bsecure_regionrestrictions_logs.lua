local FamilyShare = bSecure.Logs.CreateModule("FamilyShare Alts")
FamilyShare:Hook("bSecure.FamilyShareAltDetected", "bSecure.Logs", function(pPlayer, OwnerSteamID)
	self:Log("%s is an alt of banned user (%s)", bSecure.FormatPlayer(pPlayer), OwnerSteamID)
end)
