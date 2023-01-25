-- Define the class
Pointshop2.RolePass = class("Pointshop2.RolePass")
local RolePass = Pointshop2.RolePass

-- Link to the Pointshop2 Database
RolePass.static.DB = "Pointshop2"

-- Define model fields
RolePass.static.model = {
    -- Name of the SQL Table
    tableName = "ps2_rolepass",

    -- Table columns:
    fields = {
        -- Foreign key, needed to link to the basic item info row
        itemPersistenceId = "int",
        material = "string",
        role = "string"
    },

    -- Link to the item persistence of base_pointshop_item
    belongsTo = {
        ItemPersistence = {
            class = "Pointshop2.ItemPersistence",
            foreignKey = "itemPersistenceId",
            onDelete = "CASCADE"
        }
    }
}

-- Include Database Logic (creating tables, adding accessor functions)
RolePass:include(DatabaseModel)

-- Include EasyExport: Makes it possible to import/export the item
RolePass:include(Pointshop2.EasyExport)

--[[
    Called by the Item Creator to update or create a persistence.
    Args:
    - saveTable: A table of custom fields created by the creator
    - doUpdate: A boolean, true if we are updating an item, false if 
                creating it.
]] --
function RolePass.static.createOrUpdateFromSaveTable(saveTable, doUpdate)
    -- call the base item createOrUpdateFromSaveTable to save basic item info (description, name, price, etc.) 
    return Pointshop2.ItemPersistence.createOrUpdateFromSaveTable(saveTable, doUpdate):Then(function(itemPersistence)
        if doUpdate then
            -- Find the database row to update
            return RolePass.findByItemPersistenceId(itemPersistence.id)
        else
            -- Create a new database row
            local weaponPersistence = RolePass:new()
            -- link the basic item info
            weaponPersistence.itemPersistenceId = itemPersistence.id
            return weaponPersistence
        end
    end):Then(function(passPersistence)
        -- Set our custom properties
        -- lowGravPersistence.multiplier = saveTable.multiplier
        passPersistence.material = saveTable.material
        passPersistence.role = saveTable.role
        return passPersistence:save()
    end)
end
