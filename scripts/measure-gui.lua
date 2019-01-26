local MeasureGui = {}


function MeasureGui.GivePlayerTapeMeasure(player)
    player.clean_cursor()
    player.cursor_stack.set_stack("tape-measure")
end


return MeasureGui
