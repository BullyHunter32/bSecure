local codes = {
    ["render.Capture"] = "102A",
    ["render.CapturePixels"] = "102B",
    ["util.Compress"] = "102C",
}

util.AddNetworkString("bSecure.DetouredScreengrabDetected")
net.Receive("bSecure.DetouredScreengrabDetected", function(_,pPlayer)
    bSecure.PrintDetection(pPlayer:Nick() .. " - " .. bSecure:GetPhrase("screengrab_detour_detected"))
    local what,src = net.ReadString(),net.ReadString()
    hook.Run("bSecure.DetectedDetouredScreengrab", pPlayer)
    bSecure.CreateDataLog{Player = pPlayer, Code = codes[what], Details = "Detected a detoured screengrabbing function "..what.."\n\n"..src}
    if bSecure.ACP.ScreengrabDetours.ShouldBan then
        bSecure.BanPlayer(pPlayer,"Detoured screengrab", 0)
    end
    if bSecure.ACP.ScreengrabDetours.ShouldAlert then
        bSecure.AlertAdmins(bSecure.FormatPlayer(pPlayer).. " is hacking. Detoured functions were detected.")
    end
end)