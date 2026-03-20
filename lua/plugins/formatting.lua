return {
  -- Inline diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy",
    priority = 1000,
    opts = {
      options = {
        multilines = {
          enabled = true,
        },
        show_source = {
          enabled = true,
        },
        add_messages = {
          display_count = true,
        },
        set_arrow_to_diag_color = true,
      },
    },
  },

  -- Conform (formatting)
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = function()
      local formatters_by_ft = {
        ["toml"] = { "taplo" },
        ["lua"] = { "stylua" },
        python = { "isort", "black" },
        ["org"] = { "textlsp" },
      }

      local prettier_eslint_filetypes = {
        "javascriptreact",
        "typescript",
        "javascript",
        "typescriptreact",
        "vue",
        "css",
        "scss",
        "sass",
        "less",
        "html",
        "yaml",
        "graphql",
        "handlebars",
      }

      local eslint_only_projects = {
        "work",
      }

      for _, filetype in ipairs(prettier_eslint_filetypes) do
        local cwd = vim.fn.getcwd()
        local use_eslint_only = false

        for _, project_pattern in ipairs(eslint_only_projects) do
          if string.match(cwd, project_pattern) then
            use_eslint_only = true
            break
          end
        end

        if use_eslint_only then
          formatters_by_ft[filetype] = { "eslint_d" }
        else
          formatters_by_ft[filetype] = { "prettier", "eslint_d" }
        end
      end

      return {
        formatters_by_ft = formatters_by_ft,
        format_on_save = {
          timeout_ms = 3000,
          lsp_fallback = true,
        },
      }
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    opts = {
      linters_by_ft = {
        markdown = {},
      },
      events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    },
    config = function(_, opts)
      local lint = require("lint")
      for ft, linters in pairs(opts.linters_by_ft) do
        lint.linters_by_ft[ft] = linters
      end
      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
          -- Use pcall to avoid errors when linter is not installed
          pcall(function()
            require("lint").try_lint()
          end)
        end,
      })
    end,
  },
}
