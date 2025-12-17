-- Lazygit
return {
  -- make this load before all other plugins
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    opts = { palettes = { all = { bg1 = "#0e0e17", } } },
    config = function(_, opts)
      require("nightfox").setup(opts)
      vim.cmd([[colorscheme duskfox]])
    end
  },
  { "tpope/vim-fugitive" },
  { "chrisbra/vim-diff-enhanced" },
  { "godlygeek/tabular" },
  { "duane9/nvim-rg" },
  { "ojroques/nvim-osc52" },
  { "lambdalisue/vim-suda" },
  { "neovim/nvim-lspconfig" },
  {
    "junegunn/vim-easy-align",
    init = function()
      vim.g.easy_align_delimiters = {
        ["\\"] = { pattern = "\\\\$" },
      }
    end,
    keys = {
      { "ga",          "<Plug>(EasyAlign)",          mode = { "n", "x" }, desc = "EasyAlign" },
      { "<leader>a|",  "<Plug>(EasyAlign)ip*|",      mode = { "n" },      desc = "Align on |" },
      { "<leader>a|",  ":EasyAlign *|<CR>",          mode = { "v" },      desc = "Align on |" },
      { "<leader>a\\", "<Plug>(EasyAlign)ip*\\<CR>", mode = { "n" },      desc = "Align on \\" },
      { "<leader>a\\", ":EasyAlign *\\<CR>",         mode = { "x" },      desc = "Align on \\" },
    }
  },
}
