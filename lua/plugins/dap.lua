local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}

return {
  -- {
  --   "nvim-dap-virtual-text",
  --   config = function()
  --     -- require("nvim-dap-virtual-text").setup({
  --     --   enabled = true, -- enable this plugin (the default)
  --     --   enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  --     --   highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  --     --   highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  --     --   show_stop_reason = true, -- show stop reason when stopped for exceptions
  --     --   commented = false, -- prefix virtual text with comment string
  --     --   only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
  --     --   all_references = false, -- show virtual text on all all references of the variable (not only definitions)
  --     --   clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)
  --     --   --- A callback that determines how a variable is displayed or whether it should be omitted
  --     --   --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
  --     --   --- @param buf number
  --     --   --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
  --     --   --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
  --     --   --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
  --     --   --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
  --     --   display_callback = function(variable, buf, stackframe, node, options)
  --     --     -- by default, strip out new line characters
  --     --     if options.virt_text_pos == "inline" then
  --     --       return " = " .. variable.value:gsub("%s+", " ")
  --     --     else
  --     --       return variable.name .. " = " .. variable.value:gsub("%s+", " ")
  --     --     end
  --     --   end,
  --     --   -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
  --     --   virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
  --     --
  --     --   -- experimental features:
  --     --   all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  --     --   virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
  --     --   virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
  --     --   -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
  --     -- })
  --   end,
  -- },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")

      -- 设置更美观的调试图标
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = "◆", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
      )
      vim.fn.sign_define("DapLogPoint", { text = "◉", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })
      vim.fn.sign_define(
        "DapStopped",
        { text = "➤", texthl = "DiagnosticSignHint", linehl = "DapStoppedLine", numhl = "" }
      )
      vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = "✖", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
      )

      -- 添加保存所有缓冲区的预启动钩子，解决"修改后的缓冲区"错误
      -- dap.listeners.before.launch.saveAll = function()
      --   vim.cmd("wa") -- 保存所有修改过的缓冲区
      -- end

      -- 共用同一个js-debug-adapter作为调试适配器
      local js_debug_adapter = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = vim.fn.expand("~/.local/share/nvim/mason/bin/js-debug-adapter"),
          args = { "${port}" },
        },
      }

      -- Node.js调试适配器
      dap.adapters["pwa-node"] = js_debug_adapter

      -- Chrome浏览器调试适配器
      dap.adapters["pwa-chrome"] = js_debug_adapter

      -- 为支持的JavaScript相关语言创建通用配置
      for _, language in ipairs(js_based_languages) do
        dap.configurations[language] = {
          -- 调试当前文件
          {
            type = "pwa-node",
            request = "launch",
            name = "调试当前文件",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            runtimeExecutable = "node",
            -- TypeScript 需要 ts-node
            runtimeArgs = (function()
              if language:match("typescript") then
                return {
                  "--nolazy",
                  "-r",
                  "ts-node/register",
                }
              else
                return {}
              end
            end)(),
            outFiles = { "${workspaceFolder}/{dist,build,public}/**/*.js" },
            resolveSourceMapLocations = {
              "${workspaceFolder}/{dist,build,public}/**/*.js",
              "${workspaceFolder}/**/*.{ts,tsx,js,jsx}",
              "!**/node_modules/**",
            },
            skipFiles = { "<node_internals>/**" },
            console = "integratedTerminal",
          },
          -- 调试项目(从package.json的启动脚本)
          {
            type = "pwa-node",
            request = "launch",
            name = "运行 npm start",
            runtimeExecutable = "npm",
            runtimeArgs = { "start" },
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            outFiles = { "${workspaceFolder}/{dist,build,out}/**/*.js" },
            resolveSourceMapLocations = {
              "${workspaceFolder}/{dist,build,out}/**/*.js",
              "${workspaceFolder}/**/*.{ts,tsx,js,jsx}",
              "!**/node_modules/**",
            },
            skipFiles = { "<node_internals>/**" },
            console = "integratedTerminal",
          },
          -- 附加到已运行的进程
          {
            type = "pwa-node",
            request = "attach",
            name = "附加到进程",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            outFiles = { "${workspaceFolder}/{dist,build,out}/**/*.js" },
            resolveSourceMapLocations = {
              "${workspaceFolder}/{dist,build,out}/**/*.js",
              "${workspaceFolder}/**/*.{ts,tsx,js,jsx}",
              "!**/node_modules/**",
            },
            skipFiles = { "<node_internals>/**" },
          },
        }
      end
    end,
  },

  {
    "miroshQa/debugmaster.nvim",
    config = function()
      local dm = require("debugmaster")
      -- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
      vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true })
      vim.keymap.set("t", "<C-/>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
    end,
  },
}
