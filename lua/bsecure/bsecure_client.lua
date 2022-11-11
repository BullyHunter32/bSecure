local prefixCol = Color(30,200,100)
net.Receive("bSecure.ChatPrint", function()
    chat.AddText(prefixCol, "[bSecure] ", color_white, net.ReadString())
end)

net.Receive("bSecure.NotificationAdd", function()
    local strText = net.ReadString()
    bSecure.NotificationAdd(strText)
end)

net.Receive("bSecure.AlertAdmins", function()
    local strText = net.ReadString()
    if bSecure.Config.Get("notify_popup") then
        bSecure.NotificationAdd(strText)
    end
    if bSecure.Config.Get("notify_chat") then
        chat.AddText(prefixCol, "[bSecure] ", color_white, strText)
    end
end)

function bSecure.FindBySteamID(SteamID) -- Self explanatory
    local tPlayers = player.GetAll()
    for i = 1, #tPlayers do
        local playerSteamID = tPlayers[i]:SteamID()
        if SteamID == playerSteamID then
            return tPlayers[i]
        end
    end
end

function bSecure.Ban(pPlayer) -- Admin mod compatability
    if ULib then
        RunConsoleCommand("ulx","banid","\""..pPlayer:SteamID().."\"")
    elseif serverguard then
        RunConsoleCommand("sg","ban","\""..pPlayer:SteamID().."\"")
    elseif FAdmin then
        RunConsoleCommand("fadmin", "ban", "\""..pPlayer:SteamID().."\"")
    elseif sam then
        RunConsoleCommand("sam", "banid", "\""..pPlayer:SteamID().."\"")
    end
end

function bSecure.Kick(pPlayer)
    if ULib then
        RunConsoleCommand("ulx","kick","\""..pPlayer:Nick().."\"")
    elseif serverguard then
        RunConsoleCommand("sg","kick","\""..pPlayer:SteamID().."\"")
    elseif FAdmin then
        RunConsoleCommand("fadmin", "kick", "\""..pPlayer:SteamID().."\"")
    elseif sam then
        RunConsoleCommand("sam", "kick", "\""..pPlayer:Nick().."\"")
    end
end

function bSecure.Jail(pPlayer) -- Admin mod compatability
    if ULib then
        RunConsoleCommand("ulx","jail","\""..pPlayer:Nick().."\"")
    elseif serverguard then
        RunConsoleCommand("sg","jail","\""..pPlayer:SteamID().."\"")
    elseif FAdmin then
        RunConsoleCommand("fadmin", "jail", "\""..pPlayer:SteamID().."\"")
    elseif sam then
        RunConsoleCommand("sam", "jail", "\""..pPlayer:Nick().."\"")
    end
end


function bSecure.Goto(pPlayer) -- Admin mod compatability
    if ULib then
        RunConsoleCommand("ulx","goto","\""..pPlayer:Nick().."\"")
    elseif serverguard then
        RunConsoleCommand("sg","goto","\""..pPlayer:SteamID().."\"")
    elseif FAdmin then
        RunConsoleCommand("fadmin", "goto", "\""..pPlayer:SteamID().."\"")
    elseif sam then
        RunConsoleCommand("sam", "goto", "\""..pPlayer:Nick().."\"")
    end
end

function bSecure.Bring(pPlayer) -- Admin mod compatability
    if ULib then
        RunConsoleCommand("ulx","bring","\""..pPlayer:Nick().."\"")
    elseif serverguard then
        RunConsoleCommand("sg","bring","\""..pPlayer:SteamID().."\"")
    elseif FAdmin then
        RunConsoleCommand("fadmin", "bring", "\""..pPlayer:SteamID().."\"")
    elseif sam then
        RunConsoleCommand("sam", "bring", "\""..pPlayer:Nick().."\"")
    end
end
