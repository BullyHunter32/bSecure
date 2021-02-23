
util.AddNetworkString("bSecure.ChatPrint")
function bSecure.BroadcastChat( strText )
    net.Start("bSecure.ChatPrint")
        net.WriteString(strText)
    net.Broadcast()
end

function bSecure.FetchAdmins( bSuperAdminOnly )
    local returned = {}
    local count = 1
    for k,v in ipairs(player.GetAll()) do
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

function bSecure.BroadcastAdminChat( strText, bSuperAdminOnly )
    local tRecipients = (bSuperAdminOnly and bSecure.FetchAdmins(true)) or bSecure.FetchAdmins() or {}
    net.Start("bSecure.ChatPrint")
        net.WriteString(strText)
    net.Send(tRecipients)
end