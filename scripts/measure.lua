local Utils = require("utility/utils")
local Events = require("utility/events")
local Interfaces = require("utility/interfaces")
local Measure = {}

Measure.CreateGlobals = function()
    global.measure = global.measure or {}
    global.measure.playerFirstClick = global.measure.playerFirstClick or {}
end

Measure.OnLoad = function()
    Events.RegisterHandlerCustomInput("tape_measure_tool-get_tape_measure", "Measure.OnGetTapeMeasureCustomInput", Measure.OnGetTapeMeasureCustomInput)
    Events.RegisterHandlerCustomInput("tape_measure_tool-dispose_tape_measure", "Measure.DisposeTapeMeasureInHand", Measure.DisposeTapeMeasureInHand)
    Events.RegisterHandlerEvent(defines.events.on_player_selected_area, "Measure.OnSelectedEvent", Measure.OnSelectedEvent)
    Events.RegisterHandlerEvent(defines.events.on_mod_item_opened, "Measure.OnModItemOpenedEvent", Measure.OnModItemOpenedEvent)
    Interfaces.RegisterInterface("Measure.GivePlayerTapeMeasure", Measure.GivePlayerTapeMeasure)
end

Measure.OnSelectedEvent = function(eventData)
    if eventData.item ~= "tape_measure_tool" then
        return
    end
    local area = eventData.area
    local distanceX = area.right_bottom.x - area.left_top.x
    local distanceY = area.right_bottom.y - area.left_top.y
    if distanceX > 1 or distanceY > 1 then
        Measure.SelectionBoxMade(eventData)
    else
        Measure.PointClicked(eventData)
    end
end

Measure.SelectionBoxMade = function(eventData)
    local area = eventData.area
    local pointsDistanceX = area.right_bottom.x - area.left_top.x
    local pointsDistanceY = area.right_bottom.y - area.left_top.y

    local positionedBoundingBox = Utils.CalculateBoundingBoxFrom2Points(area.left_top, area.right_bottom)
    local tile_left_top_x = math.floor(positionedBoundingBox.left_top.x)
    local tile_left_top_y = math.floor(positionedBoundingBox.left_top.y)
    local tile_right_bottom_x = math.floor(positionedBoundingBox.right_bottom.x)
    local tile_right_bottom_y = math.floor(positionedBoundingBox.right_bottom.y)
    local pointsTileX = (tile_right_bottom_x - tile_left_top_x) + 1
    local pointsTileY = (tile_right_bottom_y - tile_left_top_y) + 1

    local player = game.players[eventData.player_index]
    Interfaces.Call("Gui.UpdateGui", player, pointsDistanceX, pointsDistanceY, pointsTileX, pointsTileY)
    global.measure.playerFirstClick[player.index] = nil
end

Measure.PointClicked = function(eventData)
    local area = eventData.area
    local distanceX = area.right_bottom.x - area.left_top.x
    local distanceY = area.right_bottom.y - area.left_top.y
    local centerPos = {x = area.left_top.x + (distanceX / 2), y = area.left_top.y + (distanceY / 2)}
    local player = game.players[eventData.player_index]
    local firstPoint = global.measure.playerFirstClick[player.index]
    if firstPoint == nil then
        global.measure.playerFirstClick[player.index] = centerPos
        player.surface.create_entity {type = "flying-text", name = "flying-text", position = centerPos, text = {"player-message.tape_measure_tool-first_point"}, color = {r = 0, g = 1, b = 0, a = 0}, render_player_index = player.index}
    else
        local secondPoint = centerPos
        player.surface.create_entity {type = "flying-text", name = "flying-text", position = centerPos, text = {"player-message.tape_measure_tool-second_point"}, color = {r = 0, g = 1, b = 0, a = 0}, render_player_index = player.index}
        local pointsDistanceX = firstPoint.x - secondPoint.x
        if pointsDistanceX < 0 then
            pointsDistanceX = 0 - pointsDistanceX
        end
        local pointsDistanceY = firstPoint.y - secondPoint.y
        if pointsDistanceY < 0 then
            pointsDistanceY = 0 - pointsDistanceY
        end

        local positionedBoundingBox = Utils.CalculateBoundingBoxFrom2Points(firstPoint, secondPoint)
        local tile_left_top_x = math.floor(positionedBoundingBox.left_top.x)
        local tile_left_top_y = math.floor(positionedBoundingBox.left_top.y)
        local tile_right_bottom_x = math.floor(positionedBoundingBox.right_bottom.x)
        local tile_right_bottom_y = math.floor(positionedBoundingBox.right_bottom.y)
        local pointsTileX = (tile_right_bottom_x - tile_left_top_x) + 1
        local pointsTileY = (tile_right_bottom_y - tile_left_top_y) + 1

        Interfaces.Call("Gui.UpdateGui", player, pointsDistanceX, pointsDistanceY, pointsTileX, pointsTileY)
        global.measure.playerFirstClick[player.index] = nil
    end
end

Measure.OnModItemOpenedEvent = function(eventData)
    local itemName = eventData.item.name
    if itemName ~= "tape_measure_tool" then
        return
    end
    local player = game.players[eventData.player_index]
    player.remove_item({name = "tape_measure_tool", count = 1})
end

Measure.OnGetTapeMeasureCustomInput = function(eventData)
    local player = game.players[eventData.player_index]
    Measure.GivePlayerTapeMeasure(player)
end

Measure.DisposeTapeMeasureInHand = function(eventData)
    local player = game.players[eventData.player_index]
    if not player.cursor_stack.valid_for_read or player.cursor_stack.name ~= "tape_measure_tool" then
        return
    end
    player.cursor_stack.clear()
end

Measure.GivePlayerTapeMeasure = function(player)
    player.clear_cursor()
    player.cursor_stack.set_stack("tape_measure_tool")
end

return Measure
