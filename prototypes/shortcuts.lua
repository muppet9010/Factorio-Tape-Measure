local Constants = require("constants")

data:extend(
    {
        {
            type = "shortcut",
            name = "tape_measure_tool-give_tape_measure",
            action = "lua",
            toggleable = true,
            icon = {
                filename = Constants.AssetModName .. "/graphics/gui/tape_measure32.png",
                width = 32,
                height = 32
            },
            small_icon = {
                filename = Constants.AssetModName .. "/graphics/gui/tape_measure24.png",
                width = 24,
                height = 24
            },
            disabled_small_icon = {
                filename = Constants.AssetModName .. "/graphics/gui/tape_measure24_disabled.png",
                width = 24,
                height = 24
            }
        }
    }
)
