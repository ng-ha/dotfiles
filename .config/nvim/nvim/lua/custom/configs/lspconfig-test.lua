dofile(vim.g.base46_cache .. "lsp")
require "nvchad_ui.lsp"


local utils = require "core.utils"
dofile(vim.g.base46_cache .. "lsp")
require "nvchad_ui.lsp"
local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
  print("ng-ha: Not found 'cmp_nvim_lsp' !")
	return
end

-- export on_attach & capabilities for custom lspconfigs

local on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  utils.load_mappings("lspconfig", { buffer = bufnr })
  if client.server_capabilities.signatureHelpProvider then
    require("nvchad_ui.signature").setup(client)
  end

  local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) 
	keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) 
	-- keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) 
	keymap(bufnr, "n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) 
	-- keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) 
	keymap(bufnr, "n", "<leader>gt", "<cmd>Lspsaga peek_type_definition<CR>", opts) 
	keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) 
	keymap(bufnr, "n", "gy", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) 
	keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts) 
	keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) 
	keymap(bufnr, "n", "<leader>fm", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts) 
	keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
	keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
	-- keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts) 
	keymap(bufnr, "n", "<leader>ca", "<cmd>Lspsaga code_action<cr>", opts) 
	-- keymap(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
	-- keymap(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
	keymap(bufnr, "n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opts)
	keymap(bufnr, "n", "]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", opts)
	keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts) 
	keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) 
	keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
	keymap(bufnr, "n", "<leader>rs", "<cmd>LspRestart<CR>", opts) 
	keymap(bufnr, "n", "<leader>o", "<cmd>Lspsaga outline_toggle<CR>", opts) 
	keymap(bufnr, "n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) 
	keymap(bufnr, "n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) 
	keymap(bufnr, "n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) 

  if client.name == "tsserver" then
    vim.keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
    vim.keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
    vim.keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
  end

  local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
    print("ng-ha: Not found 'illuminate' !")
		return
	end
	illuminate.on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)


-------------------------------------------------


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
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/extensions/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}

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




