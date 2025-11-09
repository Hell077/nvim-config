-- ~/.config/nvim/lua/config/projects.lua
local project = require("project_nvim")

project.setup({
  -- как определять корень проекта:
  detection_methods = { "lsp", "pattern" },
  patterns = {
    ".git", "go.mod", "package.json", "Cargo.toml", "pyproject.toml",
    "Makefile", "docker-compose.yml", "compose.yml",
  },
  show_hidden = true,
  silent_chdir = true,
})

-- Пикер "последние 3 директории"
local function pick_recent_dirs()
  local telescope_ok, telescope = pcall(require, "telescope")
  if telescope_ok and telescope.extensions and telescope.extensions.projects then
    telescope.extensions.projects.projects({})
    return
  end
  local recent = project.get_recent_projects() or {}
  -- оставим только уникальные существующие пути
  local paths = {}
  local set = {}
  for _, p in ipairs(recent) do
    if vim.fn.isdirectory(p) == 1 and not set[p] then
      table.insert(paths, p)
      set[p] = true
    end
  end
  -- возьмём первые три
  local top = {}
  for i = 1, math.min(3, #paths) do top[i] = paths[i] end
  if #top == 0 then
    vim.notify("Нет недавних проектов", vim.log.levels.INFO)
    return
  end
  vim.ui.select(top, { prompt = "Open recent project:" }, function(choice)
    if not choice then return end
    vim.cmd("cd " .. vim.fn.fnameescape(choice))
    -- откроем список файлов сразу (как IDE)
    require("telescope.builtin").find_files({ cwd = choice, hidden = true })
  end)
end

-- Команда и хоткей
vim.api.nvim_create_user_command("ProjectPick", pick_recent_dirs, {})
vim.keymap.set("n", "<leader>pp", "<cmd>ProjectPick<cr>", { desc = "Pick recent project (top 3)" })

-- Открывать меню при старте, если nvim запущен без файлов
