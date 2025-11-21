return {
  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "echasnovski/mini.icons",
    },
    version = "1.*",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "enter" },
      appearance = { nerd_font_variant = "normal" },
      completion = {
        menu = {
          draw = {
            treesitter = { "lsp" },
            components = {
              kind_icon = {
                ellipsis = false,
                text = function(ctx)
                  local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                  return kind_icon
                end,
                -- Optionally, you may also use the highlights from mini.icons
                highlight = function(ctx)
                  local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                  return hl
                end,
              },
            },
          },
          border = "rounded",
        },
        documentation = {
          window = { border = "rounded" },
          auto_show = true,
          auto_show_delay_ms = 0,
        },
        ghost_text = { enabled = vim.g.ai_cmp },
      },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
    opts_extend = { "sources.default" },
  },
}
