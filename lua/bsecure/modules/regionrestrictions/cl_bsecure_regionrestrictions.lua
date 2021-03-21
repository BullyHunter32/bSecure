local net_Start = net.Start
local net_Receive = net.Receive
local net_WriteString = net.WriteString
local net_SendToServer = net.SendToServer
local getCountry = system.GetCountry

net_Receive("bSecure.RegionRestrictions.RequestCountry", function()
    net_Start("bSecure.RegionRestrictions.ReceiveCountry")
    net_WriteString(getCountry())
    net_SendToServer()
end)

net_Receive("bSecure.RegionRestrictions.UpdateClient", function()
    local countrycode = net.ReadString()
    while countrycode ~= "" do
        bSecure.RegionRestrictions.DisallowedCountries[countrycode] = net.ReadBool()
        countrycode = net.ReadString()
    end
end)