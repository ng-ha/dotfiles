local overrides = require "custom.configs.overrides"
local myonattach = require "custom.configs.my_on_attach_nvimtree"
---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
          "jose-elias-alvarez/typescript.nvim",
        },
        config = function()
          require "custom.configs.null-ls"
        end,
      },
      {
        "williamboman/mason-lspconfig.nvim",
        "williamboman/mason.nvim",
        "jay-babu/mason-null-ls.nvim",
        "hrsh7th/cmp-nvim-lsp",
      },
    },
    config = function()
      -- require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  {
    "glepnir/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup {
        -- keybinds for navigation in lspsaga window
        scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
        -- use enter to open file with definition preview
        definition = {
          edit = "<CR>",
        },
        -- ui = {
        --   colors = {
        --     normal_bg = "#022746",
        --   },
        -- },
        -- default options
        -- finder = {
        --   max_height = 0.5,
        --   min_width = 30,
        --   force_max_height = false,
        --   keys = {
        --     jump_to = 'p',
        --     expand_or_jump = 'o',
        --     vsplit = 's',
        --     split = 'i',
        --     tabe = 't',
        --     tabnew = 'r',
        --     quit = { 'q', '<ESC>' },
        --     close_in_preview = '<ESC>',
        --   },
        -- },
        -- definition = {
        --   edit = "<C-c>o",
        --   vsplit = "<C-c>v",
        --   split = "<C-c>i",
        --   tabe = "<C-c>t",
        --   quit = "q",
        -- }
        lightbulb = {
          enable = false, ------->
          enable_in_insert = false,
          sign = true,
          sign_priority = 40,
          virtual_text = true,
        },
        -- hover = {
        --   max_width = 0.6,
        --   open_link = 'gx',
        --   open_browser = '!chrome',
        -- },
      }
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      --Please make sure you install markdown and markdown_inline parser
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "onsails/lspkind.nvim",
  },
  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = overrides.treesitter,
    dependencies = {
      {
        "mrjones2014/nvim-ts-rainbow",
        -- "p00f/nvim-ts-rainbow",
        -- "HiPhish/nvim-ts-rainbow2",
        "JoosepAlviste/nvim-ts-context-commentstring",
        "windwp/nvim-ts-autotag",
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup {
        autotag = {
          enable = true,
        },

        filetypes = {
          "html",
          "htmldjango",
          "javascript",
          "javascriptreact",
          "jsx",
          "typescript",
          "typescriptreact",
          "tsx",
          "rescript",
          "svelte",
          "vue",
          "xml",
          "php",
          "markdown",
          "glimmer",
          "handlebars",
          "hbs",
        },

        skip_tags = {
          "area",
          "base",
          "br",
          "col",
          "command",
          "embed",
          "hr",
          "img",
          "slot",
          "input",
          "keygen",
          "link",
          "meta",
          "param",
          "source",
          "track",
          "wbr",
          "menuitem",
        },
      }
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    opts = function()
      -- h, j, k, l Style Navigation And Editing
      local lib = require "nvim-tree.lib"
      local view = require "nvim-tree.view"

      local function collapse_all()
        require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
      end

      local function edit_or_open()
        -- open as vsplit on current node
        local action = "edit"
        local node = lib.get_node_at_cursor()
        -- Just copy what's done normally with vsplit
        if node.link_to and not node.nodes then
          require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
          view.close() -- Close the tree if file was opened
        elseif node.nodes ~= nil then
          lib.expand_or_collapse(node)
        else
          require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
          view.close() -- Close the tree if file was opened
        end
      end

      local function vsplit_preview()
        -- open as vsplit on current node
        local action = "vsplit"
        local node = lib.get_node_at_cursor()
        -- Just copy what's done normally with vsplit
        if node.link_to and not node.nodes then
          require("nvim-tree.actions.node.open-file").fn(action, node.link_to)
        elseif node.nodes ~= nil then
          lib.expand_or_collapse(node)
        else
          require("nvim-tree.actions.node.open-file").fn(action, node.absolute_path)
        end
        -- Finally refocus on tree if it was lost
        view.focus()
      end

      local git_add = function()
        local node = lib.get_node_at_cursor()
        local gs = node.git_status.file
        -- If the file is untracked, unstaged or partially staged, we stage it
        if gs == "??" or gs == "MM" or gs == "AM" or gs == " M" then
          vim.cmd("silent !git add " .. node.absolute_path)
          -- If the file is staged, we unstage
        elseif gs == "M " or gs == "A " then
          vim.cmd("silent !git restore --staged " .. node.absolute_path)
        end
        lib.refresh_tree()
      end

      local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
      if not config_status_ok then
        return
      end
      local tree_cb = nvim_tree_config.nvim_tree_callback
      local config = {
        on_attach = myonattach,
        view = {
          -- mappings = {
          --   custom_only = false,
          --   list = {
          --     -- { key = "l", action = "edit", action_cb = edit_or_open },
          --     { key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
          --     -- { key = "h", action = "close_node" },
          --     { key = "H", action = "collapse_all", action_cb = collapse_all },
          --     { key = "ga", action = "git_add", action_cb = git_add },
          --     { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
          --     { key = "h", cb = tree_cb "close_node" },
          --     { key = "v", cb = tree_cb "vsplit" },
          --   },
          -- },
          adaptive_size = false,
          side = "left",
          width = 30,
          hide_root_folder = false,
          preserve_window_proportions = true,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
        },
        diagnostics = {
          enable = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        git = {
          enable = true,
          ignore = false,
        },
        filesystem_watchers = {
          enable = true,
        },
        actions = {
          open_file = {
            quit_on_open = false,
          },
        },
        filters = {
          dotfiles = false,
          exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
        },
        disable_netrw = true,
        hijack_netrw = true,
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = false,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = false,
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "name",
          indent_markers = {
            enable = true,
            inline_arrows = false,
          },
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                -- open = "",
                -- symlink = "",
                symlink_open = "",
                arrow_open = "",
                arrow_closed = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
              },
              git = {
                unstaged = "",
                staged = "",
                unmerged = "",
                renamed = "➜",
                untracked = "",
                deleted = "",
                ignored = "◌",
              },
              -- git = {
              --   unstaged = "",
              --   staged = "S",
              --   unmerged = "",
              --   renamed = "➜",
              --   untracked = "U",
              --   deleted = "",
              --   ignored = "◌",
              -- },
            },
          },
        },
      }
      return config
    end,
  },

  -- Install a plugin
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup {
        mapping = { "jk", "jj" }, -- a table with mappings to use
        timeout = vim.o.timeoutlen, -- the time in which the keys must be hit in ms. Use option timeoutlen by default
        clear_empty_lines = false, -- clear line after escaping if there is only whitespace
        keys = "<Esc>", -- keys used for escaping, if it is a function will use the result everytime
        -- example(recommended)
        -- keys = function()
        --   return vim.api.nvim_win_get_cursor(0)[2] > 1 and '<esc>l' or '<esc>'
        -- end,)
      }
    end,
  },

  -- To make a plugin not be loaded
  {
    "NvChad/nvim-colorizer.lua",
    enabled = true,
  },
  -------------my custom--------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function()
      vim.opt.termguicolors = true
      -- vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

      -- vim.cmd [[highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine]]

      -- vim.cmd [[highlight IndentBlanklineIndent1 guibg=#2E2E22 gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent2 guibg=#252E25 gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent3 guibg=#2F252F gui=nocombine]]
      -- vim.cmd [[highlight IndentBlanklineIndent4 guibg=#232C2D gui=nocombine]]

      vim.opt.list = true
      vim.opt.listchars:append "space:⋅"
      -- vim.opt.listchars:append "eol:↴"

      local setup = {
        space_char_blankline = " ",
        -- char_highlight_list = {
        --   "IndentBlanklineIndent1",
        --   "IndentBlanklineIndent2",
        --   "IndentBlanklineIndent3",
        --   "IndentBlanklineIndent4",
        --   "IndentBlanklineIndent5",
        --   "IndentBlanklineIndent6",
        -- },

        char = " ", -- turn this on/off
        -- char_highlight_list = {
        --   "IndentBlanklineIndent1",
        --   "IndentBlanklineIndent2",
        -- },
        -- space_char_highlight_list = {
        --     "IndentBlanklineIndent1",
        --     "IndentBlanklineIndent2",
        -- },
        indentLine_enabled = 1,
        filetype_exclude = {
          "help",
          "terminal",
          "lazy",
          "lspinfo",
          "TelescopePrompt",
          "TelescopeResults",
          "mason",
          "nvdash",
          "nvcheatsheet",
          "",
        },
        buftype_exclude = { "terminal" },
        show_trailing_blankline_indent = false,
        show_first_indent_level = true,
        show_current_context = true,
        show_current_context_start = true,
        -- show_end_of_line = true,
      }
      return setup
    end,
  },
  {
    "godlygeek/tabular",
  },
  {
    "preservim/vim-markdown",
  },
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    "TimUntersberger/neogit",
    init = function()
      require("core.utils").lazy_load "neogit"
    end,
  },
  {
    "gelguy/wilder.nvim",
    lazy = false,
    config = function()
      local wilder = require "wilder"
      wilder.setup {
        next_key = "<C-j>",
        accept_key = "<C-l>",
        reject_key = "<C-h>",
        previous_key = "<C-k>",
        modes = { ":", "/", "?" },
      }
      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_border_theme {
          pumblend = 20,
          border = "rounded",
          highlights = { border = "Normal" },
          highlighter = wilder.basic_highlighter(),
          left = { " ", wilder.popupmenu_devicons() },
        })
      )
    end,
  },
  -- {
  --   "mxsdev/nvim-dap-vscode-js",
  --   lazy = false,
  --   dependencies = {
  --     {"mfussenegger/nvim-dap"}
  --   }

  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   lazy = false,
  --   config = function()
  --     local dap = require "dap"

  --     dap.adapters.chrome = {
  --       type = "executable",
  --       command = "node",
  --       args = {os.getenv("HOME") .. "~/.config/nvim/lua/custom/vscode-chrome-debug-master/out/src/chromeDebug.js"} -- TODO adjust
  --       -- args = {os.getenv("HOME") .. "/path/to/vscode-chrome-debug/out/src/chromeDebug.js"} -- TODO adjust
  --   }
  --     dap.configurations.javascript = { -- change this to javascript if needed
  --         {
  --             type = "chrome",
  --             request = "attach",
  --             program = "${file}",
  --             cwd = vim.fn.getcwd(),
  --             sourceMaps = true,
  --             protocol = "inspector",
  --             port = 19000,
  --             webRoot = "${workspaceFolder}"
  --         }
  --     }
  --     dap.configurations.typescript = { -- change to typescript if needed
  --         {
  --             type = "chrome",
  --             request = "attach",
  --             program = "${file}",
  --             cwd = vim.fn.getcwd(),
  --             sourceMaps = true,
  --             protocol = "inspector",
  --             port = 19000,
  --             webRoot = "${workspaceFolder}"
  --         }
  --     }
  --   end,
  -- },
  -- {
  --   "folke/which-key.nvim",
  --   keys = { "<leader>", '"', "'", "`", "c", "v" },
  -- },
  {
    "CRAG666/code_runner.nvim",
    init = function()
      require("core.utils").lazy_load "code_runner.nvim"
    end,
    config = function()
      require("code_runner").setup {
        focus = false,
        filetype = {
          -- java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
          -- python = "python3 -u",
          typescript = "deno run",
          -- rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",
          -- dart = "dart $dir/$fileName",
          javascript = "node",
          sh = "bash",
          excluded_buftypes = { "message" },
        },
      }
    end,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    -- init = function()
    --   require("core.utils").lazy_load "vim-tmux-navigator"
    -- end,
  },
  {
    "szw/vim-maximizer",
    init = function()
      require("core.utils").lazy_load "vim-maximizer"
    end,
  },
  {
    "tpope/vim-surround",
    init = function()
      require("core.utils").lazy_load "vim-surround"
    end,
  },
  {
    "tpope/vim-repeat",
    init = function()
      require("core.utils").lazy_load "vim-repeat"
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        build = "make install_jsregexp",
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          check_ts = true, -- enable treesitter
          ts_config = {
            lua = { "string" }, -- don't add pairs in lua string treesitter nodes
            javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
            java = false, -- don't check treesitter on java
          },
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          local Rule = require "nvim-autopairs.rule"
          require("nvim-autopairs").setup(opts)
          require("nvim-autopairs").add_rules {
            Rule("%<c>$", "</>", { "typescript", "typescriptreact", "javascript", "javascriptreact" }):use_regex(true),
          }

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },
      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        -- "hrsh7th/cmp-cmdline",
        -- "amarakon/nvim-cmp-buffer-lines",
        "petertriho/cmp-git",
        "hrsh7th/cmp-emoji",
        "chrisgrieser/cmp-nerdfont",
        -- "jcha0713/cmp-tw2css",
      },
      -- {
      --   "tzachar/cmp-tabnine",
      --   build = "./install.sh",
      --   dependencies = "hrsh7th/nvim-cmp",
      --   config = function()
      --     local tabnine = require "cmp_tabnine.config"
      --     tabnine:setup {
      --       max_lines = 1000,
      --       max_num_results = 20,
      --       sort = true,
      --       run_on_every_keystroke = true,
      --       snippet_placeholder = "..",
      --       ignored_file_types = {
      --         -- default is not to ignore
      --         -- uncomment to ignore in lua:
      --         -- lua = true
      --       },
      --       show_prediction_strength = false,
      --     }
      --   end,
      -- },
      -- {
      --   "zbirenbaum/copilot-cmp",
      --   dependencies = "copilot.lua",
      --   config = function ()
      --     require("copilot_cmp").setup()
      --   end
      -- },
      -- {
      --   "zbirenbaum/copilot.lua",
      --   cmd = "Copilot",
      --   event = "InsertEnter",
      --   config = function()
      --     require("copilot").setup({})
      --   end,
      -- }
    },
    opts = function()
      return require "custom.configs.cmp"
    end,
  },
  {
    "RRethy/vim-illuminate",
    lazy = false,
    config = function()
      -- default configuration
      require("illuminate").configure {
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
          "lsp",
          "treesitter",
          "regex",
        },
        -- delay: delay in milliseconds
        delay = 0,
        -- filetype_overrides: filetype specific overrides.
        -- The keys are strings to represent the filetype while the values are tables that
        -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
        filetype_overrides = {},
        -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
        filetypes_denylist = {
          "dirvish",
          "fugitive",
        },
        -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
        filetypes_allowlist = {},
        -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
        -- See `:help mode()` for possible values
        modes_denylist = {},
        -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
        -- See `:help mode()` for possible values
        modes_allowlist = {},
        -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_denylist = {},
        -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
        -- Only applies to the 'regex' provider
        -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
        providers_regex_syntax_allowlist = {},
        -- under_cursor: whether or not to illuminate under the cursor
        under_cursor = true,
        -- large_file_cutoff: number of lines at which to use large_file_config
        -- The `under_cursor` option is disabled when this cutoff is hit
        large_file_cutoff = nil,
        -- large_file_config: config to use for large files (based on large_file_cutoff).
        -- Supports the same keys passed to .configure
        -- If nil, vim-illuminate will be disabled for large files.
        large_file_overrides = nil,
        -- min_count_to_highlight: minimum number of matches required to perform highlighting
        min_count_to_highlight = 1,
      }
      vim.cmd [[
            hi IlluminatedWordText guibg=#333333 guifg=none cterm=NONE blend=80 gui=none
            hi IlluminatedWordRead guibg=#333333 guifg=none cterm=NONE blend=80 gui=none
            hi IlluminatedWordWrite guibg=#333333 guifg=none cterm=NONE blend=80 gui=none
          ]]
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      signs = {
        add = { hl = "DiffAdd", text = "│", numhl = "GitSignsAddNr" },
        change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
        delete = { hl = "DiffDelete", text = "_", numhl = "GitSignsDeleteNr" },
        topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
        changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
        untracked = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      },
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
      numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
      linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
      word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
      watch_gitdir = {
        interval = 1000,
        follow_files = true,
      },
      attach_to_untracked = true,
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil, -- Use default
      max_file_length = 40000, -- Disable if file is longer than this (in lines)
      preview_config = {
        -- Options passed to nvim_open_win
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
      yadm = {
        enable = false,
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = "   ",
        -- path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = require("telescope.actions").move_selection_previous, -- move to prev result
            ["<C-j>"] = require("telescope.actions").move_selection_next, -- move to next result
            ["<C-q>"] = require("telescope.actions").close,
          },
        },
      },
      extensions_list = {
        "themes",
        "terms",
        "fzf",
        "media_files",
        "file_browser",
        "http",
        "frecency",
        "tailiscope",
        "neoclip",
        "emoji",
        "gitmoji",
        "glyph",
        media_files = {
          -- filetypes whitelist
          -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
          filetypes = { "png", "webp", "jpg", "jpeg", "mp4", "webm", "pdf" },
          -- find command (defaults to `fd`)
          find_cmd = "rg",
        },
        -- file_browser = {
        --   theme = "ivy",
        --   -- disables netrw and use telescope-file-browser in its place
        --   hijack_netrw = true,
        --   mappings = {
        --     ["i"] = {
        --       -- your custom insert mode mappings
        --     },
        --     ["n"] = {
        --       -- your custom normal mode mappings
        --     },
        --   }
        -- }
      },
    },
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        "nvim-telescope/telescope-media-files.nvim",
        dependencies = {
          "nvim-lua/popup.nvim",
          "nvim-lua/plenary.nvim",
        },
      },
      {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "barrett-ruth/telescope-http.nvim",
      },
      {
        "nvim-telescope/telescope-frecency.nvim",
        dependencies = { "kkharji/sqlite.lua" },
      },
      {
        "AckslD/nvim-neoclip.lua",
        dependencies = {
          { "kkharji/sqlite.lua", module = "sqlite" },
        },
        config = function()
          require("neoclip").setup {
            -- history = 1000,
            enable_persistent_history = true,
            default_register = '"',
            on_select = {
              move_to_front = true,
              close_telescope = true,
            },
            on_paste = {
              set_reg = true,
              move_to_front = true,
              close_telescope = true,
            },
            keys = {
              telescope = {
                i = {
                  -- select = '<cr>',
                  -- paste = '<c-p>',
                  paste_behind = "<c-P>",
                  -- replay = '<c-q>',  -- replay a macro
                  -- delete = '<c-d>',  -- delete an entry
                  -- edit = '<c-e>',  -- edit an entry
                  -- custom = {},
                },
              },
            },
          }
        end,
      },
      {
        "danielvolchek/tailiscope.nvim",
        "xiyaowong/telescope-emoji.nvim",
        "olacin/telescope-gitmoji.nvim",
        "ghassan0/telescope-glyph.nvim",
      },
    },
  },
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {
        {
          position = "bottom", -- position of the list can be: bottom, top, left, right
          height = 10, -- height of the trouble list when position is top or bottom
          width = 50, -- width of the list when position is left or right
          icons = true, -- use devicons for filenames
          mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
          fold_open = "", -- icon used for open folds
          fold_closed = "", -- icon used for closed folds
          group = true, -- group results by file
          padding = true, -- add an extra new line on top of the list
          action_keys = {
            -- key mappings for actions in the trouble list
            -- map to {} to remove a mapping, for example:
            -- close = {},
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
            open_split = { "<c-x>" }, -- open buffer in new split
            open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
            open_tab = { "<c-t>" }, -- open buffer in new tab
            jump_close = { "o" }, -- jump to the diagnostic and close the list
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small popup with the full multiline message
            preview = "p", -- preview the diagnostic location
            close_folds = { "zM", "zm" }, -- close all folds
            open_folds = { "zR", "zr" }, -- open all folds
            toggle_fold = { "zA", "za" }, -- toggle fold of current file
            previous = "k", -- previous item
            next = "j", -- next item
          },
          indent_lines = true, -- add an indent guide below the fold icons
          auto_open = false, -- automatically open the list when you have diagnostics
          auto_close = false, -- automatically close the list when you have no diagnostics
          auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
          auto_fold = false, -- automatically fold a file trouble list at creation
          auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
          signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠",
          },
          use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
        },
      }
    end,
  },
  {
    "barrett-ruth/import-cost.nvim",
    lazy = false,
    build = "sh install.sh yarn",
    config = function()
      require("import-cost").setup()
    end,
  },
  {
    "mg979/vim-visual-multi",
    lazy = false,
    -- config = function()
    --   require('mc').setup()
    -- end
  },
  {
    "ggandor/leap.nvim",
    lazy = false,
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").add_default_mappings()

      -- The below settings make Leap's highlighting closer to what you've been
      -- used to in Lightspeed.
      vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" }) -- or some grey
      vim.api.nvim_set_hl(0, "LeapMatch", {
        -- For light themes, set to 'black' or similar.
        fg = "white",
        bold = true,
        nocombine = true,
      })
      -- Of course, specify some nicer shades instead of the default "red" and "blue".
      vim.api.nvim_set_hl(0, "LeapLabelPrimary", {
        fg = "red",
        bold = true,
        nocombine = true,
      })
      vim.api.nvim_set_hl(0, "LeapLabelSecondary", {
        fg = "blue",
        bold = true,
        nocombine = true,
      })
      -- Try it without this setting first, you might find you don't even miss it.
      require("leap").opts.highlight_unlabeled_phase_one_targets = true
    end,
  },
  {
    "petertriho/nvim-scrollbar",
    lazy = false,
    dependencies = {
      "kevinhwang91/nvim-hlslens",
      "lewis6991/gitsigns.nvim",
      "folke/tokyonight.nvim",
    },
    config = function()
      require("scrollbar.handlers.search").setup {
        override_lens = function() end,
      }
      local colors = require("tokyonight.colors").setup()
      -- require('gitsigns').setup()
      -- require("scrollbar.handlers.gitsigns").setup()
      require("scrollbar").setup {
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
        max_lines = false, -- disables if no. of lines in buffer exceeds this
        hide_if_all_visible = true, -- Hides everything if all lines are visible
        throttle_ms = 100,
        handle = {
          text = " ",
          blend = 30, -- Integer between 0 and 100. 0 for fully opaque and 100 to full transparent. Defaults to 30.
          color = colors.bg_highlight,
          color_nr = nil, -- cterm
          highlight = "CursorColumn",
          hide_if_all_visible = true, -- Hides handle if all lines are visible
        },
        marks = {
          Cursor = {
            text = "•",
            priority = 0,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "Normal",
          },
          Search = {
            text = { "-", "=" },
            priority = 1,
            gui = nil,
            color = colors.orange,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "Search",
          },
          Error = {
            text = { "-", "=" },
            priority = 2,
            gui = nil,
            color = colors.error,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "DiagnosticVirtualTextError",
          },
          Warn = {
            text = { "-", "=" },
            priority = 3,
            gui = nil,
            color = colors.warning,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "DiagnosticVirtualTextWarn",
          },
          Info = {
            text = { "-", "=" },
            priority = 4,
            gui = nil,
            color = colors.info,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "DiagnosticVirtualTextInfo",
          },
          Hint = {
            text = { "-", "=" },
            priority = 5,
            gui = nil,
            color = colors.hint,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "DiagnosticVirtualTextHint",
          },
          Misc = {
            text = { "-", "=" },
            priority = 6,
            gui = nil,
            color = colors.purple,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "Normal",
          },
          GitAdd = {
            text = "┆",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "GitSignsAdd",
          },
          GitChange = {
            text = "┆",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "GitSignsChange",
          },
          GitDelete = {
            text = "▁",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil, -- cterm
            highlight = "GitSignsDelete",
          },
        },
        excluded_buftypes = {
          "terminal",
        },
        excluded_filetypes = {
          "prompt",
          "TelescopePrompt",
          "noice",
        },
        autocmd = {
          render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
          },
          clear = {
            "BufWinLeave",
            "TabLeave",
            "TermLeave",
            "WinLeave",
          },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = false, -- Requires gitsigns
          handle = true,
          search = true, -- Requires hlslens
          ale = false, -- Requires ALE
        },
      }
    end,
  },
  {
    "simrat39/symbols-outline.nvim",
    lazy = false,
    opts = {
      highlight_hovered_item = true,
      show_guides = true,
      auto_preview = false,
      position = "right",
      relative_width = true,
      width = 25,
      auto_close = false,
      show_numbers = false,
      show_relative_numbers = false,
      show_symbol_details = true,
      preview_bg_highlight = "Pmenu",
      autofold_depth = nil,
      auto_unfold_hover = true,
      fold_markers = { "", "" },
      wrap = false,
      keymaps = {
        -- These keymaps can be a string or a table for multiple keys
        close = { "<Esc>", "q" },
        goto_location = "<Cr>",
        focus_location = "o",
        hover_symbol = "<C-space>",
        toggle_preview = "K",
        rename_symbol = "r",
        code_actions = "a",
        fold = "h",
        unfold = "l",
        fold_all = "W",
        unfold_all = "E",
        fold_reset = "R",
      },
      lsp_blacklist = {},
      symbol_blacklist = {},
      symbols = {
        File = { icon = "", hl = "@text.uri" },
        Module = { icon = "", hl = "@namespace" },
        Namespace = { icon = "", hl = "@namespace" },
        Package = { icon = "", hl = "@namespace" },
        Class = { icon = "𝓒", hl = "@type" },
        Method = { icon = "ƒ", hl = "@method" },
        Property = { icon = "", hl = "@method" },
        Field = { icon = "", hl = "@field" },
        Constructor = { icon = "", hl = "@constructor" },
        Enum = { icon = "ℰ", hl = "@type" },
        Interface = { icon = "ﰮ", hl = "@type" },
        Function = { icon = "", hl = "@function" },
        Variable = { icon = "", hl = "@constant" },
        Constant = { icon = "", hl = "@constant" },
        String = { icon = "𝓐", hl = "@string" },
        Number = { icon = "#", hl = "@number" },
        Boolean = { icon = "⊨", hl = "@boolean" },
        Array = { icon = "", hl = "@constant" },
        Object = { icon = "⦿", hl = "@type" },
        Key = { icon = "🔐", hl = "@type" },
        Null = { icon = "NULL", hl = "@type" },
        EnumMember = { icon = "", hl = "@field" },
        Struct = { icon = "𝓢", hl = "@type" },
        Event = { icon = "🗲", hl = "@type" },
        Operator = { icon = "+", hl = "@operator" },
        TypeParameter = { icon = "𝙏", hl = "@parameter" },
        Component = { icon = "", hl = "@function" },
        Fragment = { icon = "", hl = "@constant" },
      },
    },
    config = function(_, opts)
      require("symbols-outline").setup(opts)
    end,
  },
  {
    "karb94/neoscroll.nvim",
    lazy = false,
    config = function()
      require("neoscroll").setup {
        -- All these keys will be mapped to their corresponding default scrolling animation
        mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
        hide_cursor = true, -- Hide cursor while scrolling
        stop_eof = true, -- Stop at <EOF> when scrolling downwards
        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
        easing_function = nil, -- Default easing function
        pre_hook = nil, -- Function to run before the scrolling animation starts
        post_hook = nil, -- Function to run after the scrolling animation ends
        performance_mode = false, -- Disable "Performance Mode" on all buffers.
      }
    end,
  },
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    config = function()
      require("Comment").setup {
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
  {
    "AndrewRadev/tagalong.vim",
    lazy = false,
  },
}

return plugins
