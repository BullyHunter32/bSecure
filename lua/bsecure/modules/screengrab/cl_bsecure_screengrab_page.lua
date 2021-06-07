local color_bg = Color(54, 54, 59)
local color_text_i = Color(160,160,160)
local color_grip = Color(70, 72, 74)

local PANEL = {}

function PANEL:Init()
    self.Player = false

    self.Content = self:Add("Panel")
    self.Content:Dock(FILL)
    self.Content:DockMargin(8, 8, 8, 8)

    self.Content.Preview = self.Content:Add("DPanel")
    self.Content.Preview:Dock(TOP)
    self.Content.Preview.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, color_bg)
        if self.Player and IsValid(self.Player) then
            local pnlX, pnlY = pnl:LocalToScreen()
            render.RenderView{
                origin = self.Player:GetShootPos(),
                angles = self.Player:EyeAngles(),
                aspectratio = 1.7777777778,
                x = pnlX,
                y = pnlY,
                w = w,
                h = h,
            }
        elseif self.Player then
            self.Player = false
        end
    end

    self.Content.Players = self.Content:Add("Panel")
    self.Content.Players:Dock(TOP)
    self.Content.Players.List = self.Content.Players:Add("DScrollPanel")
    self.Content.Players.List:Dock(FILL)
    for k,v in ipairs(player.GetAll()) do
        self:AddPlayer(v)
    end
    self.Content.Players.List.vBar = self.Content.Players.List:GetVBar()
    self.Content.Players.List.vBar:SetWide(8)
    self.Content.Players.List.vBar:SetHideButtons(true)
    self.Content.Players.List.vBar.btnGrip.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(w/3, 0, 0, w, h, color_grip, true, true, true, true)
    end
    self.Content.Players.List.vBar.Paint = nil

    self.Content.Snap = self.Content:Add("DButton")
    self.Content.Snap:SetFont("bSecure.Title")
    self.Content.Snap:SetText("Capture")
    self.Content.Snap:SizeToContentsX(16)
    self.Content.Snap:SizeToContentsY(8)
    self.Content.Snap:SetText("")
    self.Content.Snap.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, color_bg)
        draw.SimpleText("Capture", "bSecure.Title", w/2, h/2, pnl:IsHovered() and color_white or color_text_i, 1, 1)
    end
    self.Content.Snap.DoClick = function()
        if not LocalPlayer():IsAdmin() then return end
        bSecure.Screengrab.Snap(self.Player)
    end

    self.Content.PerformLayout = function(pnl, w, h)
        if not pnl.Preview then return end
        local _h = h
        pnl.Preview:SetTall((w-8) * (1080/1920))
        _h = _h - (w-8) * (1080/1920)

        self.Content.Players:SetTall(_h * 0.75)
        self.Content.Snap:SetPos(w/2 - self.Content.Snap:GetWide()/2, h*0.95 - self.Content.Snap:GetTall()/2)
    end
end 

local color_active = Color(72, 72, 82)
function PANEL:AddPlayer(pPlayer)
    btnCount = 0
    local ply = self.Content.Players.List:Add("DButton")
    ply:Dock(TOP)
    ply:DockMargin(0,2,0,2)
    ply:SetTall(50)
    ply:SetText("")
    ply.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, self.Player == pPlayer and color_active or color_bg, true, true, true, true)
    end
    ply.DoClick = function()
        if not IsValid(pPlayer) then print("Invalid Entity :(") return end
        self.Player = pPlayer
    end
    ply.Avatar = ply:Add("AvatarImage")
    ply.Avatar:Dock(LEFT)
    ply.Avatar:SetWide(50)
    ply.Avatar:SetPlayer(pPlayer, 50)
    ply.Name = ply:Add("DLabel")
    ply.Name:Dock(LEFT)
    ply.Name:DockMargin(6, 0, 0, 0)
    ply.Name:SetText(pPlayer:Nick())
    ply.Name:SetFont("bSecure.Title")
    ply.Name:SizeToContents()
    ply.Name:SetTextColor(color_white)

end 

vgui.Register("bSecure.Screengrab", PANEL)