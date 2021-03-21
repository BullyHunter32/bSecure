local hook_Add = hook.Add
local net_Start = net.Start
local net_SendToServer = net.SendToServer
local net_WriteUInt = net.WriteUInt
local net_WriteString = net.WriteString
local suspiciousKeys = bSecure.SuspiciousKeys
local math_random = math.random 
local lookupBind = input.LookupKeyBinding
local timer_Simple = timer.Simple

local chars = {
    "a",
    "b",
    "hq",
    "qe",
    "qh",
    "eh",
    "om",
    "p3",
    "go",
}
local function generateString()
    local str = ""
    for i = 1, math_random(8,16) do
        str = str .. chars[math.random(1,#chars)]
    end
    return str
end

hook_Add("InitPostEntity", generateString(), function()
    timer_Simple(4, function()
        net_Start("bSecure.SuspiciousKeyLogger")
            for key,_ in pairs(suspiciousKeys) do
                net_WriteString(lookupBind(key) or "NOT BOUND")
            end
        net_SendToServer()
    end)
end)