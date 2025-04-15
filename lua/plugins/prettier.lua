return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function()
      -- 检查项目目录是否存在 Prettier 配置文件
      local prettier_config_files = {
        ".prettierrc",
        ".prettierrc.json",
        ".prettierrc.yml",
        ".prettierrc.yaml",
        ".prettierrc.js",
        ".prettierrc.cjs",
        "prettier.config.js",
        "prettier.config.cjs",
        ".prettierrc.toml",
        "prettier.config.mjs",
      }

      local function find_project_prettier_config()
        local cwd = vim.fn.getcwd()
        for _, file in ipairs(prettier_config_files) do
          local config_path = cwd .. "/" .. file
          if vim.fn.filereadable(config_path) == 1 then
            return true
          end
        end
        return false
      end

      local has_project_config = find_project_prettier_config()
      local fallback_config = vim.fn.expand("~/.config/nvim/.prettierrc.json")

      return {
        formatters = {
          prettierd = {
            -- 如果项目没有配置，则使用全局配置
            prepend_args = has_project_config and {} or { "--config", fallback_config },
          },
          prettier = {
            -- 如果项目没有配置，则使用全局配置
            prepend_args = has_project_config and {} or { "--config", fallback_config },
          },
        },
        formatters_by_ft = {
          javascript = { "prettierd", "prettier", stop_after_first = true },
          ["javascriptreact"] = { "prettierd", "prettier", stop_after_first = true },
          ["typescript"] = { "prettierd", "prettier", stop_after_first = true },
          ["typescriptreact"] = { "prettierd", "prettier", stop_after_first = true },
          ["vue"] = { "eslint_d", "prettierd", "prettier", stop_after_first = true },
          ["css"] = { "prettierd", "prettier", stop_after_first = true },
          ["scss"] = { "prettierd", "prettier", stop_after_first = true },
          ["less"] = { "prettierd", "prettier", stop_after_first = true },
          ["html"] = { "prettierd", "prettier", stop_after_first = true },
          ["json"] = { "prettierd", "prettier", stop_after_first = true },
          ["jsonc"] = { "prettierd", "prettier", stop_after_first = true },
          ["yaml"] = { "prettierd", "prettier", stop_after_first = true },
          -- ["markdown"] = { "prettier" },
          -- ["markdown.mdx"] = { "prettier" },
          ["graphql"] = { "prettierd", "prettier", stop_after_first = true },
          ["handlebars"] = { "prettierd", "prettier", stop_after_first = true },
        },
      }
    end,
  },
}
