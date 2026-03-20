-- Load options first (before lazy.nvim)
require("config.options")

-- Bootstrap lazy.nvim and plugins
require("config.lazy")

-- Load keymaps and autocmds after plugins
require("config.keymaps")
require("config.autocmds")
