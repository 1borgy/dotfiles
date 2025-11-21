local icons = require("config.icons")
local diagnostic_opts = {
  underline = true,
  update_in_insert = false,
  float = { border = "rounded" },
  jump = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
  virtual_text = false,
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
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    -- event = "LspAttach",
    event = "VeryLazy",
    priority = 1000, -- needs to be loaded in first
    enabled = true,
    opts = function()
      local success, C = pcall(require, "nyappuccin.colors")
      local mixing_color = nil
      if success then
        mixing_color = tostring(C.base)
      end

      return {
        preset = "modern",
        hi = { mixing_color = mixing_color },
        options = {
          use_icons_from_diagnostic = true,
          multilines = true,
          severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
          },
        },
        signs = {
          left = "",
          right = "",
          diag = "●",
          arrow = "   ",
          up_arrow = "    ",
          vertical = " │",
          vertical_end = " └",
        },
      }
    end,
  },
}
