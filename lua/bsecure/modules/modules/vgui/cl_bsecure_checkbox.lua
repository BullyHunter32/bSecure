local PANEL = {}
AccessorFunc(PANEL, "m_state", "State", FORCE_BOOL)

function PANEL:Init()
	self:SetState(false)
	self:SetText("")
end

function PANEL:DoClick()
	self:SetState(not self:GetState())
	self:OnToggled(self:GetState())
end

function PANEL:OnToggled() end

local tick = Material("bsecure/tick.png")
function PANEL:Paint(w,h)
	surface.SetDrawColor(80, 80, 80, 80)
	surface.DrawOutlinedRect(0, 0, w, h)
	if self:GetState() then
		surface.SetDrawColor(70,130,170)
		surface.SetMaterial(tick)
	else
		surface.SetDrawColor(213, 50, 32, 0)
	end
	surface.DrawTexturedRect(8, 8, w-16, h-16)

end

vgui.Register("bSecure.Checkbox", PANEL, "DButton")