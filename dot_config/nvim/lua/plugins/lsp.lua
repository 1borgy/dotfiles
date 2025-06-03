vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})
local icons = require("config.icons")

local diagnostic_opts = {
  underline = true,
  update_in_insert = false,
  float = { border = "rounded" },
  jump = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
  -- virtual_text = false,
  -- virtual_lines = true,
  virtual_text = {
    spacing = 4,
    source = "if_many",
    severity = { min = vim.diagnostic.severity.ERROR },
    prefix = " ● ",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
    },
  },
}

vim.diagnostic.config(diagnostic_opts)

return {
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "ansiblels",
        "arduino_language_server",
        "lua_ls",
        "pyright",
        "ruff",
        "rust_analyzer",
        "yamlls",
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- local function set_min_severity(severity)
      --   local new_opts = vim.tbl_deep_extend("force", diagnostic_opts, {
      --     signs = { severity = { min = severity } },
      --     -- virtual_text = { severity = { min = severity } },
      --     jump = { severity = { min = severity } },
      --     underline = { severity = { min = severity } },
      --   })
      --   local tid = require("tiny-inline-diagnostic")
      --   local tid_severities = {}
      --   for _, level in ipairs({
      --     vim.diagnostic.severity.ERROR,
      --     vim.diagnostic.severity.WARN,
      --   }) do
      --     if level <= severity then
      --       tid_severities[#tid_severities + 1] = level
      --     end
      --   end
      --
      --   return function()
      --     vim.diagnostic.config(new_opts)
      --     tid.change_severities(tid_severities)
      --     vim.cmd(":e")
      --   end
      -- end
      --
      --   local map = vim.keymap.set
      --   map("n", "<leader>de", set_min_severity(vim.diagnostic.severity.ERROR), { desc = "diagnostic.severity = error" })
      --   map("n", "<leader>dw", set_min_severity(vim.diagnostic.severity.WARN), { desc = "diagnostic.severity = warn" })
      --   map("n", "<leader>di", set_min_severity(vim.diagnostic.severity.INFO), { desc = "diagnostic.severity = info" })
      --   map("n", "<leader>dh", set_min_severity(vim.diagnostic.severity.HINT), { desc = "diagnostic.severity = hint" })
    end,
  },
}
