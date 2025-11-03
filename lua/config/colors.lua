-- ~/.config/nvim/lua/config/colors.lua
local M = {}

-- Список доступных схем (имена ровно как у :colorscheme)
local schemes = {
  "tokyonight",            -- из folke/tokyonight.nvim
  "catppuccin",            -- из catppuccin/nvim
  -- "kanagawa",            -- если добавишь плагин kanagawa.nvim
}

-- Команда :ThemePick — меню выбора
function M.pick()
  vim.ui.select(schemes, { prompt = "Choose colorscheme:" }, function(choice)
    if not choice then return end
    local ok, err = pcall(vim.cmd, "colorscheme " .. choice)
    if not ok then
      vim.notify("Failed to set colorscheme: " .. err, vim.log.levels.ERROR)
    else
      vim.notify("Colorscheme: " .. choice, vim.log.levels.INFO)
    end
  end)
end

-- Зарегистрировать команду
vim.api.nvim_create_user_command("ThemePick", M.pick, {})

return M

