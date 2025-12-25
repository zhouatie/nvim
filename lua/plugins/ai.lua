return {
  {
    -- commit = "476f342fe6bc1e120ba3e334b5d9cf3ef66de56a"
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    opts = {
      instructions_file = "avante.md",
      provider = "claude-code",
      acp_providers = {
        ["claude-code"] = {
          command = "npx",
          args = { "@zed-industries/claude-code-acp" },
          env = {
            NODE_NO_WARNINGS = "1",
            ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_AUTH_TOKEN"),
          },
        },
      },
      providers = {
        aihubmix = {
          endpoint = "https://aihubmix.com/v1",
          model = "gemini-3-flash-preview",
          -- model = "Qwen/QwQ-32B",
          -- stream = true,
          -- model = "llama-3.3-70b-versatile",
          -- model = "claude-3-5-sonnet-20240620",
          -- model = "aihubmix-DeepSeek-R1",
          timeout = 30000, -- timeout in milliseconds
          temperature = 0, -- adjust if needed
          max_tokens = 8192,
        },
      },
    },
  },
}
