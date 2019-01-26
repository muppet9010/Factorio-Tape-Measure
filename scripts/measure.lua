local Gui = require("scripts/gui")
local Utils = require("utility/utils")
local Measure = {}


function Measure.OnSelectedEvent(eventData)
    if eventData.item ~= "tape-measure" then return end
    local area = eventData.area
    local distanceX = area.right_bottom.x - area.left_top.x
    local distanceY = area.right_bottom.y - area.left_top.y
    if distanceX > 1 or distanceY > 1 then
        Measure.SelectionBoxMade(eventData)
    else
        Measure.PointClicked(eventData)
    end
end


function Measure.SelectionBoxMade(eventData)
    local area = eventData.area
    local pointsDistanceX = area.right_bottom.x - area.left_top.x
    local pointsDistanceY = area.right_bottom.y - area.left_top.y

    local positionedBoundingBox = Utils.CalculatePositionedBoundingBoxFrom2Points(area.left_top, area.right_bottom)
        local tile_left_top_x = math.floor(positionedBoundingBox.left_top.x)
        local tile_left_top_y = math.floor(positionedBoundingBox.left_top.y)
        local tile_right_bottom_x = math.floor(positionedBoundingBox.right_bottom.x)
        local tile_right_bottom_y = math.floor(positionedBoundingBox.right_bottom.y)
        local pointsTileX = (tile_right_bottom_x - tile_left_top_x) + 1
        local pointsTileY = (tile_right_bottom_y - tile_left_top_y) + 1


    local player = game.players[eventData.player_index]
    Gui.UpdateGui(player, pointsDistanceX, pointsDistanceY, pointsTileX, pointsTileY)
    global.MOD.PlayerFirstClick[player.index] = nil
end


function Measure.PointClicked(eventData)
    local area = eventData.area
    local distanceX = area.right_bottom.x - area.left_top.x
    local distanceY = area.right_bottom.y - area.left_top.y
    local centerPos = {x = area.left_top.x + (distanceX/2), y = area.left_top.y + (distanceY/2)}
    local player = game.players[eventData.player_index]
    local firstPoint = global.MOD.PlayerFirstClick[player.index]
    if firstPoint == nil then
        global.MOD.PlayerFirstClick[player.index] = centerPos
        player.surface.create_entity{type="flying-text", name="flying-text", position=centerPos, text={"player-message.first-point"}, color = {r=0, g=1, b=0, a=0}}
    else
        local secondPoint = centerPos
        player.surface.create_entity{type="flying-text", name="flying-text", position=centerPos, text={"player-message.second-point"}, color = {r=0, g=1, b=0, a=0}}
        local pointsDistanceX = firstPoint.x - secondPoint.x
        if pointsDistanceX < 0 then pointsDistanceX = 0 - pointsDistanceX end
        local pointsDistanceY = firstPoint.y - secondPoint.y
        if pointsDistanceY < 0 then pointsDistanceY = 0 - pointsDistanceY end

        local positionedBoundingBox = Utils.CalculatePositionedBoundingBoxFrom2Points(firstPoint, secondPoint)
        local tile_left_top_x = math.floor(positionedBoundingBox.left_top.x)
        local tile_left_top_y = math.floor(positionedBoundingBox.left_top.y)
        local tile_right_bottom_x = math.floor(positionedBoundingBox.right_bottom.x)
        local tile_right_bottom_y = math.floor(positionedBoundingBox.right_bottom.y)
        local pointsTileX = (tile_right_bottom_x - tile_left_top_x) + 1
        local pointsTileY = (tile_right_bottom_y - tile_left_top_y) + 1

        Gui.UpdateGui(player, pointsDistanceX, pointsDistanceY, pointsTileX, pointsTileY)
        global.MOD.PlayerFirstClick[player.index] = nil
    end
end


function Measure.OnModItemOpenedEvent(eventData)
    local itemName = eventData.item.name
    if itemName ~= "tape-measure" then return end
    local player = game.players[eventData.player_index]
    player.remove_item({name = "tape-measure", count = 1})
end


return Measure
