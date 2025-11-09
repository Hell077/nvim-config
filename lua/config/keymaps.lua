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
map("n", "fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })

-- Навигация по открытым файлам (буферам)
map("n", "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer (Ctrl+Tab)" })
map("n", "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer (Ctrl+Shift+Tab)" })

-- Закрытие текущего файла (буфера)
-- ВНИМАНИЕ: это перекрывает стандартный префикс управления окнами <C-w>
map("n", "<C-w>", "<cmd>Bdelete<cr>", { desc = "Delete buffer (Ctrl+W)" })
map("n", "<C-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "<C-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
-- Быстрое переключение между деревом и файлом
-- === SPACE + e — Переключение между деревом и текущим файлом ===
map("n", "<leader>e", function()
  local neotree_state_ok, state = pcall(require, "neo-tree.sources.manager")
  if not neotree_state_ok then
    vim.cmd("Neotree toggle") -- fallback если neo-tree не инициализирован
    return
  end

  local current_source = state.get_state("filesystem")
  if current_source and current_source.winid and vim.api.nvim_win_is_valid(current_source.winid) then
    -- Если открыт — фокусируемся на буфер
    vim.cmd("wincmd p")
  else
    -- Если не открыт — открываем дерево
    vim.cmd("Neotree focus filesystem left")
  end
end, { desc = "Toggle focus between Neo-tree and file" })

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

map({ "n", "v" }, "<C-Left>",  "b", { desc = "Move left by word" })
map({ "n", "v" }, "<C-Right>", "w", { desc = "Move right by word" })
map({ "n", "v" }, "<C-Up>",    "{", { desc = "Move up by paragraph" })
map({ "n", "v" }, "<C-Down>",  "}", { desc = "Move down by paragraph" })

-- В режиме вставки — перемещение без выхода
map("i", "<C-Left>",  "<C-o>b", { desc = "Move left by word" })
map("i", "<C-Right>", "<C-o>w", { desc = "Move right by word" })
map("i", "<C-Up>",    "<C-o>{", { desc = "Move up by paragraph" })
map("i", "<C-Down>",  "<C-o>}", { desc = "Move down by paragraph" })

-- === Ctrl+Shift для выделения текста ===
map("n", "<C-S-Left>",  "vb", { desc = "Select word left" })
map("n", "<C-S-Right>", "vw", { desc = "Select word right" })
map("n", "<C-S-Up>",    "v{", { desc = "Select paragraph up" })
map("n", "<C-S-Down>",  "v}", { desc = "Select paragraph down" })

-- В режиме вставки — временно выходим и выделяем
map("i", "<C-S-Left>",  "<Esc>vb", { desc = "Select word left" })
map("i", "<C-S-Right>", "<Esc>vw", { desc = "Select word right" })
map("i", "<C-S-Up>",    "<Esc>v{", { desc = "Select paragraph up" })
map("i", "<C-S-Down>",  "<Esc>v}", { desc = "Select paragraph down" })

-- === Ctrl + Shift + h/l — посимвольное выделение ===
map("n", "<C-S-h>", "vh", { desc = "Select left char" })
map("n", "<C-S-l>", "vl", { desc = "Select right char" })
map("i", "<C-S-h>", "<Esc>vh", { desc = "Select left char" })
map("i", "<C-S-l>", "<Esc>vl", { desc = "Select right char" })

map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move current line up", silent = true })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move current line down", silent = true })

-- Визуальный режим — двигаем выделенный блок
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move selected block up", silent = true })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move selected block down", silent = true })

-- Вставочный режим — временно выходим, двигаем, возвращаемся
map("i", "<A-Up>", "<Esc>:m .-2<CR>==gi", { desc = "Move current line up (insert)", silent = true })
map("i", "<A-Down>", "<Esc>:m .+1<CR>==gi", { desc = "Move current line down (insert)", silent = true })
local builtin = require("telescope.builtin")

vim.keymap.set({ "n", "i", "v" }, "<C-f>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
  builtin.current_buffer_fuzzy_find({
    previewer = false,
    layout_config = { width = 0.9, height = 0.8 },
  })
end, { desc = "Find in current file" })
