bSecure.MaliciousChat = {Config = {}}

--[[-------------------------------------
    Name: Should Ban
    Default: false

    Description: Whether or not the player
    sending the message should be banned
--]]-------------------------------------
bSecure.MaliciousChat.Config.ShouldBan = false

--[[-------------------------------------
    Name: Should Kick
    Default: false

    Description: Whether or not the player
    sending the message should be kcked
--]]-------------------------------------
bSecure.MaliciousChat.Config.ShouldKick = false

--[[-------------------------------------
    Name: Punishment Reason
    Default: "[bSecure] Code %s"

    Description: Whether or not the player
    sending the message should be kcked
--]]-------------------------------------
bSecure.MaliciousChat.Config.PunishmentReason = "[bSecure] Code %s" -- %s is the code ( Either 107A or 107B )

--[[-------------------------------------
    Name: Strictness level (1 or 2)
    Default: 2

    Description: If set to 1 then the
    system will only check for direct
    matches, for example "a" == "a".

    If set to 2 then the system will 
    look for anything similar, for
    example "n1gg3r" or "c o//0 n"
    would trigger a detection.
--]]-------------------------------------
bSecure.MaliciousChat.Config.StrictnessLevel = 2

--[[-------------------------------------
    Name: Should data log
    Default: true

    Description: If set to true then
    the incident will be logged under
    garrysmod/data/bsecure/cases/steamid/
    the file name will start with 107
--]]-------------------------------------
bSecure.MaliciousChat.Config.ShouldDataLog = true