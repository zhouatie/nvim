local function tokens(num)
  return num * 1024
end

local function extract_codemaker_text(json)
  if type(json) ~= "table" then
    return nil
  end

  if type(json.code) == "table" then
    return table.concat(json.code, "\n")
  end

  if type(json.data) == "table" and type(json.data.code) == "table" then
    return table.concat(json.data.code, "\n")
  end

  return nil
end

-- gpt-4o-mini > gemini-2.0-flash
return {
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        -- provider = "openai_compatible",

        proxy = "http://127.0.0.1:8899",
        notify = "warn",
        n_completions = 1,
        -- context_window = 512,
        context_window = tokens(64),
        after_cursor_filter_length = 1,
        provider_options = {

          openai_fim_compatible = {
            name = "CodeMaker",
            api_key = function()
              return "TERM"
            end,
            end_point = vim.env.CODEMAKER_ENDPOINT
              or "https://api-code-maker.nie.netease.com/api/v1/ai_lab/code_generate",
            model = vim.env.CODEMAKER_MODEL_CODE or "cloud-music",
            stream = true,
            optional = {
              n = 1,
              temperature = 0.7,
              top_p = 0.7,
              max_tokens = 100,
            },
            get_text_fn = {
              no_stream = extract_codemaker_text,
              stream = function(json)
                return extract_codemaker_text(json)
              end,
            },
            transform = {
              function(request)
                local env = vim.env
                local headers = request.headers

                headers.Authorization = nil
                headers.Accept = "application/json, text/plain, */*"
                headers["Content-Type"] = "application/json"
                headers.Connection = "close"
                headers["Code-Generate-Model-Code"] = env.CODEMAKER_MODEL_CODE or request.body.model or "cloud-music"
                headers["Codemaker-Version"] = env.CODEMAKER_VERSION or "2.7.1"
                headers["Department-Code"] = env.CODEMAKER_DEPARTMENT_CODE
                  or "yinyueshiyebu-jishuzhongxin-zhongduanjishubu-zhuomiandaqianduanzu"
                headers.Ide = env.CODEMAKER_IDE or "vscode"
                headers["User-Agent"] = env.CODEMAKER_USER_AGENT or "nvim"

                local access_token = env.CODEMAKER_ACCESS_TOKEN
                  or "eyJhbGciOiJIUzI1NiIsImtpZCI6IjE2ODQyMjE4NTQiLCJ0eXAiOiJKV1QifQ.eyJleHAiOjE3NjA1Nzk5MTgsImlzdCI6MTc2MDQ5MzUxOCwidXNlciI6Inpob3VzaGl0aWUifQ.XTn1y1IlPBhR0sxW_EUPXVib6JJBogxESw5ve56y6B8"
                if access_token ~= "" then
                  headers["X-Access-Token"] = access_token
                else
                  headers["X-Access-Token"] = nil
                end

                local auth_user = env.CODEMAKER_AUTH_USER or env.USER or ""
                if auth_user ~= "" then
                  headers["X-Auth-User"] = auth_user
                end

                local trace_id = env.CODEMAKER_TRACE_ID
                if trace_id and trace_id ~= "" then
                  headers["Ntes-Trace-Id"] = trace_id
                end

                headers.Host = nil

                local body = request.body
                body.prompt_after = body.suffix or ""
                body.suffix = nil
                body.prompt = body.prompt or ""
                body.stream = nil
                body.model = nil
                body.lang = body.lang or vim.bo.filetype or "plaintext"

                return request
              end,
            },
          },

          -- openai_fim_compatible = {
          --   api_key = function()
          --     return os.getenv("AIHUBMIX_COMPLETE_API_KEY")
          --   end,
          --   stream = false,
          --   end_point = "https://aihubmix.com/v1/completions",
          --   model = "gpt-4o-mini",
          --   name = "AIHubMix",
          --   optional = {
          --     max_tokens = 128,
          --     top_p = 0.9,
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
          -- auto_trigger_ft = { "*" },
          auto_trigger_ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
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
