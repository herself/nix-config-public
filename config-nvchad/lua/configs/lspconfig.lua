local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities
local on_init = require("nvchad.configs.lspconfig").on_init

-- Configure LSP floating window borders BEFORE enabling servers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
  }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "rounded",
  }
)

-- List of LSP servers to configure with default settings
local servers = { "html", "cssls", "clangd", "terraformls", "nixd", "yamlls", "helm_ls", "hls", "bashls"}

-- Configure servers with default settings using new vim.lsp.config API
for _, lsp in ipairs(servers) do
  vim.lsp.config[lsp] = {
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = on_init,
  }
  -- Enable the LSP server to start automatically
  vim.lsp.enable(lsp)
end

-- Configure pylsp with custom settings
vim.lsp.config.pylsp = {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = on_init,
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'W391'},
          maxLineLength = 200
        }
      }
    }
  }
}
-- Enable pylsp to start automatically
vim.lsp.enable('pylsp')
