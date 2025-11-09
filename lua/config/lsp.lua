-- ~/.config/nvim/lua/config/lsp.lua
local lspconfig = require("lspconfig")

-- Mason bootstrap
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "rust_analyzer",
    "lua_ls",
    "pyright",
    "clangd",
    "tsserver",
    "jdtls",
    "kotlin_language_server",
    "intelephense",
    "omnisharp",
    "clojure_lsp",
  },
})
require("mason-tool-installer").setup({
  ensure_installed = {
    "gopls",
    "typescript-language-server",
    "rust-analyzer",
    "lua-language-server",
    "pyright",
    "clangd",
    "typescript-language-server",
    "jdtls",
    "kotlin-language-server",
    "intelephense",
    "omnisharp",
    "clojure-lsp",
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

-- TypeScript / JavaScript
lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Java
lspconfig.jdtls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Kotlin
lspconfig.kotlin_language_server.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Python (Pyright)
lspconfig.pyright.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",  -- можно "off", "basic", "strict"
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly", -- чтобы не грузил весь проект
      },
    },
  },
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

-- PHP
lspconfig.intelephense.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- C#
lspconfig.omnisharp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- Lisp (Clojure)
lspconfig.clojure_lsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
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
