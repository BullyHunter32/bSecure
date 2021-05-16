bSecure.Steam.Config = {}

--[[-------------------------------------
    Name: API Key
    Default: ""

    Description: Get your API key from
    https://steamcommunity.com/dev. It's
    used to lookup data about an
    individual
--]]-------------------------------------
bSecure.Steam.Config["APIKey"] = "B4F78850DAF0F43B337D280D190D8745"

--[[-------------------------------------
    Name: Alert admins - New account
    Default: true

    Description: Whether or not admins
    should be alerted in chat when
    someone joins with an account
    that is younger than a week old
--]]-------------------------------------
bSecure.Steam.Config["AlertAdminsYoung"] = true

--[[-------------------------------------
    Name: Alert admins - Un-setup account
    Default: true

    Description: Whether or not admins
    should be alerted when someone joins
    with an account with an un-setup
    community account
--]]-------------------------------------
bSecure.Steam.Config["AlertAdminsUnSetup"] = true

--[[-------------------------------------
    Name: Estimate creation time
    Default: false

    Description: Whether or not the 
    player's creation time should be
    estimated if they're a private account.

    Disclaimer: This is more expensive as
    it downloads data for 2 other players
    for every private account on your
    server.
--]]-------------------------------------
bSecure.Steam.Config["EstimateCreationTime"] = false