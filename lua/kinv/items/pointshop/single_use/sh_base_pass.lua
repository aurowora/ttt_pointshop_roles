ITEM.baseClass = "base_single_use"
ITEM.stackCount = 1
ITEM.material = ""
ITEM.role = "traitor"
ITEM.PrintName = "Base Role Pass"

function ITEM:CanBeUsed()
    local canBeUsed, reason = ITEM.super.CanBeUsed(self)
    if not canBeUsed then
        return false, reason
    end

    if CLIENT then
        return true
    else
        local ply = self:GetOwner()

        if self.role == "traitor" then
            local canBuy, reason = ply:TTTPS_CanPlayerBuyTPass()
            if not canBuy then
                ply:PS2_DisplayError("You cannot use this item: " .. reason, 3)
                return false, reason
            end
        elseif self.role == "detective" then
            local canBuy, reason = ply:TTTPS_CanPlayerBuyDPass()
            if not canBuy then
                ply:PS2_DisplayError("You cannot use this item: " .. reason, 3)
                return false, reason
            end
        end
    end

    return true
end

function ITEM:OnUse()
    local ply = self:GetOwner()

    if self.role == "traitor" then
        ply:TTTPS_OnBuyTPass()
        ply:TTTPS_SetTraitorPass(true)
        ply:TTTPS_SendMsg('You have purchased a Traitor pass. You will be a Traitor next round.')
    elseif self.role == "detective" then
        ply:TTTPS_OnBuyDPass()
        ply:TTTPS_SetDetectivePass(true)
        ply:TTTPS_SendMsg('You have purchased a Detective pass. You will be a Detective next round.')
    end
end

function ITEM.static.getPersistence()
    return Pointshop2.RolePass
end

function ITEM.static.generateFromPersistence(itemTable, persistence)
    ITEM.super.generateFromPersistence(itemTable, persistence.ItemPersistence)

    itemTable.material = persistence.material
    itemTable.role = persistence.role
end

function ITEM.static:GetPointshopIconDimensions()
    return Pointshop2.GenerateIconSize(4, 4)
end
