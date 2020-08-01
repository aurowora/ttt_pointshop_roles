-- Some TTT locals that need to be copied into this file to allow our custom select_roles() function to work

local function GetTraitorCount(ply_count)
    -- get number of traitors: pct of players rounded down
    local traitor_count = math.floor(ply_count * GetConVar("ttt_traitor_pct"):GetFloat())
    -- make sure there is at least 1 traitor
    traitor_count = math.Clamp(traitor_count, 1, GetConVar("ttt_traitor_max"):GetInt())
 
    return traitor_count
 end
 
 
 local function GetDetectiveCount(ply_count)
    if ply_count < GetConVar("ttt_detective_min_players"):GetInt() then return 0 end
 
    local det_count = math.floor(ply_count * GetConVar("ttt_detective_pct"):GetFloat())
    -- limit to a max
    det_count = math.Clamp(det_count, 1, GetConVar("ttt_detective_max"):GetInt())
 
    return det_count
 end

-- Basically the original TTT SelectRoles() function, but we've modified it to allow us to influence the roles a little bit.
local function select_roles()
    local choices = {}
    local prev_roles = {
       [ROLE_INNOCENT] = {},
       [ROLE_TRAITOR] = {},
       [ROLE_DETECTIVE] = {}
    };
 
    if not GAMEMODE.LastRole then GAMEMODE.LastRole = {} end
 
    local plys = player.GetAll()
 
    for k,v in ipairs(plys) do
       -- everyone on the spec team is in specmode
       if IsValid(v) and (not v:IsSpec()) then
          -- save previous role and sign up as possible traitor/detective
 
          local r = GAMEMODE.LastRole[v:SteamID()] or v:GetRole() or ROLE_INNOCENT
 
          table.insert(prev_roles[r], v)
 
          table.insert(choices, v)
       end
 
       v:SetRole(ROLE_INNOCENT)
    end
 
    -- determine how many of each role we want
    local choice_count = #choices
    local traitor_count = GetTraitorCount(choice_count)
    local det_count = GetDetectiveCount(choice_count)
 
    if choice_count == 0 then return end
 
    
    local ts = 0
    local ds = 0

    local max_t_pass = math.Clamp(math.Round(TTTPS_Config.MaxTPassesPerRound * traitor_count), 0, traitor_count)
    local max_d_pass = math.Clamp(math.Round(TTTPS_Config.MaxDPassesPerRound * det_count), 0, det_count)
    ServerLog(string.format('[TTT Pointshop Roles] %d traitor passes and %d detective passes are allowed to be used this round.\n', max_t_pass, max_d_pass))
    print(string.format('tttps_debug %d %d %d %d %d', choice_count, traitor_count, det_count, max_t_pass, max_d_pass))

    -- Get any players who may hold passes and try to choose them first
    for k,v in pairs(player.GetAll()) do
        if IsValid(v) and not v:IsSpec() then
            if v:TTTPS_HasTraitorPass() and ts < max_t_pass and ts < traitor_count then
                ts = ts + 1
                v:SetRole(ROLE_TRAITOR)
                v:TTTPS_SetTraitorPass(false)
                v:TTTPS_SendMsg('Your Traitor pass has been consumed.')
                table.RemoveByValue(choices, v)
            elseif v:TTTPS_HasDetectivePass() and ds < max_d_pass and ds < det_count then
                ds = ds + 1
                v:SetRole(ROLE_DETECTIVE)
                v:TTTPS_SetDetectivePass(false)
                v:TTTPS_SendMsg('Your Detective pass has been consumed.')
                table.RemoveByValue(choices, v)
            end
        end
    end

    -- first select traitors
    while (ts < traitor_count) and (#choices >= 1) do
       -- select random index in choices table
       local pick = math.random(1, #choices)
 
       -- the player we consider
       local pply = choices[pick]
 
       -- make this guy traitor if he was not a traitor last time, or if he makes
       -- a roll
       if IsValid(pply) and
          ((not table.HasValue(prev_roles[ROLE_TRAITOR], pply)) or (math.random(1, 3) == 2)) then
          pply:SetRole(ROLE_TRAITOR)
 
          table.remove(choices, pick)
          ts = ts + 1
       end
    end
 
    -- now select detectives, explicitly choosing from players who did not get
    -- traitor, so becoming detective does not mean you lost a chance to be
    -- traitor
    local min_karma = GetConVarNumber("ttt_detective_karma_min") or 0
    while (ds < det_count) and (#choices >= 1) do
 
       -- sometimes we need all remaining choices to be detective to fill the
       -- roles up, this happens more often with a lot of detective-deniers
       if #choices <= (det_count - ds) then
          for k, pply in ipairs(choices) do
             if IsValid(pply) then
                pply:SetRole(ROLE_DETECTIVE)
             end
          end
 
          break -- out of while
       end
 
 
       local pick = math.random(1, #choices)
       local pply = choices[pick]
 
       -- we are less likely to be a detective unless we were innocent last round
       if (IsValid(pply) and
           ((pply:GetBaseKarma() > min_karma and
            table.HasValue(prev_roles[ROLE_INNOCENT], pply)) or
            math.random(1,3) == 2)) then
 
          -- if a player has specified he does not want to be detective, we skip
          -- him here (he might still get it if we don't have enough
          -- alternatives)
          if not pply:GetAvoidDetective() then
             pply:SetRole(ROLE_DETECTIVE)
             ds = ds + 1
          end
 
          table.remove(choices, pick)
       end
    end
 
    GAMEMODE.LastRole = {}
 
    for _, ply in ipairs(plys) do
       -- initialize credit count for everyone based on their role
       ply:SetDefaultCredits()
 
       -- store a steamid -> role map
       GAMEMODE.LastRole[ply:SteamID()] = ply:GetRole()

       -- Decrement everybody's wait time
       local rounds_l_t = ply:TTTPS_RoundsToNextTPass()
       local rounds_l_d = ply:TTTPS_RoundsToNextDPass()

       ply:TTTPS_SetRoundsToNextTPass(math.max(0, rounds_l_t - 1))
       ply:TTTPS_SetRoundsToNextDPass(math.max(0, rounds_l_d - 1))

       -- Lastly, send everybody who didn't get to use their pass a message
       if ply:TTTPS_HasDetectivePass() and ply:GetRole() ~= ROLE_DETECTIVE then
            ply:TTTPS_SendMsg('Too many people used Detective passes this round. You will have another chance to use yours next round.')
       elseif ply:TTTPS_HasDetectivePass() then
            ply:TTTPS_SendMsg('Your Detective pass was NOT consumed. You were randomly selected by TTT to become a Detective.')
            ply:TTTPS_SendMsg('You will have another chance to use your pass next round.')
       end

       if ply:TTTPS_HasTraitorPass() and ply:GetRole() ~= ROLE_TRAITOR then
            ply:TTTPS_SendMsg('Too many people used Traitor passes this round. You will have another chance to use yours next round')
       elseif ply:TTTPS_HasTraitorPass() then
            ply:TTTPS_SendMsg('Your Traitor pass was NOT consumed. You were randomly selected by TTT to become a Traitor.')
            ply:TTTPS_SendMsg('You will have another chance to use your pass next round.')
       end
    end
 end

 timer.Simple(7, function ()
    print('[TTT Pointshop Roles] Overriding SelectRoles()')
    SelectRoles = select_roles
    ServerLog('[TTT Pointshop Roles] Activated. If you find TTT Pointshop Roles or another addon that messes with roles doesn\'t work, you may have incompatible addons.\n')
 end)