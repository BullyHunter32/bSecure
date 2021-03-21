local net_Start = net.Start
local net_WriteString = net.WriteString
local net_SendToServer = net.SendToServer
local file_Find = file.Find
local string_find = string.find
local ipairs = ipairs
local found = {}
local flagged = {
	"hack",
	"cheat",
	"aimbot",
	"esp",
    "cobalt",
    "odium",
    "exploit",
}

local function sus(dir)
    for k,v in ipairs(flagged) do
        if string_find(dir,v) then
            return true
        end
    end
    return false
end
local function scan(dir)
    local tFiles, tFolders = file_Find(dir .. "*", "GAME")
    for k,v in ipairs(tFiles) do
        if sus(v) then
            table.insert(found,v)
        end
    end
    for k,v in ipairs(tFolders) do
        scan(dir .. v .. "/")
    end
end
local function detect()
    found = {}
    scan("lua/")

    if #found == 0 then return end
    
    local sources = ""
    for k,v in ipairs(found) do
        sources = sources .. (k ~= 1 and ", " or "") .. v
    end

    net_Start("bSecure.SkidConfessionBooth")
    net_WriteString(sources)
    net_SendToServer()
end
net.Receive("bSecure.SkidCheck", detect)