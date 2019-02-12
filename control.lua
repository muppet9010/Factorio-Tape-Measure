local Gui = require("scripts/gui")
local Measure = require("scripts/measure")


local function MakeGlobals()
    if global.MOD == nil then global.MOD = {} end
    if global.MOD.PlayerFirstClick == nil then global.MOD.PlayerFirstClick = {} end
    if global.MOD.PlayerResultTable == nil then global.MOD.PlayerResultTable = {} end
end


local function UpdatedPlayerModButtonSetting(player)
    Gui.RecreateModButton(player)
end


local function UpdateSetting(settingName, player)
	if settingName == "show-mod-button" then
		UpdatedPlayerModButtonSetting(player)
	end
end


local function OnSettingChanged(event)
    local player = game.players[event.player_index]
	UpdateSetting(event.setting, player)
end


script.on_init(function()
    MakeGlobals()
    Gui.RecreateAllGuisForAll()
end)
script.on_configuration_changed(function()
    MakeGlobals()
    Gui.RecreateAllGuisForAll()
end)
script.on_event(defines.events.on_player_joined_game, Gui.PlayerJoinedEvent)
script.on_event(defines.events.on_gui_click, Gui.GuiClickedEvent)
script.on_event(defines.events.on_player_selected_area, Measure.OnSelectedEvent)
script.on_event(defines.events.on_mod_item_opened, Measure.OnModItemOpenedEvent)
script.on_event("get-tape-measure", Measure.OnGetTapeMeasureCustomInput)
script.on_event(defines.events.on_runtime_mod_setting_changed, OnSettingChanged)
