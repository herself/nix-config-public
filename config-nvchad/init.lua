local opt = vim.opt

opt.number = true
opt.relativenumber = true               -- show relative line numbers for jumping
opt.clipboard = ""                      -- go back to default vim copy/paste behaviour
opt.whichwrap = ""                      -- don't go to next line when using left/right in the beggining

opt.undofile = true                     -- track undos
opt.undodir = vim.fn.expand('$HOME/.vim/undo') -- undo directory
opt.undolevels = 1000                   -- maximum number of changes that can be undone
opt.undoreload = 10000                  -- maximum number lines to save for undo on a buffer reload

if vim.g.neovide then
  vim.o.guifont = "Lilex Nerd Font Propo:h16"
  vim.g.neovide_cursor_vfx_mode = "railgun"
  vim.g.neovide_input_macos_alt_is_meta = true

  -- Allow clipboard copy paste in neovim
  vim.g.neovide_input_use_logo = 1
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
else
  opt.mouse = ""                          -- don't use mouse at all
end

vim.g.nvimtree_side = "right"
