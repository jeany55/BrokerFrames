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
  tileSize = 16,
  edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 },
  backgroundColor = { r = 0.05, g = 0.05, b = 0.05, a = 1 },
  borderColor = { r = 1.0, g = 1.0, b = 1.0, a = 1.0 },
  borderBlend = "BLEND",
  resizeAutomatically = true,
  width = 100,
  height = 25,
  rows = {}
}

private.defaultRowConfig = { dataType = "", showLabel = true, useLabelFromLdb = true, customLabel = "" }
