-- 加载 Obsidian 相关快捷键配置
require("config.obsidian-keymap").setup()

-- 设置 Avante 相关快捷键
vim.keymap.set("n", "<leader>an", function()
  vim.cmd("AvanteChatNew")
end, { desc = "AvanteChatNew" })
