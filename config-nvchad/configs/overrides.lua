local M = {}

M.treesitter = {
  ensure_installed = {
    "vim",
    "lua",
    "nix",
    "html",
    "css",
    "javascript",
    "typescript",
    "terraform",
    "python",
    "tsx",
    "c",
    "markdown",
    "markdown_inline",
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

M.mason = {
  ensure_installed = {
    -- lua stuff
    "lua-language-server",
    "stylua",

    -- web dev stuff
    "css-lsp",
    "html-lsp",
    "typescript-language-server",
    "deno",
    "prettier",

    -- c/cpp stuff
    "clangd",
    "clang-format",
  },
}

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
    width = 35,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

return M
