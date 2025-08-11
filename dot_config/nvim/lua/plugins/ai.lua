return {
  {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    build = "make BUILD_FROM_SOURCE=true",
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          model = "claude-sonnet-4",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "folke/snacks.nvim",
      "echasnovski/mini.icons",
      "zbirenbaum/copilot.lua",
      -- {
      --   -- support for image pasting
      --   "HakonHarnes/img-clip.nvim",
      --   event = "VeryLazy",
      --   opts = {
      --     -- recommended settings
      --     default = {
      --       embed_image_as_base64 = false,
      --       prompt_for_file_name = false,
      --       drag_and_drop = {
      --         insert_mode = true,
      --       },
      --       -- required for Windows users
      --       use_absolute_path = true,
      --     },
      --   },
      -- },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.diff",
      { "zbirenbaum/copilot.lua", opts = {} },
      {
        "Davidyz/VectorCode",
        version = "*",
        build = "uv tool upgrade vectorcode",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    opts = {
      strategies = {
        chat = {
          name = "copilot",
          model = "claude-sonnet-4-20250514",
        },
        inline = {
          name = "copilot",
          model = "claude-sonnet-4-20250514",
        },
        cmd = {
          name = "copilot",
          model = "claude-sonnet-4-20250514",
        },
      },
      display = {
        inline = {
          layout = "buffer",
        },
      },
      extensions = {
        vectorcode = {
          ---@type VectorCode.CodeCompanion.ExtensionOpts
          opts = {
            tool_group = {
              enabled = true,
              collapse = false,
            },
          },
        },
      },
    },
    keys = {
      { "<leader>ac", "<Cmd>CodeCompanionChat Toggle<CR>", desc = "ai: toggle chat" },
      { "<leader>aa", "<Cmd>CodeCompanionActions<CR>", desc = "ai: actions" },
    },
  },
}
