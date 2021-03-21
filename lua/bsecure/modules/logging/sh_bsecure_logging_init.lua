bSecure.Logs = {iStored = {}}

local time = os.time
local insert = table.insert
local hook_Add = hook.Add
local hook_Run = hook.Run
local ipairs = ipairs
local isnumber = isnumber

local MODULE = {}
--MODULE.Name = "Undefined"

function MODULE:Log(tCopyData, strLog, ...) -- Log, String Format
    if (...) then
        strLog = strLog:format(...)
    end
    local tLog = {
        time = time(),
        log = strLog,
        copy = tCopyData or {},
    }
    local index = insert(bSecure.Logs.iStored[self.ID].Logs,tLog)
    hook_Run("bSecure.OnLog", self.ID, index)
end

function MODULE:SimpleLog(strLog, ...)
    return self:Log({}, strLog, ...) 
end

function MODULE:Initialize()
    insert(bSecure.Logs.iStored,self)
end 

function MODULE:SetName(strName)
    self.Name = strName
end

function MODULE:Hook(strName, fCallback)
    hook_Add(strName,"bSecure.Logging.Module."..self.Name,fCallback)
end
MODULE.__index = MODULE

local modCount = 0
function bSecure.Logs.CreateModule(strName)
    local mod = setmetatable({},MODULE)
    modCount = modCount + 1
    mod.Logs = {}
    mod.ID = modCount
    mod.Name = strName
    mod:Initialize()
    return mod
end


function bSecure.Logs.GetStored(Data)
    if isstring(Data) then
        for k,v in ipairs(bSecure.Logs.iStored) do
            if v.Name == Data then
                return bSecure.Logs.iStored[k]
            end
        end
    elseif isnumber(Data) then
        return bSecure.Logs.iStored[Data]
    end
end