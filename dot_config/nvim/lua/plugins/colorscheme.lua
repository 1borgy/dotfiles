return {
  -- { "rktjmp/lush.nvim", event = "VeryLazy" },
  { "rktjmp/shipwright.nvim", cmd = "Shipwright" },
  {
    -- "1borgy/nyappuccin.nvim",
    dir = "/Users/ellie/dev/nyappuccin.nvim",
    dependencies = "rktjmp/lush.nvim",
    priority = 10000,
    init = function()
      vim.cmd.colorscheme("nyappuccin")
    end,
  },
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 10000,
  --   init = function()
  --     vim.cmd.colorscheme("catppuccin-latte")
  --   end,
  -- },
  -- {
  --   "comfysage/cuddlefish.nvim",
  --   priority = 10000,
  --   init = function()
  --     vim.cmd.colorscheme("cuddlefish")
  --   end,
  -- },
}
