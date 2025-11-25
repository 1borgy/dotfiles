return {
  { "rktjmp/shipwright.nvim", cmd = "Shipwright" },
  {
    -- "1borgy/nyappuccin.nvim",
    dir = "/Users/eleanor.bergman/dev/nyappuccin.nvim/",
    dependencies = "rktjmp/lush.nvim",
    priority = 10000,
    config = function(_, opts)
      require("nyappuccin").setup(opts)
      vim.cmd.colorscheme("nyappuccin")
    end,
  },
}
