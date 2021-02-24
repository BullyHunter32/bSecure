local MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "Ban evasions"
MODULE.Colour = Color(100, 255, 255)

MODULE:Setup(function()
    MODULE:Hook("bSecure.FamilyShareAltDetected", "bLogs.Log", function(pPlayer, OwnerSteamID)
        MODULE:Log("{1} was detected using a family shared account of banned user ({2}).", GAS.Logging:FormatPlayer(pPlayer), OwnerSteamID)
    end)
end)

GAS.Logging:AddModule(MODULE)