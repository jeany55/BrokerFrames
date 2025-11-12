------------------------------
-- BrokerFrames Locale File
-- ENGLISH
------------------------------
local L = LibStub("AceLocale-3.0"):NewLocale("BrokerFrames", "enUS", true, true)

L["option_category_general"] = "General"
L["option_category_frames"] = "Frames"
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
    "To create a frame, enter a name and then push 'Create frame'. Once you create a frame, a new item will appear below allowing you to configure it."

L["option_create_frame_input"] = "New frame name"
L["option_create_frame_input_desc"] = "Enter a short name for your frame (eg. coolframe1, gold, etc)"

L["option_create_frame_exec"] = "Create Frame"
L["option_create_frame_exec_desc"] =
    "Create a frame called '%s'. Once you create it, a new row for it will appear in addon options."

L["option_create_frame_error_exists"] = "A frame with that name already exists"

L["option_frame_delete"] = "Delete frame"
L["option_frame_delete_desc"] = "Delete this frame. |cffff0000Irreversible!|r"
L["option_frame_delete_confirm"] = "Are you sure you want to delete this frame. |cffff0000This is irreversible!|r"
