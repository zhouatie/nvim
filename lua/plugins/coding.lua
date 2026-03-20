-- Coding utilities: pairs, surround, snippets, comments, debugprint, hipatterns

return {
  -- Auto pairs
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
  },

  -- Surround
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
        update_n_lines = "gsn",
      },
    },
  },

  -- Comments (ts-aware)
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Mini.snippets
  {
    "echasnovski/mini.snippets",
    event = "InsertEnter",
    opts = function()
      local gen_loader = require("mini.snippets").gen_loader
      return {
        snippets = {
          gen_loader.from_file(vim.fn.stdpath("config") .. "/snippets/global.json"),
          gen_loader.from_lang(),
        },
        mappings = {
          expand = "<C-j>",
          jump_next = "<C-l>",
          jump_prev = "<C-h>",
          stop = "<Esc>",
        },
      }
    end,
  },

  -- Debug print
  {
    "andrewferrier/debugprint.nvim",
    event = "VeryLazy",
    dependencies = {
      "echasnovski/mini.hipatterns",
      "ibhagwan/fzf-lua",
      "folke/snacks.nvim",
    },
    opts = {
      keymaps = {
        normal = {
          plain_below = "<leader>rp",
          plain_above = "<leader>rP",
          variable_below = "<leader>rv",
          variable_above = "<leader>rV",
          variable_below_always_prompt = "<leader>ri",
          variable_above_always_prompt = "<leader>rI",
          delete_debug_prints = "<leader>rc",
          toggle_comment_debug_prints = "<leader>rt",
          surround_plain = "<leader>rsp",
          surround_variable = "<leader>rsv",
        },
        visual = {
          variable_below = "<leader>rv",
          variable_above = "<leader>rV",
        },
      },
      display_counter = true,
      display_snippet = true,
      commands = {
        toggle_comment_debug_prints = "ToggleCommentDebugPrints",
        delete_prints = "DeleteDebugPrints",
      },
    },
  },

  -- Highlight patterns (color values, etc.)
  {
    "echasnovski/mini.hipatterns",
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
      local hipatterns = require("mini.hipatterns")
      return {
        highlighters = {
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
  },

  -- TODO comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo Comment" },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
}
