local math_random = math.random
local string_upper = string.upper
local ScrW = ScrW
local ScrH = ScrH
local util_Base64Encode = util.Base64Encode
local render_Capture = render.Capture
local hook_Add = hook.Add
local net_Receive = net.Receive
local net_ReadString = net.ReadString
local hook_GetTable = hook.GetTable
local LocalPlayer = LocalPlayer
local net_ReadUInt = net.ReadUInt
local http_Fetch = http.Fetch
local file_Exists = file.Exists
local file_CreateDir = file.CreateDir
local os_date = os.date
local file_Write = file.Write
local net_Start = net.Start
local net_WriteUInt = net.WriteUInt
local net_WriteEntity = net.WriteEntity
local net_SendToServer = net.SendToServer
local print = function() end

bSecure.Screengrab = {}

local chars = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","."}
local function generateString()
    local str = ""
    for i = 1, math_random(14, 28) do
        str = str .. (math_random() > 0.5 and string_upper(chars[math_random(1,#chars)]) or chars[math_random(1,#chars)])
    end
    return str
end

local SnapRecipient
local SendToServer
local SendToSender
local PostRender
local isCapturing = false

PostRender = function()
    if not isCapturing then return end
    print("Snapping...")
    local capData = {
        format = "jpeg", quality = iQuality,
        x = 0, y = 0,
        w = ScrW(), h = ScrH()
    }
    local imgData = util_Base64Encode(render_Capture(capData))
    HTTP{
        ["method"] = "POST",
        ["url"] = "https://api.imgur.com/3/upload",
        ["parameters"] = {
            ["title"] = LocalPlayer():SteamID(),
            ["image"] = imgData,
            ["type"] = "base64",
        },
        success = function(_, sBody)
            print(sBody)
            net.Start(SendToServer)
            net.WriteString(sBody)
            net.SendToServer()
        end
    }
    isCapturing = false
end

local hookID = generateString()
hook_Add("PostRender", hookID, PostRender)

net_Receive("bSecure.Screengrab.Initialize", function()
    print("Screengrab initialised")
    SnapRecipient = net_ReadString()
    SendToServer = net_ReadString()
    SendToSender = net_ReadString()

    net_Receive(SnapRecipient, function()
        print("Being screengrabbed")
        if hook_GetTable()["PostRender"][hookID] ~= PostRender then
            LocalPlayer():ChatPrint("Don't be overwriting hooks sir")
            bSecure.Print("Don't be overwriting hooks sir")
            hook_Add("PostRender", hookID, PostRender)
        end
        local iQuality = net_ReadUInt(7)
        isCapturing = true
    end)

    net_Receive(SendToSender, function()
        local sURL, sRecipient = net_ReadString(), net_ReadString()
        local imgDir = "bsecure/screengrabs/client/"..sRecipient
        print("Received screengrab data for ".. sRecipient .. "\n\turl: ".. sURL.."\n\tdir: "..imgDir)
        http_Fetch(sURL, function(sImageData)
            if !sImageData then
                return
            end
            if not file_Exists(imgDir, "DATA") then
                file_CreateDir(imgDir)
            end
            local fileName = os_date("%m_%d_%y %H_%M")
            ::tryAgain::
            if file_Exists(imgDir.."/"..fileName..".jpg", "DATA") then
                fileName = fileName.."_"
                goto tryAgain
            end
            file_Write(imgDir.."/"..fileName..".jpg", sImageData)
            LocalPlayer():ChatPrint("Successfully screengrabbed ".. sRecipient..". Check garrysmod/data/bsecure/screengrab for results!")
        end)
    end)
end)

function bSecure.Screengrab.Snap(pRecipient)
    if not LocalPlayer():IsAdmin() then return end
    --print("Requesting snap")
    net_Start(SnapRecipient)
    net_WriteUInt(66,8)
    net_WriteEntity(pRecipient)
    net_SendToServer()
end