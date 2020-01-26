--[[
    Regular "margin" and "padded" are 4 pixels on the left and top. This allows things to be stacked horizontally and vertically by default.
]]
local Colors = require("utility/colors")
local defaultStyle = data.raw["gui-style"]["default"]

defaultStyle.muppet_horizontal_flow = {
    type = "horizontal_flow_style",
    margin = 0,
    padding = 0,
    horizontal_spacing = 0
}
defaultStyle.muppet_vertical_flow = {
    type = "vertical_flow_style",
    margin = 0,
    padding = 0,
    vertical_spacing = 0
}
defaultStyle.muppet_padded_horizontal_flow = {
    type = "horizontal_flow_style",
    parent = "muppet_horizontal_flow",
    top_padding = 4,
    left_padding = 4,
    horizontal_spacing = 0
}
defaultStyle.muppet_padded_vertical_flow = {
    type = "vertical_flow_style",
    parent = "muppet_vertical_flow",
    top_padding = 4,
    left_padding = 4,
    horizontal_spacing = 0
}

defaultStyle.muppet_horizontal_flow_spaced = {
    type = "horizontal_flow_style",
    parent = "muppet_horizontal_flow",
    horizontal_spacing = 4
}
defaultStyle.muppet_vertical_flow_spaced = {
    type = "vertical_flow_style",
    parent = "muppet_vertical_flow",
    vertical_spacing = 4
}
defaultStyle.muppet_padded_horizontal_flow_spaced = {
    type = "horizontal_flow_style",
    parent = "muppet_horizontal_flow",
    top_padding = 4,
    left_padding = 4,
    horizontal_spacing = 4
}
defaultStyle.muppet_padded_vertical_flow_spaced = {
    type = "vertical_flow_style",
    parent = "muppet_vertical_flow",
    top_padding = 4,
    left_padding = 4,
    vertical_spacing = 4
}

defaultStyle.muppet_frame_main = {
    type = "frame_style",
    margin = 0,
    padding = 0,
    graphical_set = {
        base = {
            position = {0, 0},
            corner_size = 8
        }
    }
}
defaultStyle.muppet_margin_frame_main = {
    type = "frame_style",
    parent = "muppet_frame_main",
    top_margin = 4,
    left_margin = 4
}
defaultStyle.muppet_padded_frame_main = {
    type = "frame_style",
    parent = "muppet_frame_main",
    top_padding = 4,
    left_padding = 4
}
defaultStyle.muppet_margin_padded_frame_main = {
    type = "frame_style",
    parent = "muppet_margin_frame_main",
    top_padding = 4,
    left_padding = 4
}

defaultStyle.muppet_frame_content = {
    type = "frame_style",
    parent = "muppet_frame_main",
    graphical_set = {
        base = {
            position = {68, 0},
            corner_size = 8
        }
    }
}
defaultStyle.muppet_margin_frame_content = {
    type = "frame_style",
    parent = "muppet_frame_content",
    top_margin = 4,
    left_margin = 4
}
defaultStyle.muppet_padded_frame_content = {
    type = "frame_style",
    parent = "muppet_frame_content",
    top_padding = 4,
    left_padding = 4
}
defaultStyle.muppet_margin_padded_frame_content = {
    type = "frame_style",
    parent = "muppet_margin_frame_content",
    top_padding = 4,
    left_padding = 4
}

defaultStyle.muppet_frame_contentInnerDark = {
    type = "frame_style",
    parent = "muppet_frame_main",
    graphical_set = {
        base = {
            position = {34, 0},
            corner_size = 8
        }
    }
}
defaultStyle.muppet_margin_frame_contentInnerDark = {
    type = "frame_style",
    parent = "muppet_frame_contentInnerDark",
    top_margin = 4,
    left_margin = 4
}
defaultStyle.muppet_padded_frame_contentInnerDark = {
    type = "frame_style",
    parent = "muppet_frame_contentInnerDark",
    top_padding = 4,
    left_padding = 4
}
defaultStyle.muppet_margin_padded_frame_contentInnerDark = {
    type = "frame_style",
    parent = "muppet_margin_frame_contentInnerDark",
    top_padding = 4,
    left_padding = 4
}

defaultStyle.muppet_frame_contentInnerLight = {
    type = "frame_style",
    parent = "muppet_frame_main",
    graphical_set = {
        base = {
            position = {0, 17},
            corner_size = 8
        }
    }
}
defaultStyle.muppet_margin_frame_contentInnerLight = {
    type = "frame_style",
    parent = "muppet_frame_contentInnerLight",
    top_margin = 4,
    left_margin = 4
}
defaultStyle.muppet_padded_frame_contentInnerLight = {
    type = "frame_style",
    parent = "muppet_frame_contentInnerLight",
    top_padding = 4,
    left_padding = 4
}
defaultStyle.muppet_margin_padded_frame_contentInnerLight = {
    type = "frame_style",
    parent = "muppet_margin_frame_contentInnerLight",
    top_padding = 4,
    left_padding = 4
}

--TODO: Tables need updating to match new approach used above
defaultStyle.muppet_padded_table = {
    type = "table_style",
    top_padding = 5,
    --doesn't need bottom padding in 0.17
    left_padding = 5,
    right_padding = 5
}
defaultStyle.muppet_padded_table_and_cells = {
    type = "table_style",
    top_padding = 5,
    --doesn't need bottom padding in 0.17
    left_padding = 5,
    right_padding = 5,
    top_cell_padding = 5,
    --doesn't need bottom padding in 0.17
    left_cell_padding = 5,
    right_cell_padding = 5
}
defaultStyle.muppet_padded_table_cells = {
    type = "table_style",
    top_cell_padding = 5,
    --doesn't need bottom padding in 0.17
    left_cell_padding = 5,
    right_cell_padding = 5
}

--TODO: all button types not checked since moving to new approach for other elements & text
defaultStyle.muppet_mod_button_sprite = {
    type = "button_style",
    width = 36,
    height = 36,
    scalable = true,
    left_padding = 0,
    right_padding = 0
}
--same height as a small button (default font)
defaultStyle.muppet_button_sprite = {
    type = "button_style",
    width = 28,
    height = 28,
    scalable = true,
    left_padding = 0,
    right_padding = 0
}
defaultStyle.muppet_small_button = {
    type = "button_style",
    padding = 2,
    font = "default"
}
defaultStyle.muppet_large_button = {
    type = "button_style",
    font = "default-large-bold"
}

defaultStyle.muppet_text = {
    type = "label_style",
    font = "default",
    padding = 0,
    left_padding = 4,
    right_padding = 4,
    margin = 0
}
defaultStyle.muppet_semibold_text = {
    type = "label_style",
    parent = "muppet_text",
    font = "default-semibold"
}
defaultStyle.muppet_bold_text = {
    type = "label_style",
    parent = "muppet_text",
    font = "default-bold"
}

defaultStyle.muppet_medium_text = {
    type = "label_style",
    parent = "muppet_text",
    font = "default-medium"
}
defaultStyle.muppet_medium_semibold_text = {
    type = "label_style",
    parent = "muppet_text",
    font = "default-medium-semibold"
}
defaultStyle.muppet_medium_bold_text = {
    type = "label_style",
    parent = "muppet_text",
    font = "default-medium-bold"
}

defaultStyle.muppet_large_text = {
    type = "label_style",
    parent = "muppet_text",
    font = "default-large"
}
defaultStyle.muppet_large_semibold_text = {
    type = "label_style",
    parent = "muppet_text",
    font = "default-large-semibold"
}
defaultStyle.muppet_large_bold_text = {
    type = "label_style",
    parent = "muppet_text",
    font = "default-large-bold"
}

local textsToMakeHeadings = {"muppet_medium_text", "muppet_medium_semibold_text", "muppet_bold_text", "muppet_medium_text", "muppet_medium_semibold_text", "muppet_medium_bold_text", "muppet_large_text", "muppet_large_semibold_text", "muppet_large_bold_text"}
for _, textName in pairs(textsToMakeHeadings) do
    local headingName = string.gsub(textName, "_text", "_heading")
    defaultStyle[headingName] = {
        type = "label_style",
        parent = textName,
        font_color = Colors.guiheadingcolor
    }
end

data:extend(
    {
        {
            type = "font",
            name = "default-medium",
            from = "default",
            size = 16
        },
        {
            type = "font",
            name = "default-medium-semibold",
            from = "default-semibold",
            size = 16
        },
        {
            type = "font",
            name = "default-medium-bold",
            from = "default-bold",
            size = 16
        }
    }
)
