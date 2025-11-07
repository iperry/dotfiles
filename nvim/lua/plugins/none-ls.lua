return {
  "nvimtools/none-ls.nvim",
  config = function()
    local none_ls = require("null-ls")
    none_ls.setup({
      sources = {
        none_ls.builtins.formatting.prettier.with({
          filetypes = { "markdown" },
          extra_args = { "--prose-wrap", "always" },
        }),
      },
    })
  end,
}
