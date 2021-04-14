bSecure = {}
bSecure.ConCommands = {}
bSecure.iConCommands = {}
function bSecure.ConCommandAdd(strName, callback)
    bSecure.ConCommands[strName] = callback
    table.insert(bSecure.iConCommands,"bsecure "..strName)
end

if SERVER then
    concommand.Add("bsecure", function(ply, cmd, args)
        if not args[1] then return end
        if bSecure.ConCommands[args[1]] then return bSecure.ConCommands[args[1]](ply, cmd, args) end
    end, 
    function(cmd, args)
        local returned = {}
        local i = 1
        for k,v in ipairs(bSecure.iConCommands) do
            if string.find(v, args) then
                returned[i] = v
                i = i + 1
            end
        end
        return returned
    end)
end

local prefixCol = Color(30, 200, 100)

function bSecure.Print(...)
    MsgC(prefixCol, "[bSecure] ", color_white, ...)
    print()
end

local function IncludeCS(dir) -- it's depricated but i doubt it will be getting removed any time soon. just to be safe though.
    if SERVER then
        AddCSLuaFile(dir)
    end
    include(dir)
end

function bSecure.IncludeModules()
    local tFiles, tFolders = file.Find("bsecure/modules/sh*.lua", "LUA")
    for k, sFile in ipairs(tFiles) do
        IncludeCS("bsecure/modules/" .. sFile)
    end

    tFiles, tFolders = file.Find("bsecure/modules/sv*.lua", "LUA")
    for k, sFile in ipairs(tFiles) do
        if SERVER then
            include("bsecure/modules/" .. sFile)
        end
    end

    tFiles, _ = file.Find("bsecure/modules/cl*.lua", "LUA")
    for k, sFile in ipairs(tFiles) do
        if SERVER then
            AddCSLuaFile("bsecure/modules/" .. sFile)
        else
            include("bsecure/modules/" .. sFile)
        end
    end

    tFiles, tFolders = file.Find("bsecure/modules/*", "LUA")
    for k, sModule in ipairs(tFolders) do
        local tModuleShared, _ = file.Find("bsecure/modules/" .. sModule .. "/sh*.lua", "LUA")
        for k, sFolder in ipairs(tModuleShared) do
            IncludeCS("bsecure/modules/" .. sModule .. "/" .. sFolder)
        end

        local tModuleServer, _ = file.Find("bsecure/modules/" .. sModule .. "/sv*.lua", "LUA")
        for k, sFile in ipairs(tModuleServer) do
            if SERVER then
                include("bsecure/modules/" .. sModule .. "/" .. sFile)
            end
        end

        local tModuleClient, _ = file.Find("bsecure/modules/" .. sModule .. "/cl*.lua", "LUA")
        for k, sFolder in ipairs(tModuleClient) do
            if SERVER then
                AddCSLuaFile("bsecure/modules/" .. sModule .. "/" .. sFolder)
            else
                include("bsecure/modules/" .. sModule .. "/" .. sFolder)
            end
        end
    end
end

if SERVER then
    include("bsecure/bsecure_language.lua")
    AddCSLuaFile("bsecure/bsecure_language.lua")
    include("bsecure/bsecure_server.lua")
    AddCSLuaFile("bsecure/bsecure_client.lua")
end

if CLIENT then
    include("bsecure/bsecure_language.lua")
    include("bsecure/bsecure_client.lua")
end

if SERVER then
    local tBaseMaterials,_ = file.Find("materials/bsecure/*", "GAME")
    for k,v in ipairs(tBaseMaterials) do
        resource.AddSingleFile("materials/bsecure/"..v)
    end

    local tFlagMaterials,_ = file.Find("materials/bsecure/flags/*", "GAME")
    for k,v in ipairs(tFlagMaterials) do
        resource.AddSingleFile("materials/bsecure/flags/"..v)
    end
end

bSecure.IncludeModules()