local chars = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","."}
local function generateNetString()
    local str = ""
    for i = 1, math.random(14, 28) do
        str = str .. (math.random() > 0.5 and string.upper(chars[math.random(1,#chars)]) or chars[math.random(1,#chars)])
    end
    return str
end

local ConVarValidate = generateNetString()
local GlobalVarValidate = generateNetString()
local DetourValidate = generateNetString()

util.AddNetworkString(ConVarValidate)
util.AddNetworkString(GlobalVarValidate)
util.AddNetworkString(DetourValidate)
util.AddNetworkString("bSecure.Hack.Init")
hook.Add("PlayerInitialSpawn", "bSecure.FrickHackers.Init", function(pPlayer)
    net.Start("bSecure.Hack.Init")
    net.WriteString(ConVarValidate)
    net.WriteString(GlobalVarValidate)
    net.WriteString(DetourValidate)
    net.Send(pPlayer)
end)

net.Receive(ConVarValidate, function(_,pPlayer)
    local convars = {}
    local convar = net.ReadString()
    local i = 1
    while convar ~= nil and convar ~= "" do 
        convars[i] = convar
        i = i + 1
        convar = net.ReadString()
    end
    for k,v in ipairs(convars) do
        local tConVarData = string.Split(v, "/-/")
        local CConVar,CConVarValue = tConVarData[1],tConVarData[2]
        if not CConVarValue then goto skip end
        local SConVarValue = GetConVar(CConVar):GetString()
        if SConVarValue ~= CConVarValue then
            bSecure.CreateDataLog{Player = pPlayer, Code = "100A", Details = "Detected CVar Manipulation.\n"..CConVar.."\nServerValue: "..SConVarValue.."\nClientValue: "..CConVarValue}
            bSecure.BanPlayer(pPlayer, "bSecure [Code 100A]", 0)
        end
        ::skip::
    end
end)

net.Receive(GlobalVarValidate, function(_, pPlayer)
    local varName = net.ReadString()
    local isTbl = net.ReadBool()
    local type = net.ReadString()
    bSecure.CreateDataLog{Player = pPlayer, Code = "100B", Details = "Detected a malicious global variable "..varName..".\n\n"..type}
    bSecure.BanPlayer(pPlayer,"bSecure [Code 100B]", 0)
end)

net.Receive(DetourValidate, function(l,pPlayer)
    local detours = {}

    local size = net.ReadUInt(8)
    for i = 1, size do
        detours[i] = detours[i] or {}
        local size = net.ReadUInt(28)
        detours[i][1] = util.Decompress(net.ReadData(size))
    end
    for i = 1, size do
        local size = net.ReadUInt(28)
        detours[i][2] = util.Decompress(net.ReadData(size))
    end
    for i = 1, size do
        local size = net.ReadUInt(28)
        detours[i][3] = util.Decompress(net.ReadData(size))
    end

    local details = "\n"
    for i = 1, size do
        details = details .. "Function Name - ".. detours[i][1] .. "\nFunction Source - " .. detours[i][2] .. "\nFunction Source Code\n\n".. detours[i][3].. "\n\n" 
    end

    bSecure.BanPlayer(pPlayer, "[bSecure] Code 100C", 0)
    bSecure.CreateDataLog{Player = pPlayer, Code = "100C", Details = details}
end)