-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

-- Open a vertical terminal on the right and run a command
map("n", "<leader>cq", function()
  vim.cmd("vsplit") -- vertical split
  vim.cmd("wincmd l") -- move to the new split (right pane)
  vim.cmd("terminal qwen") -- replace 'htop' with your command
end, {
  noremap = true,
  silent = true,
  desc = "Open qwen code('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })",
})

map("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })
