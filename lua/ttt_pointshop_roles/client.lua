net.Receive('TTTPSRoles_SendMsg', function ()
    local msg = net.ReadString()

    chat.AddText(Color(255, 100, 100), '[TTT Pointshop Roles] ', Color(255, 255, 255), msg)
end)