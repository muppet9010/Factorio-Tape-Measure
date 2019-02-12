local Utils = require("utility/utils")
local MeasureGui = require("scripts/measure-gui")
local Gui = {}


function Gui.PlayerJoinedEvent(eventData)
    local player = game.players[eventData.player_index]
    Gui.RecreateModButton(player)
end


function Gui.GuiClickedEvent(eventData)
    local player = game.players[eventData.player_index]
    local clickedElement = eventData.element
    if clickedElement.name == "tape-measure-mod-button" then Gui.ToggleGui(player) end
    if clickedElement.name == "get-tape-measure-button" then MeasureGui.GivePlayerTapeMeasure(player) end
    if clickedElement.name == "close-tape-measure-gui-button" then Gui.CloseGui(player) end
end


function Gui.RecreateModButton(player)
    local modFlow = player.gui.top["tape-measure-mod-flow"]
    if modFlow then modFlow.destroy() end

    if settings.get_player_settings(player)["show-mod-button"].value then
        modFlow = player.gui.top.add{type="flow", name="tape-measure-mod-flow", style = "tm_padded_horizontal_flow", direction = "horizontal"}
        modFlow.add{type="sprite-button", name="tape-measure-mod-button", tooltip={"gui-tooltip.mod-toggle-button"}, sprite="tape-measure", style = "tm_mod_button_sprite"}
    end
end


function Gui.RecreateAllGuisForAll()
    for _, player in pairs(game.players) do
        Gui.CloseGui(player)
        Gui.RecreateModButton(player)
    end
end


function Gui.CloseGui(player)
    local modGui = player.gui.left["tape-measure-gui-flow"]
    if modGui ~= nil then modGui.destroy() end
end


function Gui.OpenGui(player)
    Gui.CloseGui(player)
    local guiFlow = player.gui.left.add{type="flow", name="tape-measure-gui-flow", style = "tm_padded_horizontal_flow", direction = "horizontal"}
    local guiFrame = guiFlow.add{type="frame", name="tape-measure-gui-frame", direction="vertical", style="tm_gui_frame"}

    local resultsTable = guiFrame.add{type="table", name="tape-measure-results-table", column_count = 3, draw_vertical_lines = true, draw_horizontal_lines = true, style = "tm_padded_table"}
    global.MOD.PlayerResultTable[player.index] = resultsTable
    resultsTable.add{type="label", name="results-table-type-header", caption="", style="tm_padded_table_cell"}
    resultsTable.add{type="label", name="results-table-width-header", caption={"gui-caption.results-table-width-title"}, tooltip={"gui-tooltip.results-table-width-title"}, style="tm_padded_table_cell"}
    resultsTable.add{type="label", name="results-table-depth-header", caption={"gui-caption.results-table-depth-title"}, tooltip={"gui-tooltip.results-table-depth-title"}, style="tm_padded_table_cell"}
    resultsTable.add{type="label", name="results-table-distance-title", caption={"gui-caption.results-table-distance-title"}, tooltip={"gui-tooltip.results-table-distance-title"}, style="tm_padded_table_cell"}
    resultsTable.add{type="label", name="results-table-distance-width-value", caption="", style="tm_padded_table_cell"}
    resultsTable.add{type="label", name="results-table-distance-depth-value", caption="", style="tm_padded_table_cell"}
    resultsTable.add{type="label", name="results-table-tile-title", caption={"gui-caption.results-table-tile-title"}, tooltip={"gui-tooltip.results-table-tile-title"}, style="tm_padded_table_cell"}
    resultsTable.add{type="label", name="results-table-tile-width-value", caption="", style="tm_padded_table_cell"}
    resultsTable.add{type="label", name="results-table-tile-depth-value", caption="", style="tm_padded_table_cell"}

    local bottomSection = guiFrame.add{type="flow", name="tape-measure-bottom-section", direction="horizontal"}
    bottomSection.style.top_padding = 4
    bottomSection.add{type="sprite-button", name="get-tape-measure-button", tooltip={"gui-tooltip.get-tape-measure"}, sprite="tape-measure", style = "tm_button_sprite"}
    local closerButtonFlow = bottomSection.add{type="flow", name="close-tape-measure-gui-button-flow"}
    closerButtonFlow.style.horizontally_stretchable = true
    closerButtonFlow.style.align = "right"
    closerButtonFlow.add{type="button", name="close-tape-measure-gui-button", caption={"gui-caption.close-gui-button"}}
end


function Gui.ToggleGui(player)
    if player.gui.left["tape-measure-gui-flow"] == nil then
        Gui.OpenGui(player)
    else
        Gui.CloseGui(player)
    end
end


function Gui.UpdateGui(player, distanceX, distanceY, tileX, tileY)
    Gui.OpenGui(player)
    local resultsTable = global.MOD.PlayerResultTable[player.index]
    resultsTable["results-table-distance-width-value"].caption = Utils.RoundNumberToDecimalPlaces(distanceX, 1)
    resultsTable["results-table-distance-depth-value"].caption = Utils.RoundNumberToDecimalPlaces(distanceY, 1)
    resultsTable["results-table-tile-width-value"].caption = tileX
    resultsTable["results-table-tile-depth-value"].caption = tileY
end

return Gui
