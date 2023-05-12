---@type ChadrcConfig
local M = {}

------------ My custom ----------------
local g = vim.g
local opt = vim.opt
-- :help options
opt.relativenumber = true
opt.wrap = true
vim.wo.wrap = false --word wrap
opt.iskeyword:append "-"

-- vim.api.nvim_set_keymap('i', '<c-j>', 'pumvisible() ? "\\<c-n>" : "\\<c-j>"' , { noremap = true, expr=true })
-- vim.api.nvim_set_keymap('i', '<c-k>', 'pumvisible() ? "\\<c-p>" : "\\<c-j>"' , { noremap = true, expr=true })

if g.neovide then
  vim.o.guifont = "FiraCode Nerd Font:h12:l"
  g.neovide_refresh_rate = 60
  g.neovide_refresh_rate_idle = 5
  g.neovide_confirm_quit = true
  g.neovide_remember_window_size = true
  g.neovide_remember_dimensions = true
  -- g.neovide_underline_automatic_scaling = true
  -- g.neovide_transparency=0.8
  g.neovide_cursor_animation_length = 0.1
  g.neovide_cursor_trail_size = 0.8
  -- g.neovide_cursor_trail_length=0.00
  g.neovide_cursor_vfx_mode = "" ---- torpedo | railgun | pixiedust | sonicboom | ripple | wireframe
  g.neovide_cursor_animate_command_line = true
  -- g.neovide_cursor_vfx_particle_phase=1.5
  -- g.neovide_cursor_vfx_particle_curl=1.0
  -- g.neovide_cursor_vfx_opacity = 200.0
  -- g.neovide_cursor_vfx_particle_lifetime = 1.2
  -- g.neovide_cursor_vfx_particle_density = 7.0
  -- g.neovide_cursor_vfx_particle_speed = 10.0
  -- g.neovide_cursor_vfx_particle_phase = 1.5 (for railgun)
  -- g.neovide_cursor_vfx_particle_curl = 1.0 (for railgun)
  -- g.neovide_profiler = true;
  g.neovide_scroll_animation_length = 0.3
  -- Helper function for transparency formatting
  local alpha = function()
    return string.format("%x", math.floor(255 * g.transparency or 0.8))
  end
  ------------------BG color------------------
  -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
  g.neovide_transparency = 0
  g.transparency = 0.8
  g.neovide_background_color = "#0f1117" .. alpha()
  -------------Floating Blur Amount-----------------------
  -- g.neovide_floating_blur_amount_x = 2.0
  -- g.neovide_floating_blur_amount_y = 2.0
end

-- Rememeber last editing position.
local api = vim.api
api.nvim_create_autocmd({ "BufRead", "BufReadPost" }, {
  callback = function()
    local row, column = unpack(api.nvim_buf_get_mark(0, '"'))
    local buf_line_count = api.nvim_buf_line_count(0)

    if row >= 1 and row <= buf_line_count then
      api.nvim_win_set_cursor(0, { row, column })
    end
  end,
})

-- LSP diagnostics tweaks
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = true,
})

------------------------------------------------------------

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"
M.ui = {
  theme = "tokyonight",
  theme_toggle = { "tokyonight", "one_light" },
  transparency = true,
  hl_override = highlights.override,
  hl_add = highlights.add,
  statusline = {
    theme = "default",
  },
}
M.plugins = "custom.plugins"
-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
