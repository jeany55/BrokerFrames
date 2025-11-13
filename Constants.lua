-- Addon namespace
local _, private = ...

private.constants = {
  ADDON_NAME = "BrokerFrames",
  ADDON_VERSION = C_AddOns.GetAddOnMetadata("BrokerFrames", "Version"),
  GITHUB_REPO = "https://github.com/jeany55/BrokerFrames/",
  AUTHOR = "Jeany-Nazgrim"
}

private.defaultConfig = { showDebugMessages = false }

private.defaultFrameConfig = {
  locked = false,
  requireShift = true,
  background = "Interface\\Tooltips\\UI-Tooltip-Background",
  edge = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true,
  tileSize = 5,
  edgeSize = 5,
  insets = { left = 5, right = 5, top = 5, bottom = 5 },
  backgroundColor = { r = 0, g = 0, b = 0 },
  resizeAutomatically = true,
  width = 100,
  height = 25
}
