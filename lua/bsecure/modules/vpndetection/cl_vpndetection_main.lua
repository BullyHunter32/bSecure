local net_Receive = function(a, b)
    print("Incoming net message - \""..a.."\"\tsrc - ".. debug.getinfo(2).source )
    return net.Receive(a,b)
end
local net_ReadString = function()
    local string = net.ReadString()
    print("Reading string - \""..string.."\"\tsrc - ".. debug.getinfo(2).source )
    return string
end

net_Receive("bSecure.VPN.Whitelist", function()
    if not LocalPlayer():IsSuperAdmin() then return end
    bSecure.VPN.Whitelist = {}

    local SteamID64 = net_ReadString()
    --print("SteamID - ".. SteamID64)
    local i = 1
    while SteamID64 ~= nil and SteamID64 ~= "" do
        i = i + 1
        bSecure.VPN.Whitelist[SteamID64] = true
        --bSecure.Print("Whitelisted: \""..SteamID64.."\"")
        SteamID64 = net_ReadString()
    end
    bSecure.Print("Whitelisted ".. i .. " SteamID's")
    for k,v in pairs(bSecure.VPN.Whitelist) do
        bSecure.Print("\t".. k)
    end
end)