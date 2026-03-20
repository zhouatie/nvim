return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      },
      inlay_hints = { enabled = false },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              codeLens = { enable = true },
              completion = { callSnippet = "Replace" },
              doc = { privateName = { "^_" } },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
        ts_ls = {},
        vue_ls = {},
        eslint = {},
        tailwindcss = {},
        jsonls = {},
        yamlls = {},
        pyright = {},
        taplo = {},
        html = {},
        cssls = {},
      },
    },
    config = function(_, opts)
      -- Configure diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
        callback = function(ev)
          local buf = ev.buf
          local m = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
          end

          m("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
          m("n", "gr", function() Snacks.picker.lsp_references() end, "References")
          m("n", "gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
          m("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
          m("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          m("n", "K", vim.lsp.buf.hover, "Hover")
          m("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          m("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
          m({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          m("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          m("n", "<leader>cA", function()
            vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
          end, "Source Action")
        end,
      })

      -- Setup servers via mason-lspconfig
      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        -- merge blink.cmp capabilities if available
        (function()
          local ok, blink = pcall(require, "blink.cmp")
          return ok and blink.get_lsp_capabilities() or {}
        end)()
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        require("lspconfig")[server].setup(server_opts)
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_servers = vim.tbl_keys(servers)

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_filter(function(s)
            return s ~= "eslint"
          end, all_servers),
          handlers = { setup },
        })
      else
        for _, server in ipairs(all_servers) do
          setup(server)
        end
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "eslint_d",
        "black",
        "isort",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
}
