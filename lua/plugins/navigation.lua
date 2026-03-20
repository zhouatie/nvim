return {
  -- fzf-lua
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      winopts = {
        height = 0.90,
        width = 0.80,
        row = 0.50,
        col = 0.50,
        border = "single",
        preview = {
          layout = "vertical",
          height = "20",
        },
      },
    },
  },

  -- Tmux navigation
  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<C-h>",
        function()
          require("tmux").move_left()
        end,
        desc = "Move to left pane",
      },
      {
        "<C-j>",
        function()
          require("tmux").move_bottom()
        end,
        desc = "Move to bottom pane",
      },
      {
        "<C-k>",
        function()
          require("tmux").move_top()
        end,
        desc = "Move to top pane",
      },
      {
        "<C-l>",
        function()
          require("tmux").move_right()
        end,
        desc = "Move to right pane",
      },
    },
    config = function()
      require("tmux").setup({
        copy_sync = {
          enable = true,
        },
        navigation = {
          enable_default_keybindings = false,
        },
        resize = {
          enable_default_keybindings = false,
        },
      })
    end,
  },

  -- URL open
  {
    "sontungexpt/url-open",
    event = "VeryLazy",
    cmd = "URLOpenUnderCursor",
    config = function()
      local status_ok, url_open = pcall(require, "url-open")
      if not status_ok then
        return
      end
      url_open.setup({})
    end,
  },

  -- Snipe buffer menu
  {
    "leath-dub/snipe.nvim",
    event = "VeryLazy",
    keys = {
      {
        "gb",
        function()
          require("snipe").open_buffer_menu()
        end,
        desc = "Open Snipe buffer menu",
      },
    },
    opts = {},
  },

  -- Yazi file manager
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<leader>y",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },

  -- Incline (floating filename labels)
  {
    "b0o/incline.nvim",
    event = "VeryLazy",
    config = function()
      require("incline").setup()
    end,
  },

  -- Colorful window separators
  {
    "nvim-zh/colorful-winsep.nvim",
    config = true,
    event = { "WinLeave" },
  },
}
