surface.CreateFont("bSecure.Title",{
    font = "Roboto",
    size = 22
})

surface.CreateFont("bSecure.Small",{
    font = "Roboto",
    size = 18
})

surface.CreateFont("bSecure.ExtraSmallButSlightlyBigger",{
    font = "Roboto",
    size = 17,
})

surface.CreateFont("bSecure.ExtraSmall",{
    font = "Roboto",
    size = 15,
})

net.Receive("bSecure.OpenMenu", function()
    local frame = vgui.Create("bSecure.Frame")
    frame:SetSize(860,630)
    frame:Center()
    frame:MakePopup()
    
    local navbar = frame:Add("bSecure.NavBar")
    navbar:Dock(LEFT)
    navbar:SetWide(170)
    navbar:SetBody(frame)
    --navbar:AddPage("Dashboard", "DButton")
    navbar:AddPage("All Players", "bSecure.AllPlayers")
    navbar:AddPage("Ban Records", "bSecure.BanRecords")
    navbar:AddPage("Region Restriction", "bSecure.RegionRestrictions")
    navbar:AddPage("VPN Whitelist", "bSecure.VPNDetection")
    navbar:AddPage("Screengrab", "bSecure.Screengrab")
    navbar:AddPage("Logs", "bSecure.Logs")
    navbar:AddPage("Settings", "bSecure.Settings")
    navbar:SetActive("All Players")
end)
