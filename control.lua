local Gui = require("scripts/gui")
local Measure = require("scripts/measure")


local function MakeGlobals()
    if global.MOD == nil then global.MOD = {} end
    if global.MOD.PlayerFirstClick == nil then global.MOD.PlayerFirstClick = {} end
    if global.MOD.PlayerResultTable == nil then global.MOD.PlayerResultTable = {} end
end


script.on_init(function()
    MakeGlobals()
    Gui.RecreateModButtonForAll()
end)
script.on_configuration_changed(function()
    MakeGlobals()
    Gui.RecreateModButtonForAll()
end)
script.on_event(defines.events.on_player_joined_game, Gui.PlayerJoinedEvent)
script.on_event(defines.events.on_gui_click, Gui.GuiClickedEvent)
script.on_event(defines.events.on_player_selected_area, Measure.OnSelectedEvent)
script.on_event(defines.events.on_mod_item_opened, Measure.OnModItemOpenedEvent)
