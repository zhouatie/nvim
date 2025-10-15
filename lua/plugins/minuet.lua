-- gpt-4o-mini > gemini-2.0-flash
return {
  {
    "milanglacier/minuet-ai.nvim",
    -- enabled = false,
    config = function()
      require("minuet").setup({
        -- provider = "openai",
        provider = "openai_fim_compatible",
        -- provider = "openai_compatible",

        proxy = "http://127.0.0.1:8899",

        notify = false,
        n_completions = 1,
        context_window = 512,
        provider_options = {

          openai_fim_compatible = {},

          -- openai_fim_compatible = {
          --   api_key = function()
          --     return os.getenv("AIHUBMIX_COMPLETE_API_KEY")
          --   end,
          --   -- stream = false,
          --   end_point = "https://aihubmix.com/v1/completions",
          --   model = "gpt-4o-mini",
          --   name = "AIHubMix",
          --   optional = {
          --     max_tokens = 128,
          --     top_p = 0.9,
          --   },
          -- },

          openai = {
            model = "gpt-5-codex",
            end_point = "https://gaccode.com/codex/v1/completions",
            -- system = "see [Prompt] section for the default value",
            -- few_shots = "see [Prompt] section for the default value",
            -- chat_input = "See [Prompt Section for default value]",
            stream = true,
            api_key = "CODEX_API_KEY",
            -- api_key = "OPENAI_API_KEY",
            optional = {
              -- gaccode streams require disabling the server-side store flag
              store = false,
              -- provide instruction string per gaccode chat API requirement
              instructions = "You are a helpful coding assistant.",
              -- pass any additional parameters you want to send to OpenAI request,
              -- e.g.
              -- stop = { 'end' },
              -- max_tokens = 256,
              -- top_p = 0.9,
              -- reasoning_effort = 'minimal'
            },
          },

          -- openai_compatible = {
          --   api_key = function()
          --     return os.getenv("AIHUBMIX_COMPLETE_API_KEY")
          --   end,
          --   end_point = "https://aihubmix.com/v1/chat/completions",
          --   model = "gpt-4o-mini",
          --   -- model = "gemini-2.0-flash",
          --   name = "AIHubMix",
          --   optional = {
          --     max_tokens = 128,
          --     top_p = 0.9,
          --   },
          -- },

          -- openai_fim_compatible = {
          --   name = "Codex",
          --   api_key = "CODEX_API_KEY", -- 这里写环境变量名，提前 export
          --   end_point = "https://gaccode.com/codex/v1/completions",
          --   model = "gpt-5-codex",
          --   optional = {
          --     max_tokens = 128,
          --     temperature = 0.2,
          --     -- stop = { "<endCompletion>" }, -- 根据需要自定义
          --   },
          -- },

          -- openai_fim_compatible = {
          --   api_key = "TERM",
          --   name = "Ollama",
          --   end_point = "http://localhost:11434/v1/completions",
          --   model = "qwen2.5-coder:7b",
          --   optional = {
          --     max_tokens = 256,
          --     top_p = 0.9,
          --   },
          -- },
        },
        virtualtext = {
          auto_trigger_ft = { "*" },
          -- auto_trigger_ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
          keymap = {
            accept = "<Tab>",
            next = "<C-;>",
            accept_line = "<C-l>",
            -- accept_n_lines = "<A-z>",
            -- prev = "<A-[>",
            -- next = "<A-]>",
            -- dismiss = "<A-e>",
          },
          show_on_completion_menu = true,
        },

        cmp = {
          enable_auto_complete = false,
        },
        blink = {
          enable_auto_complete = false,
        },
      })
    end,
  },

  { "nvim-lua/plenary.nvim" },
}
