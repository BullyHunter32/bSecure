bSecure.ACP = {}

--[[-------------------------------------
            SCREENGRAB DETOURS
--]]-------------------------------------

bSecure.ACP.ScreengrabDetours = {}

--[[-------------------------------------
    Name: Should Ban
    Default: true

    Description: Whether or not a player
    should be banned when the anticheat
    detects render.Capture, 
    render.CapturePixel or util.Compress 
    detoured.
--]]-------------------------------------
bSecure.ACP.ScreengrabDetours.ShouldBan = true

--[[-------------------------------------
    Name: ShouldAlert
    Default: false

    Description: Whether or not admins
    should be alerted when a detour
    is detected.
--]]-------------------------------------
bSecure.ACP.ScreengrabDetours.ShouldAlert = false



--[[-------------------------------------
            ANTI METH CHATSPAM
--]]-------------------------------------

bSecure.ACP.AntiMethChatSpam = {}

--[[-------------------------------------
    Name: ShouldAlert
    Default: true

    Description: Whether or not admins
    should be alerted when a detour
    is detected.
--]]-------------------------------------
bSecure.ACP.AntiMethChatSpam.ShouldBan = true

--[[-------------------------------------
    Name: Strictness level (1 or 2)
    Default: 1

    Description: If set to 1 then the
    system will only check for direct
    matches, for example "a" == "a".

    If set to 2 then the system will 
    look for anything similar, for
    example "methamphetamine.s0lut1ons"
    would trigger a detection.
--]]-------------------------------------
bSecure.ACP.AntiMethChatSpam.StrictnessLevel = 1