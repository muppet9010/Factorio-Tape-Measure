local defaultStyle = data.raw["gui-style"]["default"]

defaultStyle.tm_padded_horizontal_flow = {
    type = "horizontal_flow_style",
    left_padding = 4,
    top_padding = 4
}

defaultStyle.tm_mod_button_sprite = {
    type = "button_style",
    width = 36,
    height = 36,
    scalable = true,
    left_padding = 0,
    right_padding = 0
}

--same height as a button default font
defaultStyle.tm_button_sprite = {
    type = "button_style",
    width = 28,
    height = 28,
    scalable = true,
    left_padding = 0,
    right_padding = 0
}

defaultStyle.tm_gui_frame = {
    type = "frame_style",
    left_padding = 4,
    top_padding = 4
}

defaultStyle.tm_padded_table = {
    type = "table_style",
    top_padding = 5,
    --doesn't need bottom padding in 0.17
    left_padding = 5,
    right_padding = 5
}

defaultStyle.tm_padded_table_cell = {
    type = "label_style",
    top_padding = 5,
    --doesn't need bottom padding in 0.17
    left_padding = 5,
    right_padding = 5
}
