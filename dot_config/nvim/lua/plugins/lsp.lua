vim.lsp.config("*", {
  capabilities = vim.lsp.protocol.make_client_capabilities(),
})

return {
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", event = "VeryLazy", opts = {} },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "ansible-language-server",
        "arduino-language-server",
        "just-lsp",
        "lua-language-server",
        "pyright",
        { "ruff", version = "0.12.11" },
        "rust-analyzer",
        "yaml-language-server",
        "yamlfmt",
        "prettier",
        "typescript-language-server",
        "eslint-lsp",
        "zls",
        "stylua",
        "gopls",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "LspAttach",
    dependencies = { "williamboman/mason.nvim" },
    opts = {},
    --   config = function(_, opts)
    --     require("mason-lspconfig").setup(opts)
    --
    --     -- local function set_min_severity(severity)
    --     --   local new_opts = vim.tbl_deep_extend("force", diagnostic_opts, {
    --     --     signs = { severity = { min = severity } },
    --     --     -- virtual_text = { severity = { min = severity } },
    --     --     jump = { severity = { min = severity } },
    --     --     underline = { severity = { min = severity } },
    --     --   })
    --     --   local tid = require("tiny-inline-diagnostic")
    --     --   local tid_severities = {}
    --     --   for _, level in ipairs({
    --     --     vim.diagnostic.severity.ERROR,
    --     --     vim.diagnostic.severity.WARN,
    --     --   }) do
    --     --     if level <= severity then
    --     --       tid_severities[#tid_severities + 1] = level
    --     --     end
    --     --   end
    --     --
    --     --   return function()
    --     --     vim.diagnostic.config(new_opts)
    --     --     tid.change_severities(tid_severities)
    --     --     vim.cmd(":e")
    --     --   end
    --     -- end
    --     --
    --     --   local map = vim.keymap.set
    --     --   map("n", "<leader>de", set_min_severity(vim.diagnostic.severity.ERROR), { desc = "diagnostic.severity = error" })
    --     --   map("n", "<leader>dw", set_min_severity(vim.diagnostic.severity.WARN), { desc = "diagnostic.severity = warn" })
    --     --   map("n", "<leader>di", set_min_severity(vim.diagnostic.severity.INFO), { desc = "diagnostic.severity = info" })
    --     --   map("n", "<leader>dh", set_min_severity(vim.diagnostic.severity.HINT), { desc = "diagnostic.severity = hint" })
    --   end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  { -- optional blink completion source for require statements and module annotations
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
        },
      },
    },
  },
}
