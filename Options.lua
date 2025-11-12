-- Addon namespace
local _, private = ...

local constants = private.constants

local L = LibStub("AceLocale-3.0"):GetLocale(constants.ADDON_NAME)
local BrokerFrames = LibStub("AceAddon-3.0"):GetAddon(constants.ADDON_NAME)

-- Wrapper to set a value in characters addon options DB
local function setBooleanValueInDatabaseSettings(keyName, value) BrokerFrames.db.char.addonOptions[keyName] = value end
-- Wrapper to get a value in characters addon options DB
local function getBooleanValueInDatabaseSettings(keyName) return BrokerFrames.db.char.addonOptions[keyName] end

local additionalOptionFrames = {}

-- Forces BrokerFrame's WoW's addon options to update when its open
local function forceConfigRerender()
  local ACR = LibStub("AceConfigRegistry-3.0")
  ACR:NotifyChange(constants.ADDON_NAME)
end

-- Holds Ace3 Config object when clicking into addon options
local launchConfig = {
  type = "group",
  name = "",
  args = {
    about = { type = "description", order = 0, fontSize = "large", name = "|cFFFFA500" .. private.constants.ADDON_NAME .. "|r" },
    about_group = {
      type = "group",
      inline = true,
      name = "",
      args = {
        version = { type = "description", width = "full", order = 1, name = "v." .. private.constants.ADDON_VERSION },
        author = { type = "description", width = "full", order = 2, name = "by " .. private.constants.AUTHOR },
        github = {
          type = "input",
          width = 3,
          order = 3,
          name = "Github",
          get = function() return "https://github.com/jeany55/BrokerFrames" end
        }
      }
    }
  }
}

-- Holds Ace3 Config object for general addon settings
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

local inputFrameFieldText = ""

local function makeNewFrameOption(name, ref)
  local optionsTab = {
    type = "group",
    name = name,
    inline = true,
    args = {
      exec = {
        order = 0,
        func = function()
          ref.args[name] = nil
          forceConfigRerender()
        end,
        type = "execute",
        name = L["option_frame_delete"],
        desc = L["option_frame_delete_desc"],
        confirm = function() return L["option_frame_delete_confirm"] end
      }
    }
  }

  additionalOptionFrames[name] = optionsTab
  ref.args[name] = optionsTab

  forceConfigRerender()
end

private.frameConfig = {
  type = "group",
  name = L["option_category_frames"],
  args = {
    create_new_frame = {
      type = "group",
      inline = true,
      name = L["option_create_frame"],
      args = {
        header = { type = "description", order = 0, name = L["option_create_frame_header"] },
        frameName = {
          type = "input",
          order = 1,
          name = L["option_create_frame_input"],
          desc = L["option_create_frame_input_desc"],
          get = function() return inputFrameFieldText end,
          set = function(_, val) inputFrameFieldText = val end,
          validate = function(_, val)
            if private.frames[val] then
              return L["option_create_frame_error_exists"]
            end
            return true
          end
        },
        createFrame = {
          type = "execute",
          order = 2,
          func = function()
            makeNewFrameOption(inputFrameFieldText, private.frameConfig)
            inputFrameFieldText = ""
          end,
          name = L["option_create_frame_exec"],
          disabled = function() return inputFrameFieldText == "" end,
          desc = function() return format(L["option_create_frame_exec_desc"], inputFrameFieldText) end
        }
      }
    }
  }
}

local frameOrder = 3

local knownLdbItems = 0

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

---Handles registration of the addon's config with Ace3Config, adding it into Blizzard options 
function BrokerFrames:RegisterOptions()
  -- Main entry
  LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME, launchConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME, constants.ADDON_NAME)

  -- General
  LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME .. '-General', generalConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME .. '-General', generalConfig.name, constants.ADDON_NAME)

  -- Create new frames
  LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME .. '-Frames', private.frameConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME .. '-Frames', private.frameConfig.name,
                                                  constants.ADDON_NAME)
  -- LDB known data
  LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME .. '-LdbInfo', ldbInfoConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME .. '-LdbInfo', ldbInfoConfig.name, constants.ADDON_NAME)
end

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
