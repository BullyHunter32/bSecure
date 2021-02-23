
local prefixCol = Color(160,200,80)
net.Receive("bSecure.ChatPrint", function()
    chat.AddText(prefixCol, "bSecure |", color_white, net.ReadString())
end)