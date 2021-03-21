local PANEL = {}

local color_grip = Color(70, 72, 74)
local color_bg = Color(54, 54, 59)

local mat_clipboard = Material("bsecure/clipboard.png")
local mat_hammer = Material("bsecure/hammer.png")
local mat_kick = Material("bsecure/kick.png")
local mat_cuffs = Material("bsecure/handcuffs.png")
local mat_left = Material("bsecure/left.png")
local mat_right = Material("bsecure/right.png")

function PANEL:Init()
    self.Contents = self:Add("Panel")
    self.Contents:Dock(FILL)
    self.Contents:DockMargin(8, 8, 8, 8)

    self.Searchbar = self.Contents:Add("bSecure.Searchbar")
    self.Searchbar:Dock(TOP)
    self.Searchbar:SetTall(38)
    self.Searchbar:SetPlaceholderText("Search for a player by name")
    self.Searchbar.OnValueChange = function(pnl, val)
        self.PlayerList:Clear()
        for k,v in ipairs(player.GetAll()) do
            if string.find(string.lower(v:Nick()),val) then
                self:AddPlayer(v)
            end
        end
    end

    self.PlayerList = self.Contents:Add("DScrollPanel")
    self.PlayerList:Dock(FILL)
    self.PlayerList:DockMargin(0,4,0,0)
    self.PlayerList.vBar = self.PlayerList:GetVBar()
    self.PlayerList.vBar:SetWide(8)
    self.PlayerList.vBar:SetHideButtons(true)
    self.PlayerList.vBar.btnGrip.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(w/3, 0, 0, w, h, color_grip, true, true, true, true)
    end
    self.PlayerList.vBar.Paint = nil

    for k,v in ipairs(player.GetAll()) do
        self:AddPlayer(v)
    end
end

local btnCount = 0
function PANEL:AddPlayer(pPlayer)
    btnCount = 0
    local ply = self.PlayerList:Add("DPanel")
    ply:Dock(TOP)
    ply:DockMargin(0,2,0,2)
    ply:SetTall(50)
    ply.Paint = function(pnl, w, h)
        draw.RoundedBoxEx(4, 0, 0, w, h, color_bg, true, true, true, true)
    end
    ply.Avatar = ply:Add("AvatarImage")
    ply.Avatar:Dock(LEFT)
    ply.Avatar:SetWide(50)
    ply.Avatar:SetPlayer(pPlayer, 50)
    ply.Name = ply:Add("DLabel")
    ply.Name:Dock(LEFT)
    ply.Name:DockMargin(6, 0, 0, 0)
    ply.Name:SetText(pPlayer:Nick())
    ply.Name:SetFont("bSecure.Title")
    ply.Name:SizeToContents()
    ply.Name:SetTextColor(color_white)
    ply.Actions = {}
    
    ply.AddAction = function(strName, matIcon, fCallback)
        btnCount = btnCount + 1
        local btn = ply:Add("DButton")
        ply.Actions[btnCount] = btn
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
            draw.SimpleText(strName,"bSecure.Small",w/2,h/2,Color(255, 255, 255, pnl.delta*255),1,1)

            surface.SetDrawColor(255, 255, 255, 255-(pnl.delta*255))
            surface.SetMaterial(matIcon)
            surface.DrawTexturedRect(6, 6, w-12, h-12)
        end
        btn.DoClick = function()
            fCallback(ply)
        end
    end
    local SteamID64 = pPlayer:SteamID64()
    local copyData = 
    ([[
==================
Name: %s %s
SteamID32: %s
SteamID64: %s
Community URL: %s
==================
]]):format(
        pPlayer:Name(),
        (pPlayer.SteamName and "("..pPlayer:SteamName()..")" or ""),
        pPlayer:SteamID(),
        SteamID64 or "NONE",
        (SteamID64 and "https://steamcommunity.com/profiles/"..SteamID64.."/" or "NONE")
    )
    ply.AddAction("Copy Info",mat_clipboard, function() 
        MsgC(copyData)
        SetClipboardText(copyData)
        bSecure.NotificationAdd("Copied data for "..pPlayer:Name() .. " to your clipboard!")
    end)
    ply.AddAction("Ban",mat_hammer, function() 
        bSecure.Ban(pPlayer)
    end)
    ply.AddAction("Kick",mat_kick, function() 
        bSecure.Kick(pPlayer)
    end)
    ply.AddAction("Jail",mat_cuffs, function()
        bSecure.Jail(pPlayer) 
    end)
    ply.AddAction("Bring",mat_left, function() 
        bSecure.Bring(pPlayer)
    end)
    ply.AddAction("Goto",mat_right, function() 
        bSecure.Goto(pPlayer)
    end)

    ply.PerformLayout = function(pnl, w, h)
        local increment = (60)
        local initpos = w/2 - ((increment*btnCount)/2)
        for k,v in ipairs(ply.Actions) do
            v:SetPos(initpos+((k+1)*increment),h/2-25)
            v:SetSize(50,50)
        end
    end
end 

vgui.Register("bSecure.AllPlayers", PANEL, "EditablePanel")