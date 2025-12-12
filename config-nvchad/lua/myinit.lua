local opt = vim.opt

opt.number = true
opt.relativenumber = true               -- show relative line numbers for jumping
opt.clipboard = ""                      -- go back to default vim copy/paste behaviour
opt.whichwrap = ""                      -- don't go to next line when using left/right in the beggining
opt.cursorline = true                   -- highlight the current line
opt.cursorlineopt = "both"              -- highlight both line number AND line content

opt.undofile = true                     -- track undos
opt.undodir = vim.fn.expand('$HOME/.vim/undo') -- undo directory
opt.undolevels = 1000                   -- maximum number of changes that can be undone
opt.undoreload = 10000                  -- maximum number lines to save for undo on a buffer reload

-- Disable line numbers in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

if vim.g.neovide then

  -- Debian + KDE5
  if vim.loop.os_uname().sysname == "Linux" then
    vim.o.guifont = "Lilex Nerd Font Propo:h12"
  -- macOS
  else
    vim.o.guifont = "Lilex Nerd Font Propo:h16"
  end
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_input_macos_alt_is_meta = true

  -- Allow clipboard copy paste in neovim
  vim.g.neovide_input_use_logo = 1
	vim.api.nvim_set_keymap('v', '<C-c>', '"+y', {noremap = true})
	vim.api.nvim_set_keymap('n', '<C-v>', 'l"+P', {noremap = true})
	vim.api.nvim_set_keymap('v', '<C-v>', '"+P', {noremap = true})
	vim.api.nvim_set_keymap('c', '<C-v>', '<C-o>l<C-o>"+<C-o>P<C-o>l', {noremap = true})
	vim.api.nvim_set_keymap('i', '<C-v>', '<ESC>l"+Pli', {noremap = true})
	vim.api.nvim_set_keymap('t', '<C-v>', '<C-\\><C-n>"+Pi', {noremap = true})
else
  opt.mouse = ""                          -- don't use mouse at all
end

vim.g.nvimtree_side = "right"

-- Override LSP floating window utility to always use borders
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Configure diagnostics display
-- This needs to be delayed to override NvChad's settings
vim.schedule(function()
  local x = vim.diagnostic.severity
  vim.diagnostic.config({
    float = {
      border = "rounded",
      source = "always",  -- Show source (e.g., eslint, pyright)
      wrap = true,        -- Enable text wrapping
      max_width = 80,     -- Maximum width of floating window
    },
    virtual_text = {
      prefix = "●",       -- Icon to show before diagnostic
      spacing = 4,        -- Spacing between text and diagnostic
    },
    signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
  })
end)

-- Set updatetime for faster CursorHold events (used by GitSigns, etc.)
-- Default is 4000ms
vim.opt.updatetime = 1000
