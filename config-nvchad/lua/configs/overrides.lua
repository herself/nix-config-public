local M = {}

M.treesitter = {
  ensure_installed = {
    "c",
    "css",
    "haskell",
    "html",
    "javascript",
    "lua",
    "markdown",
    "markdown_inline",
    "nix",
    "bash",
    "python",
    "terraform",
    "tsx",
    "typescript",
    "vim",
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
}

-- M.mason_lspconfig = {
--   ensure_installed = {
--     -- lua stuff
--     "lua_ls",
--     "clangd",
--   },
-- }
--
-- M.mason = {
--   ensure_installed = {
--     -- Formatters and others
--     "stylua",
--     "prettier",
--     "clang-format",
--   },
-- }

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },
  filters = {
    dotfiles = true,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
  },
  view = {
    side = "right",
    width = 45,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- Default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- Custom mapping: 'l' to change directory down and update vim's cwd
    vim.keymap.set('n', 'l', function()
      local node = api.tree.get_node_under_cursor()
      if node and node.type == 'directory' then
        api.tree.change_root_to_node()
        vim.cmd('cd ' .. node.absolute_path)
      else
        api.node.open.edit()
      end
    end, opts('CD'))

    -- Custom mapping: 'h' to go up one directory level and update vim's cwd
    vim.keymap.set('n', 'h', function()
      api.tree.change_root_to_parent()
      local cwd = vim.fn.getcwd()
      local parent = vim.fn.fnamemodify(cwd, ':h')
      vim.cmd('cd ' .. parent)
    end, opts('Up'))
  end,
}

-- get text completion from all buffers
M.cmp = {
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lua" },
    { name = "path" },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    }
  }
}

-- Custom telescope action for multi-select with <CR>
local select_one_or_multi = function(prompt_bufnr)
  local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
  local multi = picker:get_multi_selection()
  if not vim.tbl_isempty(multi) then
    require('telescope.actions').close(prompt_bufnr)
    for _, j in pairs(multi) do
      if j.path ~= nil then
        vim.cmd(string.format('%s %s', 'edit', j.path))
      end
    end
  else
    require('telescope.actions').select_default(prompt_bufnr)
  end
end

M.telescope = {
  defaults = {
    fuzzy = true,
    mappings = {
      i = {
        ["<CR>"] = select_one_or_multi,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
  extensions_list = { "fzf" },
}

return M
