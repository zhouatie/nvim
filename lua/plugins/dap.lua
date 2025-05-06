local js_based_languages = {
  "typescript",
  "javascript",
  "typescriptreact",
  "javascriptreact",
  "vue",
}

return {
  {
    "mfussenegger/nvim-dap",
    -- dependencies = {
    --   -- "theHamsta/nvim-dap-virtual-text",
    -- },
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

      dap.adapters.chrome = {
        type = "executable",
        command = "node",
        args = { os.getenv("HOME") .. "/dap-debugger/vscode-chrome-debug/out/src/chromeDebug.js" },
      }

      -- node 支持
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
          {
            type = "pwa-node",
            request = "launch",
            name = "运行 npm dev",
            runtimeExecutable = "npm",
            runtimeArgs = { "dev" },
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            outFiles = { "${workspaceFolder}/{public, dist,build,out}/**/*.js" },
            resolveSourceMapLocations = {
              "${workspaceFolder}/{dist,build,out, public}/**/*.js",
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
      -- chrome 支持
      dap.configurations.javascriptreact = { -- change this to javascript if needed
        {
          type = "chrome",
          request = "attach",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          port = 9222,
          webRoot = "${workspaceFolder}",
        },
      }

      dap.configurations.typescriptreact = { -- change to typescript if needed
        {
          type = "chrome",
          request = "attach",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          port = 9222,
          webRoot = "${workspaceFolder}",
        },
      }
    end,
  },

  {
    "miroshQa/debugmaster.nvim",
    config = function()
      local dm = require("debugmaster")
      -- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
      vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true })
      vim.keymap.set("t", "<C-/>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
      vim.api.nvim_set_hl(0, "dCursor", { bg = "#FF2C2C" })
    end,
  },
}
