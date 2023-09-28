-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
  return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
  return
end

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
  -- keybind options
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- set keybinds
  keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)            --  Toggle Lspsaga hover_doc
  keymap.set("n", "gf", "<cmd>Lspsaga finder<CR>", opts)              -- Toggle Lspsaga finder
  keymap.set("n", "<leader>gf", "<cmd>Lspsaga finder imp<CR>", opts)  -- Toggle Lspsaga finder imp
  keymap.set("n", "gx", "<cmd>Lspsaga code_action<CR>", opts)         -- Toggle Lspsaga code_action
  keymap.set("n", "gr", "<cmd>Lspsaga rename<CR>", opts)              -- 重命名
  keymap.set("n", "gP", "<cmd>Lspsaga peek_definition<CR>", opts)     -- show definition, references
  keymap.set("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- show definition, references
  keymap.set("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- show definition, references
  keymap.set("n", "gK", function()
    require("lspsaga.diagnostic").goto_prev({
      severity = vim.diagnostic.severity.ERROR,
    })
  end, opts) -- 跳转到上一个错误 

  keymap.set("n", "gJ", function()
    require("lspsaga.diagnostic").goto_next({
      severity = vim.diagnostic.severity.ERROR,
    })
  end, opts) -- 跳转到下一个错误

  keymap.set("n", "<leader>ol", "<cmd>Lspsaga outline<CR>", opts) -- show definition, references
  keymap.set("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- 显示诊断list
  keymap.set("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- 显示诊断list
  keymap.set("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", opts) -- 显示诊断list
  keymap.set("n", "<leader>o", "<cmd>SymbolsOutline<CR>", opts)                 -- 调用栈 
  -- keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)           -- see available code actions
  -- keymap.set("n", "<leader>co", "<cmd>Lspsaga outgoint_calls<CR>", opts)           -- see available code actions
  -- keymap.set("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", opts)           -- see available code actions

  -- vim.api.nvim_set_keymap("n", "<leader>so", "<cmd>SymbolsOutline<CR>", {silent = true, noremap = true})

  -- typescript specific keymaps (e.g. rename file and update imports)
  if client.name == "tsserver" then
    keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")    -- rename file and update imports
    keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
    keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")  -- remove unused variables (not in youtube nvim video)
  end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure typescript server with plugin
typescript.setup({
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  },
})

-- configure css server
lspconfig["cssls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
  capabilities = capabilities,
  on_attach = on_attach,
  settings = { -- custom settings for lua
    Lua = {
      -- make the language server recognize "vim" global
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        -- make language server aware of runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.stdpath("config") .. "/lua"] = true,
        },
      },
    },
  },
})
