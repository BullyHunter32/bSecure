util.AddNetworkString("bSecure.DetouredScreengrabDetected")
net.Receive("bSecure.DetouredScreengrabDetected", function(_,pPlayer)
    bSecure.PrintDetection(pPlayer:Nick() .. " - " .. bSecure:GetPhrase("screengrab_detour_detected"))
    hook.Run("bSecure.DetectedDetouredScreengrab", pPlayer)
    if bSecure.ACP.ScreengrabDetours.ShouldBan then
        bSecure.BanPlayer(pPlayer,"Detoured screengrab", 0)
    end
    if bSecure.ACP.ScreengrabDetours.ShouldAlert then
        bSecure.AlertAdmins(bSecure.FormatPlayer(pPlayer).. " is hacking. Detoured functions were detected.")
    end
end)