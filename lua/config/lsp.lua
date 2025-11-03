-- ~/.config/nvim/lua/config/lsp.lua
local lspconfig = require("lspconfig")

-- Mason bootstrap
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "rust_analyzer",
    "lua_ls",
  },
})
require("mason-tool-installer").setup({
  ensure_instualled = {
    "gopls","typescript-language-server", "rust-analyzer", "lua-language-server",
  },
  auto_update = false,
  run_on_start = true,
})

-- capabilities для nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- on_attach: локальные бинды для LSP
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
end

  -- твои хоткеи:
  map("n", "K", vim.lsp.buf.hover, "LSP Hover")
  map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  map("n", "gr", vim.lsp.buf.references, "Find References")
  map("n", "<leader>r", vim.lsp.buf.rename, "Rename Symbol")

  -- форматирование
  map("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, "Format Buffer")
end

-- Сервера
-- Go
lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      gofumpt = true,
      analyses = { unusedparams = true, nilness = true, unusedwrite = true, shadow = true },
      staticcheck = true,
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Rust
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      check = { command = "clippy" },
    },
  },
})

-- Lua (Neovim)
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",          -- символ перед текстом (можно "●", "▎", "■", "→")
    spacing = 2,           -- расстояние от кода до текста
    source = "if_many",    -- показывать источник (LSP)
    severity_sort = true,  -- сортировать по важности
  },
  signs = true,            -- символы в колонке слева
  underline = true,        -- подчёркивание ошибочных мест
  update_in_insert = true,
  float = {
    border = "rounded",    -- окно при наведении
    source = "always",
  },
})
