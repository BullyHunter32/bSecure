
util.AddNetworkString("bSecure.WriteLogData")
function bSecure.Logs.SendLogs(pPlayer, iType)
    if not pPlayer:IsAdmin() then return end
    local tData = bSecure.Logs.GetStored(iType)
    if not tData then return end
    net.Start("bSecure.WriteLogData")
    net.WriteUInt(iType,4)
    net.WriteTable(tData)
    net.Send(pPlayer)
end 

util.AddNetworkString("bSecure.RequestLogData")
net.Receive("bSecure.RequestLogData", function(_,ply)
    local iType = net.ReadUInt(6)
    if not iType or not ply:IsAdmin() then return end
    bSecure.Logs.SendLogs(ply, iType)
end)

util.AddNetworkString("bSecure.UpdateLogs")
hook.Add("bSecure.OnLog", "bSecure.UpdateAdminValues", function(ID, Index)
    local tData,tRecipients = bSecure.Logs.iStored[ID].Logs[Index], bSecure.FetchAdmins()
    net.Start("bSecure.UpdateLogs")
    net.WriteUInt(ID,8)
    net.WriteString(tostring(tData.time)) -- tis a big number
    net.WriteString(tData.log)
    net.WriteTable(tData.copy)
    net.Send(tRecipients)
end)