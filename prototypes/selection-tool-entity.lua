local Constants = require("constants")

data:extend({
    {
        type = "selection-tool",
        name = "tape-measure",
        icon = Constants.AssetModName .. "/graphics/item/tape-measure.png",
        icon_size = 640,
        flags = {"goes-to-quickbar"},
        stack_size = 1,
        stackable = false,
        subgroup = "other",
        order = "a",
        selection_color = { r = 0, g = 1, b = 0 },
        selection_mode = {"any-tile"},
        selection_cursor_box_type = "entity",
        alt_selection_color = { a = 0 },
        alt_selection_mode = {"matches-force", "tiles"}, --nothing will highlight
        alt_selection_cursor_box_type = "entity",
        can_be_mod_opened = true
    }
})
