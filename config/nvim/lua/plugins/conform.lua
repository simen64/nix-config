return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      nix = { "alejandra" },
      terraform = { "terraform_fmt" },
      ["terraform-vars"] = { "terraform_fmt" },
      hcl = { "terraform_fmt" },
    },
  },
}
