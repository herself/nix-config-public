require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<leader>n", ":set relativenumber!<CR>", { desc = "Toggle relative numbers" })
map('n', '<leader>fm', ':lua require("conform").format()<CR>', { desc = "Format with conform", noremap = true, silent = true })

-- Ctrl - F11 for escaping terminal
map("t", "<C-F11>", "<C-\\><C-N>", { noremap = true, silent = true, desc = "terminal escape terminal mode" })
map("t", "<F35>", "<C-\\><C-N>", { noremap = true, silent = true, desc = "terminal escape terminal mode" })

-- H & L for indent manipulation
map("n", "H", function() vim.cmd("normal! <<") vim.cmd("normal! " .. vim.bo.shiftwidth .. "h") end, { desc = "Indent" })
map("n", "L", function() vim.cmd("normal! >>") vim.cmd("normal! " .. vim.bo.shiftwidth .. "l") end, { desc = "Unindent" })
map("v", "H", function() vim.cmd("normal! <<") vim.cmd("normal! " .. vim.bo.shiftwidth .. "h") end, { desc = "Indent" })
map("v", "L", function() vim.cmd("normal! >>") vim.cmd("normal! " .. vim.bo.shiftwidth .. "l") end, { desc = "Unindent" })

-- move in and out of terminal
map('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = "Move out of terminal" })
map('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = "Move out of terminal" })
map('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = "Move out of terminal" })
map('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = "Move out of terminal" })

-- unmap the default <leader>h
pcall(vim.keymap.del, "n", "<leader>h")

-- Unmap default terminal keybindings
pcall(vim.keymap.del, "n", "<A-i>")  -- floating terminal
pcall(vim.keymap.del, "t", "<A-i>")
pcall(vim.keymap.del, "n", "<A-h>")  -- horizontal terminal
pcall(vim.keymap.del, "t", "<A-h>")

-- Bind <leader>tt to toggle floating terminal
map({ "n", "t" }, "<leader>tt", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "floatTerm",
    float_opts = {
      row = 0.15,
      col = 0.15,
      width = 0.7,
      height = 0.65,
      border = "single",
    }
  }
end, { desc = "Toggle floating terminal" })

-- Show full diagnostic in floating window
map("n", "gl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- Override default <leader>e to toggle nvim-tree instead of focus
pcall(vim.keymap.del, "n", "<leader>e")
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })

-- Toggle iron REPL window
map("n", "<leader>ie", "<cmd>IronRepl<cr>", { desc = "Toggle REPL window" })
