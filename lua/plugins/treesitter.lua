return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    config = function()
      require("nvim-treesitter").install({
        "bash",
        "c",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "scss",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "xml",
        "yaml",
      })

      local ts_group = vim.api.nvim_create_augroup("config_treesitter", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = ts_group,
        callback = function()
          if vim.bo.buftype ~= "" then
            return
          end

          pcall(vim.treesitter.start)
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Some openers display an existing buffer before filetype detection runs.
      -- Detect filetype or start highlighting here as a fallback.
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = ts_group,
        callback = function(event)
          local buf = event.buf
          if vim.bo[buf].buftype ~= "" then
            return
          end

          if vim.bo[buf].filetype == "" then
            vim.cmd("filetype detect")
            return
          end

          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(buf) then
              return
            end

            if vim.treesitter.highlighter.active[buf] then
              return
            end

            pcall(vim.treesitter.start, buf)
          end)
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        move = { set_jumps = true },
      })

      local move = require("nvim-treesitter-textobjects.move")
      local to = "textobjects"

      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", to) end)
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", to) end)
      vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", to) end)
      vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", to) end)
      vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", to) end)
      vim.keymap.set({ "n", "x", "o" }, "]A", function() move.goto_next_end("@parameter.inner", to) end)
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", to) end)
      vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", to) end)
      vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", to) end)
      vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", to) end)
      vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", to) end)
      vim.keymap.set({ "n", "x", "o" }, "[A", function() move.goto_previous_end("@parameter.inner", to) end)
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mode = "cursor",
      max_lines = 3,
    },
  },

  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
