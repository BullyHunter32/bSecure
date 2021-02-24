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

function bSecure.FormatIP(IP)
    return IP:match("([%d%.]+)") or "error"
end

local PLAYER_METATABLE = debug.getregistry().Player

function bSecure.isPlayer(Ent)
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

function bSecure.BanPlayer(pPlayer, strReason, iDuration)
    iDuration = iDuration or ""
    strReason = strReason or "No reason."
    if serverguard then
        return serverguard:BanPlayer(nil, pPlayer, iDuration, "bSecure - "..strReason, true, false)
    elseif ULib then
        return ULib.Ban(pPlayer, iDuration, strReason)
    else
        return pPlayer:Ban(iDuration,true)
    end
end

function bSecure.ArrayToList( tTable )
    local returned = {}
    for k,v in ipairs(tTable) do
        returned[v] = true
    end
    return returned
end

-- Chat printing
util.AddNetworkString("bSecure.ChatPrint")
function bSecure.BroadcastChat(strText)
    net.Start("bSecure.ChatPrint")
    net.WriteString(strText)
    net.Broadcast()
end

function bSecure.BroadcastAdminChat(strText, bSuperAdminOnly)
    local tRecipients = (bSuperAdminOnly and bSecure.FetchAdmins(true)) or bSecure.FetchAdmins() or {}
    net.Start("bSecure.ChatPrint")
    net.WriteString(strText)
    net.Send(tRecipients)
end

function bSecure.ChatPrint(pPlayer, strText)
    net.Start("bSecure.ChatPrint")
    net.WriteString(strText)
    net.Send(pPlayer)
end

-- Extra printing
function bSecure.PrintDetection(...)
    bSecure.Print(Color(255, 30, 60), "[Detection] ", color_white, ...)
end

function bSecure.PrintError(...)
    bSecure.Print(Color(255, 255, 0), "[Error] ", color_white, ...)
end