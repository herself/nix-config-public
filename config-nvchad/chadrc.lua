---@type ChadrcConfig
local M = {}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "ashes",
  theme_toggle = { "ashes", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  telescope = {
    style = "bordered",
  },
  tabufline = {
    show_numbers = true,
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
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
