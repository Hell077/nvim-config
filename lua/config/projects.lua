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

-- Красивый пикер недавних проектов
local function pick_recent_dirs()
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
  if #paths == 0 then
    vim.notify("Нет недавних проектов", vim.log.levels.INFO)
    return
  end
  local telescope_ok, _ = pcall(require, "telescope")
  if telescope_ok then
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers.new({}, {
      prompt_title = "Recent Projects",
      finder = finders.new_table({
        results = paths,
        entry_maker = function(path)
          return {
            value = path,
            display = path,
            ordinal = path,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, _)
        local function open_project()
          local selection = action_state.get_selected_entry()
          if not selection then return end
          actions.close(prompt_bufnr)
          local choice = selection.value
          vim.cmd("cd " .. vim.fn.fnameescape(choice))
          vim.cmd("edit " .. vim.fn.fnameescape(choice))
        end
        actions.select_default:replace(open_project)
        return true
      end,
    }):find()
    return
  end
  vim.ui.select(paths, { prompt = "Open recent project:" }, function(choice)
    if not choice then return end
    vim.cmd("cd " .. vim.fn.fnameescape(choice))
    vim.cmd("edit " .. vim.fn.fnameescape(choice))
  end)
end

-- Команда и хоткей
vim.api.nvim_create_user_command("ProjectPick", pick_recent_dirs, {})
vim.keymap.set("n", "<leader>pp", "<cmd>ProjectPick<cr>", { desc = "Pick recent project" })

-- Открывать меню при старте, если nvim запущен без файлов
