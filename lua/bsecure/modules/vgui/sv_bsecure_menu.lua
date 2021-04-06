util.AddNetworkString("bSecure.OpenMenu")
bSecure.ConCommandAdd("menu", function(ply)
    if not ply:IsAdmin() then return bSecure.ChatPrint(ply, "Insufficient access") end
    bSecure.ChatPrint(ply, "Opening the menu...")
    net.Start("bSecure.OpenMenu")
    net.Send(ply)
end)

hook.Add("PlayerSay", "bSecure.OpenMenu", function(pPlayer, strText)
    if not strText:lower() == "!bsecure" then return end
    if not pPlayer:IsAdmin() then return bSecure.ChatPrint(pPlayer, "Insufficient access") end
    bSecure.ChatPrint(pPlayer, "Opening the menu...")
    net.Start("bSecure.OpenMenu")
    net.Send(pPlayere)
    return ""
end)
