local defaultStyle = data.raw["gui-style"]["default"]

defaultStyle.tm_padded_horizontal_flow = {
    type = "horizontal_flow_style",
    left_padding = 4,
    top_padding = 4,
}

defaultStyle.tm_mod_button_sprite = {
    type = "button_style",
    width = 36,
    height = 36,
    scalable = true,
}

--same size as a button
defaultStyle.tm_button_sprite = {
    type = "button_style",
    width = 42,
    height = 42,
    scalable = true,
}

defaultStyle.tm_gui_frame = {
    type = "frame_style",
    left_padding = 4,
    top_padding = 4,
}

defaultStyle.tm_padded_table = {
    type = "table_style",
    top_padding = 5,
    bottom_padding = 5,
    left_padding = 5,
    right_padding = 5,
}

defaultStyle.tm_padded_table_cell = {
    type = "label_style",
    top_padding = 5,
    bottom_padding = 5,
    left_padding = 5,
    right_padding = 5,
}
