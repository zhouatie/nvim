return {
  {
    "nvim-orgmode/orgmode",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-orgmode/telescope-orgmode.nvim",
      "nvim-orgmode/org-bullets.nvim",
      "Saghen/blink.cmp",
    },
    event = "VeryLazy",
    config = function()
      require("orgmode").setup({
        org_agenda_files = { "~/org/inbox.org", "~/org/gtd/**/*.org" },
        org_default_notes_file = "~/org/inbox.org",

        org_capture_templates = {
          -- 1. 任务流 (Tasks)
          t = {
            description = "待办任务",
            template = "* TODO %?\n  SCHEDULED: %t\n",
            target = "~/org/inbox.org",
          },

          -- 日记模板：实现 ~/org/gtd/年/月/年-月-日.org
          j = {
            description = "Daily Journal",
            template = "\n* %<%H:%M> 记录\n%?",
            -- 关键：通过时间格式化构建深层目录
            -- %<%Y> 是年，%<%m> 是月，%<%Y-%m-%d> 是文件名
            target = "~/org/gtd/%<%Y>/%<%m>/%<%Y-%m-%d>.org",
          },

          -- 4. 灵感/闪念 (Inbox) - 最简化的记录
          i = {
            description = "瞬时灵感",
            template = "* %?\n  %U", -- %U 是带精确时间的戳
            target = "~/org/inbox.org",
          },
        },
        org_archive_location = "#+ARCHIVE: ~/org/archive/%s_archive::",
      })

      require("org-bullets").setup()
      require("blink.cmp").setup({
        sources = {
          per_filetype = {
            org = { "orgmode" },
          },
          providers = {
            orgmode = {
              name = "Orgmode",
              module = "orgmode.org.autocompletion.blink",
              fallbacks = { "buffer" },
            },
          },
        },
      })
    end,
  },
  {
    "nvim-orgmode/telescope-orgmode.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-orgmode/orgmode",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("telescope").load_extension("orgmode")
    end,
    keys = {
      {
        "<leader>oR",
        function()
          require("telescope").extensions.orgmode.refile_heading()
        end,
        desc = "Refile heading",
      },
      {
        "<leader>of",
        function()
          require("telescope").extensions.orgmode.search_headings()
        end,
        desc = "Search headings",
      },
      {
        "<leader>olI",
        function()
          require("telescope").extensions.orgmode.insert_link()
        end,
        desc = "Telescope Insert link",
      },
      {
        "<leader>ost",
        function()
          require("telescope").extensions.orgmode.search_tags()
        end,
        desc = "Search tags",
      },
    },
  },
  -- {
  --   "hamidi-dev/org-super-agenda.nvim",
  --   dependencies = {
  --     "nvim-orgmode/orgmode", -- required
  --     { "lukas-reineke/headlines.nvim", config = true }, -- optional nicety
  --   },
  --   config = function()
  --     require("org-super-agenda").setup({
  --       org_directories = { "~/org/" },
  --
  --       todo_states = {
  --         {
  --           name = "TODO",
  --           keymap = "ot",
  --           color = "#E8706F",
  --           strike_through = false,
  --           fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --         },
  --         {
  --           name = "PROGRESS",
  --           keymap = "op",
  --           color = "#F5A623",
  --           strike_through = false,
  --           fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --         },
  --         {
  --           name = "WAITING",
  --           keymap = "ow",
  --           color = "#9D7FB3",
  --           strike_through = false,
  --           fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --         },
  --         {
  --           name = "DONE",
  --           keymap = "od",
  --           color = "#52C0A1",
  --           strike_through = true,
  --           fields = { "filename", "todo", "headline", "priority", "date", "tags" },
  --         },
  --       },
  --
  --       -- Agenda keymaps (inline comments explain each)
  --       keymaps = {
  --         filter_reset = "oa", -- reset all filters
  --         toggle_other = "oo", -- toggle catch-all "Other" section
  --         filter = "of", -- live filter (exact text)
  --         filter_fuzzy = "oz", -- live filter (fuzzy)
  --         filter_query = "oq", -- advanced query input
  --         undo = "u", -- undo last change
  --         reschedule = "cs", -- set/change SCHEDULED
  --         set_deadline = "cd", -- set/change DEADLINE
  --         cycle_todo = "t", -- cycle TODO state
  --         set_state = "s", -- set state directly (st, sd, etc.) or show menu
  --         reload = "r", -- refresh agenda
  --         refile = "R", -- refile via Telescope/org-telescope
  --         hide_item = "x", -- hide current item
  --         preview = "K", -- preview headline content
  --         reset_hidden = "X", -- clear hidden list
  --         toggle_duplicates = "D", -- duplicate items may appear in multiple groups
  --         cycle_view = "ov", -- switch view (classic/compact)
  --       },
  --
  --       -- Window/appearance
  --       window = {
  --         width = 0.8,
  --         height = 0.7,
  --         border = "rounded",
  --         title = "Org Super Agenda",
  --         title_pos = "center",
  --         margin_left = 0,
  --         margin_right = 0,
  --         fullscreen_border = "none", -- border style when using fullscreen
  --       },
  --
  --       -- Group definitions (order matters; first match wins unless allow_duplicates=true)
  --       groups = {
  --         {
  --           name = "📅 今天",
  --           matcher = function(i)
  --             return i.scheduled and i.scheduled:is_today()
  --           end,
  --           sort = { by = "priority", order = "desc" },
  --         },
  --         {
  --           name = "🗓️ Tomorrow",
  --           matcher = function(i)
  --             return i.scheduled and i.scheduled:days_from_today() == 1
  --           end,
  --         },
  --         {
  --           name = "☠️ Deadlines",
  --           matcher = function(i)
  --             return i.deadline and i.todo_state ~= "DONE" and not i:has_tag("personal")
  --           end,
  --           sort = { by = "deadline", order = "asc" },
  --         },
  --         {
  --           name = "⭐ Important",
  --           matcher = function(i)
  --             return i.priority == "A" and (i.deadline or i.scheduled)
  --           end,
  --           sort = { by = "date_nearest", order = "asc" },
  --         },
  --         {
  --           name = "⏳ Overdue",
  --           matcher = function(i)
  --             return i.todo_state ~= "DONE"
  --               and ((i.deadline and i.deadline:is_past()) or (i.scheduled and i.scheduled:is_past()))
  --           end,
  --           sort = { by = "date_nearest", order = "asc" },
  --         },
  --         {
  --           name = "🏠 Personal",
  --           matcher = function(i)
  --             return i:has_tag("personal")
  --           end,
  --         },
  --         {
  --           name = "💼 Work",
  --           matcher = function(i)
  --             return i:has_tag("work")
  --           end,
  --         },
  --         {
  --           name = "📆 Upcoming",
  --           matcher = function(i)
  --             local days = require("org-super-agenda.config").get().upcoming_days or 10
  --             local d1 = i.deadline and i.deadline:days_from_today()
  --             local d2 = i.scheduled and i.scheduled:days_from_today()
  --             return (d1 and d1 >= 0 and d1 <= days) or (d2 and d2 >= 0 and d2 <= days)
  --           end,
  --           sort = { by = "date_nearest", order = "asc" },
  --         },
  --       },
  --
  --       -- Defaults & behavior
  --       upcoming_days = 10,
  --       hide_empty_groups = true, -- drop blank sections
  --       keep_order = false, -- keep original org order (rarely useful)
  --       allow_duplicates = false, -- if true, an item can live in multiple groups
  --       group_format = "* %s", -- group header format
  --       other_group_name = "Other",
  --       show_other_group = false, -- show catch-all section
  --       show_tags = true, -- draw tags on the right
  --       show_filename = true, -- include [filename]
  --       heading_max_length = 70,
  --       persist_hidden = false, -- keep hidden items across reopen
  --       view_mode = "classic", -- 'classic' | 'compact'
  --
  --       classic = {
  --         heading_order = { "filename", "todo", "priority", "headline" },
  --         short_date_labels = false,
  --         inline_dates = true,
  --       },
  --       compact = { filename_min_width = 10, label_min_width = 12 },
  --
  --       -- Global fallback sort for groups that omit `sort`
  --       group_sort = { by = "date_nearest", order = "asc" },
  --
  --       -- Popup mode: run in a persistent tmux session for instant access
  --       popup_mode = {
  --         enabled = false,
  --         hide_command = nil, -- e.g., "tmux detach-client"
  --       },
  --
  --       debug = false,
  --     })
  --   end,
  -- },
}
