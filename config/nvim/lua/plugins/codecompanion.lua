return {
  {
    "olimorris/codecompanion.nvim",
    opts = {
      strategies = {
        chat = {
          adapter = "openai",
          model = "gpt-5",
        },
        inline = {
          adapter = "openai",
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}
