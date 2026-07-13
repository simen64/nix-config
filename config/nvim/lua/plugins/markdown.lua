return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = false,
  },
  {
    "snacks.nvim",
    opts = function(_, opts)
      opts.scope = opts.scope or {}
      local scope_filter = opts.scope.filter
      opts.scope.filter = function(buf)
        if vim.bo[buf].filetype == "markdown" then
          return false
        end
        return scope_filter and scope_filter(buf) or true
      end

      opts.indent = opts.indent or {}
      local indent_filter = opts.indent.filter
      opts.indent.filter = function(buf)
        if vim.bo[buf].filetype == "markdown" then
          return false
        end
        return indent_filter and indent_filter(buf) or true
      end
    end,
  },
}
