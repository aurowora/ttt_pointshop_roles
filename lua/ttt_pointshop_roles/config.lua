AddCSLuaFile()

TTTPS_Config = {}

-- These groups can purchase passes
-- Set to nil for no restrictions
-- This should be a table with each group as a value
TTTPS_Config.AllowedGroups = nil

-- This controls how often individual groups can purchase a Traitor pass
-- Set to nil for no restrictions
-- This should be a table with groups as keys and positive numbers as values

TTTPS_Config.TraitorPassFreq = nil

-- This controls how often individual groups can purchase a Detective pass
-- Set to nil for no restrictions
-- This should be a table with groups as keys and positive numbers as values

TTTPS_Config.DetectivePassFreq = nil

-- If you wish not to restrict by groups, but to set a global limit for how often you can purchase a pass, set this to a positive number value.
-- Set to nil for no restrictions

TTTPS_Config.GlobalPassFreq = 7

-- The max % of traitors / detectives respectively that may be selected because they hold a T/D pass
-- I recommend you stick with the defaults here or values > 0.5 as for values < 0.5 there can be certain player counts at which passes cannot be used.
TTTPS_Config.MaxTPassesPerRound = 0.5
TTTPS_Config.MaxDPassesPerRound = 0.5

-- The pricing of the items for Pointshop
TTTPS_Config.TPassPrice = 500
TTTPS_Config.DPassPrice = 500