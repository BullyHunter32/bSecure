net.Receive("bSecure.WriteLogData", function()
    local iType = net.ReadUInt(4)
    if not iType then return end
    bSecure.Logs.iStored[iType] = (net.ReadTable() or {})
end)

net.Receive("bSecure.UpdateLogs", function()
    local ID = net.ReadUInt(8)
    if not ID then return end
    bSecure.Logs.iStored[ID] = bSecure.Logs.iStored[ID] or {}
    table.insert(bSecure.Logs.iStored[ID].Logs,{
        time = tonumber(net.ReadString()),
        log = net.ReadString(),
        copy = net.ReadTable(),
    }) 
end)

function bSecure.Logs.RequestLogData(iType)
    if not iType or not LocalPlayer():IsAdmin() then return end
    net.Start("bSecure.RequestLogData")
    net.WriteUInt(iType,6)
    net.SendToServer()
end
