bSecure.Screengrab = {}

local chars = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","."}
local function generateNetString()
    local str = ""
    for i = 1, math.random(14, 28) do
        str = str .. (math.random() > 0.5 and string.upper(chars[math.random(1,#chars)]) or chars[math.random(1,#chars)])
    end
    util.AddNetworkString(str)
    return str
end

local SnapRecipient = generateNetString()
local SendToServer = generateNetString()
local SendToSender = generateNetString()

util.AddNetworkString("bSecure.Screengrab.Initialize")
function bSecure.Screengrab.InitializeClient(pPlayer)
    if not IsValid(pPlayer) then return end
    net.Start("bSecure.Screengrab.Initialize")
    net.WriteString(SnapRecipient)
    net.WriteString(SendToServer)
    net.WriteString(SendToSender)
    net.Send(pPlayer)
end

hook.Add("PlayerInitialSpawn", "bSecure.Screengrab.InitializeClient", bSecure.Screengrab.InitializeClient)

local screengrabQueue = {}
function bSecure.Screengrab.Snap(pRecipient, iQuality, pSender)
    if !pRecipient then return end
    if screengrabQueue[pRecipient] then
        bSecure.CreateNotification(pSender, "This player is already being screengrabbed.")
        return
    end

    iQuality = iQuality or 50
    screengrabQueue[pRecipient] = pSender or false
    net.Start(SnapRecipient)
    net.WriteUInt(iQuality, 7)
    net.Send(pRecipient)
    print("Trying to screengrab ", pRecipient)
end

net.Receive(SnapRecipient, function(iLength, pAdmin)
    if not pAdmin:IsAdmin() then
        return bSecure.BanPlayer(pAdmin, "[bSecure] Attempted to exploit net messages - screengrab.")
    end
    local iQuality, pRecipient = net.ReadUInt(8), net.ReadEntity()
    if not IsValid(pRecipient) or not IsEntity(pRecipient) or not pRecipient:IsPlayer() or not iQuality then  print("Got some invalid data", pRecipient, iQuality, pAdmin) return end
    bSecure.Screengrab.Snap(pAdmin, iQuality, pRecipient)
end)

net.Receive(SendToServer, function(iLength, pRecipient)
    if not screengrabQueue[pRecipient] then
        bSecure.KickPlayer(pRecipient, "[bSecure] Sending unrequested data.")
        return
    end

    local sImgData = net.ReadString()
    local tImgData = util.JSONToTable(sImgData)
    --PrintTable(tImgData)
    if not tImgData.success then
        if IsValid(screengrabQueue[pRecipient]) then
            bSecure.ChatPrint(screengrabQueue[pRecipient], "Something went wrong screengrabbing ".. bSecure.FormatPlayer(pRecipient))
        end
        bSecure.PrintError(screengrabQueue[pRecipient], "Something went wrong screengrabbing ".. bSecure.FormatPlayer(pRecipient))
        return
    end

    local imgDir = "bsecure/screengrabs/server/"..pRecipient:SteamID64()
    http.Fetch(tImgData.data.link, function(sImageData)
        if !sImageData then
            return
        end
        if not file.Exists(imgDir, "DATA") then
            file.CreateDir(imgDir)
        end
        local fileName = os.date("%m_%d_%y %H_%M")
        ::tryAgain::
        if file.Exists(imgDir.."/"..fileName..".jpg", "DATA") then
            fileName = fileName.."_"
            goto tryAgain
        end
        file.Write(imgDir.."/"..fileName..".jpg", sImageData)
    end)

    if IsValid(screengrabQueue[pRecipient]) then
        net.Start(SendToSender)
        net.WriteString(tImgData.data.link)
        net.WriteString(pRecipient:SteamID64())
        net.Send(screengrabQueue[pRecipient])
    end

    screengrabQueue[pRecipient] = nil
end)
