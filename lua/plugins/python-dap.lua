return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "mfussenegger/nvim-dap-python", -- Python 专用的 DAP 扩展
    },
    config = function()
      local dap_python = require("dap-python")
      
      -- 设置 Python 调试器
      -- 使用 Mason 安装的 debugpy
      local debugpy_path = vim.fn.expand("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
      dap_python.setup(debugpy_path)
      
      -- 配置测试方法支持
      dap_python.test_runner = "pytest"
      
      -- 添加自定义配置
      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "launch",
        name = "运行当前文件(带参数)",
        program = "${file}",
        args = function()
          local args_string = vim.fn.input("命令行参数: ")
          return vim.split(args_string, " ")
        end,
        console = "integratedTerminal",
      })

      -- 添加 Django 配置
      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "launch",
        name = "运行 Django 服务器",
        program = "${workspaceFolder}/manage.py",
        args = {"runserver", "--noreload"},
        django = true,
        console = "integratedTerminal",
      })
      
      -- 添加 FastAPI 配置
      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "launch",
        name = "运行 FastAPI 应用",
        module = "uvicorn",
        args = function()
          local app_module = vim.fn.input("应用模块 (例如: main:app): ")
          return {
            app_module,
            "--reload",
          }
        end,
        console = "integratedTerminal",
      })
      
      -- 添加远程调试配置
      table.insert(require("dap").configurations.python, {
        type = "python",
        request = "attach",
        name = "远程调试",
        connect = function()
          local host = vim.fn.input("主机 (默认: localhost): ")
          if host == "" then host = "localhost" end
          
          local port = tonumber(vim.fn.input("端口 (默认: 5678): "))
          if port == nil or port == 0 then port = 5678 end
          
          return { host = host, port = port }
        end,
        pathMappings = function()
          local local_path = vim.fn.input("本地路径: ")
          local remote_path = vim.fn.input("远程路径: ")
          
          if local_path ~= "" and remote_path ~= "" then
            return {
              {
                localRoot = local_path,
                remoteRoot = remote_path,
              }
            }
          else
            return {}
          end
        end,
      })
    end,
  },
}
