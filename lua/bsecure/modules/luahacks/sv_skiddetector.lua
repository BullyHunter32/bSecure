
util.AddNetworkString("bSecure.SkidConfessionBooth")
net.Receive("bSecure.SkidConfessionBooth", function(_,pPlayer)
    local src = net.ReadString()
    bSecure.CreateDataLog{Player = pPlayer, Code = "105A", Details = "The suspect has many potentially harmful lua files within garrysmod/lua. Sources: ".. src}
    hook.Run("bSecure.SkidDetected", pPlayer, src)
end)

util.AddNetworkString("bSecure.SkidCheck")
hook.Add("PlayerInitialSpawn", "bSecure.SkidCheck", function(pPlayer)
    net.Start("bSecure.SkidCheck")
    net.Send(pPlayer)
end)