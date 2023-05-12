local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-----------------------------------my custom----------------------------
-- open nvim-tree on setup
local function open_nvim_tree(data)
    -- buffer is a real file on the disk
    local real_file = vim.fn.filereadable(data.file) == 1
    -- buffer is a [No Name]
    local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
    -- buffer is a directory
    local directory = vim.fn.isdirectory(data.file) == 1
    if not real_file and not no_name and not directory  then
      return
    end
    if directory then
      vim.cmd.cd(data.file)
    end
    -- open the tree, find the file but don't focus it
    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end
autocmd({ "VimEnter" }, { callback = open_nvim_tree })
  
-- Auto Close
-- vim.api.nvim_create_autocmd({"QuitPre"}, {
--     callback = function() vim.cmd("NvimTreeClose") end,
-- })
autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
    pattern = "NvimTree_*",
    callback = function()
      local layout = vim.api.nvim_call_function("winlayout", {})
      if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
    end
  })
-------------------

