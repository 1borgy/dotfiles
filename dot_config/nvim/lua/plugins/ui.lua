return {
  { "jake-stewart/force-cul.nvim", event = "VeryLazy", opts = {} },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    -- enabled = false,
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local icons = require("config.icons")
      local success, nyappuccin = pcall(require, "lualine.nyappuccin")
      local theme = nil
      if success then
        theme = nyappuccin.get()
      end
      return {
        options = {
          theme = theme,
          component_separators = { left = "┊", right = "┊" },
          section_separators = { left = "", right = "" },
          globalstatus = true,
          disabled_filetypes = { statusline = { "dashboard" } },
        },
        sections = {
          lualine_a = { { "mode", fmt = string.lower, separator = { left = "", right = "" } } },
          lualine_b = { "branch" },
          lualine_c = {},
          lualine_x = {
            {
              function()
                return require("noice").api.status.mode.get()
              end,
              cond = function()
                return package.loaded["noice"] and require("noice").api.status.mode.has()
              end,
            },
            { "diagnostics", sections = { "error", "warn", "info" } },
            { "diff", symbols = icons.git },
          },
          lualine_y = { "progress" },
          lualine_z = { { "location", separator = { left = "", right = "" } } },
        },
      }
    end,
  },
  {
    "sschleemilch/slimline.nvim",
    event = "VeryLazy",
    enabled = false,
    opts = {
      configs = {
        mode = {
          verbose = true, -- Mode as single letter or as a word
          hl = {
            normal = "Type",
            insert = "Function",
            pending = "Boolean",
            visual = "Keyword",
            command = "String",
          },
        },
      },
      -- Global highlights
      hl = {
        base = "Normal", -- highlight of the background
        primary = "Comment", -- highlight of primary parts (e.g. filename)
        secondary = "Normal", -- highlight of secondary parts (e.g. filepath)
      },
    },
  },
  {
    "sphamba/smear-cursor.nvim",
    -- enabled = false,
    event = "VeryLazy",
    opts = {},
  },
  {
    "nanozuki/tabby.nvim",
    event = "VimEnter", -- if you want lazy load, see below
    -- dependencies = "nvim-tree/nvim-web-devicons",
    enabled = false,
    opts = function()
      local theme = {
        fill = "TabLineFill",
        -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
        head = "TabLine",
        current_tab = "TabLineSel",
        tab = "TabLine",
        win = "TabLine",
        tail = "TabLine",
      }
      return {
        line = function(line)
          return {
            {
              { "  ", hl = theme.head },
              line.sep("", theme.head, theme.fill),
            },
            line.tabs().foreach(function(tab)
              local hl = tab.is_current() and theme.current_tab or theme.tab
              return {
                line.sep("", hl, theme.fill),
                tab.name(),
                line.sep("", hl, theme.fill),
                hl = hl,
                margin = " ",
              }
            end),
            line.spacer(),
          }
        end,
      }
    end,
  },
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    -- enabled = false,
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "next buffer" },
      { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "move buffer prev" },
      { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "move buffer next" },
    },
    opts = function()
      local bufferline = require("bufferline")

      local success, C = pcall(require, "nyappuccin.colors")
      local highlights = {}
      if success then
        highlights = {
          fill = { bg = tostring(C.base) },
          indicator_selected = { fg = tostring(C.lavender) },
        }
      end

      return {
        highlights = highlights,
        options = {
          style_preset = { bufferline.style_preset.no_italic },
          -- style_preset = { bufferline.style_preset.minimal },
          mode = "buffers",
          always_show_bufferline = false,
          diagnostics = "nvim_lsp",
          indicator = { style = "underline" },
          show_buffer_close_icons = false,
          show_close_icon = false,
        },
      }
    end,
    config = function(_, opts)
      require("bufferline").setup(opts)
      -- Fix bufferline when restoring a session
      vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
        callback = function()
          vim.schedule(function()
            pcall(nvim_bufferline)
          end)
        end,
      })
    end,
  },
  { "yorickpeterse/nvim-pqf", event = "VeryLazy", opts = {} },
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    opts = {
      icons = {

        ui = {
          bar = {
            separator = " ",
            -- extends = '󰇘 ',
          },
        },
      },
      bar = {
        enable = function(buf, win, _)
          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ""
            or vim.wo[win].winbar ~= ""
            or vim.bo[buf].ft == "help"
            or vim.bo[buf].ft == "codecompanion"
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then
            return false
          end

          return vim.bo[buf].ft == "markdown"
            or pcall(vim.treesitter.get_parser, buf)
            or not vim.tbl_isempty(vim.lsp.get_clients({
              bufnr = buf,
              method = "textDocument/documentSymbol",
            }))
        end,
      },
      menu = {
        preview = false,
        entry = {
          padding = {
            left = 0,
          },
        },
        win_configs = {
          border = "rounded",
          style = "minimal",
          row = function(menu)
            return menu.prev_menu and menu.prev_menu.clicked_at and menu.prev_menu.clicked_at[1] - vim.fn.line("w0")
              or 0
          end,
          ---@param menu dropbar_menu_t
          col = function(menu)
            if menu.prev_menu then
              return menu.prev_menu._win_configs.width + (menu.prev_menu.scrollbar and 1 or 0)
            end
            local mouse = vim.fn.getmousepos()
            local bar = require("dropbar.api").get_dropbar(vim.api.nvim_win_get_buf(menu.prev_win), menu.prev_win)
            if not bar then
              return mouse.wincol
            end
            local _, range = bar:get_component_at(math.max(0, mouse.wincol - 1))
            return range and range.start or mouse.wincol
          end,
          relative = "win",
          win = function(menu)
            return menu.prev_menu and menu.prev_menu.win or vim.fn.getmousepos().winid
          end,
          height = function(menu)
            return math.max(
              1,
              math.min(#menu.entries, vim.go.pumheight ~= 0 and vim.go.pumheight or math.ceil(vim.go.lines / 4))
            )
          end,
          width = function(menu)
            local min_width = vim.go.pumwidth ~= 0 and vim.go.pumwidth or 8
            if vim.tbl_isempty(menu.entries) then
              return min_width
            end
            return math.max(
              min_width,
              math.max(unpack(vim.tbl_map(function(entry)
                return entry:displaywidth()
              end, menu.entries)))
            )
          end,
          zindex = function(menu)
            if menu.prev_menu then
              if menu.prev_menu.scrollbar and menu.prev_menu.scrollbar.thumb then
                return vim.api.nvim_win_get_config(menu.prev_menu.scrollbar.thumb).zindex
              end
              return vim.api.nvim_win_get_config(menu.prev_win).zindex
            end
          end,
        },
      },
    },
    keys = {
      {
        "<leader>;",
        function()
          require("dropbar.api").pick()
        end,
        desc = "pick symbols in winbar",
      },
      {
        "<leader>[;",
        function()
          require("dropbar.api").goto_context_start()
        end,
        desc = "go to start of current context",
      },
      {
        "<leader>:",
        function()
          require("dropbar.api").select_next_context()
        end,
        desc = "select next context",
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    ft = { "markdown", "codecompanion" },
    opts = {},
    keys = {
      { "<leader>um", "<Cmd>RenderMarkdown toggle<CR>", desc = "toggle markdown" },
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      popupmenu = { enabled = false },
      messages = {
        enabled = true,
        -- enabled = true, -- enables the Noice messages UI
        view = "notify", -- default view for messages
        view_info = "notify", -- view for errors
        view_error = "notify", -- view for errors
        view_warn = "notify", -- view for warnings
        view_history = "messages", -- view for :messages
        view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
      },
      lsp = {
        progress = { enabled = false },
        hover = { enabled = true, silent = true },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
            },
          },
          view = "notify",
          opts = {
            title = "Saved",
            replace = true,
          },
        },
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "notify",
          opts = {
            title = "Undo/Redo",
            replace = true,
          },
        },
      },
      views = {
        cmdline_popup = { position = { row = "15%", col = "50%" } },
        hover = {
          view = "popup",
          relative = "cursor",
          zindex = 45,
          enter = false,
          anchor = "auto",
          silent = true,
          size = {
            width = "auto",
            height = "auto",
            max_height = 20,
            max_width = 120,
          },
          border = {
            style = "rounded",
            padding = { 0, 2 },
          },
          position = { row = 2, col = 0 },
          win_options = { wrap = true, linebreak = true },
        },
      },
      presets = { bottom_search = false, inc_rename = true },
    },
    keys = {
      { "<leader>sn", "", desc = "+noice" },
      {
        "<S-Enter>",
        function()
          require("noice").redirect(vim.fn.getcmdline())
        end,
        mode = "c",
        desc = "Redirect Cmdline",
      },
      {
        "<leader>snl",
        function()
          require("noice").cmd("last")
        end,
        desc = "Noice Last Message",
      },
      {
        "<leader>snh",
        function()
          require("noice").cmd("history")
        end,
        desc = "Noice History",
      },
      {
        "<leader>sna",
        function()
          require("noice").cmd("all")
        end,
        desc = "Noice All",
      },
      {
        "<leader>snd",
        function()
          require("noice").cmd("dismiss")
        end,
        desc = "Dismiss All",
      },
      {
        "<leader>snt",
        function()
          require("noice").cmd("pick")
        end,
        desc = "Noice Picker (Telescope/FzfLua)",
      },
      {
        "<c-f>",
        function()
          if not require("noice.lsp").scroll(4) then
            return "<c-f>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Forward",
        mode = { "i", "n", "s" },
      },
      {
        "<c-b>",
        function()
          if not require("noice.lsp").scroll(-4) then
            return "<c-b>"
          end
        end,
        silent = true,
        expr = true,
        desc = "Scroll Backward",
        mode = { "i", "n", "s" },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },
  {
    "echasnovski/mini.diff",
    opts = {
      view = { style = "sign", signs = { add = "▎", change = "▎", delete = "▎" } },
    },
  },
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "echasnovski/mini.animate",
    enabled = false,
    opts = function()
      local animate = require("mini.animate")
      return {
        resize = {
          enable = false,
        },
        scroll = {
          enable = false,
          timing = animate.gen_timing.linear({ duration = 75, unit = "total" }),
        },
        cursor = {
          enable = false,
        },
        open = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          winblend = animate.gen_winblend.linear({ from = 60, to = 100 }),
        },
        close = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
          winblend = animate.gen_winblend.linear({ from = 60, to = 100 }),
        },
      }
    end,
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "VeryLazy",
    enabled = false,
    opts = {
      draw = {
        delay = 50,
        animation = function(_, n)
          return math.min(150 / n, 20)
        end,
      },
      -- symbol = "▏",
      symbol = "┋",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "alpha",
          "dashboard",
          "fzf",
          "help",
          "lazy",
          "lazyterm",
          "mason",
          "neo-tree",
          "notify",
          "toggleterm",
          "Trouble",
          "trouble",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
  {
    "echasnovski/mini.files",
    lazy = true,
    version = false,
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      mappings = {
        go_in = "L",
        go_in_plus = "l",
      },
      content = {
        filter = function(entry)
          return not vim.tbl_contains(
            { "__pycache__", ".cursor", ".mypy_cache", ".pytest_cache", ".ropeproject", ".ruff_cache", ".venv" },
            entry.name
          ) and string.find(entry.name, ".dmypy") == nil
        end,
        -- sauce: https://github.com/mrjones2014/dotfiles/commit/31f7988420e5418925022c524de04934e02a427c
        -- sort = function(entries)
        --   -- technically can filter entries here too, and checking gitignore for _every entry individually_
        --   -- like I would have to in `content.filter` above is too slow. Here we can give it _all_ the entries
        --   -- at once, which is much more performant.
        --   local all_paths = table.concat(
        --     vim.tbl_map(function(entry)
        --       return entry.path
        --     end, entries),
        --     "\n"
        --   )
        --   local output_lines = {}
        --   local job_id = vim.fn.jobstart({ "git", "check-ignore", "--stdin" }, {
        --     stdout_buffered = true,
        --     on_stdout = function(_, data)
        --       output_lines = data
        --     end,
        --   })
        --
        --   -- command failed to run
        --   if job_id < 1 then
        --     return entries
        --   end
        --
        --   -- send paths via STDIN
        --   vim.fn.chansend(job_id, all_paths)
        --   vim.fn.chanclose(job_id, "stdin")
        --   vim.fn.jobwait({ job_id })
        --
        --   local ignore = { "__pycache__" }
        --
        --   return require("mini.files").default_sort(vim.tbl_filter(function(entry)
        --     return not vim.tbl_contains(output_lines, entry.path) or string.match(entry.path, ".local")
        --   end, entries))
        -- end,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesWindowOpen",
        callback = function(args)
          local win_id = args.data.win_id

          -- Customize window-local settings
          local config = vim.api.nvim_win_get_config(win_id)
          config.border = "rounded"
          config.title_pos = "left"
          vim.api.nvim_win_set_config(win_id, config)
        end,
      })
    end,
    keys = {
      {
        "<leader>e",
        function(...)
          if not MiniFiles.close() then
            MiniFiles.open(...)
          end
        end,
        desc = "explorer",
      },
      {
        "<leader>E",
        function()
          if not MiniFiles.close() then
            MiniFiles.open(vim.api.nvim_buf_get_name(0))
            MiniFiles.reveal_cwd()
          end
        end,
        desc = "explorer (focus current file)",
      },
    },
  },
}
