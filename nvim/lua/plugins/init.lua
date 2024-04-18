return {
  -- make this load before all other plugins
  { "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = { palettes = { all = { bg1 = "#0e0e17", } } },
    config = function(_, opts)
      require("nightfox").setup(opts)
      vim.cmd([[colorscheme duskfox]])
    end
  },
  { "tpope/vim-fugitive" },
  { "godlygeek/tabular" },
  { "duane9/nvim-rg" },
  { "lewis6991/gitsigns.nvim" },
  { "nvim-telescope/telescope.nvim" },
  { "ojroques/nvim-osc52" },
}
