local MODULE = {}

MODULE.Name = "PS2 Passes"
MODULE.Author = "aurowora, askrealcookie"
MODULE.Blueprints = {{
    label = "Role Pass",
    base = "base_pass",
    icon = "pointshop2/vip2.png",
    creator = "DPassCreator",
    tooltip = "Create pass that allows a player to become a traitor or detective."
}}

Pointshop2.RegisterModule(MODULE)
