-- To find any highlight groups: "<cmd> Telescope highlights"
-- Each highlight group can take a table with variables fg, bg, bold, italic, etc
-- base30 variable names can also be used as colors

local M = {}

M.override = {
  Comment = {
    italic = true,
    fg = "#82868b"
  },
  DiagnosticInformation = {
    bg = "#3c3c3c"
  },
  DiagnosticHint = {
    bg = "#3c3c3c"
  },
  DiagnosticWarn = {
    bg = "#3c3c3c"
  },
  DiagnosticError = {
    bg = "#3c3c3c"
  },
}

M.add = {
  NvimTreeOpenedFolderName = { fg = "green", bold = true },
  CursorLine = {
    bg = "one_bg"
  },
}

return M
