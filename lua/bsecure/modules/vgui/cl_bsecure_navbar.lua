
local PANEL = {}
AccessorFunc(PANEL, "m_accent", "Accent")

local color_accent = Color(70, 130, 170)
local color_text_i = Color(160,160,160)
local color_bg = Color(43, 43, 46)
function PANEL:Init()
    self:SetAccent(color_accent)
    self.Pages = {}
end

function PANEL:AddPage(strName, pPanel)
    self.Pages[strName] = self:Add("DButton")
    local btn = self.Pages[strName]
    btn:Dock(TOP)
    btn:SetText("")
    btn:SetTall(40) 
    btn:DockMargin(1,0,1,0)
    btn.Paint = function(pnl, w, h)
        if pnl.isActive then
            surface.SetDrawColor(self:GetAccent())
            surface.DrawRect(0, 0, w, h)
        end
        draw.SimpleText(strName, "bSecure.Title", 10, h/2, pnl.isActive and color_white or color_text_i, 0, 1)
    end
    btn.DoClick = function(pnl)
        self:SetActive(strName)
    end
    
    btn.Panel = self.Body:Add(pPanel or "Panel")
    btn.Panel:Dock(FILL)
    btn.Panel:SetVisible(false)
end

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(4, 0, 0, w, h, color_bg, false, false, true, false)
end

function PANEL:SetActive(strName)
    if IsValid(self.Pages.Active) then
        self.Pages.Active.isActive = false
        self.Pages.Active.Panel:SetVisible(false)
    end
    self.Pages.Active = self.Pages[strName]
    self.Pages[strName].isActive = true
    self.Pages[strName].Panel:SetVisible(true)
end 

function PANEL:SetBody(pBody)
    self.Body = pBody:Add("EditablePanel")
    self.Body:Dock(FILL)
    return self.Body
end

vgui.Register("bSecure.NavBar", PANEL)