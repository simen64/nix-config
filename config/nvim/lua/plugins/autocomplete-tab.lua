-- lua/plugins/tab-autocomplete.lua
return {
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.keymap = {
        preset = "super-tab",
        ["<Tab>"] = { "select_and_accept", "fallback" },
        ["<S-Tab>"] = { "select_next", "fallback" },
        ["C-j"] = { "select_next", "fallback" },
        ["C-k"] = { "select_prev", "fallback" },
      }
    end,
  },
}
