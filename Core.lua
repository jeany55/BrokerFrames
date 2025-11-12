-- Addon namespace
local _, private = ...
local BrokerFrames = LibStub("AceAddon-3.0"):NewAddon(
                         private.constants.ADDON_NAME,
                         "AceConsole-3.0", "AceEvent-3.0")

private.LDBData = {}
private.frames = {}

-- Is called when LDB informs BrokerFrames that new LDB data is available
function BrokerFrames:OnNewLdbDataEvent(self, name_str, obj)
  BrokerFrames:PrintDebugMessage("Received LDB data about %s",
                                 name_str)
  private.LDBData[name_str] = obj
  BrokerFrames:InformOptionsOfNewLDBData(name_str, obj)
end

---Addon initializer. Runs when addon is loaded and ready to go.
function BrokerFrames:OnInitialize()
  self.db = LibStub("AceDB-3.0"):New("BrokerFramesDB")
  BrokerFrames:SetUnregisteredOptionsToDefaults()

  if not self.db.char.frames then
    self.db.char.frames = {}
  end

  -- Tell LDB we'd like to be informed about any data objects created
  local ldb = LibStub("LibDataBroker-1.1", true)
  ldb.RegisterCallback(self, "LibDataBroker_DataObjectCreated",
                       "OnNewLdbDataEvent")

  BrokerFrames:RegisterOptions()
end

---Print a message to the chat window if the user has turned on debug messages in addon settings
function BrokerFrames:PrintDebugMessage(message, ...)
  if self.db.char.addonOptions.showDebugMessages == true then
    BrokerFrames:Printf("|cffff0000[Debug]|r " .. message, ...)
  end
end
