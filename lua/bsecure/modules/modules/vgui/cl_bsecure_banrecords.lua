local tBanData = {}
net.Receive("bSecure.WriteBanData", function()
    tBanData = net.ReadTable()
end)

local PANEL = {}

local color_bg = Color(54, 54, 59)
local color_div = Color(60,60,63)
local color_page_a = Color(63, 63, 67)
local color_page_i = Color(52, 52, 56)

local pageCount = 0
local count = 0
function PANEL:Init()
    net.Start("bSecure.RequestBanData")
    net.SendToServer()
    
    count = 0
    pageCount = 0

    self.Contents = self:Add("Panel")
    self.Contents:Dock(FILL)
    self.Contents:DockMargin(8, 8, 8, 8)

    self.PageNavigation = self.Contents:Add("DPanel")
    self.PageNavigation:Dock(BOTTOM)
    self.PageNavigation:DockMargin(0,4,0,0)
    self.PageNavigation:SetTall(38)

    self.PageNavigation.Paint = nil
    self.PageNavigation.Pages = {}

    self.RecordHeader = self.Contents:Add("Panel")
    self.RecordHeader:Dock(TOP)
    self.RecordHeader:SetTall(35)
    self.RecordHeader.Paint = function(pnl,w,h)
        draw.SimpleText("Name","bSecure.Title", w*(0.25/2), h/2, color_white, 1, 1)
        draw.RoundedBoxEx(0,w*0.25, 6, 2, h-12, color_div)

        draw.SimpleText("Admin","bSecure.Title", w*((0.25+0.5)/2), h/2, color_white, 1, 1)
        draw.RoundedBoxEx(0,w*0.5, 6, 2, h-12, color_div)

        draw.SimpleText("Date","bSecure.Title", w*((0.25+0.5+0.5)/2), h/2, color_white, 1, 1)
        draw.RoundedBoxEx(0,w*0.75, 6, 2, h-12, color_div)

        draw.SimpleText("Details","bSecure.Title", w*((0.25+0.5+0.5+0.5)/2), h/2, color_white, 1, 1)
    end
    self.RecordList = self.Contents:Add("Panel")
    self.RecordList:Dock(FILL)
    self.RecordList:DockMargin(0,4,0,0)

    self.temp = self.Contents:Add("Panel")
    self.temp:Dock(FILL)
    self.temp:SetVisible(false)
    self.Pages = {}
    self.Buttons = {}

    local dataLength = #tBanData
    for k,v in ipairs(tBanData) do
        self:AddRecord(v, k == dataLength)
    end

end

function PANEL:PerformLayout(w,h)
    local increment = (42)
    local initpos = w/2 - ((increment*(pageCount-1))) --w/2 - ((increment*pageCount)/2) --pnl.w -  (increment*count/2)
    for k,v in ipairs(self.Buttons) do
        v:SetPos(initpos+(k-1)*increment,38/2-19)
        v:SetSize(38,38)
    end
end

function PANEL:SetActivePage(iPage)
    self.Buttons[iPage]:DoClick()
end

function PANEL:AddPage(pPanel)
    pageCount = pageCount + 1

    self.Pages[pageCount] = self.temp
    self.temp = self.Contents:Add("Panel")
    self.temp:Dock(FILL)
    self.temp:SetVisible(false)

    self.Buttons[pageCount] = self.PageNavigation:Add("DButton")
    local btn = self.Buttons[pageCount]
    btn:SetText("")
    btn.id = pageCount
    btn.DoClick = function(pnl)
        if IsValid(self.Pages.Active) then
            self.Pages.Active:SetVisible(false)
        end
        self.Pages.ActiveButton = btn
        if not IsValid(pPanel) then
            btn:Remove()
            return
        end
        pPanel:SetVisible(true)
        self.Pages.Active = pPanel
    end
    btn.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h,self.Pages.ActiveButton == pnl and color_page_a or color_page_i, true, true, true, true)
        draw.SimpleText(pnl.id, "bSecure.Title", w/2, h/2, color_white, 1, 1)
    end
end 

function PANEL:AddRecord(tData, bPage)
    count = count + 1

    local Name = tData.name or tData.player or "NULL"
    local SteamID = tData.steam_id or "N/A"
    local SteamID64 = tData.community_id or tData.steamid or "NONE"
    local CommunityURL = SteamID64 ~= "NONE" and "https://www.steamcommunity.com/profiles/"..SteamID64.."/" or "NONE"
    local Admin = tData.admin or "NONE"
    local BanReason = tData.reason or "NONE"
    local BanTime = os.date("%x", (tData.time or tData.start_time or 0)) or "NONE"
    
    local ply = self.temp:Add("DPanel")
    ply:Dock(TOP)
    ply:DockMargin(0,2,0,2)
    ply:SetTall(47)
    ply.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, color_bg, true, true, true, true)
        
        draw.SimpleText(Name,"bSecure.Title", w*(0.25/2), h/2, color_white, 1, 1)
        draw.RoundedBoxEx(0,w*0.25, 6, 2, h-12, color_div)

        draw.SimpleText(Admin,"bSecure.Title", w*((0.25+0.5)/2), h/2, color_white, 1, 1)
        draw.RoundedBoxEx(0,w*0.5, 6, 2, h-12, color_div)

        draw.SimpleText(BanTime,"bSecure.Title", w*((0.25+0.5+0.5)/2), h/2, color_white, 1, 1)
        draw.RoundedBoxEx(0,w*0.75, 6, 2, h-12, color_div)

    end
    local btn = ply:Add("DButton")
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
        draw.SimpleText("Copy","bSecure.Small",w/2,h/2,Color(255, 255, 255, pnl.delta*255),1,1)

        surface.SetDrawColor(255, 255, 255, 255-(pnl.delta*255))
        surface.SetMaterial(Material("bsecure/clipboard.png"))
        surface.DrawTexturedRect(0, 0, w, h)
    end

    local copyData = 
    ([[
==================
Suspect Name: %s
Suspect SteamID: %s
Suspect SteamID64: %s
Suspect Community URL: %s

Admin Name: %s
Ban Reason: %s
Ban Time: %s
==================
]]):format(
        Name or "Woops",
        SteamID or "Woops",
        SteamID64 or "Woops",
        CommunityURL or "Woops",
        Admin or "Woops",
        BanReason or "Woops",
        os.date("%x @ %X",tData.time) or "Woops"
    )
    btn.DoClick = function(pnl)
        MsgC(copyData)
        SetClipboardText(copyData)
        bSecure.NotificationAdd("Copied ban data for ".. Name .. " to your clipboard!")
    end

    
    ply.PerformLayout = function(pnl, w, h)
        btn:SetPos(w*((0.25+0.5+0.5+0.5)/2) - 18, h/2 - 18)
        btn:SetSize(36, 36)
    end


    if count%10 == 0 or bPage then
        self:AddPage(self.temp)
        if self.Pages[1] and bPage then self:SetActivePage(1) end
    end
end

vgui.Register("bSecure.BanRecords", PANEL)