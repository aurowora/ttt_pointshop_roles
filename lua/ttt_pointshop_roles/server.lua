include('ttt_pointshop_roles/config.lua')
include('ttt_pointshop_roles/persist.lua')
include('ttt_pointshop_roles/limits.lua')

local meta = FindMetaTable('Player')

if not meta then
    error('Whoops! Couldn\'t find the Player meta table!')
end

util.AddNetworkString('TTTPSRoles_SendMsg')

-- Quick function to print a chat message in the player's chat
function meta:TTTPS_SendMsg(msg)
    net.Start('TTTPSRoles_SendMsg')
    net.WriteString(msg)
    net.Send(self)
end

include('ttt_pointshop_roles/role_selection.lua')