local wk = require("which-key")
local utils = require("utils")

wk.register({
  b = {
    name = "+buffer",
    d = { function() utils.delete_other_buffers() end, "Delete other buffers" },
  },
}, { prefix = "<leader>" })