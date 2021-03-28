
util.AddNetworkString("bSecure.SkidConfessionBooth")
net.Receive("bSecure.SkidConfessionBooth", function(_,pPlayer)
    local src = net.ReadString()
    bSecure.PrintDetection(bSecure:GetPhrase("skid_detection", {["player_name"] = bSecure.FormatPlayer(pPlayer),["sources"] = src}))
    hook.Run("bSecure.SkidDetected", pPlayer, src)
end)

util.AddNetworkString("bSecure.SkidCheck")
hook.Add("PlayerInitialSpawn", "bSecure.SkidCheck", function(pPlayer)
    net.Start("bSecure.SkidCheck")
    net.Send(pPlayer)
end)