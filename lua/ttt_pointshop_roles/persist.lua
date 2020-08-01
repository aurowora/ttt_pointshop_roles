local meta = FindMetaTable('Player')

if not meta then
    error('Whoops! Couldn\'t find the Player meta table!')
end

if not file.Exists('ttt_pointshop_roles', 'DATA') then
    file.CreateDir('ttt_pointshop_roles')
end

local function load_player(ply)
    local fi = file.Read('ttt_pointshop_roles/' .. ply:SteamID64() .. '.dat', 'DATA')

    if fi then
        local dc = util.Decompress(fi)
        if dc then
            ply.TTTPS_Data = util.JSONToTable(dc)
        end
    end

end

hook.Add('PlayerInitialSpawn', 'TTTPointshopRoles_PlayerInitialSpawn', load_player)

local function save_player(ply)
    if not ply.TTTPS_Data or (not ply.TTTPS_Data.hasTraitorPass and not ply.TTTPS_Data.hasDetectivePass and ply:TTTPS_RoundsToNextDPass() == 0 and ply:TTTPS_RoundsToNextTPass() == 0) then
        file.Delete('ttt_pointshop_roles/' .. ply:SteamID64() .. '.dat')
        return
    end

    local c = util.Compress(util.TableToJSON(ply.TTTPS_Data))
    file.Write('ttt_pointshop_roles/' .. ply:SteamID64() .. '.dat', c)
end

function meta:TTTPS_SetTraitorPass(b_traitorPass)
    self.TTTPS_Data = self.TTTPS_Data or {}
    self.TTTPS_Data.hasTraitorPass = b_traitorPass

    save_player(self)
end

function meta:TTTPS_SetDetectivePass(b_detectivePass)
    self.TTTPS_Data = self.TTTPS_Data or {}
    self.TTTPS_Data.hasDetectivePass = b_detectivePass

    save_player(self)
end

function meta:TTTPS_SetRoundsToNextTPass(rounds)
    self.TTTPS_Data = self.TTTPS_Data or {}
    self.TTTPS_Data.roundsUntilNextTPass = rounds

    save_player(self)
end

function meta:TTTPS_SetRoundsToNextDPass(rounds)
    self.TTTPS_Data = self.TTTPS_Data or {}
    self.TTTPS_Data.roundsUntilNextDPass = rounds

    save_player(self)
end

function meta:TTTPS_HasTraitorPass()
    return self.TTTPS_Data and (self.TTTPS_Data.hasTraitorPass and self.TTTPS_Data.hasTraitorPass or false) or false
end

function meta:TTTPS_HasDetectivePass()
    return self.TTTPS_Data and (self.TTTPS_Data.hasDetectivePass and self.TTTPS_Data.hasDetectivePass or false) or false
end

function meta:TTTPS_RoundsToNextTPass()
    return self.TTTPS_Data and (self.TTTPS_Data.roundsUntilNextTPass and self.TTTPS_Data.roundsUntilNextTPass or 0) or 0
end

function meta:TTTPS_RoundsToNextDPass()
    return self.TTTPS_Data and (self.TTTPS_Data.roundsUntilNextDPass and self.TTTPS_Data.roundsUntilNextDPass or 0) or 0
end