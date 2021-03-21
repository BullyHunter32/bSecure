local net_Receive = net.Receive
local net_ReadString = net.ReadString

net_Receive("bSecure.VPN.Whitelist", function()
    if not LocalPlayer():IsSuperAdmin() then return end
    bSecure.VPN.Whitelist = {}
    
    local SteamID64 = net_ReadString()
    print("SteamID - ".. SteamID64)
    while SteamID64 ~= nil and SteamID64 ~= "" do
        bSecure.VPN.Whitelist[SteamID64] = true
        SteamID64 = net_ReadString()
    end
end)