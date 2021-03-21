local suspiciousKeys = bSecure.SuspiciousKeys

local binds = {}
util.AddNetworkString("bSecure.SuspiciousKeyLogger")
net.Receive("bSecure.SuspiciousKeyLogger", function(_,ply)
    binds[ply] = binds[ply] or {}
    for key,_ in pairs(suspiciousKeys) do
        binds[ply][key] = net.ReadString()
    end
end)

hook.Add("PlayerButtonDown", "bSecure.SuspiciousKeyLogger", function(pPlayer, iKey)
    if suspiciousKeys[iKey] then
        bSecure.PrintDetection(pPlayer:Nick().."["..pPlayer:SteamID64().."] has pressed a suspicious key. "..suspiciousKeys[iKey].." Bound to: ".. binds[pPlayer][iKey] ) 
        hook.Run("bSecure.SuspiciousKeyPressed", suspiciousKeys[iKey], binds[pPlayer][iKey])
    end
end)

