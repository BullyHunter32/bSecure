local MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "VPN Detections"
MODULE.Colour = Color(100, 255, 255)

MODULE:Setup(function()
    MODULE:Hook("bSecure.OnVPNDetected", "bLogs.Log", function(pPlayer, sIPAddress)
        MODULE:Log("{1} was detected using a vpn @ {2}", GAS.Logging:FormatPlayer(pPlayer), sIPAddress)
    end)
end)

GAS.Logging:AddModule(MODULE)
MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "FamilyShare Alts"
MODULE.Colour = Color(140, 255, 33)

MODULE:Setup(function()
    MODULE:Hook("bSecure.FamilyShareAltDetected", "bLogs.Log", function(pPlayer, OwnerSteamID)
        MODULE:Log("{1} was caught bypassing a ban via familyshare. Owner - {2} ", GAS.Logging:FormatPlayer(pPlayer), OwnerSteamID)
    end)
end)

GAS.Logging:AddModule(MODULE)
MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "Suspicious Keys"
MODULE.Colour = Color(140, 60, 133)

MODULE:Setup(function()
    MODULE:Hook("bSecure.SuspiciousKeyPressed", "bLogs.Log", function(pPlayer, sKey, sBind)
        MODULE:Log("{1} pressed {2} which is bound to \"{3}\"", GAS.Logging:FormatPlayer(pPlayer), sKey, sBind)
    end)
end)

GAS.Logging:AddModule(MODULE)
MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "Restricted Country"
MODULE.Colour = Color(140, 60, 33)

MODULE:Setup(function()
    MODULE:Hook("bSecure.RestrictedRegionDetected", "bLogs.Log", function(pPlayer, sCountry)
        MODULE:Log("{1} attempted to connect from {2}", GAS.Logging:FormatPlayer(pPlayer), sCountry)
    end)
end)

GAS.Logging:AddModule(MODULE)
MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "Lua Hacks"
MODULE.Colour = Color(250, 33, 33)

MODULE:Setup(function()
    MODULE:Hook("bSecure.DetectedDetouredScreengrab", "bLogs.Log", function(pPlayer)
        MODULE:Log("{1} was caught detouring screengrab functions", GAS.Logging:FormatPlayer(pPlayer))
    end)
end)

GAS.Logging:AddModule(MODULE)
MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "New Steam Accounts"
MODULE.Colour = Color(60, 133, 233)

MODULE:Setup(function()
    MODULE:Hook("bSecure.YoungAccountDetected", "bLogs.Log", function(pPlayer, sKey, sBind)
        MODULE:Log("{1} has connected with a new account. ", GAS.Logging:FormatPlayer(pPlayer), sKey, sBind)
    end)
end)

GAS.Logging:AddModule(MODULE)
MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "Unsetup Steam Accounts"
MODULE.Colour = Color(80, 143, 33)

MODULE:Setup(function()
    MODULE:Hook("bSecure.UnsetupAccountDetected", "bLogs.Log", function(pPlayer)
        MODULE:Log("{1} has connected with an unsetup community account. ", GAS.Logging:FormatPlayer(pPlayer))
    end)
end)

GAS.Logging:AddModule(MODULE)
MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "Bans"
MODULE.Colour = Color(255, 0, 0)

MODULE:Setup(function()
    MODULE:Hook("bSecure.PostPlayerBan", "bLogs.Log", function(pPlayer, strReason, iDuration)
        MODULE:Log("{1} has been banned for \"{2}\" {3}", bSecure.FormatPlayer(pPlayer), strReason, (iDuration == 0 and "permanently") or ("for " .. iDuration .. " seconds"))
    end)
end)

GAS.Logging:AddModule(MODULE)