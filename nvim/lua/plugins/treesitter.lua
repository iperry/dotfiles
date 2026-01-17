return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = { "c", "cpp", "rust", "markdown", "markdown_inline", "lua", "vim", "vimdoc" },
    })
  end,
}
