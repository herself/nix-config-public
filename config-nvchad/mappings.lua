local M = {}

-- helper funciton that returns an ordered list of buffers
local function list_buffers()
  return vim.tbl_filter(function(buf) return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted') end, vim.api.nvim_list_bufs())
end

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>n"] = { ":set relativenumber!<CR>", "Toggle relative numbers", opts = { nowait = true } },
    ["<C-h>"] = { "<<", "Indent"},
    ["<C-l>"] = { ">>", "Unindent"},
    ["<C-j>"] = { "mz:m+<cr>`z", "Move line down"},
    ["<C-k>"] = { "mz:m-2<cr>`z", "Move line up"},
  },
  v = {
    [">"] = { ">gv", "indent"},
    ["<C-h>"] = { "<", "Indent"},
    ["<C-l>"] = { ">", "Unindent"},
    ["<C-j>"] = { ":m'>+<cr>`<my`>mzgv`yo`z", "Move line down"},
    ["<C-k>"] = { "mz:m-2<cr>`z", "Move line up"},
  },
}

-- M.buffers = {
--  n = {
--  ["<A-1>"] = { function() switch_buffer(1) end, "Go to buffer #1", },
--  },
--}
M.buffers = { n = {}, }
for i = 1, 9 do
  M.buffers.n["<A-" .. i .. ">"] = { function() vim.cmd("b" .. list_buffers()[i]) end, "Go to buffer #" .. i, }
end

return M
