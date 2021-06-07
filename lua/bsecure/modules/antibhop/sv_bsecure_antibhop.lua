hook.Add("OnPlayerHitGround", "bSecure.AntiBHop", function(pPlayer)
    local curVelocity = pPlayer:GetVelocity()
    pPlayer:SetVelocity( -Vector(curVelocity.x * 0.25, curVelocity.y * 0.25, 0) )
end)