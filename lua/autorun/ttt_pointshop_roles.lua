AddCSLuaFile()

if SERVER then
    include('ttt_pointshop_roles/server.lua')
    AddCSLuaFile('ttt_pointshop_roles/client.lua')
else
    include('ttt_pointshop_roles/client.lua')
end