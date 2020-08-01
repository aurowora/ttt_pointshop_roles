if not TTTPS_Config then
    include('ttt_pointshop_roles/config.lua')
end

ITEM.Name = 'Traitor Pass'
ITEM.Price = TTTPS_Config.TPassPrice or 500
ITEM.Model = 'models/weapons/w_knife_t.mdl'
ITEM.AllowedUserGroups = TTTPS_Config.AllowedGroups or nil
ITEM.SingleUse = true
ITEM.NoPreview = true
ITEM.Except = true

function ITEM:OnBuy(ply)
    ply:TTTPS_OnBuyTPass()
    ply:TTTPS_SetTraitorPass(true)
    ply:TTTPS_SendMsg('You have purchased a Traitor pass. You will be a Traitor next round.')
end

function ITEM:CanPlayerBuy(ply)
    local can_buy, reason = ply:TTTPS_CanPlayerBuyTPass()

    if not can_buy then
        ply:TTTPS_SendMsg(reason)
        return false
    else
        return true
    end
end