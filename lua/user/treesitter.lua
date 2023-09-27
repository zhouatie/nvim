local M = {
}
function M.config()
  local treesitter = require "nvim-treesitter"
  local configs = require "nvim-treesitter.configs"

  configs.setup {
    ensure_installed = { "lua", "markdown", "markdown_inline", "bash", "python" }, -- put the language you want in this array
    -- ensure_installed = "all", -- one of "all" or a list of languages
    ignore_install = { "" },                                                       -- List of parsers to ignore installing
    sync_install = false,                                                          -- install languages synchronously (only applied to `ensure_installed`)

    highlight = {
      enable = true,       -- false will disable the whole extension
      disable = { "css" }, -- list of language that will be disabled
    },
    autopairs = {
      enable = true,
    },
    indent = { enable = true, disable = { "python", "css" } },

    -- TODO:
    incremental_selection = {
      enable = true,
      keymaps = {
         init_selection = "gnn", -- set to `false` to disable one of the mappings
         node_incremental = "grn",
         scope_incremental = "grc",
         node_decremental = "grm",
      },
    },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  }
end

return M
