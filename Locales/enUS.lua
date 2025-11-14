------------------------------
-- BrokerFrames Locale File
-- ENGLISH
------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("BrokerFrames", "enUS", true, true)

L["option_category_general"] = "General"
L["option_category_frames"] = "Frames"
L["option_category_templates"] = "Templates"
L["option_category_ldb_info"] = "Loaded LDB data"

L["option_create_frame"] = "Create a new frame"

L["option_debug_messages"] = "Show debug messages"
L["option_debug_messages_desc"] = "Show messages in chat intended for debugging purposes"

L["option_ldb_info_header"] =
    "The following LDB information is known about and is available when configuring frame data. Currently loaded |cffffff00%d|r items"
L["none"] = "None"

L["option_ldb_type"] = "|cffffff00Type:|r"
L["option_ldb_label"] = "|cffffff00Label:|r"
L["option_ldb_icon"] = "|cffffff00Icon:|r"

L["option_create_frame_header"] =
    "To create a frame, enter a name and then push 'Create frame'. Once you create a frame, a new item will appear in the list allowing you to configure it."

L["option_create_frame_input"] = "New frame name"
L["option_create_frame_input_desc"] = "Enter a short name for your frame (eg. coolframe1, gold, etc)"

L["option_create_frame_exec"] = "Create Frame"
L["option_create_frame_exec_desc"] =
    "Create a frame called '%s'. Once you create it, a new row for it will appear in addon options."

L["option_create_frame_error_exists"] = "A frame with that name already exists"

L["option_frame_delete"] = "Delete frame"
L["option_frame_delete_desc"] = "Delete this frame. |cffff0000Irreversible!|r"
L["option_frame_delete_confirm"] = "Are you sure you want to delete this frame. |cffff0000This is irreversible!|r"

L["option_create_frame_look_feel"] = "Look and feel"

L["option_frame_create_bg"] = "Background texture"
L["option_frame_create_bg_desc"] = "Which background texture to use for the frame"

L["option_frame_create_edge"] = "Edge texture"
L["option_frame_create_edge_desc"] = "Which edge texture to use for the frame"

L["option_frame_tile"] = "Tile"
L["option_frame_tile_desc"] = "Tile backdrop texture"

L["option_frame_tile_size"] = "Tile Size"
L["option_frame_tile_size_desc"] = "Size of tiles"

L["option_frame_edge_size"] = "Edge Size"
L["option_frame_edge_size_desc"] = "Size of edge"

L["option_frame_insets"] = "Insets"

L["option_frame_insets_left"] = "Left"
L["option_frame_insets_right"] = "Right"
L["option_frame_insets_top"] = "Top"
L["option_frame_insets_bottom"] = "Bottom"

L["option_frame_backdrop_color"] = "Backdrop color"
L["option_frame_backdrop_color_desc"] = "Background color of the backdrop"

L["option_frame_border_color"] = "Border color"
L["option_frame_border_color_desc"] = "Border color of the frame"

L["option_frame_lock"] = "Lock frame"
L["option_frame_lock_desc"] = "Prevent the frame from being moved"
L["option_frame_shift"] = "Require shift to be held to be dragged"
L["option_frame_shift_desc"] = "If true, shift needs to be held for the frame to be dragged"

L["option_frame_resize"] = "Resize frame automatically"
L["option_frame_resize_desc"] = "Automatically calculate height and width based off of frame contents"

L["option_frame_width"] = "Width"
L["option_frame_width_desc"] = "Width of the frame"

L["option_frame_height"] = "Height"
L["option_frame_height_desc"] = "Width of the frame"

L["option_border_blend"] = "Border style"
L["option_border_blend_desc"] = "How to render the border texture"

L["option_border_blend_add"] = "Add"
L["option_border_blend_blend"] = "Blend"
L["option_border_blend_mod"] = "Mod"
L["option_border_blend_alphakey"] = "AlphaKey"
L["option_border_blend_disable"] = "Disable"
L["option_border_blend_overlay"] = "Overlay"
