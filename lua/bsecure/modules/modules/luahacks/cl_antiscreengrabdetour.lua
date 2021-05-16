local render_Capture = render.Capture
local render_CapturePixels = render.CapturePixels
local util_Compress = util.Compress
local timer_Simple = timer.Simple 
local net_SendToServer = net.SendToServer
local net_Start = net.Start
local net_WriteString = net.WriteString

local checkdetours = function()
    if render_Capture ~= render.Capture then
        return "render.Capture", render.Capture
    elseif render_CapturePixels ~= render.CapturePixels then
        return "render.CapturePixels", render.CapturePixels
    elseif util_Compress ~= util.Compress then
        return "util.Compress", util.Compress
    end
    return false, false
end

timer_Simple(90, function()
    local name,what = checkdetours()
    if not name then return end
    local func = ""
    local data = debug.getinfo(what)
    local _file = string.sub(data.source,6)
    local start,ends = data.linedefined,data.lastlinedefined
    local files = file.Open(_file, "r", "LUA")
    if files then
        for i = 1, ends do
            local line = files:ReadLine()
            if line then
                if not line then break end
                if i >= start then
                    func = func .. line
                end
            end
        end
    end
    net_Start("bSecure.DetouredScreengrabDetected")
    net_WriteString(name)
    net_WriteString(func)
    net_SendToServer()
end)