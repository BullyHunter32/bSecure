local PANEL = {}
local color_bg = Color(65, 65, 69)
local color_toggle = Color(70,130,170)
AccessorFunc(PANEL, "b_ToggleState", "State", FORCE_BOOL)
function PANEL:Init()
    self:SetText("")
    self:NoClipping(true)
    self:SetState(false)
    self.anim = false
    self.ratio = 0
    self.start = 0
end

function PANEL:Toggle()
    local newValue = not self:GetState()
    self:SetState(newValue)
    self:OnToggled(newValue)
    self.anim = true
    self.start = CurTime()
end

function PANEL:Think()
    local iEnd = 1-(self:GetTall()/self:GetWide())
    if self:GetState() and self.ratio ~= iEnd then -- Just so it's not calling functions that essentially do nothiing 
        self.ratio = Lerp((CurTime()-self.start)/0.4, (self.ratio or 0), iEnd)
    elseif not self:GetState() and self.ratio ~= 0 then 
        self.ratio = Lerp((CurTime()-self.start)/0.4, (self.ratio or 0), 0)
    end
end

function PANEL:DoClick()
    self:Toggle()
end

function PANEL:Paint(w, h)
    draw.RoundedBox(h/3, 0, h*0.25, w, h/2, color_bg)
    local bounds = w*0.1
    local size = h
    draw.RoundedBox(size,self.ratio * w, 0, size, size, color_toggle)
    draw.SimpleText(self:GetState(),"DermaDefault",w*1.5,h*0.5,color_white,1,1)
end

function PANEL:OnToggled(bState) end

vgui.Register("bSecure.Toggle", PANEL, "DButton")