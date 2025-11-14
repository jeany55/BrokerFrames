-- Addon namespace
local _, private = ...

local constants = private.constants
local BrokerFrames = LibStub("AceAddon-3.0"):GetAddon(constants.ADDON_NAME)
local L = LibStub("AceLocale-3.0"):GetLocale(constants.ADDON_NAME)

local inputFrameFieldInput = ""

-- Forces BrokerFrame's WoW's addon options to update when its open
local function forceConfigRerender()
  local ACR = LibStub("AceConfigRegistry-3.0")
  ACR:NotifyChange(constants.ADDON_NAME)
end

-- Creates a frame in the options menu and inserts into addon database. If no options is passed in then defaults are used
local function createFrame(frameName, options)
  local frameSettings = options and options or private.defaultFrameConfig
  frameSettings.name = frameName

  BrokerFrames.db.char.frames[frameName] = frameSettings
  BrokerFrames:CreateOrUpdateFrame(frameSettings)

  local function updateRenderedFrame() BrokerFrames:CreateOrUpdateFrame(BrokerFrames.db.char.frames[frameName]) end

  local optionsTab = {
    type = "group",
    name = "|cff9ff5a0" .. frameName .. "|r",
    args = {
      exec = {
        order = 0,
        func = function()
          private.frameConfig.args[frameName] = nil
          BrokerFrames.db.char.frames[frameName] = nil
          BrokerFrames:DeleteFrame(frameName)
          forceConfigRerender()
        end,
        type = "execute",
        name = L["option_frame_delete"],
        desc = L["option_frame_delete_desc"],
        confirm = function() return L["option_frame_delete_confirm"] end
      },
      general = {
        order = 0,
        type = "group",
        inline = true,
        name = L["option_category_general"],
        args = {
          locked = {
            order = 1,
            type = "toggle",
            width = "full",
            name = L["option_frame_lock"],
            desc = L["option_frame_lock_desc"],
            get = function() return BrokerFrames.db.char.frames[frameName].locked end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].locked = val
              updateRenderedFrame()
            end
          },
          require_shift = {
            order = 2,
            type = "toggle",
            width = "full",
            disabled = function() return BrokerFrames.db.char.frames[frameName].locked == true end,
            name = L["option_frame_shift"],
            desc = L["option_frame_shift_desc"],
            get = function() return BrokerFrames.db.char.frames[frameName].requireShift end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].requireShift = val
              updateRenderedFrame()
            end
          },
          calculate_width = {
            order = 3,
            type = "toggle",
            width = "full",
            get = function() return BrokerFrames.db.char.frames[frameName].resizeAutomatically end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].resizeAutomatically = val
              updateRenderedFrame()
            end,
            name = L["option_frame_resize"],
            desc = L["option_frame_resize_desc"]
          },
          width = {
            order = 4,
            type = "range",
            get = function() return BrokerFrames.db.char.frames[frameName].width end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].width = val
              updateRenderedFrame()
            end,
            disabled = function() return BrokerFrames.db.char.frames[frameName].resizeAutomatically == true end,
            name = L["option_frame_width"],
            desc = L["option_frame_width_desc"],
            min = 5,
            max = 700
          },
          height = {
            order = 5,
            type = "range",
            get = function() return BrokerFrames.db.char.frames[frameName].height end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].height = val
              updateRenderedFrame()
            end,
            disabled = function() return BrokerFrames.db.char.frames[frameName].resizeAutomatically == true end,
            name = L["option_frame_height"],
            desc = L["option_frame_height_desc"],
            min = 5,
            max = 700
          }
        }
      },
      look_and_feel = {
        order = 1,
        type = "group",
        inline = true,
        name = L["option_create_frame_look_feel"],
        args = {
          frameBackground = {
            name = L["option_frame_create_bg"],
            desc = L["option_frame_create_bg_desc"],
            type = "input",
            width = "full",
            order = 0,
            get = function() return BrokerFrames.db.char.frames[frameName].background end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].background = val
              updateRenderedFrame()
            end
          },
          frameEdge = {
            name = L["option_frame_create_edge"],
            desc = L["option_frame_create_edge_desc"],
            type = "input",
            width = "full",
            order = 2,
            get = function() return BrokerFrames.db.char.frames[frameName].edge end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].edge = val
              updateRenderedFrame()
            end
          },
          tile = {
            name = L["option_frame_tile"],
            desc = L["option_frame_tile_desc"],
            type = "toggle",
            width = "full",
            order = 3,
            get = function() return BrokerFrames.db.char.frames[frameName].tile end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].tile = val
              updateRenderedFrame()
            end
          },
          tileSize = {
            name = L["option_frame_tile_size"],
            desc = L["option_frame_tile_size_desc"],
            type = "range",
            width = "full",
            disabled = function() return BrokerFrames.db.char.frames[frameName].tile == false end,
            order = 4,
            min = 0,
            max = 30,
            get = function() return BrokerFrames.db.char.frames[frameName].tileSize end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].tileSize = val
              updateRenderedFrame()
            end
          },
          edgeSize = {
            name = L["option_frame_edge_size"],
            desc = L["option_frame_edge_size_desc"],
            type = "range",
            width = "full",
            order = 5,
            min = 0,
            max = 30,
            get = function() return BrokerFrames.db.char.frames[frameName].edgeSize end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].edgeSize = val
              updateRenderedFrame()
            end
          },
          insets = {
            name = L["option_frame_insets"],
            inline = true,
            type = "group",
            order = 6,
            args = {
              left = {
                name = L["option_frame_insets_left"],
                desc = L["option_frame_insets_left_desc"],
                type = "range",
                width = "full",
                order = 4,
                min = 0,
                max = 30,
                get = function() return BrokerFrames.db.char.frames[frameName].insets.left end,
                set = function(_, val)
                  BrokerFrames.db.char.frames[frameName].insets.left = val
                  updateRenderedFrame()
                end
              },
              right = {
                name = L["option_frame_insets_right"],
                desc = L["option_frame_insets_right_desc"],
                type = "range",
                width = "full",
                order = 5,
                min = 0,
                max = 30,
                get = function() return BrokerFrames.db.char.frames[frameName].insets.right end,
                set = function(_, val)
                  BrokerFrames.db.char.frames[frameName].insets.right = val
                  updateRenderedFrame()
                end
              },
              top = {
                name = L["option_frame_insets_top"],
                desc = L["option_frame_insets_top_desc"],
                type = "range",
                width = "full",
                order = 4,
                min = 0,
                max = 30,
                get = function() return BrokerFrames.db.char.frames[frameName].insets.top end,
                set = function(_, val)
                  BrokerFrames.db.char.frames[frameName].insets.top = val
                  updateRenderedFrame()
                end
              },
              bottom = {
                name = L["option_frame_insets_bottom"],
                desc = L["option_frame_insets_bottom_desc"],
                type = "range",
                width = "full",
                order = 5,
                min = 0,
                max = 30,
                get = function() return BrokerFrames.db.char.frames[frameName].insets.bottom end,
                set = function(_, val)
                  BrokerFrames.db.char.frames[frameName].insets.bottom = val
                  updateRenderedFrame()
                end
              }
            }
          },
          backgroundColor = {
            order = 5.1,
            type = "color",
            name = L["option_frame_backdrop_color"],
            desc = L["option_frame_backdrop_color_desc"],
            width = "full",
            hasAlpha = true,
            set = function(_, r, g, b, a)
              if (r == 0 and g == 0 and b == 0) then
                -- Color picker malfunctions when picking black?
                BrokerFrames.db.char.frames[frameName].backgroundColor.r = 0.05
                BrokerFrames.db.char.frames[frameName].backgroundColor.g = 0.05
                BrokerFrames.db.char.frames[frameName].backgroundColor.b = 0.05
                BrokerFrames.db.char.frames[frameName].backgroundColor.a = 1
                return
              end
              BrokerFrames.db.char.frames[frameName].backgroundColor.r = r
              BrokerFrames.db.char.frames[frameName].backgroundColor.g = g
              BrokerFrames.db.char.frames[frameName].backgroundColor.b = b
              BrokerFrames.db.char.frames[frameName].backgroundColor.a = a
              updateRenderedFrame()
            end,
            get = function()
              return BrokerFrames.db.char.frames[frameName].backgroundColor.r,
                     BrokerFrames.db.char.frames[frameName].backgroundColor.g,
                     BrokerFrames.db.char.frames[frameName].backgroundColor.b,
                     BrokerFrames.db.char.frames[frameName].backgroundColor.a
            end
          },
          borderColor = {
            order = 5.2,
            type = "color",
            name = L["option_frame_border_color"],
            desc = L["option_frame_border_color_desc"],
            width = "full",
            hasAlpha = true,
            set = function(_, r, g, b, a)
              if (r == 0 and g == 0 and b == 0) then
                -- Color picker malfunctions when picking black?
                BrokerFrames.db.char.frames[frameName].borderColor.r = 0.05
                BrokerFrames.db.char.frames[frameName].borderColor.g = 0.05
                BrokerFrames.db.char.frames[frameName].borderColor.b = 0.05
                BrokerFrames.db.char.frames[frameName].borderColor.a = 1
                return
              end
              BrokerFrames.db.char.frames[frameName].borderColor.r = r
              BrokerFrames.db.char.frames[frameName].borderColor.g = g
              BrokerFrames.db.char.frames[frameName].borderColor.b = b
              BrokerFrames.db.char.frames[frameName].borderColor.a = a
              updateRenderedFrame()
            end,
            get = function()
              return BrokerFrames.db.char.frames[frameName].borderColor.r, BrokerFrames.db.char.frames[frameName].borderColor.g,
                     BrokerFrames.db.char.frames[frameName].borderColor.b, BrokerFrames.db.char.frames[frameName].borderColor.a
            end
          },
          borderStyle = {
            order = 5.3,
            type = "select",
            name = L["option_border_blend"],
            desc = L["option_border_blend_desc"],
            values = {
              ADD = L["option_border_blend_add"],
              BLEND = L["option_border_blend_blend"],
              MOD = L["option_border_blend_mod"],
              ALPHAKEY = L["option_border_blend_alphakey"],
              DISABLE = L["option_border_blend_disable"],
              OVERLAY = L["option_border_blend_overlay"]
            },
            get = function() return BrokerFrames.db.char.frames[frameName].borderBlend end,
            set = function(_, val)
              BrokerFrames.db.char.frames[frameName].borderBlend = val
              updateRenderedFrame()
            end
          }
        }

      }
    }
  }

  private.frameConfig.args[frameName] = optionsTab
  forceConfigRerender()
end

private.frameConfig = {
  type = "group",
  name = L["option_category_frames"],
  args = {
    create_new_frame = {
      type = "group",
      -- inline = true,
      name = L["option_create_frame"],
      args = {
        header = { type = "description", order = 0, name = L["option_create_frame_header"] },
        frameName = {
          type = "input",
          order = 1,
          name = L["option_create_frame_input"],
          desc = L["option_create_frame_input_desc"],
          get = function() return inputFrameFieldInput end,
          set = function(_, val) inputFrameFieldInput = val end,
          validate = function(_, val)
            if private.frameConfig.args[val] or val == L["option_create_frame"] then
              return L["option_create_frame_error_exists"]
            end
            return true
          end
        },
        createFrame = {
          type = "execute",
          order = 2,
          func = function()
            createFrame(inputFrameFieldInput)
            inputFrameFieldInput = ""
          end,
          name = L["option_create_frame_exec"],
          disabled = function() return inputFrameFieldText == "" end,
          desc = function() return format(L["option_create_frame_exec_desc"], inputFrameFieldInput) end
        }
      }
    }
  }
}

function BrokerFrames:SetupCreateFrameOptions()
  -- Load any existing frames saved
  for name, data in pairs(self.db.char.frames) do
    createFrame(name, data)
  end

  -- Create new frames
  LibStub("AceConfig-3.0"):RegisterOptionsTable(constants.ADDON_NAME .. '-Frames', private.frameConfig)
  LibStub("AceConfigDialog-3.0"):AddToBlizOptions(constants.ADDON_NAME .. '-Frames', private.frameConfig.name,
                                                  constants.ADDON_NAME)
end
