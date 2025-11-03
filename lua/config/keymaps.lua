-- ~/.config/nvim/lua/config/keymaps.lua
local map = vim.keymap.set

-- Лидер
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Базовое
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Файловое дерево
map("n", "<C-t>", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })

-- Поиск
map("n", "ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })

-- Навигация по открытым файлам (буферам)
map("n", "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer (Ctrl+Tab)" })
map("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer (Ctrl+Shift+Tab)" })

-- Закрытие текущего файла (буфера)
-- ВНИМАНИЕ: это перекрывает стандартный префикс управления окнами <C-w>
map("n", "<C-w>", "<cmd>Bdelete<cr>", { desc = "Delete buffer (Ctrl+W)" })
map("n", "<C-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<C-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
-- Быстрое переключение между деревом и файлом
map("n", "<leader>e", function()
  local neotree = require("neo-tree.sources.manager")
  local state = neotree.get_state("filesystem")
  if state and state.winid and vim.api.nvim_win_is_valid(state.winid) then
    -- Если дерево открыто — фокусируем его
    if vim.api.nvim_get_current_win() ~= state.winid then
      vim.api.nvim_set_current_win(state.winid)
    else
      -- если уже в дереве — фокус обратно на окно с файлом
      vim.cmd("wincmd p")
    end
  else
    -- если дерево не открыто — просто открыть
    vim.cmd("Neotree show filesystem left")
  end
end, { desc = "Focus toggle between Neo-tree and file" })

map("n", "<leader>ct", "<cmd>ThemePick<cr>", { desc = "Choose colorscheme" })
-- Save on Ctrl+S (normal/insert/visual)
vim.keymap.set("n", "<C-s>", "<cmd>w<cr>", { desc = "Save" })
vim.keymap.set("i", "<C-s>", "<Esc><cmd>w<cr>a", { desc = "Save" })
vim.keymap.set("v", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save" })
map({ "n", "i" }, "<C-z>", function()
  vim.cmd("silent! undo")
end, { desc = "Undo" })

map({ "n", "i" }, "<C-y>", function()
  vim.cmd("silent! redo")
end, { desc = "Redo" })
