local Utils = {}

function Utils.GetTableLength(table)
	local count = 0
	for _ in pairs(table) do
		 count = count + 1
	end
	return count
end

function Utils.RoundNumberToDecimalPlaces(num, numDecimalPlaces)
    local result
	if numDecimalPlaces ~= nil and numDecimalPlaces > 0 then
		local mult = 10 ^ numDecimalPlaces
		result =  math.floor(num * mult + 0.5) / mult
	else
		result = math.floor(num + 0.5)
	end
	if result == "nan" then
		result = 0
	end
	return result
end

function Utils.CalculatePositionedBoundingBoxFrom2Points(point1, point2)
    local minX = nil
    local maxX = nil
    local minY = nil
    local maxY = nil
    if minX == nil or point1.x < minX then minX = point1.x end
    if maxX == nil or point1.x > maxX then maxX = point1.x end
    if minY == nil or point1.y < minY then minY = point1.y end
    if maxY == nil or point1.y > maxY then maxY = point1.y end
    if minX == nil or point2.x < minX then minX = point2.x end
    if maxX == nil or point2.x > maxX then maxX = point2.x end
    if minY == nil or point2.y < minY then minY = point2.y end
    if maxY == nil or point2.y > maxY then maxY = point2.y end
    return {left_top = {x = minX, y = minY}, right_bottom = {x = maxX, y = maxY}}
end

return Utils
