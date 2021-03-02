local suspiciousKeys = {
    [KEY_INSERT] = "INSERT",
    [KEY_END] = "END",
    [KEY_HOME] = "HOME",
    [KEY_DELETE] = "DELETE",
}

hook.Add("PlayerButtonDown", "bSecure.SuspiciousKeyLogger", function(pPlayer, iKey)
    if suspiciousKeys[iKey] then
        bSecure.PrintDetection(pPlayer:Nick().."["..pPlayer:SteamID64().."] has pressed a suspicious key: ".. suspiciousKeys[iKey])
    end
end)
