local PANEL = {}

function PANEL:Init()

    self.Contents = self:Add("Panel")
    self.Contents:Dock(FILL)
    self.Contents:DockMargin(8, 8, 8, 8)

    self.Top = self.Contents:Add("DPanel")
    self.Top:Dock(TOP)
    self.Top:SetTall(38)
    self.Top.Paint = nil

    self.AddWhitelist = self.Top:Add("DButton")
    self.AddWhitelist:Dock(RIGHT)
    self.AddWhitelist:SetWide(38)
    self.AddWhitelist:SetText("")
    self.AddWhitelist.Paint = function(pnl, w, h)
        draw.RoundedBox(4, 0, 0, w, h, Color(54, 54, 59))
        surface.SetMaterial(Material("bsecure/cross.png"))
        surface.SetDrawColor(130, 130, 130)
        surface.DrawTexturedRectRotated(w*0.5, w*0.5, w*0.5, h*0.5, 45)
    end
    self.AddWhitelist.DoClick = function()
        Derma_StringRequest("Whitelist", "Add a user to the VPN whitelist", "", function(input)
            RunConsoleCommand("bsecure", "addvpnwhitelist", input)
            steamworks.RequestPlayerInfo(input, function(SteamName)
                self:AddPlayer(input,SteamName)
            end)
        end, function() end, "Whitelist", "Cancel")
    end

    self.Searchbar = self.Top:Add("bSecure.Searchbar")
    self.Searchbar:Dock(FILL)
    self.Searchbar:DockMargin(0,0,1,0)
    self.Searchbar:SetPlaceholderText("Search for a player by SteamID64")
    self.Searchbar.OnValueChange = function(pnl, val)
        self.PlayerList:Clear()
        for k,v in pairs(bSecure.VPN.Whitelist) do
            if string.find(val, k) then
                steamworks.RequestPlayerInfo(k, function(SteamName)
                    self:AddPlayer(k,SteamName)
                end)
            end
        end
    end

    self.PlayerList = self.Contents:Add("DScrollPanel")
    self.PlayerList:Dock(FILL)
    self.PlayerList:DockMargin(0,4,0,0)
    self.PlayerList.vBar = self.PlayerList:GetVBar()
    self.PlayerList.vBar:SetWide(8)
    self.PlayerList.vBar:SetHideButtons(true)
    self.PlayerList.vBar.btnGrip.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(w/3,0,0,w,h,Color(70, 72, 74),true,true,true,true)
    end
    self.PlayerList.vBar.Paint = nil

    for k,v in pairs(bSecure.VPN.Whitelist) do
        steamworks.RequestPlayerInfo(k, function(SteamName)
            self:AddPlayer(k,SteamName)
        end)
    end
end

local btnCount = 0
function PANEL:AddPlayer(SteamID64, SteamName)
    btnCount = 0
    local ply = self.PlayerList:Add("DPanel")
    ply:Dock(TOP)
    ply:DockMargin(0,2,0,2)
    ply:SetTall(50)
    ply.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, Color(54, 54, 59), true, true, true, true)
    end
    ply.Avatar = ply:Add("AvatarImage")
    ply.Avatar:Dock(LEFT)
    ply.Avatar:SetWide(50)
    ply.Avatar:SetSteamID(SteamID64, 50)
    ply.Name = ply:Add("DLabel")
    ply.Name:Dock(LEFT)
    ply.Name:DockMargin(6, 0, 0, 0)
    ply.Name:SetText(SteamName)
    ply.Name:SetFont("bSecure.Title")
    ply.Name:SizeToContents()
    ply.Name:SetTextColor(color_white)
    ply.Actions = {}
    
    ply.AddAction = function(strName, matIcon, fCallback)
        btnCount = btnCount + 1
        local btn = ply:Add("DButton")
        ply.Actions[btnCount] = btn
        btn:SetText("")
        btn:NoClipping(true)
        btn.startHover = 0
        btn.anim = false
        btn.delta = 0
        btn.OnCursorEntered = function(pnl)
            pnl.anim = true
        end
        btn.OnCursorExited = function(pnl)
            pnl.anim = false
        end
        btn.Think = function(pnl)
            if pnl.anim then
                pnl.delta = math.Clamp(pnl.delta + 4 * FrameTime(), 0, 1)
            else
                pnl.delta = math.Clamp(pnl.delta - 4 * FrameTime(), 0, 1)
            end
        end
        btn.Paint = function(pnl, w, h)
            draw.SimpleText(strName,"bSecure.Small",w/2,h/2,Color(255, 255, 255, pnl.delta*255),1,1)

            surface.SetDrawColor(255, 255, 255, 255-(pnl.delta*255))
            surface.SetMaterial(matIcon)
            surface.DrawTexturedRect(6, 6, w-12, h-12)
        end
        btn.DoClick = function()
            fCallback(ply)
        end
    end
    local copyData = 
    ([[
==================
Name: %s
SteamID64: %s  
Community URL: %s
==================
]]):format(
        SteamName,
        SteamID64,
        (SteamID64 and "https://steamcommunity.com/profiles/"..SteamID64.."/" or "NONE")
    )

    ply.AddAction("Remove Whitelist",Material("bsecure/hammer.png"), function() 
        if not LocalPlayer():IsSuperAdmin() then return end
        RunConsoleCommand("bsecure", "removevpnwhitelist", SteamID64)
        ply:Remove()
        bSecure.NotificationAdd("You have un-whitelisted ".. SteamName)
    end)

    ply.PerformLayout = function(pnl, w, h)
        local increment = (60)
        local initpos = w/2 - ((increment*btnCount)/2)
        for k,v in ipairs(ply.Actions) do
            v:SetPos(initpos+((k+1)*increment),h/2-25)
            v:SetSize(50,50)
        end
    end
end 

vgui.Register("bSecure.VPNDetection", PANEL, "EditablePanel")