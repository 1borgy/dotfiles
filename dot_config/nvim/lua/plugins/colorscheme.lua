return {
  -- { "rktjmp/lush.nvim", event = "VeryLazy" },
  { "rktjmp/shipwright.nvim", cmd = "Shipwright" },
  {
    "1borgy/nyappuccin.nvim",
    -- dir = "/Users/ellie/dev/nyappuccin.nvim",
    dependencies = "rktjmp/lush.nvim",
    priority = 10000,
    -- enabled = false,
    config = function(_, opts)
      require("nyappuccin").setup(opts)
      vim.cmd.colorscheme("nyappuccin")
    end,
  },
  {
    "github-main-user/lytmode.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      require("lytmode").setup()
      vim.cmd.colorscheme("lytmode")
    end,
  },
}
