local PANEL = {} 

function PANEL:Init()
    self:SetFont("bSecure.Title")
end

local color_bg = Color(54, 54, 59)
local color_text = Color(200, 200, 200)
local color_highlight = Color(130, 130, 130)
local color_cursor = Color(160, 160, 160)

function PANEL:Paint(w, h)
    draw.RoundedBoxEx(4, 0, 0, w, h, color_bg, true, true, true, true)
    if not self:GetValue() or #self:GetValue() == 0 and self:GetPlaceholderText() and not self:IsEditing() then
        draw.SimpleText(self:GetPlaceholderText(), "bSecure.Title", 5, h/2, color_highlight, 0, 1)
        return
    end 
    self:DrawTextEntryText(color_text, color_highlight, color_cursor)
end
vgui.Register("bSecure.Searchbar", PANEL, "DTextEntry")