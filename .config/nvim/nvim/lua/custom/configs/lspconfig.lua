local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

-- if you just want default config for the servers then put them in a table
local servers = {
  "tsserver",
  "html",
  "cssls",
  "tailwindcss",
  "lua_ls",
  "emmet_ls",
  "eslint",
  "graphql",
  "jsonls",
  -- "quick_lint_js",
  "marksman",
  -- "denols",
  "gradle_ls",
  "jdtls",   --java
  "kotlin_language_server",
  "pyright",
  -- "vtsls",
}
---------------------------mason & mason-lsp------------------------
local mason_status, mason = pcall(require, "mason")
if not mason_status then
  print("ng-ha: Not found 'mason' !")
  return
end
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  print("ng-ha: Not found 'mason-lspconfig' !")
  return
end
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
  print("ng-ha: Not found 'typescript' !")
  return
end
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
  print("ng-ha: Not found 'mason-null-ls'")
  return
end
mason.setup()
mason_lspconfig.setup({
  ensure_installed = servers,
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
})

mason_null_ls.setup({
  -- list of formatters & linters for mason to install
  ensure_installed = {
    "prettier", -- ts/js formatter
    "stylua", -- lua formatter
    "eslint_d", -- ts/js linter
    "tsserver",
  },
  -- auto-install configured formatters & linters (with null-ls)
  automatic_installation = true,
})
----------------------------------lspconfig-------------------------


local lspconfig = require "lspconfig"

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

typescript.setup({
  server = {
    capabilities = capabilities,
    on_attach = on_attach,
  },
  disable_commands = false, -- prevent the plugin from creating Vim commands
  debug = false, -- enable debug logging for commands
  go_to_source_definition = {
      fallback = true, -- fall back to standard LSP definition on failure
  },
})


lspconfig.pyright.setup(require("custom.configs.settings.pyright"))
lspconfig.jsonls.setup(require("custom.configs.settings.jsonls"))
lspconfig["lua_ls"].setup(require("custom.configs.settings.lua_ls"))
lspconfig["emmet_ls"].setup({ filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

------------------lsp_highlight_document-------------------------
-- local function lsp_highlight_document(client)
--   -- Set autocommands conditional on server_capabilities
--   if client.server_capabilities.documentFormattingProvider then
--     vim.cmd([[
--       hi LspReferenceText  guibg=#383838 guifg=none 
--       hi LspReferenceRead  guibg=#383838 guifg=none 
--       hi LspReferenceWrite  guibg=#383838 guifg=none 
--     ]])
--     vim.api.nvim_exec(
--         [[
--         augroup lsp_document_highlight
--             autocmd! * <buffer>
--             autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
--             autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
--             autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--         augroup END
--         ]],
--       false
--     )
--   end
-- end
-- M.on_attach = function(client, bufnr)

--   client.server_capabilities.documentFormattingProvider = false
--   client.server_capabilities.documentRangeFormattingProvider = false

--   utils.load_mappings("lspconfig", { buffer = bufnr })
--      lsp_highlight_document(client)
--   if client.server_capabilities.signatureHelpProvider then
--     require("nvchad_ui.signature").setup(client)
--   end
-- end




