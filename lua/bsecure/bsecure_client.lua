
local prefixCol = Color(30,200,100)
net.Receive("bSecure.ChatPrint", function()
    chat.AddText(prefixCol, "[bSecure] ", color_white, net.ReadString())
end)