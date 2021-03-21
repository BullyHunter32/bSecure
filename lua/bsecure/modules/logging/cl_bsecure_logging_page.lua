local PANEL = {}

function PANEL:Init()
    self.SideBar = self:Add("bSecure.NavBar")
    self.SideBar:Dock(LEFT)
    self.SideBar:SetWide(145)
    self.SideBar.Paint = function(pnl,w,h)
        draw.RoundedBoxEx(0,0,0,w,h,Color(52, 52, 56    ))
    end
    self.SideBar:SetBody(self)
    self.SideBar:DockPadding(1, 1, 1, 1)
    self.SideBar:SetAccent(Color(90,160,89))
    for k,v in ipairs(bSecure.Logs.iStored) do
        self:AddLoggingPage(v.ID)
    end
end

function PANEL:AddLoggingPage(ID)
    local tLogData = bSecure.Logs.iStored[ID]
    local tLogs = tLogData.Logs
    local page = self:Add("Panel")
    page:Dock(FILL)
    local header = page:Add("Panel")
    header:Dock(TOP)
    header:DockMargin(4, 1, 4, 1)
    header:SetTall(30)
    header.Paint = function(pnl, w, h)
        draw.SimpleText("Time","bSecure.ExtraSmallButSlightlyBigger", w*(0.2/2), h/2, color_white, 1, 1)
        draw.RoundedBoxEx(0,w*0.2-1, 6, 2, h-12, Color(60,60,63))

        draw.SimpleText("Log","bSecure.ExtraSmallButSlightlyBigger", w*(0.18+0.5+0.5)/2, h/2, color_white, 1, 1)
    end

    local scroll = page:Add("DScrollPanel")
    scroll:Dock(FILL)
    for k,v in ipairs(tLogs) do
        local log = scroll:Add("DButton")
        log:Dock(TOP)
        log:SetTall(25)
        log:SetText("")
        log:DockMargin(4, 1, 4, 1)
        log.dateWidth = 0
        log.Paint = function(pnl, w, h)
            draw.RoundedBoxEx(0, 0, 0, w, h, Color(50, 50, 54))
            surface.SetDrawColor(44, 44, 50, 255)
            surface.DrawOutlinedRect(0, 0, w, h)
            pnl.dateWidth,_ = draw.SimpleText(os.date("%X",v.time),"bSecure.ExtraSmall", w*(0.2/2), h/2, color_white, 1, 1)
            --draw.SimpleText(v.log,"bSecure.ExtraSmall", w*(0.24),h/2,color_white,0,1 )
            draw.RoundedBoxEx(0,w*0.2-1, 6, 2, h-12, Color(60,60,63))
        end
        log.Log = log:Add("DLabel")
        log.Log:SetSize(400,80)
        log.Log:SetFont("bSecure.ExtraSmall")
        log.Log:SetWrap(true)
        log.Log:SetTextColor(color_white)
        log.Log:SetText(v.log)
        log.PerformLayout = function(pnl, w, h)
            pnl.Log:SetPos(w*0.24,5)
            pnl.Log:SizeToContents()
            pnl:SetTall(pnl.Log:GetTall() + 10)
        end
        log.DoClick = function(pnl)
            local menu = DermaMenu(nil, nil)
            for k,v in pairs(v.copy) do
                if istable(v) then
                    local submenu = menu:AddSubMenu(k)
                    for k,v in ipairs(v) do
                        submenu:AddOption(v,function()
                            SetClipboardText(v)
                        end)
                    end
                else
                    menu:AddOption(v,function()
                        SetClipboardText(v)
                    end)
                end
            end
            menu:MakePopup()
            menu:SetPos(input.GetCursorPos())
        end
    end
    page:SetVisible(false)
    self.SideBar:AddPage(tLogData.Name, page)
end 

vgui.Register("bSecure.Logs", PANEL)