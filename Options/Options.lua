-- Addon namespace
local _, private = ...

local constants = private.constants
local L = LibStub("AceLocale-3.0"):GetLocale(constants.ADDON_NAME)
local BrokerFrames = LibStub("AceAddon-3.0"):GetAddon(constants.ADDON_NAME)

-- Wrapper to set a value in characters addon options DB
local function setBooleanValueInDatabaseSettings(keyName, value) BrokerFrames.db.char.addonOptions[keyName] = value end
-- Wrapper to get a value in characters addon options DB
local function getBooleanValueInDatabaseSettings(keyName) return BrokerFrames.db.char.addonOptions[keyName] end

-- Addon options entry page
local launchConfig = {
  type = "group",
  name = "",
  args = {
    about = { type = "description", order = 0, fontSize = "large", name = "|cFFFFA500" .. constants.ADDON_NAME .. "|r" },
    about_group = {
      type = "group",
      inline = true,
      name = "",
      args = {
        version = { type = "description", width = "full", order = 1, name = "v." .. constants.ADDON_VERSION },
        author = { type = "description", width = "full", order = 2, name = "by " .. constants.AUTHOR },
        github = { type = "input", width = 3, order = 3, name = "Github", get = function() return constants.GITHUB_REPO end }
      }
    }
  }
}

-- General addon settings
local generalConfig = {
  type = "group",
  name = L["option_category_general"],
  args = {
    debug_messages = {
      type = "toggle",
      width = "full",
      name = L["option_debug_messages"],
      desc = L["option_debug_messages_desc"],
      get = function() return getBooleanValueInDatabaseSettings('showDebugMessages') end,
      set = function(_, val) setBooleanValueInDatabaseSettings('showDebugMessages', val) end
    }
  }
}

local knownLdbItems = 0
---Config tab
local ldbInfoConfig = {
  type = "group",
  name = L["option_category_ldb_info"],
  args = {
    description = {
      type = "description",
      order = 0,
      name = function() return format(L["option_ldb_info_header"], knownLdbItems) end
    }
  }
}

---Informs options that LDB has been loaded and the ldb info should be added to the LDB info screen
function BrokerFrames:InformOptionsOfNewLDBData(key, data)
  ldbInfoConfig.args[key] = {
    type = "group",
    inline = true,
    name = key,
    args = { type = { order = 1, type = "description", name = L["option_ldb_type"] .. " " .. data.type } }
  }

  local label = data.label or L["none"]
  ldbInfoConfig.args[key].args.label = { order = 2, type = "description", name = L["option_ldb_label"] .. " " .. label }

  if data.icon then
    ldbInfoConfig.args[key].args.icon = { order = 0, type = "description", name = "  |T" .. data.icon .. ":28|t" }
  end

  knownLdbItems = knownLdbItems + 1
end

---Handles registration of the addon's config with Ace3Config, adding it into Blizzard options 
function BrokerFrames:RegisterOptions()
  -- Main entry
  LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME, launchConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME, constants.ADDON_NAME)

  -- General
  LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME .. '-General', generalConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME .. '-General', generalConfig.name, constants.ADDON_NAME)

  BrokerFrames:SetupCreateFrameOptions()

  -- -- Create new frames
  -- LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME .. '-Frames', private.frameConfig)
  -- LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME .. '-Frames', private.frameConfig.name,
  --                                                 constants.ADDON_NAME)
  -- LDB known data
  LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME .. '-LdbInfo', ldbInfoConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME .. '-LdbInfo', ldbInfoConfig.name, constants.ADDON_NAME)
end

---Checks known addon options and sees if the user doesn't know about any of them.
---This is either the case when the addon is first loaded after installation or a new config value has been added in an update.
---If an unknown setting is found then the default will be set.
function BrokerFrames:SetUnregisteredOptionsToDefaults()
  if not self.db.char.addonOptions then
    self.db.char.addonOptions = {}
  end

  for optionName, defaultValue in pairs(private.defaultConfig) do
    if self.db.char.addonOptions[optionName] == nil then
      self.db.char.addonOptions[optionName] = defaultValue
    end
  end
end
