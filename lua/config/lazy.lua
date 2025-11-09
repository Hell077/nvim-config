-- ~/.config/nvim/lua/config/lazy.lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv and vim.loop then vim.uv = vim.loop end
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Плагины
require("lazy").setup({

  -- базовые
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },

  -- Telescope (поиск файлов/текста)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.telescope")
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    config = function()
      require("config.projects")
    end,
  },
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.alpha")
    end,
  },


  -- Встроенные терминалы
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("config.toggleterm")
    end,
  },

  -- Тема (по умолчанию)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.opt.termguicolors = true
      vim.cmd("colorscheme tokyonight")
    end,
  },

  -- Доп. тема (по желанию переключать через ThemePick)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
  },

  -- Treesitter (подсветка, парсинг)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        -- базовое
        "lua", "vim", "vimdoc", "query", "bash", "regex",
        "c", "cpp",
        -- web
        "javascript", "typescript", "tsx", "html", "css", "json", "jsonc", "yaml", "toml",
        -- backend
        "go", "gomod", "gowork", "rust", "python", "sql", "dockerfile",
        -- docs/markdown
        "markdown", "markdown_inline",
      },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      auto_install = true,
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    version = "v0.1.7", -- зафиксировали стабильную
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("config.lsp")
    end,
  },

  -- Вкладки/буферы
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("config.bufferline")
    end,
  },

  -- Корректное удаление буфера
  { "moll/vim-bbye", event = "VeryLazy" },

  -- nvim-cmp (автокомплит) + сниппеты + источники
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      require("config.cmp")
    end,
  },

  -- автоскобки
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Gitsigns (инлайн дифы, подсветка изменений в коде)
{
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("gitsigns").setup({
      signs = {
        add          = { text = "│" },
        change       = { text = "│" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
      current_line_blame = true, -- показывать blame справа от строки
      preview_config = {
        border = "rounded",
        style = "minimal",
      },
    })
  end,
},

-- Lazygit (полноценный UI как в JetBrains VCS)
{
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
  },
},

-- Diffview (как в IDE – панель дифов, история коммитов)
{
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Git Diff view" },
    { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File history" },
  },
  config = function()
    require("diffview").setup({
      view = {
        merge_tool = { layout = "diff3_mixed" },
        default = { layout = "diff2_horizontal" },
      },
    })
  end,
},

  -- Файловое дерево
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          git_status = {
            symbols = {
              added     = "A",
              modified  = "M",
              deleted   = "D",
              renamed   = "R",
              untracked = "U",
              ignored   = "◌",
              staged    = "S",
              conflict  = "",
            },
          },
        },
        window = { width = 32, mappings = { ["<space>"] = "none" } },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false, -- показываем игнорируемые
          },
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
        },
      })

      -- Подсветка статусов Git в дереве
      local function set_neotree_git_highlights()
        vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#00d084" }) -- зелёный
        vim.api.nvim_set_hl(0, "NeoTreeGitStaged",   { fg = "#00d084" })
        vim.api.nvim_set_hl(0, "NeoTreeGitIgnored",  { fg = "#ff8800" }) -- оранжевый
      end
      set_neotree_git_highlights()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_neotree_git_highlights })
    end,
  },

-- ← тут заканчивается СПИСОК ПЛАГИНОВ
}, {
  -- ← это уже ВТОРОЙ аргумент setup: глобальные опции lazy.nvim
  ui = { border = "rounded" },
  change_detection = { notify = false },
})
