-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

-- Open a vertical terminal on the right and run a command
map("n", "<leader>cq", function()
  vim.cmd("vsplit") -- vertical split
  vim.cmd("wincmd l") -- move to the new split (right pane)
  vim.cmd("terminal copilot") -- replace 'htop' with your command
end, {
  noremap = true,
  silent = true,
  desc = "Open copilot('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })",
})

map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Which-key register for deleting other buffers
local wk = require("which-key")
local utils = require("utils")
wk.register({
  b = {
    name = "+buffer",
    d = { function() utils.delete_other_buffers() end, "Delete other buffers" },
  },
}, { prefix = "<leader>" })