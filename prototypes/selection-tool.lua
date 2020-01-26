local Constants = require("constants")

data:extend(
    {
        {
            type = "selection-tool",
            name = "tape-measure",
            icon = Constants.AssetModName .. "/graphics/item/tape-measure.png",
            icon_size = 640,
            stack_size = 1,
            subgroup = "other",
            order = "a",
            flags = {"mod-openable", "not-stackable"},
            selection_color = {r = 0, g = 1, b = 0},
            selection_mode = {"any-tile"},
            selection_cursor_box_type = "entity",
            alt_selection_color = {a = 0},
            alt_selection_mode = {"nothing"}, --nothing will highlight
            alt_selection_cursor_box_type = "entity"
        }
    }
)
