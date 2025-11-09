-- ~/.config/nvim/lua/config/toggleterm.lua
local toggleterm = require("toggleterm")

toggleterm.setup({
  size = 18,                      -- высота терминала внизу
  open_mapping = [[<C-`>]],       -- клавиша открытия (Ctrl + `)
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = "horizontal",       -- открывается снизу
  close_on_exit = true,
  shell = vim.o.shell,
  autochdir = true,                -- терминал следует за текущим project root
})

-- Горизонтальный терминал по Ctrl+`
vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm direction=horizontal<cr>", { desc = "Toggle terminal (bottom)" })

-- Вертикальный терминал (справа)
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm size=60 direction=vertical<cr>", { desc = "Toggle vertical terminal" })

-- Плавающее окно (как popup)
vim.keymap.set("n", "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", { desc = "Toggle floating terminal" })

-- Навигация между несколькими терминалами
vim.keymap.set("n", "<leader>tn", "<cmd>ToggleTermNext<cr>", { desc = "Next terminal" })
vim.keymap.set("n", "<leader>tp", "<cmd>ToggleTermPrev<cr>", { desc = "Previous terminal" })

-- Быстрое открытие / переключение между терминалами (1–10)
-- ===============================
-- Терминалы 1–10: открыть/переключить Ctrl+1..0, закрыть Ctrl+W + 1..0
-- ===============================
for i = 1, 10 do
  local key = i % 10 -- чтобы Ctrl+0 был терминал №10
  if key == 0 then key = 10 end

  -- Открыть или переключить терминал
  vim.keymap.set({ "n", "t" }, "<C-" .. key .. ">", function()
    local Terminal = require("toggleterm.terminal").Terminal
    local term = require("toggleterm.terminal").get(key)
    if term and term:is_open() then
      term:focus()  -- если открыт — фокусируемся
    else
      -- если нет — создаём и открываем
      term = Terminal:new({ id = key, direction = "horizontal" })
      term:toggle()
    end
  end, { desc = "Toggle terminal " .. key })

  -- Закрыть терминал
  vim.keymap.set({ "n", "t" }, "<C-w>" .. key, function()
    local term = require("toggleterm.terminal").get(key)
    if term and term:is_open() then
      term:close()
      vim.notify("Closed terminal " .. key, vim.log.levels.INFO, { title = "ToggleTerm" })
    else
      vim.notify("Terminal " .. key .. " not open", vim.log.levels.WARN, { title = "ToggleTerm" })
    end
  end, { desc = "Close terminal " .. key })
end

