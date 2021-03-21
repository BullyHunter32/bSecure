local hitgroups = {
    [HITGROUP_GENERIC] = "Misc",
    [HITGROUP_HEAD] = "Headshot",
    [HITGROUP_CHEST] = "Chest",
    [HITGROUP_STOMACH] = "Stomach",
    [HITGROUP_LEFTARM] = "L. Arm",
    [HITGROUP_RIGHTARM] = "R. Arm",
    [HITGROUP_LEFTLEG] = "L. Leg",
    [HITGROUP_RIGHTLEG] = "R. Leg",
    [HITGROUP_GEAR] = "Gear",
}

local M = Material
local MATERIAL_BRICKS = ("icon16/bricks.png")
local MATERIAL_SHIELD = ("icon16/shield.png")
local MATERIAL_USER = ("icon16/user_suit.png")
local MATERIAL_TIME = ("icon16/time.png")

local deaths = bSecure.Logs.CreateModule("Deaths")
deaths:Hook("PlayerDeath", function(pVictim, pKiller)
    local Weapon = pKiller:GetActiveWeapon()
    local HITGROUP = pVictim:LastHitGroup()
    local hitGroup = hitgroups[HITGROUP]
    deaths:Log({
        ["Weapon"] = {
            "Class: "..(IsValid(Weapon) and Weapon:GetClass() or "Unknown"),
            "Name: "..(IsValid(Weapon) and Weapon:GetPrintName() or "Unknown"),
        },
        ["Victim"] = {
            "Name: "..pVictim:Nick(),
            "SID64: "..pVictim:SteamID64(),
            "SID32: "..pVictim:SteamID(),
            "Rank: "..pVictim:GetUserGroup(),
        },
        ["Killer"] = {
            "Name: "..pKiller:Nick(),
            "SID64: "..pKiller:SteamID64(),
            "SID32: "..pKiller:SteamID(),
            "Rank: "..pKiller:GetUserGroup(),
        },
        ["Extras"] = {
            "HG: "..hitGroup,
            "Time: "..os.date("%x",os.time()),
        }
    },"%s was killed by %s using a %s (%s)", pVictim:Nick(), pKiller:Nick(), IsValid(Weapon) and Weapon:GetClass() or "Unknown", hitGroup)
end)

local steam = bSecure.Logs.CreateModule("Steam")
--hook.Run("bSecure.YoungAccountDetected", tData, tData.personaname, strAge, tData.timecreated)
steam:Hook("bSecure.YoungAccountDetected", function(tData, strName, strAge, timeCreated)
    steam:Log({
        ["Player"] = {
            "Name: "..strName,
            "Age: "..strAge,
            "CreationTime: "..timeCreated, 
        }
    },"%s has connected with a new steam account. (%s old)", strName, strAge)
end) 


local Bans = bSecure.Logs.CreateModule("Bans")
Bans:Hook("bSecure.PostPlayerBan", function(pPlayer, strReason, iDuration)
    Bans:Log({
        ["Player"] = {
            "Name: "..pPlayer:Name(),
            "SteamID: "..pPlayer:SteamID64(),
            "Reason: "..strReason,
            "Duration: "..iDuration 
        }
    },"%s was banned for \"%s\" %s.", bSecure.FormatPlayer(pPlayer), strReason, (iDuration == 0 and "permanently") or ("for ".. iDuration .. " seconds") )
end) 