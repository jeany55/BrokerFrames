-- Addon namespace
local _, private = ...

local constants = private.constants
local BrokerFrames = LibStub("AceAddon-3.0"):GetAddon(constants.ADDON_NAME)
local L = LibStub("AceLocale-3.0"):GetLocale(constants.ADDON_NAME)

-- Marks a frame for deletion, either not rendering it next time the game starts (or reuse it if the user wants to make a new frame)
function BrokerFrames:DeleteFrame(name)
  private.frameInstances[name].active = false
  private.frameInstances[name].frame:Hide()
  self.db.char.frames[name] = nil
end

-- Either creates a new instance, or updates the look and feel of an existing rendered frame
function BrokerFrames:CreateOrUpdateFrame(config)
  local name = config.name

  local frameInstance
  if private.frameInstances[name] then
    frameInstance = private.frameInstances[name].frame
  else
    frameInstance = CreateFrame("Frame", "BrokerFrames-" .. name, UIParent, "BackdropTemplate")
    BrokerFrames:PrintDebugMessage("Creating new frame instance for %s (no existing found)", name)
    frameInstance:SetPoint("CENTER")
    private.frameInstances[name] = { active = true, frame = frameInstance, rows = {} }
  end

  frameInstance:SetBackdrop({
    bgFile = config.background,
    edgeFile = config.edge,
    tile = config.tile,
    tileSize = config.tileSize,
    edgeSize = config.edgeSize,
    insets = { left = config.insets.left, right = config.insets.right, top = config.insets.top, bottom = config.insets.bottom }
  })
  frameInstance:SetBackdropColor(config.backgroundColor.r, config.backgroundColor.g, config.backgroundColor.b,
                                 config.backgroundColor.a)
  frameInstance:SetBackdropBorderColor(config.borderColor.r, config.borderColor.g, config.borderColor.b, config.borderColor.a)
  frameInstance:SetSize(config.width, config.height)
  frameInstance:SetBorderBlendMode(config.borderBlend)

  local allowMovement = function()
    local shiftKeyCondition = true
    if config.requireShift then
      shiftKeyCondition = IsShiftKeyDown()
    end

    return (not config.locked) and shiftKeyCondition
  end

  frameInstance:SetMovable(not config.locked)
  frameInstance:EnableMouse(true)
  frameInstance:RegisterForDrag("LeftButton")
  frameInstance:SetScript("OnDragStart", function(self)
    if allowMovement() then
      frameInstance:StartMoving()
    end
  end)
  frameInstance:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
end
