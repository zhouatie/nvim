return {
  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     print(opts)
  --     table.insert(opts.ensure_installed, "prettierd")
  --   end,
  -- },
  -- {
  --   "nvimtools/none-ls.nvim",
  --   optional = true,
  --   opts = function(_, opts)
  --     print(opts)
  --     local nls = require("null-ls")
  --     opts.sources = opts.sources or {}
  --     table.insert(opts.sources, nls.builtins.formatting.prettierd)
  --   end,
  -- },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {

      formatters_by_ft = {
        -- ["javascript"] = { "prettier" },
        -- ["javascriptreact"] = { "prettier" },
        -- ["typescript"] = { "prettier" },
        -- ["typescriptreact"] = { "prettier" },
        ["vue"] = { "prettier" },
        ["css"] = { "stylelint" },
        ["scss"] = { "stylelint" },
        ["less"] = { "stylelint" },
        ["html"] = { "prettier" },
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },
        ["markdown"] = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        ["graphql"] = { "prettier" },
        ["handlebars"] = { "prettier" },
      },
    },
  },
}
