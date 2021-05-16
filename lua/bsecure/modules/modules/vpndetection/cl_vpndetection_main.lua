local net_ReadUInt = net.ReadUInt
local net_Receive = net.Receive
local net_ReadString = net.ReadString

net_Receive("bSecure.VPN.Whitelist", function()
    if not LocalPlayer():IsSuperAdmin() then return end
    bSecure.VPN.Whitelist = {}

    local iLen, iCount = net_ReadUInt(8),0
    for i = 1, iLen do
        iCount = iCount + 1
        bSecure.VPN.Whitelist[net_ReadString()] = true
    end
    bSecure.Print("Whitelisted ".. iCount .. " SteamID's")
    for k,v in pairs(bSecure.VPN.Whitelist) do
        bSecure.Print("\t".. k)
    end
end)