-- ~/.config/nvim/lua/config/alpha.lua
local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

local header = {
  "      _   _           _         ",
  " __ _| \\ | | ___   __| | ___ _ __ ",
  "/ _` |  \\| |/ _ \\ / _` |/ _ \\ '__|",
  "| (_| | |\\  | (_) | (_| |  __/ |   ",
  " \\__,_|_| \\_|\\___/ \\__,_|\\___|_|   ",
}

local function footer()
  local total_plugins = 0
  local startuptime = 0
  local ok, lazy = pcall(require, "lazy")
  if ok and lazy.stats then
    local stats = lazy.stats()
    total_plugins = stats.loaded
    startuptime = stats.startuptime
  end
  return string.format("Neovim ready  -  %d plugins in %.2fms", total_plugins, startuptime)
end

local buttons = {
  dashboard.button("f", "[F] Find file", "<cmd>Telescope find_files<cr>"),
  dashboard.button("r", "[R] Recent files", "<cmd>Telescope oldfiles<cr>"),
  dashboard.button("p", "[P] Recent projects", "<cmd>ProjectPick<cr>"),
  dashboard.button("n", "[N] New file", "<cmd>ene | startinsert<cr>"),
  dashboard.button("q", "[Q] Quit", "<cmd>qa<cr>"),
}

local function recent_files(max_items)
  local items = {}
  local seen = {}
  for _, filepath in ipairs(vim.v.oldfiles or {}) do
    if #items >= max_items then break end
    if vim.fn.filereadable(filepath) == 1 and not seen[filepath] then
      local display = vim.fn.fnamemodify(filepath, ":~:.")
      table.insert(items, dashboard.button(tostring(#items + 1), display, "<cmd>edit " .. vim.fn.fnameescape(filepath) .. "<cr>"))
      seen[filepath] = true
    end
  end
  if #items == 0 then
    return { { type = "text", val = "No recent files", opts = { position = "center" } } }
  end
  return items
end

dashboard.section.header.val = header
dashboard.section.buttons.val = buttons
dashboard.section.buttons.opts.spacing = 1
dashboard.section.footer.val = footer()
dashboard.section.footer.opts.position = "center"

local recent_section = {
  type = "group",
  val = {
    { type = "text", val = "Recent files", opts = { hl = "Comment", position = "center" } },
    { type = "padding", val = 1 },
    { type = "group", val = recent_files(8) },
  },
}

dashboard.config.layout = {
  dashboard.section.header,
  { type = "padding", val = 1 },
  dashboard.section.buttons,
  { type = "padding", val = 1 },
  recent_section,
  { type = "padding", val = 1 },
  dashboard.section.footer,
}

alpha.setup(dashboard.config)

vim.api.nvim_create_autocmd("User", {
  pattern = "AlphaReady",
  callback = function(event)
    pcall(vim.api.nvim_buf_set_option, event.buf, "buflisted", false)
  end,
})
