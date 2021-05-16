util.AddNetworkString("bSecure.OpenMenu")
bSecure.ConCommandAdd("menu", function(ply)
    if not ply:IsAdmin() then return bSecure.ChatPrint(ply, "Insufficient access") end
    bSecure.ChatPrint(ply, "Opening the menu...")
    net.Start("bSecure.OpenMenu")
    net.Send(ply)
end)