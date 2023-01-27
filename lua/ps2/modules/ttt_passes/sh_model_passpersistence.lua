Pointshop2.RolePass = class("Pointshop2.RolePass")
local RolePass = Pointshop2.RolePass

RolePass.static.DB = "Pointshop2"

RolePass.static.model = {
    tableName = "ps2_rolepass",

    fields = {
        itemPersistenceId = "int",
        material = "string",
        role = "string"
    },

    belongsTo = {
        ItemPersistence = {
            class = "Pointshop2.ItemPersistence",
            foreignKey = "itemPersistenceId",
            onDelete = "CASCADE"
        }
    }
}

RolePass:include(DatabaseModel)

RolePass:include(Pointshop2.EasyExport)

function RolePass.static.createOrUpdateFromSaveTable(saveTable, doUpdate)
    return Pointshop2.ItemPersistence.createOrUpdateFromSaveTable(saveTable, doUpdate):Then(function(itemPersistence)
        if doUpdate then
            return RolePass.findByItemPersistenceId(itemPersistence.id)
        else
            local weaponPersistence = RolePass:new()
            weaponPersistence.itemPersistenceId = itemPersistence.id
            return weaponPersistence
        end
    end):Then(function(passPersistence)
        passPersistence.material = saveTable.material
        passPersistence.role = saveTable.role
        return passPersistence:save()
    end)
end
