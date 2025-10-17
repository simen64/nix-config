return {
  "barrett-ruth/live-server.nvim",
  build = "npm i -g live-server",
  cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
  config = true,
  keys = {
    -- open http://localhost:5555/ jika menggunakan wsl
    { "<leader>cz", "<cmd>LiveServerStart<cr>", desc = "LiveServerStart" },
    { "<leader>cx", "<cmd>LiveServerStop<cr>", desc = "LiveServerStop" },
  },
}
