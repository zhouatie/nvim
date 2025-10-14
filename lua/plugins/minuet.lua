-- gpt-4o-mini > gemini-2.0-flash
return {
  {
    "milanglacier/minuet-ai.nvim",
    -- enabled = false,
    config = function()
      require("minuet").setup({
        provider = "openai_compatible",

        n_completions = 2,
        context_window = 512,
        provider_options = {
          openai_compatible = {
            api_key = function()
              return os.getenv("AIHUBMIX_COMPLETE_API_KEY")
            end,
            end_point = "https://aihubmix.com/v1/chat/completions",
            model = "gpt-4o-mini",
            -- model = "gemini-2.0-flash",
            name = "AIHubMix",
            optional = {
              max_tokens = 128,
              top_p = 0.9,
            },
          },

          openai_fim_compatible = {
            api_key = function()
              return os.getenv("AIHUBMIX_COMPLETE_API_KEY")
            end,
            end_point = "https://aihubmix.com/v1/completions",
            model = "chutesai/Mistral-Small-3.1-24B-Instruct-2503",
            name = "AIHubMix",
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },

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
