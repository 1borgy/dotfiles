return {
  { "nmac427/guess-indent.nvim", event = "BufReadPre", opts = {} },
  {
    "smjonas/inc-rename.nvim",
    opts = {
      input_buffer_type = "dressing",
    },
    config = function()
      require("inc_rename").setup({})
    end,
    event = "VeryLazy",
    keys = {
      {
        "<leader>cr",
        function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        desc = "code: rename symbol",
        expr = true,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = "VeryLazy",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "code: format buffer",
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true, just = true }
        return {
          timeout_ms = 500,
          lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
        }
      end,
      formatters_by_ft = {
        lua = { "stylua" },
        yaml = { "yamlfmt" },
        -- Conform can also run multiple formatters sequentially
        python = { "ruff_format" },
        json = { "prettier" },
        -- You can use a sub-list to tell conform to run *until* a formatter
        -- is found.
        javascript = { "eslint" },
      },
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          require("grug-far").open({ engine = "ripgrep" })
        end,
        mode = { "n", "v" },
        desc = "find+replace (rg)",
      },
      {
        "<leader>sg",
        function()
          require("grug-far").open({ engine = "astgrep" })
        end,
        mode = { "n", "v" },
        desc = "find+replace (ast-grep)",
      },
      {
        "<leader>sG",
        function()
          require("grug-far").open({ engine = "astgrep-rules" })
        end,
        mode = { "n", "v" },
        desc = "find+replace (ast-grep rules)",
      },
    },
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>qS", function() require("persistence").select() end,desc = "Select Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
  {
    "gbprod/substitute.nvim",
    lazy = true,
    dependencies = { "gbprod/yanky.nvim" },
    opts = function()
      local yanky = require("yanky.integration")

      return {
        on_substitute = yanky.substitute(),
        highlight_substituted_text = {
          timer = 200,
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "s", function() require("substitute").operator() end, desc = "sub: operator" },
      { "ss", function() require("substitute").line() end, desc = "sub: line" },
      { "S", function() require("substitute").eol() end, desc = "sub: eol" },
      { "s", function() require("substitute").visual() end, mode = { "x" }, desc = "sub: visual" },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = {
      n_lines = 500,
    },
  },
  { "echasnovski/mini.comment", event = "VeryLazy" },
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = false, terminal = false },
      -- skip autopair when next character is one of these
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      -- skip autopair when the cursor is inside these treesitter nodes
      skip_ts = { "string" },
      -- skip autopair when next character is closing pair
      -- and there are more closing pairs than opening pairs
      skip_unbalanced = true,
      -- better deal with markdown code blocks
      markdown = true,
    },
    config = function(_, opts)
      local pairs = require("mini.pairs")
      pairs.setup(opts)

      local open = pairs.open
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then
          return open(pair, neigh_pattern)
        end
        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])
        if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end
        if opts.skip_next and next ~= "" and next:match(opts.skip_next) then
          return o
        end
        if opts.skip_ts and #opts.skip_ts > 0 then
          local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
          for _, capture in ipairs(ok and captures or {}) do
            if vim.tbl_contains(opts.skip_ts, capture.capture) then
              return o
            end
          end
        end
        if opts.skip_unbalanced and next == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
          local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
          if count_close > count_open then
            return o
          end
        end
        return open(pair, neigh_pattern)
      end
    end,
  },
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
      },
    },
    keys = {
      { "gsa", desc = "add surrounding", mode = { "n", "v" } },
      { "gsd", desc = "delete surrounding" },
      { "gsf", desc = "find right surrounding" },
      { "gsF", desc = "find left surrounding" },
      { "gsh", desc = "highlight surrounding" },
      { "gsr", desc = "replace surrounding" },
    },
  },
  {
    "echasnovski/mini.bufremove",
    enabled = false,
    keys = {
      {
        "<leader>bd",
        function()
          local bd = require("mini.bufremove").delete
          if vim.bo.modified then
            local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
            if choice == 1 then -- Yes
              vim.cmd.write()
              bd(0)
            elseif choice == 2 then -- No
              bd(0, true)
            end
          else
            bd(0)
          end
        end,
        desc = "Delete Buffer",
      },
      -- stylua: ignore
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "VeryLazy",
    opts = {
      signs = false,
      highlight = {
        pattern = [[.*<(KEYWORDS).*:]],
        keyword = "bg",
        multiline = true,
      },
      keywords = {
        DOCS = { icon = " ", color = "hint" },
      },
    },
    -- stylua: ignore
    keys = {
      -- { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      -- { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
      -- { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      -- { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      win = { position = "right" },
      auto_preview = false,
      modes = {
        symbols = {
          desc = "document symbols",
          mode = "lsp_document_symbols",
          focus = true,
          filter = {
            -- remove Package since luals uses it for control flow structures
            ["not"] = { ft = "lua", kind = "Package" },
            any = {
              -- all symbol kinds for help / markdown files
              ft = { "help", "markdown" },
              -- default set of symbol kinds
              kind = {
                "Class",
                "Constructor",
                "Enum",
                "Field",
                "Function",
                "Interface",
                "Method",
                "Module",
                "Namespace",
                "Package",
                "Property",
                "Struct",
                "Trait",
              },
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      { "]t", function() require("trouble").next({ jump = true }) end, desc = "Next Todo Comment" },
      { "[t", function() require("trouble").prev({ jump = true }) end, desc = "Previous Todo Comment" },
    },
  },
  {
    "gbprod/yanky.nvim",
    lazy = true,
    opts = {
      highlight = { timer = 150 },
    },
    -- stylua: ignore
    keys = {
      { "<leader>p", function() vim.cmd([[YankyRingHistory]]) end, mode = { "n", "x" }, desc = "Open Yank History" },
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
      { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
      { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
    },
  },
  {
    "danymat/neogen",
    event = "VeryLazy",
    opts = {
      languages = {
        python = {
          template = {
            annotation_convention = "google_docstrings",
          },
        },
      },
    },
    keys = {
      {
        "<leader>cD",
        ":Neogen<cr>",
        silent = true,
        desc = "code: generate docstring",
      },
    },
  },
  {
    "RazgrizHsu/exer.nvim",
    opts = {},
    keys = {
      { "<leader>ro", "<cmd>ExerOpen<cr>", desc = "Open task picker" },
      -- { "<leader>rr", "<cmd>ExerRedo<cr>", desc = "Re-run last task" },
      { "<leader>rx", "<cmd>ExerStop<cr>", desc = "Stop all running tasks" },
      { "<leader>rr", "<cmd>ExerShow<cr>", desc = "Toggle task output window" },
      { "<C-w>t", "<cmd>ExerFocusUI<cr>", desc = "Focus task UI" },
      -- Task navigation (requires enable_navigation = true)
      { "<C-j>", "<cmd>ExerNavDown<cr>", desc = "Task navigation down" },
      { "<C-k>", "<cmd>ExerNavUp<cr>", desc = "Task navigation up" },
      { "<C-h>", "<cmd>ExerNavLeft<cr>", desc = "Task navigation left" },
      { "<C-l>", "<cmd>ExerNavRight<cr>", desc = "Task navigation right" },
    },
  },
}
