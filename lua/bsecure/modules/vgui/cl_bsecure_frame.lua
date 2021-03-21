local PANEL = {}

local mat_close = Material("bsecure/cross.png")
local color_header = Color(60, 60, 63)
function PANEL:Init()
    self.Header = self:Add("DPanel")
    self.Header:Dock(TOP)
    self.Header:SetTall(30)
    self.Header.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, color_header, true, true)
    end
    self.Header.Title = self.Header:Add("DLabel")
    self.Header.Title:Dock(LEFT)
    self.Header.Title:SetText("bSecure")
    self.Header.Title:SetFont("bSecure.Title")
    self.Header.Title:SetTextColor(color_white)
    self.Header.Title:DockMargin(10, 0, 0, 0)
    self.Header.Title:SizeToContents()

    self.Header.Close = self.Header:Add("DButton")
    self.Header.Close:Dock(RIGHT)
    self.Header.Close:SetWide(30)
    self.Header.Close:SetText("")
    self.Header.Close.DoClick = function() self:Remove() end
    self.Header.Close.Paint = function(pnl, w, h)
        surface.SetMaterial(mat_close)
        surface.SetDrawColor(180,180,180)
        surface.DrawTexturedRect(4, 4, w-8, h-8)
    end
end

local bg = Color(47, 47, 52)
function PANEL:Paint(w, h)
    draw.RoundedBox(4, 0, 0, w, h, bg, true, true)
end

vgui.Register("bSecure.Frame", PANEL, "EditablePanel")