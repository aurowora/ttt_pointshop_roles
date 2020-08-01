if not TTTPS_Config then
    include('ttt_pointshop_roles/config.lua')
end

ITEM.Name = 'Detective Pass'
ITEM.Price = TTTPS_Config.DPassPrice or 500
ITEM.Model = 'models/props_lab/huladoll.mdl'
ITEM.AllowedUserGroups = TTTPS_Config.AllowedGroups or nil
ITEM.SingleUse = true
ITEM.NoPreview = true
ITEM.Except = true

function ITEM:OnBuy(ply)
    ply:TTTPS_OnBuyDPass()
    ply:TTTPS_SetDetectivePass(true)
    ply:TTTPS_SendMsg('You have purchased a Detective pass. You will be a Detective next round.')
end

function ITEM:CanPlayerBuy(ply)
    local can_buy, reason = ply:TTTPS_CanPlayerBuyDPass()

    if not can_buy then
        ply:TTTPS_SendMsg(reason)
        return false
    else
        return true
    end
end