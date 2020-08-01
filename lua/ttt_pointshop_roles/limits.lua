local meta = FindMetaTable('Player')

if not meta then
    error('Whoops! Couldn\'t find the Player meta table!')
end

function meta:TTTPS_CanPlayerBuyTPass()
    if self:TTTPS_HasTraitorPass() then
        return false, 'You already have an active Traitor pass.'
    end
    
    if TTTPS_Config.AllowedGroups and not table.HasValue(TTTPS_Config.AllowedGroups, self:GetUserGroup()) then
        return false, 'You\'re not in the right group to buy this.'
    end

    local rounds_until_pass = self:TTTPS_RoundsToNextTPass()

    if rounds_until_pass > 0 then
        return false, string.format('You must wait %d more rounds before you can buy this.', rounds_until_pass)
    end

    return true, 'hi'
end

function meta:TTTPS_CanPlayerBuyDPass()
    if self:TTTPS_HasDetectivePass() then
        return false, 'You already have an active Detective pass.'
    end

    if TTTPS_Config.AllowedGroups and not table.HasValue(TTTPS_Config.AllowedGroups, self:GetUserGroup()) then
        return false, 'You\'re not in the right group to buy this.'
    end

    local rounds_until_pass = self:TTTPS_RoundsToNextDPass()

    if rounds_until_pass > 0 then
        return false, string.format('You must wait %d more rounds before you can buy this.', rounds_until_pass)
    end

    return true, 'hi'
end

function meta:TTTPS_OnBuyTPass()
    --Group specific limits are priority
    if TTTPS_Config.TraitorPassFreq and TTTPS_Config.TraitorPassFreq[self:GetUserGroup()] then
        self:TTTPS_SetRoundsToNextTPass(TTTPS_Config.TraitorPassFreq[self:GetUserGroup()])
    elseif TTTPS_Config.GlobalPassFreq then
        self:TTTPS_SetRoundsToNextTPass(TTTPS_Config.GlobalPassFreq)
    else
        self:TTTPS_SetRoundsToNextTPass(0)
    end
end

function meta:TTTPS_OnBuyDPass()
    if TTTPS_Config.DetectivePassFreq and TTTPS_Config.DetectivePassFreq[self:GetUserGroup()] then
        self:TTTPS_SetRoundsToNextDPass(TTTPS_Config.DetectivePassFreq[self:GetUserGroup()])
    elseif TTTPS_Config.GlobalPassFreq then
        self:TTTPS_SetRoundsToNextDPass(TTTPS_Config.GlobalPassFreq)
    else
        self:TTTPS_SetRoundsToNextDPass(0)
    end
end