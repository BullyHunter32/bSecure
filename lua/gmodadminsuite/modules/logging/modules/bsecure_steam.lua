local MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "Recently made accounts"
MODULE.Colour = Color(100, 255, 255)

MODULE:Setup(function()
    MODULE:Hook("bSecure.YoungAccountDetected", "bLogs.Log", function(SteamID64, Name, strAge, iTimeCreatted)
        MODULE:Log("{1} has connected with a recently made account. {2} old.", GAS.Logging:FormatPlayer(SteamID64), strAge)
    end)
end)

GAS.Logging:AddModule(MODULE)
local MODULE = GAS.Logging:MODULE()
MODULE.Category = "bSecure"
MODULE.Name = "Unsetup accounts"
MODULE.Colour = Color(100, 255, 255)

MODULE:Setup(function()
    MODULE:Hook("bSecure.UnsetupAccountDetected", "bLogs.Log", function(SteamID64)
        MODULE:Log("{1} has connected with an unsetup community profile.", GAS.Logging:FormatPlayer(SteamID64))
    end)
end)

GAS.Logging:AddModule(MODULE)