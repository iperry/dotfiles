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
        -- Prettier for JSON
        none_ls.builtins.formatting.prettier.with({
          filetypes = { "json", "jsonc" }, -- jsonc = JSON with comments
          extra_args = {
            "--parser", "json",
            "--tab-width", "2",          -- optional, adjust to your style
            "--use-tabs", "false",       -- optional, false = spaces
            "--print-width", "80",       -- optional, wrap lines at 80 chars
          },
        }),
      },
    })
  end,
}
