local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")

-- Enable project-specific configuration files
vim.o.exrc = true

-- Enable security for local .nvim.lua files (recommended)
vim.o.secure = true

-- always yank to osc52
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})
-- cindent > smartindent
vim.o.smartindent = false
vim.o.cindent = false
-- basic indentation copying
vim.o.autoindent = true -- optional: keep this if you still want consistent indent on new lines

-- LSP
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration)
vim.keymap.set('n', 'gd', vim.lsp.buf.declaration)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename)
vim.keymap.set('n', '<leader>fx', vim.lsp.buf.code_action)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)

-- Python
vim.lsp.enable('basedpyright')
vim.lsp.enable('ruff')

-- verilog
vim.lsp.config('verible', {
  cmd = { 'verible-verilog-ls',
    '--assignment_statement_alignment=align',
    '--case_items_alignment=align',
    '--class_member_variable_alignment=align',
    '--distribution_items_alignment=align',
    '--enum_assignment_statement_alignment=align',
    '--formal_parameters_alignment=align',
    '--module_net_variable_alignment=align',
    '--named_parameter_alignment=align',
    '--named_port_alignment=align',
    '--port_declarations_alignment=align',
    '--struct_union_members_alignment=align',
    '--align_across_blank_lines=true',
    '--compact_packed_dimensions=true',
  },
  filetypes = { 'systemverilog', 'verilog' },
  root_markers = { '.git' },
})
vim.lsp.enable('verible')

vim.lsp.config('jsonls', {
  -- Disable jsonls formatting, let null-ls handle it
  init_options = { provideFormatter = false },
})
vim.lsp.enable("jsonls")

vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
