local M = {}
M.treesitter = {
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  ensure_installed = {
    "json",
    "javascript",
    "typescript",
    "tsx",
    "yaml",
    "html",
    "css",
    "svelte",
    "graphql",
    "bash",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "dockerfile",
    "gitignore",
    "c",
    "c_sharp",
    "dart",
    "gitcommit",
    "http",
    "java",
    "kotlin",
    "markdown",
    "markdown_inline",
    "php",
    "regex",
    "scala",
    "scheme",
    "scss",
    "slint",
    "sql",
    "swift",
    "toml",
    "vue",
  },
  indent = {
    enable = true,
    -- disable = {
    --   "python"
    -- },
  },
  auto_install = true,
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  -- enable autotagging (w/ nvim-ts-autotag plugin)
  autotag = {
    enable = true,
    filetypes = {
      "html",
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
      "svelte",
      "vue",
      "tsx",
      "jsx",
      "rescript",
      "css",
      "lua",
      "xml",
      "php",
      "markdown",
    },
  },
  rainbow = {
    enable = true,
    -- list of languages you want to disable the plugin for
    -- disable = { 'jsx', 'cpp' },
    -- Which query to use for finding delimiters
    query = {
      "rainbow-parens",
      -- "rainbow-tags-react",
      html = "rainbow-tags",
      javascript = "rainbow-parens",
      jsx = "rainbow-parens",
      tsx = "rainbow-parens",
      -- javascript = "rainbow-parens-react",
      -- jsx = "rainbow-parens-react",
      -- tsx = "rainbow-parens-react",
      latex = "rainbow-blocks",
    },
    -- Highlight the entire buffer all at once
    -- strategy = require("ts-rainbow").strategy.global,
    hlgroups = {
      "TSRainbowYellow",
      "TSRainbowBlue",
      "TSRainbowOrange",
      "TSRainbowGreen",
      "TSRainbowViolet",
      "TSRainbowCyan",
      "TSRainbowRed",
    },
    --------------nvim-ts-rainbow1-----------
    extended_mode = true,
    colors = {
      "#E06C75",
      "#E5C07B",
      "#00AA5E",
      "#0D94F6",
      "#FF5ED4",
      "#8232D0",
    },
    -- colors = {
    --   "#E06C75",
    --   "#E5C07B",
    --   "#98C379",
    --   "#56B6C2",
    --   "#61AFEF",
    --   "#C678DD",
    --   "#E06C75",
    -- },
  },
}
M.mason = {
  ensure_installed = {
    -- lua stuff
    -- "lua-language-server",
    -- "stylua",

    -- web dev stuff
    -- "css-lsp",
    -- "html-lsp",
    -- "typescript-language-server",
    -- "deno",
    -- "prettier"
    ------------move all to mason-lsp---------------
  },
}

return M
