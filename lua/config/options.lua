-- ~/.config/nvim/lua/config/options.lua
local o = vim.opt

o.termguicolors = true
o.number = true
o.relativenumber = true
o.cursorline = true
o.signcolumn = "yes"
o.wrap = false
o.scrolloff = 8
o.sidescrolloff = 8

o.tabstop = 2
o.shiftwidth = 2
o.expandtab = true
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.incsearch = true
o.hlsearch = true

o.splitbelow = true
o.splitright = true
o.updatetime = 200
o.timeoutlen = 400

o.undofile = true
o.undodir = vim.fn.stdpath("state") .. "/undo"
o.swapfile = false
o.backup = false
o.completeopt = "menu,menuone,noinsert"
