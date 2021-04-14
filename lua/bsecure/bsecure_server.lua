-- Utility functions
function bSecure.FetchAdmins(bSuperAdminOnly)
    local returned = {}
    local count = 1

    for k, v in ipairs(player.GetAll()) do
        if bSuperAdminOnly and v:IsSuperAdmin() then
            returned[count] = v
            count = count + 1
        elseif v:IsAdmin() then
            returned[count] = v
            count = count + 1
        end
    end

    return returned
end

function bSecure.FormatIP(IP) -- Removes the port from an IP Address: 1.2.3.4:2015 -> 1.2.3.4
    return IP:match("([%d%.]+)") or "error"
end

local PLAYER_METATABLE = debug.getregistry().Player

function bSecure.isPlayer(Ent) -- When is this going to be added to gmod
    return getmetatable(Ent) == PLAYER_METATABLE
end

local floor = math.floor

local function ConvertTime(iSeconds)
    local seconds = floor(iSeconds % 60)
    local minutes = floor((iSeconds % 3600) / 60)
    local hours = floor((iSeconds % 86400) / 3600)
    local days = floor((iSeconds / 86400) % 365)
    local months = floor((iSeconds / 2.628e+6) % 12)
    local years = floor((iSeconds / 86400) / 365)

    return {
        seconds = seconds,
        minutes = minutes,
        hours = hours,
        days = days,
        months = months,
        years = years
    }
end

local function FormatTime(tDate)
    local returned = ""

    if tDate.years and (tDate.years > 0) then
        returned = returned .. tDate.years .. "years "
    end

    if tDate.months and (tDate.months > 0 or tDate.years > 0) then
        returned = returned .. tDate.months .. "months "
    end

    if tDate.days and (tDate.days > 0 or tDate.months > 0) then
        returned = returned .. tDate.days .. "days "
    end

    if tDate.hours and (tDate.hours > 0 or tDate.days > 0) then
        returned = returned .. tDate.hours .. "hours "
    end

    if tDate.minutes then
        returned = returned .. tDate.minutes .. "minutes "
    end

    if tDate.seconds then
        returned = returned .. tDate.seconds .. "seconds"
    end

    return returned
end

function bSecure.TimeSince(iSeconds)
    return FormatTime(ConvertTime(os.time() - iSeconds))
end

function bSecure.FormatPlayer(pPlayer)
    return pPlayer:Nick() .. "["..pPlayer:SteamID64().."]"
end

function bSecure.BanPlayer(pPlayer, strReason, iDuration) -- Bans a player
    iDuration = iDuration or 0
    strReason = strReason or "No reason."
    hook.Run("bSecure.PrePlayerBan", pPlayer, strReason, iDuration)
    if serverguard then
        serverguard:BanPlayer(nil, pPlayer, iDuration, "bSecure - "..strReason, true, false)
    elseif ULib then
        ULib.ban(pPlayer, iDuration, strReason)
    else
        pPlayer:Ban(iDuration,true)
    end
    hook.Run("bSecure.PostPlayerBan", pPlayer, strReason, iDuration)
end
bSecure.Ban = bSecure.BanPlayer -- alias

local function serverguard_kick(pPlayer, strReason)
    strReason = strReason or "No reason"
    serverguard.Notify(nil, SERVERGUARD.NOTIFY.DEFAULT, "Console has kicked '" .. (pPlayer.SteamName and pPlayer:SteamName() or pPlayer:Name()) .. "'. Reason: " .. strReason) -- mfw serverguard uses darkrp functons
    pPlayer:Kick(strReason)
end

function bSecure.KickPlayer(pPlayer, strReason) -- Bans a player
    strReason = strReason or "No reason."
    hook.Run("bSecure.PrePlayerKick", pPlayer, strReason)
    if serverguard then
        serverguard_kick(pPlayer, strReason)
    elseif ULib then
        ULib.kick(pPlayer, strReason, nil)
    else
        pPlayer:Kick(strReason)
    end
    hook.Run("bSecure.PostPlayerKick", pPlayer, strReason)
end
bSecure.Kick = bSecure.KickPlayer -- alias

function bSecure.ArrayToList(tTable) -- Changes the value for every key to true
    local returned = {}
    for k,v in ipairs(tTable) do
        returned[v] = true
    end
    return returned, tTable
end

-- Chat printing
util.AddNetworkString("bSecure.ChatPrint")
function bSecure.BroadcastChat(strText) -- Send a message into everyones chat
    net.Start("bSecure.ChatPrint")
    net.WriteString(strText)
    net.Broadcast()
end

function bSecure.BroadcastAdminChat(strText, bSuperAdminOnly) -- Send a message into every admin's chat
    local tRecipients = bSecure.FetchAdmins(bSuperAdminOnly)
    net.Start("bSecure.ChatPrint")
    net.WriteString(strText)
    net.Send(tRecipients)
end

function bSecure.ChatPrint(pPlayer, strText) -- Send a message into a specific persons chat
    net.Start("bSecure.ChatPrint")
    net.WriteString(strText)
    net.Send(pPlayer)
end

util.AddNetworkString("bSecure.NotificationAdd")
function bSecure.CreateNotification(pPlayer, strText) -- Creates a popup notification on the client
    net.Start("bSecure.NotificationAdd")
    net.WriteString(strText)
    net.Send(pPlayer)
end

util.AddNetworkString("bSecure.AlertAdmins")
function bSecure.AlertAdmins(strText, bSuperAdminOnly) -- Notifies admins, how they're notified is configured by the client
    local tRecipients = bSecure.FetchAdmins(bSuperAdminOnly)
    net.Start("bSecure.AlertAdmins")
    net.WriteString(strText)
    net.Send(tRecipients)
end

local logDataFormat = 
[[
     __   _____                         
    / /_ / ___/___  _______  __________ 
   / __ \\__ \/ _ \/ ___/ / / / ___/ _ \
  / /_/ /__/ /  __/ /__/ /_/ / /  /  __/
 /_.___/____/\___/\___/\__,_/_/   \___/ 
                                        

[Server]
HostName - %s
IP Address - %s

[Suspect]
Name - %s
SteamID - %s

[Details]
Code %s
%s
]]

if not file.Exists("bsecure/cases", "DATA") then
    file.CreateDir("bsecure/cases")
end

function bSecure.CreateDataLog(tData)
    local SID64 = tData.SteamID or tData.Player and tData.Player:SteamID64() or false
    local logData = logDataFormat:format(
		(GetHostName()),
		(game.GetIPAddress()),
        (tData.Name or tData.Player and tData.Player:Name() or "Unknown"),
        (SID64 or "Unknown"),
        (tData.Code or "Unknown"),
        (tData.Details or "No Details")
    )
    if SID64 then
		if not file.Exists("bsecure/cases/"..SID64.."/","DATA") then
        	file.CreateDir("bsecure/cases/"..SID64)
		end
    else
        return logData
    end
    if SID64 then 
        local id = 0
        local x,y = file.Find("bsecure/cases/"..SID64.."/"..tData.Code.."*.txt", "DATA")
        id = #x
        file.Write("bsecure/cases/"..SID64.."/"..tData.Code.." "..id..".txt", logData) 
    end
    return logData
end 

-- Extra printing
function bSecure.PrintDetection(...) 
    local detection = "["..bSecure:GetPhrase("detection").."] "
    bSecure.Print(Color(255, 30, 60), detection, color_white, ...)
end

function bSecure.PrintError(...)
    local error = "["..bSecure:GetPhrase("error").."] "
    bSecure.Print(Color(255, 255, 0), error, color_white, ...)
end