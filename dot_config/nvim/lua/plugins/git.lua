return {
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    opts = {
      enhanced_diff_hl = true,
      default = { disable_diagnostics = false },
      view = {
        merge_tool = {
          winbar_info = true,
        },
      },
    },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "open diffview" },
      { "<leader>gf", "<cmd>DiffviewFileHistory<cr>", desc = "open file history" },
    },
  },
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    event = "VeryLazy",
    config = true,
    keys = {
      { "<leader>gq", "<Cmd>GitConflictListQf<CR>", desc = "list conflicts (qflist)" },
      { "<leader>gr", "<Cmd>GitConflictRefresh<CR>", desc = "refresh conflicts (qflist)" },
    },
  },
}
