-- You'd be surprised how many servers I join that have sv_allowcslua set to 1.
hook.Add("PlayerInitialSpawn", "bSecure.NotifyCSLuaEnabled", function(pPlayer)
    timer.Simple(6,function()
        if pPlayer:IsSuperAdmin() and GetConVar("sv_allowcslua"):GetInt() == 1 and not game.SinglePlayer() and not pPlayer:IPAddress() == "loopback" then
            bSecure.ChatNotify(pPlayer, "sv_allowcslua is enabled! This allows players to run malicious scripts such as hacks or exploits on your server.")
        else
            hook.Remove("PlayerInitialSpawn", "bSecure.NotifyCSLuaEnabled")
        end
    end)
end)