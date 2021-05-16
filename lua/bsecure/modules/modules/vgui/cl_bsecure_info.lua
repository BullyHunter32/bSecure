local PANEL = {}
local mat = Material("bsecure/questionmark.png")

function PANEL:Init()
    self.hovered = false
    self.start = 0
end 

function PANEL:Paint(w, h)
    surface.SetMaterial(mat)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(8, 8, w-16, h-16)
end

function PANEL:OnCursorEntered()
    self.hovered = true
    self.starst = CurTime()
end

function PANEL:OnCursorExited()
    self.hovered = false
end

function PANEL:Think()
    if self.hovered and CurTime() - self.start > 2.2 then
        if not self.tooltip then
            self.tooltip = vgui.Create("DPanel")
            local x,y,w,h = self:GetPos(),self:GetSize()
            self.tooltip:SetPos(x+w,y)
            self.tooltip.poly = {}
            self.tooltip.PerformLayout = function(pnl, w, h)
                pnl.poly = {
                    {x = 0, y = h/2},
                    {x = x + 15, y = h/2 - 8},
                    {x = x + 15, y = h/2 + 8}
                }
            end
            self.tooltip.Paint = function(pnl, w, h)
                surface.SetDrawColor(54, 54, 58)
                surface.DrawPoly(pnl.poly)
                draw.RoundedBox(4, 0, 0, w, h, Color(54, 54, 58))
            end
        end
    elseif not self.hovered and self.tooltip then
        self.tooltip:Remove()
        self.tooltip = nil
    end
end

vgui.Register("bSecure.Info", PANEL)