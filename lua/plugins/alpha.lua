-- 修改 dashboard 封面图
return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
              ▀████▀▄▄              ▄█
                █▀    ▀▀▄▄▄▄▄    ▄▄▀▀█
        ▄        █          ▀▀▀▀▄  ▄▀
       ▄▀ ▀▄      ▀▄              ▀▄▀
      ▄▀    █     █▀   ▄█▀▄      ▄█
      ▀▄     ▀▄  █     ▀██▀     ██▄█
       ▀▄    ▄▀ █   ▄██▄   ▄  ▄  ▀▀ █
        █  ▄▀  █    ▀██▀    ▀▀ ▀▀  ▄▀
       █   █  █      ▄▄           ▄▀
    ]]

      dashboard.section.header.val = vim.split(logo, "\n")
      return dashboard
    end,
  },
}
