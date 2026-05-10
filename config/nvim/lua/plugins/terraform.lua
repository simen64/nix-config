return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        terraformls = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "terraform", "hcl" },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "terraform-ls" },
    },
  },
}
