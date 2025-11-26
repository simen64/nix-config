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
            min_keyword_length = 2,  -- Reduced to allow shorter completions
            score_offset = 4,        -- Increased priority for LSP completions
          },
          path = {
            min_keyword_length = 3,
            score_offset = 2,
          },
          buffer = {
            min_keyword_length = 3,  -- Reduced for better local variable matching
            score_offset = 2,        -- Increased to match path
          },
        },
        per_filetype = {
          codecompanion = { "codecompanion" },
        },
      },
      -- Improve relevance sorting to better prioritize variables
      sorting = {
        comparators = {
          "score",
          "recently_used",
          "kind",
          "length",
          "offset",
        },
      },
    },
  },
}
