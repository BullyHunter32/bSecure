local blocked, ang = {}

hook.Add("StartCommand", "bSecure.Anglessss", function(pPlayer, cmd)
    if blocked[pPlayer] then
        return
    end

    ang = cmd:GetViewAngles()
    if ang.x > 89 or ang.x < -89 or ang.y > 180 or ang.y < -180 then -- cba for other checks
        local pos = pPlayer:GetPos()
        local closeplayers = {}
        local i = 0
        for k,v in ipairs(player.GetAll()) do
            local dist = v:GetPos():DistToSqr(pPlayer:GetPos())
            if dist  < 500*500 then
                i = i + 1
                closeplayers[i] = {
                    ["Name"] = v:Nick(),
                    ["Steamid"] = v:SteamID64(),
                    ["Distance From Suspect"] = math.floor(math.sqrt(dist)),
                }
            end
        end
        local dat = {
            ["Angles"] = {
                ["x"] = ang.x,
                ["y"] = ang.y,
                ["z"] = ang.z,
            },
            ["Position"] = {
                ["x"] = pos.x,
                ["y"] = pos.y,
                ["z"] = pos.z,
            },
            ["Detected"] = {
                ["Pitch"] = ang.x > 89 or ang.x < -89,
                ["Yaw"] =  ang.y > 180 or ang.y < -180,
            },
            ["Nearby Players"] = closeplayers,
        }
        bSecure.CreateDataLog{Player = pPlayer, Code = "108A", Details = "Detected this retard cheating or something.\n\n".. util.TableToJSON(dat, true)}
        bSecure.BanPlayer(pPlayer, "[bSecure] Fucky angles detected!!!!", 0)
        blocked[pPlayer] = true  -- to prevent spamming because the player wont be banned immediately 
    end
end)