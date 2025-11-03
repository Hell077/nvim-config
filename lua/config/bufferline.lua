-- ~/.config/nvim/lua/config/bufferline.lua
require("bufferline").setup({
  options = {
    mode = "buffers",
    numbers = "none",
    diagnostics = "nvim_lsp",
    separator_style = "slant", -- "thin" | "thick" | "slant"
    show_buffer_close_icons = true,
    show_close_icon = false,
    always_show_bufferline = true,
    offsets = {
      { filetype = "neo-tree", text = "Explorer", text_align = "left", separator = true },
    },
  },
})
