local timer_Simple = timer.Simple
local debug_getinfo = debug.getinfo
local net_Receive = net.Receive
local GetConVar = GetConVar
local net_Start = net.Start
local net_SendToServer = net.SendToServer 
local net_WriteString = net.WriteString
local net_WriteUInt = net.WriteUInt
local net_ReadString = net.ReadString
local net_WriteData = net.WriteData
local util_TableToJSON = util.TableToJSON
local net_WriteBool = net.WriteBool
local ipairs,pairs = ipairs,pairs
local util_Compress = util.Compress
local istable = istable
local file_Open = file.Open

local bad_globals = {
    "dickwrap",
    "UnloadSmegHack",
    "ReloadSmegHack",
    "LoadSmegHack",
    "ValidateAimbot",
    "ValidateESP",
}

local convars = {"sv_cheats","sv_allowcslua"}

local detourCompare = {
	["debug"] = {
		["traceback"] = "=[C]",
		["sethook"] = "=[C]",
		["getlocal"] = "=[C]",
		["getregistry"] = "=[C]",
		["getupvalue"] = "=[C]",
		["Trace"] = "@lua/includes/extensions/debug.lua",
		["setmetatable"] = "=[C]",
		["getfenv"] = "=[C]",
		["gethook"] = "=[C]",
		["debug"] = "=[C]",
		["getmetatable"] = "=[C]",
		["setfenv"] = "=[C]",
		["getinfo"] = "@LuaCmd",
	},
	["vgui"] = {
		["CreateX"] = "=[C]",
		["CursorVisible"] = "=[C]",
		["RegisterFile"] = "@lua/includes/extensions/client/panel/scriptedpanels.lua",
		["Create"] = "@lua/includes/extensions/client/panel/scriptedpanels.lua",
		["IsHoveringWorld"] = "=[C]",
		["GetHoveredPanel"] = "=[C]",
		["GetWorldPanel"] = "=[C]",
		["GetKeyboardFocus"] = "=[C]",
		["FocusedHasParent"] = "=[C]",
		["Register"] = "@lua/includes/extensions/client/panel/scriptedpanels.lua",
		["RegisterTable"] = "@lua/includes/extensions/client/panel/scriptedpanels.lua",
		["CreateFromTable"] = "@lua/includes/extensions/client/panel/scriptedpanels.lua",
		["GetControlTable"] = "@lua/includes/extensions/client/panel/scriptedpanels.lua",
	},
	["concommand"] = {
		["Run"] = "@lua/includes/modules/concommand.lua",
		["Remove"] = "@lua/includes/modules/concommand.lua",
		["AutoComplete"] = "@lua/includes/modules/concommand.lua",
		["GetTable"] = "@lua/includes/modules/concommand.lua",
		["Add"] = "@lua/includes/modules/concommand.lua",
	},
	["net"] = {
		["Receive"] = "@lua/includes/extensions/net.lua",
		["WriteInt"] = "=[C]",
		["ReadInt"] = "=[C]",
		["SendToServer"] = "=[C]",
		["WriteFloat"] = "=[C]",
		["ReadType"] = "@lua/includes/extensions/net.lua",
		["BytesWritten"] = "=[C]",
		["WriteBool"] = "=[C]",
		["WriteAngle"] = "=[C]",
		["WriteBit"] = "=[C]",
		["ReadHeader"] = "=[C]",
		["WriteType"] = "@lua/includes/extensions/net.lua",
		["BytesLeft"] = "=[C]",
		["ReadBit"] = "=[C]",
		["WriteNormal"] = "=[C]",
		["WriteUInt"] = "=[C]",
		["ReadString"] = "=[C]",
		["ReadMatrix"] = "=[C]",
		["WriteColor"] = "@lua/includes/extensions/net.lua",
		["WriteDouble"] = "=[C]",
		["ReadTable"] = "@lua/includes/extensions/net.lua",
		["WriteMatrix"] = "=[C]",
		["ReadBool"] = "@lua/includes/extensions/net.lua",
		["ReadColor"] = "@lua/includes/extensions/net.lua",
		["ReadEntity"] = "@lua/includes/extensions/net.lua",
		["WriteData"] = "=[C]",
		["WriteEntity"] = "@lua/includes/extensions/net.lua",
		["ReadUInt"] = "=[C]",
		["ReadData"] = "=[C]",
		["WriteTable"] = "@lua/includes/extensions/net.lua",
		["Start"] = "=[C]",
		["WriteString"] = "=[C]",
		["ReadDouble"] = "=[C]",
		["ReadFloat"] = "=[C]",
		["WriteVector"] = "=[C]",
		["Incoming"] = "@lua/includes/extensions/net.lua",
		["ReadAngle"] = "=[C]",
		["ReadNormal"] = "=[C]",
		["ReadVector"] = "=[C]",
	},
	["file"] = {
		["Exists"] = "=[C]",
		["Write"] = "@lua/includes/extensions/file.lua",
		["Append"] = "@lua/includes/extensions/file.lua",
		["Rename"] = "=[C]",
		["Time"] = "=[C]",
		["Delete"] = "=[C]",
		["Read"] = "@lua/includes/extensions/file.lua",
		["Size"] = "=[C]",
		["AsyncRead"] = "=[C]",
		["Open"] = "=[C]",
		["CreateDir"] = "=[C]",
		["IsDir"] = "=[C]",
		["Find"] = "=[C]",
	},
	["sql"] = {
		["Query"] = "=[C]",
		["QueryValue"] = "@lua/includes/util/sql.lua",
		["SQLStr"] = "@lua/includes/util/sql.lua",
		["LastError"] = "@lua/includes/util/sql.lua",
		["Commit"] = "@lua/includes/util/sql.lua",
		["QueryRow"] = "@lua/includes/util/sql.lua",
		["IndexExists"] = "@lua/includes/util/sql.lua",
		["TableExists"] = "@lua/includes/util/sql.lua",
		["Begin"] = "@lua/includes/util/sql.lua",
	},
	["http"] = {
		["Fetch"] = "@lua/includes/modules/http.lua",
		["Post"] = "@lua/includes/modules/http.lua",
	},
}

timer_Simple(15, function()
	detourCompare["hook"] = { -- big dumb sam detours these functions for some reason. so does ulx, smh
		["Run"] = debug_getinfo(hook.Run).source,
		["Remove"] = debug_getinfo(hook.Remove).source,
		["Call"] = debug_getinfo(hook.Call).source,
		["GetTable"] = debug_getinfo(hook.GetTable).source,
		["Add"] = debug_getinfo(hook.Add).source,
	},
end)

local detourCheck = {
	{"debug", "traceback","sethook","getlocal","getregistry","getupvalue","Trace","setmetatable","getfenv","gethook","debug","getmetatable","setfenv","getinfo"},
	{"vgui", "CreateX","CursorVisible","RegisterFile","Create","IsHoveringWorld","GetHoveredPanel","GetWorldPanel","GetKeyboardFocus","FocusedHasParent","Register","RegisterTable","CreateFromTable","GetControlTable"},
	{"concommand", "Run","Remove","AutoComplete","GetTable","Add"},
	{"net", "Receive","WriteInt","ReadInt","SendToServer","WriteFloat","ReadType","BytesWritten","WriteBool","WriteAngle","WriteBit","ReadHeader","WriteType","BytesLeft","ReadBit","WriteNormal","WriteUInt","ReadString","ReadMatrix","WriteColor","WriteDouble","ReadTable","WriteMatrix","ReadBool","ReadColor","ReadEntity","WriteData","WriteEntity","ReadUInt","ReadData","WriteTable","Start","WriteString","ReadDouble","ReadFloat","WriteVector","Incoming","ReadAngle","ReadNormal","ReadVector"},
	{"file", "Exists","Write","Append","Rename","Time","Delete","Read","Size","AsyncRead","Open","CreateDir","IsDir","Find"},
	{"sql", "Query","QueryValue","SQLStr","LastError","Commit","QueryRow","IndexExists","TableExists","Begin"},
	{"http", "Fetch","Post"},
	{"hook", "Run","Remove","Call","GetTable","Add"},
}

local ConVarValidate
local GlobalVarValidate
local DetourValidate
net_Receive("bSecure.Hack.Init", function()
    ConVarValidate = net_ReadString()
    GlobalVarValidate = net_ReadString()
    DetourValidate = net_ReadString()
end)

local detourCheckSize = #detourCheck
local function DetourValidation()
    local report = {}
    local detected = false
    local p = 0
    for i = 1, detourCheckSize do
        for x = 2, #detourCheck[i] - 1 do
			local table = detourCheck[i][1]
			local func = detourCheck[i][x]
			local addr = _G[table][func]
            if debug_getinfo(addr).source ~= detourCompare[table][func] then
                p = p + 1
                detected = true
                local funcsrc = ""
                local data = debug_getinfo(addr)
                report[p] = {table .. "." .. func, data.source, }
                local _file = string.sub(data.source,6)
                local start,ends = data.linedefined,data.lastlinedefined
                local files = file_Open(_file, "r", "LUA")
                if not files then 
                    goto skip 
                end
                for i = 1, ends do
                    local line = files:ReadLine()
                    if not line then break end
                    if i >= start then
                        funcsrc = funcsrc .. line
                    end
                end
                report[p][3] = funcsrc
            end
            ::skip::
        end
    end 

    if detected then
        net_Start(DetourValidate)
        net_WriteUInt(p, 8)
        for i = 1, p do
            local compressed = util_Compress(report[i][1])
            net_WriteUInt(#compressed, 28)
            net_WriteData(compressed)
        end
        for i = 1, p do
            local compressed = util_Compress(report[i][2])
            net_WriteUInt(#compressed, 28)
            net_WriteData(compressed)
        end
        for i = 1, p do
            local compressed = util_Compress(report[i][3] or "No source code")
            net_WriteUInt(#compressed, 28)
            net_WriteData(compressed)
        end
        net_SendToServer()
    end
	timer_Simple(20, DetourValidation)
end
timer_Simple(20, DetourValidation)

local function ConVarValidation()
    net_Start(ConVarValidate)
    for k,v in ipairs(convars) do
        net_WriteString(v.."/-/"..GetConVar(v):GetString())
    end
    net_SendToServer()
    timer_Simple(120, ConVarValidation)
end
timer_Simple(120, ConVarValidation)

local function GlobalVarValidation()
    for k,v in ipairs(bad_globals) do
        if _G[v] then
            local _GV = _G[v]
            local istbl = istable(_GV)
            net_Start(GlobalVarValidate)
            net_WriteString(v)
            net_WriteBool(istbl)
            if istbl then
                local d = {}
                for k,v in pairs(_GV) do
                    if not istable(v) then
                        d[k] = tostring(v)
                    end
                end
                net.WriteString(util_TableToJSON(d, true))
            elseif isfunction(_GV) then
                local func = ""
                local data = debug_getinfo(_GV)
                local _file = string.sub(data.source,6)
                local start,ends = data.linedefined,data.lastlinedefined
                local files = file_Open(_file, "r", "LUA")
                if not files then 
                    net_WriteString(tostring(_GV))
                    net_SendToServer() 
                    return
                end
                for i = 1, ends do
                    local line = files:ReadLine()
                    if not line then break end
                    if i >= start then
                        func = func .. line
                    end
                end
                net_WriteString(func)
            else
                ::skip::
                net_WriteString(tostring(_GV))
            end
            net_SendToServer() 
            break
        end
    end
    timer_Simple(120, GlobalVarValidation)
end
timer_Simple(120, GlobalVarValidation)

-- local function reportDetour(k)
--     net_Start(DetourValidate)
--     net_WriteString(v)
--     net_WriteBool(istbl)
--     if istable(_G[k]) then
--         local d = {}
--         for k,v in pairs(_G[k]) do
--             if not istable(v) then
--                 d[k] = tostring(v)
--             end
--         end
--         net.WriteString(util_TableToJSON(d, true))
--     elseif isfunction(_G[k]) then
--         local func = ""
--         local data = debug_getinfo(_G[k])
--         local _file = string.sub(data.source,6)
--         local start,ends = data.linedefined,data.lastlinedefined
--         local files = file_Open(_file, "r", "LUA")
--         if not files then 
--             net_WriteString(tostring(_GV))
--             net_SendToServer() 
--             return
--         end
--         for i = 1, ends do
--             local line = files:ReadLine()
--             if not line then break end
--             if i >= start then
--                 func = func .. line
--             end
--         end
--         net_WriteString(func)
--     else
--         ::skip::
--         net_WriteString(tostring(_GV))
--     end
--     net_SendToServer() 
-- end
