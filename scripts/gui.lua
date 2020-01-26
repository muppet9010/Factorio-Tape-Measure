local Utils = require("utility/utils")
local Events = require("utility/events")
local GuiUtil = require("utility/gui-util")
local GuiActions = require("utility/gui-actions")
local Interfaces = require("utility/interfaces")
local Gui = {}

Gui.OnLoad = function()
    Events.RegisterHandler(defines.events.on_player_joined_game, "Gui.PlayerJoinedEvent", Gui.PlayerJoinedEvent)
    GuiActions.RegisterActionType("Gui.ToggleGuiButtonAction", Gui.ToggleGuiButtonAction)
    GuiActions.RegisterActionType("Gui.CloseGuiButtonAction", Gui.CloseGuiButtonAction)
    GuiActions.RegisterActionType("Gui.GivePlayerTapeMeasureButtonAction", Gui.GivePlayerTapeMeasureButtonAction)
    Interfaces.RegisterInterface("Gui.UpdateGui", Gui.UpdateGui)
end

Gui.OnStartup = function()
    Gui.RecreateGuiForAll()
end

Gui.OnSettingChanged = function(event)
    if event ~= nil and event.setting_type == "runtime-per-user" and event.setting == "tape_measure_tool-show_mod_button" then
        local player = game.get_player(event.player_index)
        Gui.RecreateModButton(player)
    end
end

Gui.PlayerJoinedEvent = function(eventData)
    local player = game.players[eventData.player_index]
    Gui.RecreateModButton(player)
end

Gui.RecreateModButton = function(player)
    GuiUtil.DestroyElementInPlayersReferenceStorage(player.index, "tape_measure_tool", "show_mod_button", "flow")
    if settings.get_player_settings(player)["tape_measure_tool-show_mod_button"].value then
        local modFlow = GuiUtil.AddElement({parent = player.gui.top, type = "flow", name = "show_mod_button", style = "muppet_padded_horizontal_flow", direction = "horizontal"}, "tape_measure_tool")
        GuiUtil.AddElement({parent = modFlow, type = "sprite-button", name = "show_mod_button", tooltip = "self", sprite = "tape_measure_tool", style = "muppet_mod_button_sprite"})
        GuiActions.RegisterButtonToAction("show_mod_button", "sprite-button", "Gui.ToggleGuiButtonAction")
    end
end

Gui.RecreateGuiForAll = function()
    for _, player in pairs(game.players) do
        Gui.CloseGui(player)
        Gui.RecreateModButton(player)
    end
end

Gui.CloseGui = function(player)
    GuiUtil.DestroyElementInPlayersReferenceStorage(player.index, "tape_measure_tool", "tape_measure_gui", "flow")
end

Gui.CloseGuiButtonAction = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    Gui.CloseGui(player)
end

Gui.OpenGui = function(player)
    Gui.CloseGui(player)
    local guiFlow = GuiUtil.AddElement({parent = player.gui.left, type = "flow", name = "tape_measure_gui", style = "muppet_padded_horizontal_flow", direction = "horizontal"}, "tape_measure_tool")
    local guiFrame = GuiUtil.AddElement({parent = guiFlow, type = "frame", name = "tape_measure_gui", direction = "vertical", style = "muppet_frame_main"})

    local resultsTable = GuiUtil.AddElement({parent = guiFrame, type = "table", name = "tape_measure_results", column_count = 3, draw_vertical_lines = true, draw_horizontal_lines = true, style = "muppet_padded_table_and_cells"})
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_type_header", caption = ""})
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_width_header", caption = "self", tooltip = "self"})
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_depth_header", caption = "self", tooltip = "self"})
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_distance_title", caption = "self", tooltip = "self"})
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_distance_width_value", caption = ""}, "tape_measure_tool")
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_distance_depth_value", caption = ""}, "tape_measure_tool")
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_tile_title", caption = "self", tooltip = "self"})
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_tile_width_value", caption = ""}, "tape_measure_tool")
    GuiUtil.AddElement({parent = resultsTable, type = "label", name = "results_table_tile_depth_value", caption = ""}, "tape_measure_tool")

    local bottomSection = GuiUtil.AddElement({parent = guiFrame, type = "flow", name = "tape_measure_bottom_section", direction = "horizontal"})
    bottomSection.style.top_padding = 4
    GuiUtil.AddElement({parent = bottomSection, type = "sprite-button", name = "get_tape_measure_button", tooltip = "self", sprite = "tape_measure_tool", style = "muppet_button_sprite"})
    GuiActions.RegisterButtonToAction("get_tape_measure_button", "sprite-button", "Gui.GivePlayerTapeMeasureButtonAction")
    local closerButtonFlow = GuiUtil.AddElement({parent = bottomSection, type = "flow", name = "close_tape_measure_gui"})
    closerButtonFlow.style.horizontally_stretchable = true
    closerButtonFlow.style.horizontal_align = "right"
    GuiUtil.AddElement({parent = closerButtonFlow, type = "button", name = "close_tape_measure_gui", caption = "self"})
    GuiActions.RegisterButtonToAction("close_tape_measure_gui", "button", "Gui.CloseGuiButtonAction")
end

Gui.ToggleGuiButtonAction = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    if GuiUtil.GetElementFromPlayersReferenceStorage(player.index, "tape_measure_tool", "tape_measure_gui", "flow") == nil then
        Gui.OpenGui(player)
    else
        Gui.CloseGui(player)
    end
end

Gui.UpdateGui = function(player, distanceX, distanceY, tileX, tileY)
    Gui.OpenGui(player)
    GuiUtil.UpdateElementFromPlayersReferenceStorage(player.index, "tape_measure_tool", "results_table_distance_width_value", "label", {caption = Utils.RoundNumberToDecimalPlaces(distanceX, 1)})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(player.index, "tape_measure_tool", "results_table_distance_depth_value", "label", {caption = Utils.RoundNumberToDecimalPlaces(distanceY, 1)})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(player.index, "tape_measure_tool", "results_table_tile_width_value", "label", {caption = tileX})
    GuiUtil.UpdateElementFromPlayersReferenceStorage(player.index, "tape_measure_tool", "results_table_tile_depth_value", "label", {caption = tileY})
end

Gui.GivePlayerTapeMeasureButtonAction = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    Interfaces.Call("Measure.GivePlayerTapeMeasure", player)
end

return Gui
