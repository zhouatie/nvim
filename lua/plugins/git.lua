return {
  {
    "petertriho/nvim-scrollbar",
    event = "VeryLazy",
    config = function()
      require("scrollbar").setup()
    end,
  },

  {
    "f-person/git-blame.nvim",
    event = "VeryLazy",
    opts = {
      enabled = true,
      message_template = "<author> . <summary> . <date>",
      date_format = "%Y-%m-%d %H:%M:%S",
      virtual_text_column = 1,
    },
    init = function()
      vim.g.gitblame_message_when_not_committed = ""
      vim.g.gitblame_delay = 2000
    end,
  },
}
