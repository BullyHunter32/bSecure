bSecure.VPN.Config = {}

--[[-------------------------------------
    Name: API Key

    Description: Get your API key from
    https://www.ipqualityscore.com/. This
    is used to check whether or not
    someone is using a VPN.
--]]-------------------------------------
bSecure.VPN.Config["APIKey"] = ""

--[[-------------------------------------
    Name: Email

    Description: Use a valid email for
    https://www.getipintel.net/. This
    is used to contact you if you are hitting limits.
--]]-------------------------------------
bSecure.VPN.Config["Email"] = ""

--[[-------------------------------------
    Name: Preferred Service

    Description: Which VPN detection
    service should be used?

    Services:
    1 - ipqualityscore.com
    2 - proxycheck.io/
	3 - getipintel.net/
--]]-------------------------------------
bSecure.VPN.Config["PreferredService"] = 2


--[[-------------------------------------
    Name: Should Alert Admins

    Description: If set to true then admins
    will be notified in the chat when a 
    player joins with a vpn.
--]]-------------------------------------
bSecure.VPN.Config["ShouldAlertAdmins"] = true


--[[-------------------------------------
    Name: Alert Only Superadmins

    Description: If set to true then only
    superadmins will be notified.
    ShoulldAlertAdmins must be set to true
    for this to take effect!
--]]-------------------------------------
bSecure.VPN.Config["AlertOnlySuperadmins"] = true


--[[-------------------------------------
    Name: Should Kicks
    
    Description: If set to true then if
    a player is detected connecting
    with a VPN they will be kicked
    for the reason provided below
--]]-------------------------------------
bSecure.VPN.Config["ShouldKick"] = false

--[[-------------------------------------
    Name: Kick message
    
    Description: The reason they see
    for getting kicked 
--]]-------------------------------------
bSecure.VPN.Config["KickReason"] = "Kicked for connecting with a VPN"
