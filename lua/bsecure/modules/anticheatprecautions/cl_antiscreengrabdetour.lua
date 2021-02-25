local render_Capture = render.Capture
local render_CapturePixels = render.CapturePixels
local util_Compress = util.Compress
local net_SendToServer = net.SendToServer
local net_Start = net.Start 
local timer_Simple = timer.Simple 

local function checkScreengrabDetours()
    if  render.Capture ~= render_Capture or
        render.CapturePixels ~= render_CapturePixels or
        util.Compress ~= util_Compress then

        net_Start("bSecure.DetouredScreengrabDetected")
        net_SendToServer()
    end
    timer_Simple(60,checkScreengrabDetours)
end
timer_Simple(60,checkScreengrabDetours)
