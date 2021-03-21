local notifications = {}
function bSecure.NotificationAdd(strText, iType, iDuration)
    strText = strText or "No text provied"
    iType = iType or 0
    iDuration = iDuration or 4
    local iIndex = table.insert(notifications,{
        strText,
        iType,
        iDuration,
        CurTime(),
    })
end

local height = 40
local icon = Material("bsecure/icon.png")
hook.Add("HUDPaint", "bSecure.Notifs", function()
    for k,v in ipairs(notifications) do
        if CurTime()-v[4] > v[3] then
            table.remove(notifications,k)
            return
        end
        surface.SetFont("bSecure.Title")
        local textWidth, textHeight = surface.GetTextSize(v[1])
        local barHeight = 38
        local barWidth = textWidth + 10 + barHeight -- margin of 5 on each side of the text + barHeight to make room for the icon

        local targetY = ScrH() * 0.9 - ((k-1) * (barHeight + 4))
        local yPos = Lerp((CurTime() - v[4]) / 0.2, (yPos or ScrH()), targetY)

        local xPos = ScrW()/2 - barWidth/2


        surface.SetDrawColor(59, 59, 63)
        surface.DrawRect(xPos, yPos, barWidth, barHeight)

        surface.SetDrawColor(36, 36, 39)
        surface.DrawRect(xPos, yPos, barHeight, barHeight)

        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(icon)
        surface.DrawTexturedRect(xPos, yPos, barHeight, barHeight)

        surface.SetTextColor(color_white)
        surface.SetTextPos(xPos + barHeight + 5 , (yPos + barHeight/2) - textHeight/2)
        surface.DrawText(v[1])
    end
end)