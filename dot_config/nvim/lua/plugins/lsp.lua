-- local keymaps = {}
--
-- ---@type LazyKeysLspSpec[]|nil
-- keymaps._keys = nil
--
-- ---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], cond?:fun():boolean}
-- ---@alias LazyKeysLsp LazyKeys|{has?:string|string[], cond?:fun():boolean}
--
-- ---@return LazyKeysLspSpec[]
-- function keymaps.get()
--   if keymaps._keys then
--     return keymaps._keys
--   end
--   -- local builtin = require("telescope.builtin")
--   local noice_lsp = require("noice.lsp")
--
--     -- stylua: ignore
--     keymaps._keys = {
--         -- { "<leader>cl", "<cmd>LspInfo<cr>",         desc = "Lsp Info" },
--         -- { "gd",         "<cmd>FzfLua lsp_definitions<cr>",     desc = "Goto Definition" },
--         -- { "gr",         "<cmd>FzfLua lsp_references<cr>",      desc = "References",            nowait = true },
--         -- { "gI",         "<cmd>FzfLua lsp_implementations<cr>", desc = "Goto Implementation" },
--         -- { "gy",         "<cmd>FzfLua lsp_typedefs<cr>",        desc = "Goto T[y]pe Definition" },
--         -- { "gD",         "<cmd>FzfLua lsp_declarations<cr>",    desc = "Goto Declaration" },
--         -- { "K", vim.lsp.buf.hover, desc = "Hover" },
--         { "K",          noice_lsp.hover,            desc = "Hover" },
--         { "gK",         vim.lsp.buf.signature_help, desc = "Signature Help" },
--         -- { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
--         {
--             "<leader>ca",
--             vim.lsp.buf.code_action,
--             desc = "Code Action",
--             mode = { "n", "v" }
--             -- , has = "codeAction"
--         },
--         { "<leader>cc", vim.lsp.codelens.run,     desc = "Run Codelens",               mode = { "n", "v" } },
--         { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & Display Codelens", mode = { "n" } },
--         {
--             "<leader>cr",
--             function()
--                 return ":IncRename " .. vim.fn.expand("<cword>")
--             end,
--             desc = "rename",
--             expr = true,
--         },
--     }
--
--   return keymaps._keys
-- end
--
-- ---@return LazyKeysLsp[]
-- function keymaps.resolve(buffer)
--   local Keys = require("lazy.core.handler.keys")
--   if not Keys.resolve then
--     return {}
--   end
--   local spec = keymaps.get()
--   return Keys.resolve(spec)
-- end
--
-- function keymaps.on_attach(_, buffer)
--   local Keys = require("lazy.core.handler.keys")
--   local resolved = keymaps.resolve(buffer)
--
--   for _, keys in pairs(resolved) do
--     local has = not keys.has
--     local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))
--
--     if has and cond then
--       local opts = Keys.opts(keys)
--       opts.cond = nil
--       opts.has = nil
--       opts.silent = opts.silent ~= false
--       opts.buffer = buffer
--       vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
--     end
--   end
-- end
--
-- return { -- LSP Configuration & Plugins
--   {
--     "neovim/nvim-lspconfig",
--     -- event = "VeryLazy",
--     dependencies = {
--       "mason.nvim",
--       { "williamboman/mason-lspconfig.nvim", config = function() end },
--       { "artemave/workspace-diagnostics.nvim", enabled = true },
--     },
--     opts = function()
--       local icons = require("config.icons")
--
--       return {
--         -- options for vim.diagnostic.config()
--         ---@type vim.diagnostic.Opts
--         diagnostics = {
--           underline = true,
--           update_in_insert = false,
--           float = { border = "rounded" },
--           jump = {
--             severity = { min = vim.diagnostic.severity.WARN },
--           },
--           -- virtual_text = false,
--           -- virtual_lines = true,
--           -- virtual_text = {
--           --   spacing = 4,
--           --   source = "if_many",
--           --   severity = { min = vim.diagnostic.severity.WARN },
--           --   -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
--           --   -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
--           -- },
--           severity_sort = true,
--           signs = {
--             text = {
--               [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
--               [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
--               [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
--               [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
--             },
--           },
--         },
--         -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
--         -- Be aware that you also will need to properly configure your LSP server to
--         -- provide the inlay hints.
--         inlay_hints = {
--           enabled = false,
--           -- enabled = true,
--           -- exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
--         },
--         -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
--         -- Be aware that you also will need to properly configure your LSP server to
--         -- provide the code lenses.
--         codelens = {
--           enabled = false,
--         },
--         -- Enable lsp cursor word highlighting
--         document_highlight = {
--           enabled = true,
--         },
--         -- add any global capabilities here
--         capabilities = {
--           workspace = {
--             fileOperations = {
--               didRename = true,
--               willRename = true,
--             },
--           },
--         },
--         -- options for vim.lsp.buf.format
--         -- `bufnr` and `filter` is handled by the LazyVim formatter,
--         -- but can be also overridden when specified
--         format = {
--           formatting_options = nil,
--           timeout_ms = nil,
--         },
--         servers = {
--           ruff = {
--             filetypes = { "python" },
--             settings = {
--               args = {
--                 "--ignore",
--                 "S101",
--               },
--             },
--           },
--           rust_analyzer = {},
--           pyright = {
--             settings = {
--               pyright = {
--                 disableOrganizeImports = true, -- Using Ruff
--               },
--               python = {
--                 analysis = {
--                   indexing = true,
--                   autoSearchPaths = true,
--                   -- diagnosticMode = "workspace",
--                   useLibraryCodeForTypes = true,
--                 },
--               },
--             },
--           },
--           lua_ls = {
--             settings = {
--               Lua = {
--                 workspace = {
--                   checkThirdParty = false,
--                 },
--                 codeLens = {
--                   enable = true,
--                 },
--                 format = {
--                   enable = true,
--                 },
--                 completion = {
--                   callSnippet = "Replace",
--                 },
--                 doc = {
--                   privateName = { "^_" },
--                 },
--                 hint = {
--                   enable = true,
--                   setType = false,
--                   paramType = true,
--                   paramName = "Disable",
--                   semicolon = "Disable",
--                   arrayIndex = "Disable",
--                 },
--               },
--             },
--           },
--           yamlls = {},
--           arduino_language_server = {
--             cmd = {
--               "arduino-language-server",
--               "-cli-config",
--               "/Users/ellie/Library/Arduino15/arduino-cli.yaml",
--               "-fqbn",
--               "arduino:avr:nano",
--             },
--           },
--           ansiblels = {},
--         },
--       }
--     end,
--     config = function(_, opts)
--       local lsp = require("util.lsp")
--
--       lsp.on_attach(function(client, buffer)
--         keymaps.on_attach(client, buffer)
--       end)
--       lsp.on_dynamic_capability(keymaps.on_attach)
--
--       lsp.setup()
--
--       -- inlay hints
--       if opts.inlay_hints.enabled then
--         lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
--           if
--             vim.api.nvim_buf_is_valid(buffer)
--             and vim.bo[buffer].buftype == ""
--             and not (
--               opts.inlay_hints.exclude ~= nil and vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
--             )
--           then
--             vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
--           end
--         end)
--       end
--
--       -- code lens
--       if opts.codelens.enabled and vim.lsp.codelens then
--         lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
--           vim.lsp.codelens.refresh()
--           vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
--             buffer = buffer,
--             callback = vim.lsp.codelens.refresh,
--           })
--         end)
--       end
--
--       if type(opts.diagnostics.virtual_text) == "table" then
--         opts.diagnostics.virtual_text.prefix = function(diagnostic)
--           local icons = require("config.icons").diagnostics
--           for d, icon in pairs(icons) do
--             if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
--               return " " .. icon
--             end
--           end
--         end
--       end
--
--       local servers = opts.servers
--       local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
--       local capabilities = vim.tbl_deep_extend(
--         "force",
--         {},
--         vim.lsp.protocol.make_client_capabilities(),
--         has_cmp and cmp_nvim_lsp.default_capabilities() or {},
--         opts.capabilities or {}
--       )
--
--       local function setup(server)
--         local server_opts = vim.tbl_deep_extend("force", {
--           capabilities = vim.deepcopy(capabilities),
--         }, servers[server] or {})
--         if server_opts.enabled == false then
--           return
--         end
--
--         require("lspconfig")[server].setup(server_opts)
--       end
--
--       -- get all the servers that are available through mason-lspconfig
--       -- local mlsp = require("mason-lspconfig.mappings.server")
--       -- local all_mslp_servers = vim.tbl_keys(mlsp.lspconfig_to_package)
--
--       local ensure_installed = {} ---@type string[]
--       for server, server_opts in pairs(servers) do
--         if server_opts then
--           server_opts = server_opts == true and {} or server_opts
--           if server_opts.enabled ~= false then
--             ensure_installed[#ensure_installed + 1] = server
--           end
--         end
--       end
--
--       require("mason-lspconfig").setup({
--         ensure_installed = ensure_installed,
--         handlers = { setup },
--       })
--
--       local function set_min_severity(severity)
--         local new_opts = vim.tbl_deep_extend("force", opts.diagnostics, {
--           signs = { severity = { min = severity } },
--           -- virtual_text = { severity = { min = severity } },
--           jump = { severity = { min = severity } },
--           underline = { severity = { min = severity } },
--         })
--
--         local tid = require("tiny-inline-diagnostic")
--         local tid_severities = {}
--         for _, level in ipairs({
--           vim.diagnostic.severity.ERROR,
--           vim.diagnostic.severity.WARN,
--         }) do
--           if level <= severity then
--             tid_severities[#tid_severities + 1] = level
--           end
--         end
--
--         return function()
--           vim.diagnostic.config(new_opts)
--           tid.change_severities(tid_severities)
--         end
--       end
--
--       local map = vim.keymap.set
--             -- stylua: ignore
--             map("n", "<leader>de", set_min_severity(vim.diagnostic.severity.ERROR),
--                 { desc = "diagnostic.severity = error" })
--             -- stylua: ignore
--             map("n", "<leader>dw", set_min_severity(vim.diagnostic.severity.WARN),
--                 { desc = "diagnostic.severity = warn" })
--             -- stylua: ignore
--             map("n", "<leader>di", set_min_severity(vim.diagnostic.severity.INFO),
--                 { desc = "diagnostic.severity = info" })
--             -- stylua: ignore
--             map("n", "<leader>dh", set_min_severity(vim.diagnostic.severity.HINT),
--                 { desc = "diagnostic.severity = hint" })
--
--       vim.diagnostic.config(vim.deepcopy(opts.diagnostics))
--     end,
--   },
--   {
--     "williamboman/mason.nvim",
--     lazy = true,
--     opts = {
--       ui = {
--         border = "rounded",
--         width = 0.4,
--         height = 0.7,
--       },
--     },
--   },
--   {
--     "mfussenegger/nvim-ansible",
--     { "williamboman/mason-lspconfig.nvim", lazy = true },
--     { "WhoIsSethDaniel/mason-tool-installer.nvim", lazy = true },
--   },
--   {
--     {
--       "folke/lazydev.nvim",
--       ft = "lua", -- only load on lua files
--       opts = {
--         library = {
--           -- See the configuration section for more details
--           -- Load luvit types when the `vim.uv` word is found
--           { path = "luvit-meta/library", words = { "vim%.uv" } },
--         },
--       },
--     },
--     { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
--     { -- optional completion source for require statements and module annotations
--       "iguanacucumber/magazine.nvim",
--       opts = function(_, opts)
--         opts.sources = opts.sources or {}
--         table.insert(opts.sources, {
--           name = "lazydev",
--           group_index = 0, -- set group index to 0 to skip loading LuaLS completions
--         })
--       end,
--     },
--     -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
--   },
-- }

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
    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
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

      --   local function set_min_severity(severity)
      --     local new_opts = vim.tbl_deep_extend("force", diagnostic_opts, {
      --       signs = { severity = { min = severity } },
      --       -- virtual_text = { severity = { min = severity } },
      --       jump = { severity = { min = severity } },
      --       underline = { severity = { min = severity } },
      --     })
      --     local tid = require("tiny-inline-diagnostic")
      --     local tid_severities = {}
      --     for _, level in ipairs({
      --       vim.diagnostic.severity.ERROR,
      --       vim.diagnostic.severity.WARN,
      --     }) do
      --       if level <= severity then
      --         tid_severities[#tid_severities + 1] = level
      --       end
      --     end
      --
      --     return function()
      --       vim.diagnostic.config(new_opts)
      --       tid.change_severities(tid_severities)
      --       vim.cmd(":e")
      --     end
      --   end
      --
      --   local map = vim.keymap.set
      --   map("n", "<leader>de", set_min_severity(vim.diagnostic.severity.ERROR), { desc = "diagnostic.severity = error" })
      --   map("n", "<leader>dw", set_min_severity(vim.diagnostic.severity.WARN), { desc = "diagnostic.severity = warn" })
      --   map("n", "<leader>di", set_min_severity(vim.diagnostic.severity.INFO), { desc = "diagnostic.severity = info" })
      --   map("n", "<leader>dh", set_min_severity(vim.diagnostic.severity.HINT), { desc = "diagnostic.severity = hint" })
    end,
  },
}
