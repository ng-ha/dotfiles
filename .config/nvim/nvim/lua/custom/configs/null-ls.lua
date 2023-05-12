local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {

  -- webdev stuff
  b.formatting.deno_fmt, -- choosed deno for ts/js files cuz its very fast!
  -- b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes
  -- b.formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote"}}), --  js/ts formatter
  b.formatting.prettier,

  -- Lua
  b.formatting.stylua,

  -- cpp
  b.formatting.clang_format,
  -- Shell
  b.formatting.shfmt,
  b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

  b.diagnostics.eslint.with { -- js/ts linter
    -- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
    condition = function(utils)
      return utils.root_has_file ".eslintrc.js" -- change file extension if you use something else
    end,
  },
  b.diagnostics.eslint_d.with { -- js/ts linter
    -- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
    condition = function(utils)
      return utils.root_has_file ".eslintrc.js" -- change file extension if you use something else
    end,
  },
  -- b.code_action.gitsigns,
  -- b.completion.spell,
  b.diagnostics.tsc,
  require "typescript.extensions.null-ls.code-actions",
}

null_ls.setup {
  debug = true,
  sources = sources,
  on_attach = function(current_client, bufnr)
    if current_client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format {
            filter = function(client)
              --  only use null-ls for formatting instead of lsp server
              return client.name == "null-ls"
            end,
            bufnr = bufnr,
          }
        end,
      })
    end
  end,
}
