local overrides = require("configs.overrides")

local plugins = {

	-- Override
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			-- format & linting
			{
				"stevearc/conform.nvim",
				-- event = 'BufWritePre', -- uncomment for format on save
				opts = require("configs.conform"),
			},
		},
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end, -- Override to setup mason-lspconfig
	},

	{
		"hrsh7th/nvim-cmp",
		opts = overrides.cmp,
	},

	-- {
	--   "williamboman/mason.nvim",
	--   cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
	--   config = function(_)
	--     require("mason").setup({
	--       ensure_installed = overrides.mason_lspconfig.ensure_installed,
	--     })
	--     -- Ensure mason-lspconfig is loaded and configured
	--     require("mason-lspconfig").setup({
	--       ensure_installed = overrides.mason_lspconfig.ensure_installed,
	--       automatic_installation = true,
	--     })
	--   end,
	--   dependencies = {
	--     "williamboman/mason-lspconfig.nvim",
	--   },
	-- },

	{
		"nvim-treesitter/nvim-treesitter",
		opts = overrides.treesitter,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = overrides.nvimtree,
	},

	{
		"vladdoster/remember.nvim",
		config = function()
			require("remember")
		end,
		lazy = false,
	},

	-- Install
	{
		"max397574/better-escape.nvim",
		event = "InsertEnter",
		config = function()
			require("better_escape").setup()
		end,
	},

	{
		"vim-scripts/surround.vim",
		lazy = false,
	},

	{
		"tpope/vim-fugitive",
		lazy = false,
	},

	{
		"towolf/vim-helm",
		lazy = false,
	},

  {
  'hkupty/iron.nvim',
  cmd = {
    "IronRepl",
    "IronReplHere",
    "IronFocus",
    "IronSend",
    "IronRestart",
  },
  config = function()
    require("iron.core").setup({
      config = {
        -- By default, iron will reuse the same REPL instance for the same filetype
        repl_definition = {
          python = {
            command = {"python"}
          },
          haskell = {
            command = {"ghci"}
          }
        },
        repl_open_cmd = "vertical botright 80 split",
      },
      keymaps = {
        send_motion = "<leader>is",
        visual_send = "<leader>is",
        send_line = "<leader>il",
        send_file = "<leader>if",
        exit = "<leader>ic",
        clear = "<leader>ix",
      },
    })
  end,
  keys = {
      {"<leader>is", desc = "Send code to REPL"},
      {"<leader>il", desc = "Send line to REPL"},
      {"<leader>if", desc = "Send file to REPL"},
      {"<leader>ic", desc = "Close REPL"},
      {"<leader>ix", desc = "Clear REPL"},
    },
  },

  {
  "telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    opts = overrides.telescope,
  },

  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup({
        handle = {
          color = "#3b4261",
        },
        marks = {
          Search = { color = "#ff9e64" },
          Error = { color = "#db4b4b" },
          Warn = { color = "#e0af68" },
          Info = { color = "#0db9d7" },
          Hint = { color = "#1abc9c" },
          Misc = { color = "#9d7cd8" },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = false,
          handle = true,
          search = false,  -- Disabled to avoid hlslens warning
        },
      })
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      lazygit = {
        enabled = true,
        configure = true,
      },
    },
    keys = {
      { "<leader>gg", function()
          require("snacks").lazygit({
            win = {
              width = 0.95,  -- 95% of screen width
              height = 0.9,  -- 90% of screen height
            }
          })
        end,
        desc = "Lazygit"
      },
    },
  },

	-- Disable
	{
		"windwp/nvim-autopairs",
		enabled = false,
	},

  {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 24
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,
      open_mapping = [[<F11>]],
      hide_numbers = true,
      shade_terminals = false,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      direction = 'horizontal',
    })
  end,
  keys = {
    {"<F11>", desc = "Toggle terminal"},
    -- {"<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Toggle horizontal terminal"},
    -- {"<leader>tv", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Toggle vertical terminal"},
    -- {"<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "Toggle float terminal"},
  },
}
}

return plugins
