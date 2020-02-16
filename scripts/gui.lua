local Utils = require("utility/utils")
local Events = require("utility/events")
local GuiUtil = require("utility/gui-util")
local GuiActionsClick = require("utility/gui-actions-click")
local Interfaces = require("utility/interfaces")
local Gui = {}

Gui.OnLoad = function()
    GuiActionsClick.LinkGuiClickActionNameToFunction("Gui.ToggleGuiButtonAction", Gui.ToggleGuiButtonAction)
    GuiActionsClick.LinkGuiClickActionNameToFunction("Gui.CloseGuiButtonAction", Gui.CloseGuiButtonAction)
    GuiActionsClick.LinkGuiClickActionNameToFunction("Gui.GivePlayerTapeMeasureButtonAction", Gui.GivePlayerTapeMeasureButtonAction)
    Interfaces.RegisterInterface("Gui.UpdateGui", Gui.UpdateGui)
    Events.RegisterHandler(defines.events.on_lua_shortcut, "Gui.OnLuaShortcut", Gui.OnLuaShortcut)
end

Gui.OnStartup = function()
    Gui.CloseGuiForAll()
end

Gui.CloseGuiForAll = function()
    for _, player in pairs(game.players) do
        Gui.CloseGui(player)
    end
end

Gui.CloseGui = function(player)
    GuiUtil.DestroyElementInPlayersReferenceStorage(player.index, "tape_measure_tool", "tape_measure_gui", "frame")
end

Gui.CloseGuiButtonAction = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    Gui.CloseGui(player)
end

Gui.OpenGui = function(player)
    Gui.CloseGui(player)
    GuiUtil.AddElement(
        {
            parent = player.gui.left,
            type = "frame",
            name = "tape_measure_gui",
            direction = "vertical",
            style = "muppet_frame_main_marginTL_paddingBR",
            storeName = "tape_measure_tool",
            children = {
                {
                    type = "flow",
                    direction = "horizontal",
                    style = "muppet_flow_horizontal_marginTL",
                    children = {
                        {
                            type = "label",
                            name = "gui_title",
                            caption = "self",
                            style = "muppet_label_heading_large_bold"
                        },
                        {
                            type = "flow",
                            direction = "horizontal",
                            style = "muppet_flow_horizontal",
                            styling = {horizontal_align = "right", minimal_width = 24},
                            children = {
                                {
                                    type = "sprite-button",
                                    name = "close_tape_measure_gui",
                                    sprite = "utility/close_white",
                                    style = "muppet_sprite_button_frameCloseButtonClickable",
                                    registerClick = {actionName = "Gui.CloseGuiButtonAction"}
                                }
                            }
                        }
                    }
                },
                {
                    type = "table",
                    column_count = 3,
                    draw_vertical_lines = true,
                    draw_horizontal_lines = true,
                    style = "muppet_table_marginTL_paddingBR_cellPadded",
                    children = {
                        {
                            type = "label",
                            caption = "",
                            style = "muppet_label_text_small_paddingSides"
                        },
                        {
                            type = "label",
                            name = "results_table_width_header",
                            caption = "self",
                            tooltip = "self",
                            style = "muppet_label_text_small_paddingSides"
                        },
                        {
                            type = "label",
                            name = "results_table_depth_header",
                            caption = "self",
                            tooltip = "self",
                            style = "muppet_label_text_small_paddingSides"
                        },
                        {
                            type = "label",
                            name = "results_table_distance_title",
                            caption = "self",
                            tooltip = "self",
                            style = "muppet_label_text_small_paddingSides"
                        },
                        {
                            type = "label",
                            name = "results_table_distance_width_value",
                            caption = "",
                            storeName = "tape_measure_tool",
                            style = "muppet_label_text_small_paddingSides"
                        },
                        {
                            type = "label",
                            name = "results_table_distance_depth_value",
                            caption = "",
                            storeName = "tape_measure_tool",
                            style = "muppet_label_text_small_paddingSides"
                        },
                        {
                            type = "label",
                            name = "results_table_tile_title",
                            caption = "self",
                            tooltip = "self",
                            style = "muppet_label_text_small_paddingSides"
                        },
                        {
                            type = "label",
                            name = "results_table_tile_width_value",
                            caption = "",
                            storeName = "tape_measure_tool",
                            style = "muppet_label_text_small_paddingSides"
                        },
                        {
                            type = "label",
                            name = "results_table_tile_depth_value",
                            caption = "",
                            storeName = "tape_measure_tool",
                            style = "muppet_label_text_small_paddingSides"
                        }
                    }
                }
            }
        }
    )
end

Gui.ToggleGuiButtonAction = function(actionData)
    local player = game.get_player(actionData.playerIndex)
    if GuiUtil.GetElementFromPlayersReferenceStorage(player.index, "tape_measure_tool", "tape_measure_gui", "frame") == nil then
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

Gui.OnLuaShortcut = function(eventData)
    local shortcutName = eventData.prototype_name
    if shortcutName == "tape_measure_tool-give_tape_measure" then
        local player = game.get_player(eventData.player_index)
        Interfaces.Call("Measure.GivePlayerTapeMeasure", player)
    end
end

return Gui
