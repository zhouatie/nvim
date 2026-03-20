return {
  -- Obsidian vault integration
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      legacy_commands = false,

      workspaces = {
        {
          name = "personal",
          path = "~/vaults/personal",
        },
      },

      templates = {
        folder = "templates",
        date_format = "%Y-%m-%d",
        time_format = "%H:%M",
        substitutions = {},
      },

      daily_notes = {
        folder = "0.周期笔记/dailies",
        date_format = "%Y-%m-%d",
        alias_format = "%B %-d, %Y",
        default_tags = { "daily-notes" },
        template = "daily.md",
      },

      completion = {
        nvim_cmp = false,
        blink = true,
        min_chars = 2,
      },

      attachments = {
        folder = "assets/imgs",
        img_text_func = function(path)
          local name = vim.fs.basename(tostring(path))
          local encoded_name = require("obsidian.util").urlencode(name)
          return string.format("![%s](~/vaults/personal/assets/imgs/%s)", name, encoded_name)
        end,
      },

      picker = {
        name = "snacks.pick",
        note_mappings = {
          new = "<C-x>",
          insert_link = "<C-l>",
        },
        tag_mappings = {
          tag_note = "<C-x>",
          insert_tag = "<C-l>",
        },
      },

      checkbox = {
        order = { " ", "x" },
      },

      ui = { enable = false },
      link = { style = "markdown" },
    },
    config = function(_, opts)
      require("obsidian").setup(opts)
    end,
  },

  -- Image rendering (kitty protocol)
  {
    "3rd/image.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    ft = { "org", "markdown" },
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        org = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      kitty_method = "normal",
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = true,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
    },
  },

  -- Markdown rendering
  {
    "MeanderingProgrammer/render-markdown.nvim",
    cmd = { "RenderMarkdown" },
    ft = "markdown",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    opts = {
      win_options = {
        conceallevel = { rendered = 2 },
      },
      heading = {
        enabled = true,
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      code = {
        enabled = true,
        sign = true,
        style = "full",
        left_pad = 2,
        right_pad = 2,
        language_pad = 2,
      },
    },
    config = function(_, opts)
      local ns = vim.api.nvim_get_namespaces()["ObsidianUI"]
      if ns then
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
      end
      require("render-markdown").setup(opts)
    end,
  },
}
