return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Associate .rdl files with systemrdl filetype
      vim.filetype.add({
        extension = {
          rdl = "systemrdl",
        },
      })

      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end,
  },
  {
    "SystemRDL/tree-sitter-systemrdl",
    build = "npm install && cc -shared -fPIC -O2 src/parser.c -I src -o " ..
      vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/parser/systemrdl.so",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
}
