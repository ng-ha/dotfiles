---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<C-n>"] = "",
    ["<leader>cm"] = "",
    ["<leader>gt"] = "",
    ["df"] = "",
    ["dd"] = "",
    ["<leader>ca"] = "",
    ["<leader>ra"] = "",
    ["<leader>rn"] = "",

    ["<C-h>"] = "",
    ["<C-l>"] = "",
    ["<C-j>"] = "",
    ["<C-k>"] = "",
    ["<c>"] = "",
    ["<v>"] = "",

    ["[d"] = "",
    ["]d"] = "",
    ["K"] = "",
    -- ["gD"] = "",
    ["gd"] = "",
    ["gi"] = "",
    -- ["<leader>ls"] = "",
    -- ["<leader>D"] = "",
    -- ["gr"] = "",
    ["<leader>f"] = "",
    ["<leader>q"] = "",
    -- ["<leader>fm"] = "",
    ["<leader>wa"] = "",
    ["<leader>wr"] = "",
    ["<leader>wl"] = "",
    ["<leader>wk"] = "",
    ["<leader>wK"] = "",
  },
}

M.schizo = {
  i = {
    ["<A-j>"] = { "<Esc>:m .+1<CR>==gi", "move line" },
    ["<A-k>"] = { "<Esc>:m .-2<CR>==gi", "move line" },
  },

  n = {
    ["x"] = { '"_x', "cut, no yank" },
    ["<A-j>"] = { ":m .+1<CR>==", "move line" },
    ["<A-k>"] = { ":m .-2<CR>==", "move line" },

    -- [";"] = { ":", "enter command mode", opts = { nowait = true } },

    ["j"] = { "jzz", "down & centered" },
    ["k"] = { "kzz", "up & centered" },

    ["<leader>+"] = { "<C-a>", "increment" },
    ["<leader>-"] = { "<C-x>", "decrement" },
    ["<leader>w"] = { "<cmd>:w<CR>", "save" },

    ["<leader>sv"] = { "<C-w>v", "split window vertically" },
    ["<leader>sh"] = { "<C-w>s", "split window horizontally" },
    ["<leader>se"] = { "<C-w>=", "equal windows" },
    ["<leader>sx"] = { "<cmd>close<CR>", "close split window" },
    ["<leader>sm"] = { "<cmd>MaximizerToggle<CR>", "toggle maximization" },

    ["<C-Up>"] = { "<cmd>resize +2<CR>", "resize window" },
    ["<C-Down>"] = { "<cmd>resize -2<CR>", "resize window" },
    ["<C-Left>"] = { "<cmd>vertical resize -2<CR>", "resize window" },
    ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", "resize window" },

    ["<leader>to"] = { "<cmd>:tabnew<CR>", "open new tab" },
    ["<leader>tx"] = { "<cmd>:tabclose<CR>", "close current tab" },
    ["<leader>tn"] = { "<cmd>:tabn<CR>", "next tab" },
    ["<leader>tp"] = { "<cmd>:tabp<CR>", "previous tab" },

    ["<leader>e"] = { "<cmd>NvimTreeToggle<CR>", "toggle nvimtree" },

    ["<leader>fc"] = { "<cmd>Telescope grep_string<CR>", "find string under cursor" },

    ["<leader>gc"] = { "<cmd>Telescope git_commits<CR>", "git commits" },
    ["<leader>gfc"] = { "<cmd>Telescope git_bcommits<CR>", "git file commits" },
    ["<leader>gb"] = { "<cmd>Telescope git_branches<CR>", "git branch" },
    ["<leader>gs"] = { "<cmd>Telescope git_status<CR>", "git status" },

    ["<leader>q"] = { "<cmd>q<CR>", "quit" },

    ["<C-`>"] = {
      function()
        vim.diagnostic.setloclist()
      end,
      "diagnostic setloclist",
    },

    ["<leader>ra"] = { "<cmd> set rnu! <CR>", "toggle relative number" },

    -----------------lsp---------------------
    ["gf"] = { "<cmd>Lspsaga lsp_finder<CR>", "lsp_finder" },
    ["gd"] = { "<cmd>Lspsaga peek_definition<CR>", "definition" },
    ["gt"] = { "<cmd>Lspsaga peek_type_definition<CR>", "type_definition" },
    ["gy"] = {
      function()
        vim.lsp.buf.implementation()
      end,
      "lsp implementation",
    },
    ["<leader>ca"] = { "<cmd>Lspsaga code_action<CR>", "code_action" },
    ["<leader>rn"] = { "<cmd>Lspsaga rename<CR>", "rename" },
    ["<leader>d"] = { "<cmd>Lspsaga show_line_diagnostics<CR>", "show_line_diagnostics" },
    ["<leader>D"] = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "show_cursor_diagnostics" },
    ["[d"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "diagnostic_jump_prev" },
    ["]d"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "diagnostic_jump_next" },
    ["K"] = { "<cmd>Lspsaga hover_doc<CR>", "hover_doc" },
    -- ["<leader>o"] = { "<cmd>Lspsaga outline_toggle<CR>", "outline_toggle" },  --no exist Lspsaga outline_toggle
    -- ["<leader>fm"] = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "format" }, --already exist

    ["<leader>rf"] = { "<cmd> TypescriptRenameFile <CR>", "rename file, update imports" },
    ["<leader>oi"] = { "<cmd> TypescriptOrganizeImports <CR>", "organize imports" },
    ["<leader>ru"] = { "<cmd> TypescriptRemoveUnused <CR>", "remove unused" },
    ["<leader>rs"] = { "<cmd>LspRestart<CR>", "restart lsp" },

    ----------Telescope-----------------
    ["<leader>mf"] = { "<cmd>Telescope media_files<CR>", "media_files" },
    ["<leader>fe"] = { "<cmd>Telescope file_browser<CR>", "file explorer" },
    ["<leader>fy"] = { "<cmd>Telescope neoclip<CR>", "neoclip" },
    ------------Trouble--------------------
    ["<leader>zz"] = { "<cmd>TroubleToggle<CR>", "TroubleToggle" },
    ["<leader>zw"] = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "TroubleToggle workspace" },
    ["<leader>zd"] = { "<cmd>TroubleToggle document_diagnostics<CR>", "TroubleToggle document" },
    ["<leader>zl"] = { "<cmd>TroubleToggle loclist<CR>", "TroubleToggle loclist" },
    ["<leader>zq"] = { "<cmd>TroubleToggle quickfix<CR>", "TroubleToggle quickfix" },

    ["<leader>za"] = { "<cmd>SymbolsOutline<CR>", "SymbolsOutline" },

    -- ######################################
    -- DAP
    -- ######################################
    -- ["<leader>dc"] = { "<cmd> DapContinue <CR>", "DAP continue" },        --conflict d show diagnostic
    -- ["<leader>dr"] = { "<cmd> DapToggleRepl <CR>", "DAP toggle repl" },
    -- ["<leader>di"] = { "<cmd> DapStepInto <CR>", "DAP step in" },
    -- ["<leader>do"] = { "<cmd> DapStepOut <CR>", "DAP step out" },
    -- ["<leader>dl"] = { "<cmd> DapShowLog <CR>", "DAP show log" },
    -- ["<leader>dt"] = { "<cmd> DapTerminate <CR>", "DAP terminate" },
    -- ######################################
    -- NEOGIT
    -- ######################################
    ["<leader>gg"] = { "<cmd> Neogit <CR>", "Neogit" },
    -- ######################################
    -- CODE-RUNNER
    -- ######################################
    ["<leader>rc"] = { "<cmd> RunCode <CR>", "Run code" },
    ["<leader>rr"] = { "<cmd> RunFile <CR>", "Run file" },
    -- ["<leader>rft"] = { "<cmd> RunFileTab <CR>", "Run file tab" }, --confict rf rename file
    ["<leader>rp"] = { "<cmd> RunProject <CR>", "Run project" },
    ["<leader>rx"] = { "<cmd> RunClose <CR>", "Run close" },
  },
  v = {
    ["<"] = { "<gv", "tab" },
    [">"] = { ">gv", "tab" },
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "move line" },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "move line" },
    ["p"] = { '"_dP', "paste, no yank" },
  },
  x = {
    ["<A-j>"] = { ":m '>+1<CR>gv=gv", "move line" },
    ["<A-k>"] = { ":m '<-2<CR>gv=gv", "move line" },
  },
}

-- more keybinds!

return M
