return {
  "nvimtools/none-ls.nvim",
  config = function()
    local none_ls = require("null-ls")
    local h = require("null-ls.helpers")

    local tclfmt = {
      name = "tclfmt",
      method = none_ls.methods.FORMATTING,
      filetypes = { "tcl" },
      generator = h.formatter_factory({
        command = "tclfmt",
        args = { "-" },
        to_stdin = true,
      }),
    }

    none_ls.setup({
      sources = {
        none_ls.builtins.formatting.prettier.with({
          filetypes = { "markdown", "yaml" },
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
        none_ls.builtins.formatting.nixfmt,
        tclfmt,
      },
    })
  end,
}
