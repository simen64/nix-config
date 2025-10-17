return {
  {
    "saghen/blink.cmp",
    opts = {
      snippets = { preset = "luasnip" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          snippets = {
            min_keyword_length = 1,
            score_offset = 5,
          },
          lsp = {
            min_keyword_length = 3,
            score_offset = 3,
          },
          path = {
            min_keyword_length = 3,
            score_offset = 2,
          },
          buffer = {
            min_keyword_length = 5,
            score_offset = 1,
          },
        },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
    },
  },
}
