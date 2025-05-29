return {
  -- { "rktjmp/lush.nvim", event = "VeryLazy" },
  { "rktjmp/shipwright.nvim", cmd = "Shipwright" },
  {
    "1borgy/nyappuccin.nvim",
    -- dir = "/Users/ellie/dev/nyappuccin.nvim",
    dependencies = "rktjmp/lush.nvim",
    priority = 10000,
    config = function(_, opts)
      require("nyappuccin").setup(opts)
      vim.cmd.colorscheme("nyappuccin")
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 10000,
  --   init = function()
  --     vim.cmd.colorscheme("catppuccin-frappe")
  --   end,
  -- },
  {
    "everviolet/nvim",
    name = "evergarden",
    priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
    enabled = false,
    opts = {
      theme = {
        variant = "fall", -- 'winter'|'fall'|'spring'|'summer'
        accent = "purple",
      },
      editor = {
        transparent_background = false,
        sign = { color = "none" },
        float = {
          color = "base",
          invert_border = false,
        },
        completion = {
          color = "surface0",
        },
      },
    },
    config = function(_, opts)
      require("evergarden").setup(opts)
      vim.cmd.colorscheme("evergarden-fall")
    end,
  },

  -- {
  --   "comfysage/cuddlefish.nvim",
  --   priority = 10000,
  --   config = function(_, opts)
  --     require("cuddlefish").setup(opts)
  --     vim.cmd.colorscheme("cuddlefish")
  --   end,
  -- },
}
