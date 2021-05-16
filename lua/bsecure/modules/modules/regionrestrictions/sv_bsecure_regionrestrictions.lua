if file.Exists("bsecure/disallowed_countries.json", "DATA") then
    local JSON = file.Read("bsecure/disallowed_countries.json")
    bSecure.RegionRestrictions.DisallowedCountries = util.JSONToTable(JSON)
end

util.AddNetworkString("bSecure.RegionRestrictions.RequestCountry")
util.AddNetworkString("bSecure.RegionRestrictions.ReceiveCountry")
net.Receive("bSecure.RegionRestrictions.ReceiveCountry", function(_, pPlayer)
    local strRegion = net.ReadString()
    local country = bSecure.RegionRestrictions.Countries[strRegion]
    if bSecure.RegionRestrictions.DisallowedCountries[strRegion] then
        bSecure.PrintDetection(bSecure.FormatPlayer(pPlayer).. " has connected within a disallowed country [".. strRegion .. "][" .. country .. "]")
        hook.Run("bSecure.RestrictedRegionDetected", pPlayer, country)
        pPlayer:Kick("You have connected within a disallowed country. - ".. country)
    end
end)

hook.Add("PlayerInitialSpawn", "bSecure.RegionRestrictoins", function(pPlayer)
    net.Start("bSecure.RegionRestrictions.RequestCountry")
    net.Send(pPlayer)
end)

util.AddNetworkString("bSecure.RegionRestrictions.UpdateClient")
local function UpdateClient(pClient)
    net.Start("bSecure.RegionRestrictions.UpdateClient")
    for k,v in pairs(bSecure.RegionRestrictions.DisallowedCountries) do
        net.WriteString(k) 
        net.WriteBool(v) 
    end
    net.Send(pClient)
end

util.AddNetworkString("bSecure.RegionRestrictions.Update")
net.Receive("bSecure.RegionRestrictions.Update", function(_,pPlayer)
    if not pPlayer:IsSuperAdmin() then return end
    local countryID = net.ReadString()
    while countryID ~= "" do
        bSecure.RegionRestrictions.DisallowedCountries[countryID] = net.ReadBool()
        countryID = net.ReadString()
    end
    file.Write("bsecure/disallowed_countries.json", util.TableToJSON(bSecure.RegionRestrictions.DisallowedCountries))
    UpdateClient(bSecure.FetchAdmins(true))
end)