local M = {}


local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentFormattingProvider then
    vim.cmd([[
        hi LspReferenceRead cterm=bold ctermbg=237 guibg=#45403d
        hi LspReferenceText cterm=bold ctermbg=237 guibg=#45403d
        hi LspReferenceWrite cterm=bold ctermbg=237 guibg=#45403d
    ]])
    vim.api.nvim_exec(
        [[
        augroup lsp_document_highlight
            autocmd! * <buffer>
            autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
            autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]],
      false
    )
--   end
end

-- hi LspReferenceText cterm=bold gui=bold guibg=peru guifg=wheat

-- hi LspReferenceText  guibg=none guifg=wheat
-- hi LspReferenceRead  guibg=none guifg=wheat
-- hi LspReferenceWrite  guibg=none guifg=wheat

-- hi LspReferenceText  guibg=none guifg=none gui=bold
-- hi LspReferenceRead  guibg=none guifg=none gui=bold
-- hi LspReferenceWrite  guibg=none guifg=none gui=bold

-- hi LspReferenceRead cterm=bold ctermbg=237 guibg=#45403d

-- hi LspReferenceText cterm=bold ctermbg=237 guibg=#45403d

-- hi LspReferenceWrite cterm=bold ctermbg=237 guibg=#45403d
-- 6B6B6B

-- hi LspReferenceRead cterm=normal ctermbg=237 guibg=#2B2B2B

-- hi LspReferenceText cterm=normal  ctermbg=237 guibg=#2B2B2B

-- hi LspReferenceWrite cterm=normal  ctermbg=237 guibg=#2B2B2B

-- guibg=peru guifg=wheat

-- local function lsp_keymaps(bufnr)
--   local opts = { noremap = true, silent = true }
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
--   -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
--   vim.api.nvim_buf_set_keymap(
--     bufnr,
--     "n",
--     "gl",
--     '<cmd>lua vim.diagnostic.open_float()<CR>',
--     opts
--   )
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
--   vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
--   vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
-- end
------------------------on_attach-------------------------------
M.on_attach = function(client, bufnr)
    -- client.server_capabilities.documentFormattingProvider = false
    -- client.server_capabilities.documentRangeFormattingProvider = false
    -----------------------------------
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)
    ----------------------------------
    if client.server_capabilities.signatureHelpProvider then
        require("nvchad_ui.signature").setup(client)
    end
end


-- on_attach = function(client)
--     if client.server_capabilities.documentFormattingProvider then -
--         vim.cmd(
--             [[
--         augroup LspFormatting
--         autocmd! * <buffer>
--         autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
--         augroup END
--         ]]
--         )
--     end
-- end