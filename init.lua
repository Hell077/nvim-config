vim.g.mapleader = " "
vim.g.maplocalleader = " "

if not vim.lsp.buf_get_clients then
     vim.lsp.buf_get_clients  = function (bufnr)
     return vim.lsp.get_clients({bufnr = bufnr})
  end
end

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.colors")
