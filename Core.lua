-- Addon namespace
local _, private = ...

BrokerFrames = LibStub("AceAddon-3.0"):NewAddon(private.ADDON_NAME,
                                                "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(private.ADDON_NAME)

function BrokerFrames:OnInitialize() print("Addon initialized") end
