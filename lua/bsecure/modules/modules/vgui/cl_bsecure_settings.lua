if not file.Exists("bsecure", "DATA") then
    file.CreateDir("bsecure")
end

bSecure.Config = {
    Stored = {}
}

function bSecure.Config.Add(ID, value)
    if bSecure.Config.Stored[ID] == nil then
        bSecure.Config.Stored[ID] = value
    end
end

function bSecure.Config.Set(ID, value)
    bSecure.Config.Stored[ID] = value
end

function bSecure.Config.Get(ID)
    return bSecure.Config.Stored[ID]
end

function bSecure.Config.Save()
    file.Write("bsecure/config.json",util.TableToJSON(bSecure.Config.Stored))
end

function bSecure.Config.Load()
    local strFileContents = file.Read("bsecure/config.json", "DATA")
    if !strFileContents or #strFileContents == 0 then return end
    local tData = util.JSONToTable(strFileContents)
    bSecure.Config.Stored = tData
end

bSecure.Config.Load()

local PANEL = {}

function PANEL:Init()
    self.Contents = self:Add("Panel")
    self.Contents:Dock(FILL)
    self.Contents:DockMargin(8, 8, 8, 8)

    self:AddOption("notify_popup","Enable Popup Alerts","Whether or not you should be alerted via a popup when a detection occurs.", true)
    self:AddOption("notify_chat","Enable Chat Alerts","Whether or not you should be alerted via chat when a detection occurs.", true)
end

function PANEL:AddOption(ID, strName, strDesc, bDefault)
    bSecure.Config.Add(ID,bDefault)

    local option = self.Contents:Add("Panel")
    option:Dock(TOP)
    option:SetTall(62)
    option:DockMargin(0,0,0,20)

    option.Title = option:Add("Panel")
    option.Title:Dock(TOP)
    option.Title:SetTall(20)
    option.Title.Text = option.Title:Add("DLabel")
    option.Title.Text:Dock(LEFT)
    option.Title.Text:SetTextColor(color_white)
    option.Title.Text:SetText(strName)
    option.Title.Text:SetFont("bSecure.Title")
    option.Title.Text:SizeToContents()

    option.Desc = option:Add("Panel")
    option.Desc:Dock(TOP)
    option.Desc:SetTall(20)
    option.Desc.Text = option.Desc:Add("DLabel")
    option.Desc.Text:Dock(LEFT)
    option.Desc.Text:SetTextColor(color_white)
    option.Desc.Text:SetText(strDesc)
    option.Desc.Text:SetFont("bSecure.Small")
    option.Desc.Text:SizeToContents()

    option.Toggle = option:Add("bSecure.Toggle")
    option.Toggle:SetState( bSecure.Config.Get(ID) )
    option.Toggle:Dock(LEFT)
    option.Toggle:SetWide(48)
    option.Toggle.OnToggled = function(pnl,bool)
        bSecure.Config.Set(ID,bool)
    end
end

function PANEL:OnRemove()
    bSecure.Config.Save()
end

vgui.Register("bSecure.Settings", PANEL)