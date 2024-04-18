return {
  "neovim/nvim-lspconfig",

  event = { "BufReadPre", "BufNewFile" },

  dependencies = {
    "williamboman/mason.nvim",
  },

  config = function()
    local lspconfig = require("lspconfig")
    local mason = require("mason")

    mason.setup()

    lspconfig.rust_analyzer.setup({})
    lspconfig.clangd.setup({
      root_dir = lspconfig.util.root_pattern(
        'compile_commands.json',
        'build/compile_commands.json')
    })
    lspconfig.pyright.setup({})
  end,

  keys = {
    { 'gD', vim.lsp.buf.declaration },
    { 'gd', vim.lsp.buf.definition },
    { 'K', vim.lsp.buf.hover },
    { 'gi', vim.lsp.buf.implementation },
    { '<C-k>', vim.lsp.buf.signature_help },
    { '<space>wa', vim.lsp.buf.add_workspace_folder },
    { '<space>wr', vim.lsp.buf.remove_workspace_folder },
    { '<space>D', vim.lsp.buf.type_definition },
    { '<space>rn', vim.lsp.buf.rename },
    { '<leader>fx', vim.lsp.buf.code_action, { 'n', 'v' }},
    { 'gr', vim.lsp.buf.references },
    { '<leader>cf', function() vim.lsp.buf.format({ async = true }) end }
  }
}
