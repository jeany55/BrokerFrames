-- Addon namespace
local _, private = ...

private.constants = {
  ADDON_NAME = "BrokerFrames",
  ADDON_VERSION = C_AddOns.GetAddOnMetadata("BrokerFrames", "Version"),
  GITHUB_REPO = "https://github.com/jeany55/BrokerFrames/",
  AUTHOR = "Jeany-Nazgrim"
}

private.defaultConfig = { showDebugMessages = false }
