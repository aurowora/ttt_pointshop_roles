# ttt_pointshop_passes

Implements Traitor and Detective passes that can be purchased from the Pointshop. The Addon is compatible with the Open Source version of [Pointshop](https://pointshop.burt0n.net) and [Pointshop 2](https://github.com/Kamshak/Pointshop2/).

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/K3K34MSYX)

### Configuration

No additional configuration past installing the addon on to your server is required, however there are several configuration options provided in lua/ttt_pointshop_roles/config.lua to make the addon more suited to your use case.

|Configuration Option|Default|Description|
|--------------------|-------|-----------|
|AllowedGroups|nil|A table containing all groups that are allowed to purchase passes. `nil` means that there are no restrictions|
|TraitorPassFreq|nil|A table that sets how often players of certain groups are allowed to purchase T passes in rounds. The keys are the group names and the values are integers. `nil` means there are no restrictions.|
|DetectivePassFreq|nil|Same thing as TraitorPassFreq but for Detectives.|
|GlobalPassFreq|7|Similar to DetectivePassFreq / TraitorPassFreq, but serves as the catch all value for any groups not mentioned in those tables. `nil` means there are no restrictions.|
|MaxTPassesPerRound|0.5|The percentage of traitors that are allowed to be selected based on T passes per round. Values above 0.5 are recommended.|
|MaxDPassesPerRound|0.5|The percentage of detectives that are allowed to be selected based on D passes per round. Values above 0.5 are recommended.|
|TPassPrice|500|The amount of points that a Traitor pass costs.|
|DPassPrice|500|The amount of points that a Detective pass costs.|

Because the configuration is included by the pointshop items, auto-refresh may not work properly on the configuration file and might require a map change.

### Compatibility Warning

This addon overwrites TTT's SelectRoles() function to enable custom role selection logic. If you have another addon that also does this, ttt_pointshop_passes or the other addon may not function properly.
