local MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "VPN Detections"
MODULE.Colour = Color(100, 255, 255)

MODULE:Setup(function()
    MODULE:Hook("bSecure.OnVPNDetected", "bLogs.Log", function(pPlayer, sIPAddress)
        MODULE:Log("{1} was detected using a vpn.", GAS.Logging:FormatPlayer(pPlayer))
    end)
end)

GAS.Logging:AddModule(MODULE)