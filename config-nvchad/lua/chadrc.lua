---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "ashes",  -- keep your preferred theme
  theme_toggle = { "ashes", "one_light" },  -- keep your theme toggles
  hl_override = require("highlights").override,
  hl_add = require("highlights").add,
}

M.ui = {
  telescope = { style = "bordered" },

  term = {
    winopts = { number = false },

    -- Window position and sizes
    sizes = {
      sp = 0.5,    -- Split window height (40% of total)
      vsp = 0.6,   -- Vertical split width (60% of total)
    },
  },

  statusline = {
    theme = "default",
    separator_style = "arrow",
    overriden_modules = function(modules)
      table.insert(
        modules,
        2,
        (function()
          if vim.api.nvim_buf_get_name(0) ~= "" then
            local path = vim.api.nvim_buf_get_name(0):match "^.*/"
            path = string.gsub(path, "/home/wieslaw", "~")
            path = string.gsub(path, "/Users/wieslawherr", "~")
            path = string.gsub(path, "/home/herself", "~")
            path = string.gsub(path, "GIT_REPOS/(.)[^/]*/", "GR%1/")
            path = string.gsub(path, "/$", "")
            return "%#St_file_info# " .. path
          else
            return ""
          end
        end)()
      )
    end,
  },

  tabufline = {
    show_numbers = true,
  },
}

return M
