do return end -- disabled module. broken as shit

local file_Exists = file.Exists
local file_CreateDir = file.CreateDir
local os_date = os.date
local file_Append = file.Append
local string_find = string.find
local string_gsub = string.gsub
local string_lower = string.lower
local print = print
local tostring = tostring
bSecure.AntiBackdoor = {} -- if you use leaked addons kys

bSecure.AntiBackdoor.Detours = {
    ["http"] = {
        ["Fetch"] = http.Fetch
    },
    ["RunString"] = RunString,
    ["RunStringEx"] = RunStringEx,
    ["CompileString"] = CompileString,
    ["Player"] = {
        ["SendLua"] = FindMetaTable("Player").SendLua
    }
}

local URLWhitelist, _ = bSecure.ArrayToList({ -- here's the start retard, you finish it off. This must be an array of url's

})

if not file_Exists("bsecure/backdoor", "DATA") then
    file_CreateDir("bsecure/backdoor")
end

if not file_Exists("bsecure/backdoor/detections", "DATA") then
    file_CreateDir("bsecure/backdoor/detections")
end

if not file_Exists("bsecure/backdoor/logs", "DATA") then
    file_CreateDir("bsecure/backdoor/logs")
end

function bSecure.AntiBackdoor.WriteDataLog(bDetected, sID, ...)
    local tParams, sParams = {...}, ""
    for i = 1, #tParams do
        sParams = sParams .. tParams[i]
    end

    local time = "["..os_date("%X").."] "
    local day = os_date("%m_%d_%y")
    local directory = "bsecure/backdoor/"..(bDetected and "detections" or "logs")
    if not file_Exists(directory, "DATA") then
        file_CreateDir(directory)
    end
    directory = directory .. "/" .. day .. "_" .. sID .. ".txt"

    file_Append(directory, time..sParams.."\n")
end

local debug_getinfo = debug.getinfo

function bSecure.AntiBackdoor.ReadURL(sURL)
    if URLWhitelist[sURL] then
        return false
    end
    return 
        string_find(sURL, ".php") or
        string_find(sURL, "g-hub.xyz") or
        string_find(sURL, "smart-overwrite") or
        string_find(sURL, "omega-project") or
        string_find(sURL, "drm.gm.esy.es")
    or
        false
end

function bSecure.AntiBackdoor.ReadString(sCode, sID)
    sID = string_gsub(sID, " ", "")
    sCode = string_lower(sCode or "")
    return 
        string_find(sCode, ":ban") or
        string_find(sCode, ".ban") or
        string_find(sCode, "http") or 
        string_find(sCode, "addmoney") or
        string_find(sCode, "setusergroup") or 
        string_find(sCode, "runstring")
    or
        (sID == ":" or sID == "ERROR" or sID == ">")
    or
        false
end

local PLAYER = debug.getregistry().Player
function PLAYER:SendLua(code, ...)
    bSecure.AntiBackdoor.WriteDataLog(false, "player_sendlua", "Player:SendLua executed on ".. bSecure.FormatPlayer(self) .. " : ".. (debug_getinfo(2).source or "Unknown Source") .. " : " .. (string_gsub(code, "\n", "")))
    if
        string_find(code, "http.Post") or
        string_find(code, ".php")
    then
        bSecure.PrintDetection("Prevented a potentially malicious script from running, sent to ".. bSecure.FormatPlayer(self) .. ". Check bsecure/backdoor/detections")
        bSecure.AntiBackdoor.WriteDataLog(true, "player_sendlua", "Prevented Player:SendLua from executing on ".. bSecure.FormatPlayer(self) .. " : ".. (debug_getinfo(2).source or "Unknown Source") .. " : " .. (string_gsub(code, "\n", "")))
        return
    end
    return bSecure.AntiBackdoor.Detours.Player.SendLua(self, code, ...)
end

local tInfo
local httpFetch
function http.Fetch(sURL, ...)
    print(sURL)
    tInfo = debug_getinfo(2)
    if httpFetch then
        if httpFetch ~= http.Fetch then
            bSecure.PrintDetection("Potential backdoor fuckery, no action will be taken because of this. http.Fetch was detoured: "..debug_getinfo(http.Fetch).source)
        end
    end
    bSecure.AntiBackdoor.WriteDataLog(false, "httpFetch", "http.Fetch executed from: "..(tInfo.source or "Unknown Source").." : ".. sURL)
    if bSecure.AntiBackdoor.ReadURL(sURL) then
        bSecure.PrintDetection("Prevented a potentially malicious http.Fetch from executing. Check bsecure/backdoor/detections")
        bSecure.AntiBackdoor.WriteDataLog(true, "httpFetch", "Prevented http.Fetch from executing: ".. (tInfo.source or "Unknown Source") .." : ".. sURL ..": Remove the backdoor retard, or whitelist it.")
        return
    end
    return bSecure.AntiBackdoor.Detours.http.Fetch(sURL, ...)
end
httpFetch = http.Fetch

function CompileString(sCode, sID, bHandleError)
    tInfo = debug_getinfo(2)
    bSecure.AntiBackdoor.WriteDataLog(false, "CompileString", "CompileString executed from: "..(tInfo.source or "Unknown Source")..": ".. string_gsub(sCode, "\\n", "").. "\"".. sID .. "\" : ".. tostring(bHandleError))
    if bSecure.AntiBackdoor.ReadString(sCode, sID) then
        bSecure.AntiBackdoor.WriteDataLog(true, "CompileString", "Prevented CompileString executed from: "..(tInfo.source or "Unknown Source")..": ".. string_gsub(sCode, "\\n", "").. "\"".. sID .. "\" : ".. tostring(bHandleError))
        bSecure.PrintDetection("Prevented a potentially malicious CompileString from executing. Check bsecure/backdoor/detections")
        return function()
            print("["..sID.."] mfw retard")
        end
    end
    return bSecure.AntiBackdoor.Detours.CompileString(sCode, sID, bHandleError)
end

function RunString(sCode, sID, bHandleError)
    tInfo = debug_getinfo(2)
    bSecure.AntiBackdoor.WriteDataLog(false, "RunString", "RunString executed from: "..(tInfo.source or "Unknown Source")..": ".. string_gsub(sCode, "\\n", "").. "\"".. sID .. "\" : ".. tostring(bHandleError))
    if bSecure.AntiBackdoor.ReadString(sCode, sID) then
        bSecure.AntiBackdoor.WriteDataLog(true, "RunString", "Prevented RunString executed from: "..(tInfo.source or "Unknown Source")..": ".. string_gsub(sCode, "\\n", "").. "\"".. sID .. "\" : ".. tostring(bHandleError))
        bSecure.PrintDetection("Prevented a potentially malicious RunString from executing. Check bsecure/backdoor/detections")
        return "fucking fag"
    end
    return bSecure.AntiBackdoor.Detours.RunString(sCode, sID, bHandleError)
end

--[[ cba anymore
function HTTP(arguments)
    
end
]]
RunStringEx = RunString
