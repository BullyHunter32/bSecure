local iCountries,iCountryCodes = bSecure.RegionRestrictions.iCountries,bSecure.RegionRestrictions.iCountryCodes

local PANEL = {}

function PANEL:Init()
    self.Changes = {}
    self.Contents = self:Add("Panel")
    self.Contents:Dock(FILL)
    self.Contents:DockMargin(8, 8, 8, 8)

    self.Searchbar = self.Contents:Add("bSecure.Searchbar")
    self.Searchbar:Dock(TOP)
    self.Searchbar:SetTall(38)
    self.Searchbar:SetPlaceholderText("Search for a Country by name")
    self.Searchbar.OnValueChange = function(pnl, val)
        self.CountryList:Clear()
        local construct = {}
        val = string.lower(val)
        for k,v in ipairs(iCountries) do
            if string.find(string.lower(v),val) then
                table.insert(construct,{v,iCountryCodes[k]})
            end
        end
        self:Construct(construct)
    end

    self.CountryList = self.Contents:Add("DScrollPanel")
    self.CountryList:Dock(FILL)
    self.CountryList:DockMargin(0,4,0,0)
    self.CountryList.vBar = self.CountryList:GetVBar()
    self.CountryList.vBar:SetWide(8)
    self.CountryList.vBar:SetHideButtons(true)
    self.CountryList.vBar.btnGrip.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(w/3,0,0,w,h,Color(70, 72, 74),true,true,true,true)
    end
    self.CountryList.vBar.Paint = nil

    self:Construct()
end

function PANEL:Construct(tData)
    if tData then
        for k,v in ipairs(tData) do
            self:AddCountry(v[1],v[2])
        end
        return
    end
    for k,v in ipairs(iCountries) do
        self:AddCountry(v, iCountryCodes[k])
    end
end

function PANEL:AddCountry(strCountry, strCountryCode)
    local country = self.CountryList:Add("DPanel")
    country:Dock(TOP)
    country:DockMargin(0,2,0,2)
    country:SetTall(50)
    country.mat = Material("flags16/"..string.lower(strCountryCode)..".png")
    country.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, Color(54, 54, 59), true, true, true, true)
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(pnl.mat)
        surface.DrawTexturedRect(12, 8, h-8, h-16)
        draw.SimpleText(strCountry .. "["..strCountryCode.."]", "bSecure.Title", w*0.1, h/2, color_white, 0, 1)
    end

    country.toggle = country:Add("bSecure.Checkbox")    
    country.toggle:SetState(bSecure.RegionRestrictions.DisallowedCountries[strCountryCode])
    country.toggle.OnToggled = function(pnl, state)
        self.Changes[strCountryCode] = {strCountryCode,state}
    end
    country.PerformLayout = function(pnl, w, h)
        pnl.toggle:SetSize(40, 40)
        pnl.toggle:SetPos(w - 40 - 8, h/2 - (40/2)  )
    end
end

function PANEL:OnRemove()
    if not LocalPlayer():IsSuperAdmin() then return end
    net.Start("bSecure.RegionRestrictions.Update")
    for k,v in pairs(self.Changes) do
        net.WriteString(v[1])
        net.WriteBool(v[2])
    end
    net.SendToServer()
end

vgui.Register("bSecure.RegionRestrictions", PANEL)
