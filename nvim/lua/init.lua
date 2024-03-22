require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = { "c", "cpp", "rust", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = { },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}

require("neorg").setup {
  -- configuration here
  load = {
    ["core.defaults"] = {},
    ["core.concealer"] = {},
    ["core.dirman"] = {
      config = {
        workspaces = {
          work = "~/transwarp/notes/work",
          home = "~/transwarp/notes/home",
        }
      }
    }
  }
}

-- Setup nvim-cmp.
local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Default mappings. Feel free to modify or remove as you wish.
  --
  -- BEGIN_DEFAULT_ON_ATTACH
  vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
  vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
  vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
  vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
  vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
  vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
  vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
  vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
  vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
  vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
  vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
  vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
  vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
  vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
  vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
  vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
  vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
  vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
  vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
  vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
  vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
  vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
  vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
  vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
  vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
  vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
  vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
  vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
  vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
  vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
  vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
  vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
  vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
  vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
  vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
  vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
  vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
  vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
  vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
  vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
  vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
  vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
  vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
  vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
  vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
  vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
  -- END_DEFAULT_ON_ATTACH

  -- Mappings migrated from view.mappings.list
  --
  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 'o', api.node.open.no_window_picker, opts('Open: No Window Picker'))
end

local lspconfig = require('lspconfig')
require'lspconfig'.clangd.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = lspconfig.util.root_pattern(
          'compile_commands.json',
          'build/compile_commands.json')
}

require('lspconfig').rust_analyzer.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

require('lspconfig').jedi_language_server.setup{
  single_file_support = False
}

require('gitsigns').setup()

local palettes = {
  all = {
    bg1 = "#0e0e17",
  },
}
require("nightfox").setup({ palettes = palettes })

vim.cmd[[colorscheme duskfox]]

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup({
 on_attach = on_attach
})

require'nvim-web-devicons'.setup {
 -- globally enable different highlight colors per icon (default to true)
 -- if set to false all icons will have the default icon's color
 color_icons = true;
 -- globally enable default icons (default to false)
 -- will get overriden by `get_icons` option
 default = true;
}

-- require('feline').setup()
-- require('feline').winbar.setup()
-- Feline
-- https://github.com/EdenEast/nightfox.nvim/blob/main/mics/feline.lua
--
-- This file is a complete example of creating the feline configuration shown in the readme of
-- nightfox. This configuration generates its own highlight groups from the currently applied
-- colorscheme. These highlight groups are regenreated on colorscheme changes.
--
-- Required plugins:
--    - `feline-nvim/feline.nvim`
--    - `kyazdani42/nvim-web-devicons`
--
-- This file is required to be in your `lua` folder of your config.  Your colorscheme should also
-- be applied before this file is sourced. This file cannot be located `lua/feline.lua` as this
-- would clash with the actual plugin require path.
--
-- # Example:
--
-- ```lua
-- vim.cmd("colorscheme nightfox")
-- require('user.ui.feline')
-- ```
--
-- This assumes that this file is located at `lua/user/ui/feline.lua`

local fmt = string.format

----------------------------------------------------------------------------------------------------
-- Colors

---Convert color number to hex string
---@param n number
---@return string
local hex = function(n)
  if n then
    return fmt("#%06x", n)
  end
end

---Parse `style` string into nvim_set_hl options
---@param style string
---@return table
local function parse_style(style)
  if not style or style == "NONE" then
    return {}
  end

  local result = {}
  for token in string.gmatch(style, "([^,]+)") do
    result[token] = true
  end

  return result
end

---Get highlight opts for a given highlight group name
---@param name string
---@return table
local function get_highlight(name)
  local hl = vim.api.nvim_get_hl_by_name(name, true)
  if hl.link then
    return get_highlight(hl.link)
  end

  local result = parse_style(hl.style)
  result.fg = hl.foreground and hex(hl.foreground)
  result.bg = hl.background and hex(hl.background)
  result.sp = hl.special and hex(hl.special)

  return result
end

---Set highlight group from provided table
---@param groups table
local function set_highlights(groups)
  for group, opts in pairs(groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

---Generate a color palette from the current applied colorscheme
---@return table
local function generate_pallet_from_colorscheme()
  -- stylua: ignore
  local color_map = {
    black   = { index = 0, default = "#393b44" },
    red     = { index = 1, default = "#c94f6d" },
    green   = { index = 2, default = "#81b29a" },
    yellow  = { index = 3, default = "#dbc074" },
    blue    = { index = 4, default = "#719cd6" },
    magenta = { index = 5, default = "#9d79d6" },
    cyan    = { index = 6, default = "#63cdcf" },
    white   = { index = 7, default = "#dfdfe0" },
  }

  local diagnostic_map = {
    hint = { hl = "DiagnosticHint", default = color_map.green.default },
    info = { hl = "DiagnosticInfo", default = color_map.blue.default },
    warn = { hl = "DiagnosticWarn", default = color_map.yellow.default },
    error = { hl = "DiagnosticError", default = color_map.red.default },
  }

  local pallet = {}
  for name, value in pairs(color_map) do
    local global_name = "terminal_color_" .. value.index
    pallet[name] = vim.g[global_name] and vim.g[global_name] or value.default
  end

  for name, value in pairs(diagnostic_map) do
    pallet[name] = get_highlight(value.hl).fg or value.default
  end

  pallet.sl = get_highlight("StatusLine")
  pallet.sel = get_highlight("TabLineSel")

  return pallet
end

---Generate user highlight groups based on the curent applied colorscheme
---
---NOTE: This is a global because I dont known where this file will be in your config
---and it is needed for the autocmd below
_G._generate_user_statusline_highlights = function()
  local pal = generate_pallet_from_colorscheme()

  -- stylua: ignore
  local sl_colors = {
    Black   = { fg = pal.black,   bg = pal.white },
    Red     = { fg = pal.red,     bg = pal.sl.bg },
    Green   = { fg = pal.green,   bg = pal.sl.bg },
    Yellow  = { fg = pal.yellow,  bg = pal.sl.bg },
    Blue    = { fg = pal.blue,    bg = pal.sl.bg },
    Magenta = { fg = pal.magenta, bg = pal.sl.bg },
    Cyan    = { fg = pal.cyan,    bg = pal.sl.bg },
    White   = { fg = pal.white,   bg = pal.black },
  }

  local colors = {}
  for name, value in pairs(sl_colors) do
    colors["User" .. name] = { fg = value.fg, bg = value.bg, bold = true }
    colors["UserRv" .. name] = { fg = value.bg, bg = value.fg, bold = true }
  end

  local status = vim.o.background == "dark" and { fg = pal.black, bg = pal.white } or { fg = pal.white, bg = pal.black }

  local groups = {
    -- statusline
    UserSLHint = { fg = pal.sl.bg, bg = pal.hint, bold = true },
    UserSLInfo = { fg = pal.sl.bg, bg = pal.info, bold = true },
    UserSLWarn = { fg = pal.sl.bg, bg = pal.warn, bold = true },
    UserSLError = { fg = pal.sl.bg, bg = pal.error, bold = true },
    UserSLStatus = { fg = status.fg, bg = status.bg, bold = true },

    UserSLFtHint = { fg = pal.sel.bg, bg = pal.hint },
    UserSLHintInfo = { fg = pal.hint, bg = pal.info },
    UserSLInfoWarn = { fg = pal.info, bg = pal.warn },
    UserSLWarnError = { fg = pal.warn, bg = pal.error },
    UserSLErrorStatus = { fg = pal.error, bg = status.bg },
    UserSLStatusBg = { fg = status.bg, bg = pal.sl.bg },

    UserSLAlt = pal.sel,
    UserSLAltSep = { fg = pal.sl.bg, bg = pal.sel.bg },
    UserSLGitBranch = { fg = pal.yellow, bg = pal.sl.bg },
  }

  set_highlights(vim.tbl_extend("force", colors, groups))
end

_generate_user_statusline_highlights()

vim.api.nvim_create_augroup("UserStatuslineHighlightGroups", { clear = true })
vim.api.nvim_create_autocmd({ "SessionLoadPost", "ColorScheme" }, {
  callback = function()
    _generate_user_statusline_highlights()
  end,
})

----------------------------------------------------------------------------------------------------
-- Feline

local vi = {
  -- Map vi mode to text name
  text = {
    n = "NORMAL",
    no = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    [""] = "V-BLOCK",
    c = "COMMAND",
    cv = "COMMAND",
    ce = "COMMAND",
    R = "REPLACE",
    Rv = "REPLACE",
    s = "SELECT",
    S = "SELECT",
    [""] = "SELECT",
    t = "TERMINAL",
  },

  -- Maps vi mode to highlight group color defined above
  colors = {
    n = "UserRvCyan",
    no = "UserRvCyan",
    i = "UserSLStatus",
    v = "UserRvMagenta",
    V = "UserRvMagenta",
    [""] = "UserRvMagenta",
    R = "UserRvRed",
    Rv = "UserRvRed",
    r = "UserRvBlue",
    rm = "UserRvBlue",
    s = "UserRvMagenta",
    S = "UserRvMagenta",
    [""] = "FelnMagenta",
    c = "UserRvYellow",
    ["!"] = "UserRvBlue",
    t = "UserRvBlue",
  },

  -- Maps vi mode to seperator highlight goup defined above
  sep = {
    n = "UserCyan",
    no = "UserCyan",
    i = "UserSLStatusBg",
    v = "UserMagenta",
    V = "UserMagenta",
    [""] = "UserMagenta",
    R = "UserRed",
    Rv = "UserRed",
    r = "UserBlue",
    rm = "UserBlue",
    s = "UserMagenta",
    S = "UserMagenta",
    [""] = "FelnMagenta",
    c = "UserYellow",
    ["!"] = "UserBlue",
    t = "UserBlue",
  },
}

local icons = {
  locker = "", -- #f023
  page = "☰", -- 2630
  line_number = "", -- e0a1
  connected = "", -- f817
  dos = "", -- e70f
  unix = "", -- f17c
  mac = "", -- f179
  mathematical_L = "𝑳",
  vertical_bar = "┃",
  vertical_bar_thin = "│",
  left = "",
  right = "",
  block = "█",
  left_filled = "",
  right_filled = "",
  slant_left = "",
  slant_left_thin = "",
  slant_right = "",
  slant_right_thin = "",
  slant_left_2 = "",
  slant_left_2_thin = "",
  slant_right_2 = "",
  slant_right_2_thin = "",
  left_rounded = "",
  left_rounded_thin = "",
  right_rounded = "",
  right_rounded_thin = "",
  circle = "●",
}

---Get the number of diagnostic messages for the provided severity
---@param str string [ERROR | WARN | INFO | HINT]
---@return string
local function get_diag(str)
  local diagnostics = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[str] })
  local count = #diagnostics

  return (count > 0) and " " .. count .. " " or ""
end

---Get highlight group from vi mode
---@return string
local function vi_mode_hl()
  return vi.colors[vim.fn.mode()] or "UserSLViBlack"
end

---Get sep highlight group from vi mode
local function vi_sep_hl()
  return vi.sep[vim.fn.mode()] or "UserSLBlack"
end

---Get the path of the file relative to the cwd
---@return string
local function file_info()
  local list = {}
  if vim.bo.readonly then
    table.insert(list, "🔒")
  end

  if vim.bo.modified then
    table.insert(list, "●")
  end

  table.insert(list, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:."))

  return table.concat(list, " ")
end

-- Create a table that contians every status line commonent
local c = {
  vimode = {
    provider = function()
      return fmt(" %s ", vi.text[vim.fn.mode()])
    end,
    hl = vi_mode_hl,
    right_sep = { str = " ", hl = vi_sep_hl },
  },
  gitbranch = {
    provider = "git_branch",
    icon = " ",
    hl = "UserSLGitBranch",
    right_sep = { str = "  ", hl = "UserSLGitBranch" },
    enabled = function()
      return vim.b.gitsigns_status_dict ~= nil
    end,
  },
  file_type = {
    provider = function()
      return fmt(" %s ", vim.bo.filetype:upper())
    end,
    hl = "UserSLAlt",
  },
  fileinfo = {
    provider = { name = "file_info", opts = { type = "relative" } },
    hl = "UserSLAlt",
    left_sep = { str = " ", hl = "UserSLAltSep" },
    right_sep = { str = " ", hl = "UserSLAltSep" },
  },
  file_enc = {
    provider = function()
      local os = icons[vim.bo.fileformat] or ""
      return fmt(" %s %s ", os, vim.bo.fileencoding)
    end,
    hl = "StatusLine",
    left_sep = { str = icons.left_filled, hl = "UserSLAltSep" },
  },
  cur_position = {
    provider = function()
      -- TODO: What about 4+ diget line numbers?
      return fmt(" %3d:%-2d ", unpack(vim.api.nvim_win_get_cursor(0)))
    end,
    hl = vi_mode_hl,
    left_sep = { str = icons.left_filled, hl = vi_sep_hl },
  },
  cur_percent = {
    provider = function()
      return " " .. require("feline.providers.cursor").line_percentage() .. "  "
    end,
    hl = vi_mode_hl,
    left_sep = { str = icons.left, hl = vi_mode_hl },
  },
  default = { -- needed to pass the parent StatusLine hl group to right hand side
    provider = "",
    hl = "StatusLine",
  },
  lsp_status = {
    provider = function()
      return vim.tbl_count(vim.lsp.buf_get_clients(0)) == 0 and "" or " ◦ "
    end,
    hl = "UserSLStatus",
    left_sep = { str = "", hl = "UserSLStatusBg", always_visible = true },
    right_sep = { str = "", hl = "UserSLErrorStatus", always_visible = true },
  },
  lsp_error = {
    provider = function()
      return get_diag("ERROR")
    end,
    hl = "UserSLError",
    right_sep = { str = "", hl = "UserSLWarnError", always_visible = true },
  },
  lsp_warn = {
    provider = function()
      return get_diag("WARN")
    end,
    hl = "UserSLWarn",
    right_sep = { str = "", hl = "UserSLInfoWarn", always_visible = true },
  },
  lsp_info = {
    provider = function()
      return get_diag("INFO")
    end,
    hl = "UserSLInfo",
    right_sep = { str = "", hl = "UserSLHintInfo", always_visible = true },
  },
  lsp_hint = {
    provider = function()
      return get_diag("HINT")
    end,
    hl = "UserSLHint",
    right_sep = { str = "", hl = "UserSLFtHint", always_visible = true },
  },

  in_fileinfo = {
    provider = "file_info",
    hl = "StatusLine",
  },
  in_position = {
    provider = "position",
    hl = "StatusLine",
  },
  file_winbar = {
    provider = file_info,
    hl = "Comment",
  },
}

local active = {
  { -- left
    c.vimode,
    c.gitbranch,
    c.fileinfo,
    c.default, -- must be last
  },
  { -- right
    c.lsp_status,
    c.lsp_error,
    c.lsp_warn,
    c.lsp_info,
    c.lsp_hint,
    c.file_type,
    c.file_enc,
    c.cur_position,
    c.cur_percent,
  },
}

local inactive = {
  { c.in_fileinfo }, -- left
  { c.in_position }, -- right
}

require("feline").setup({
  components = { active = active, inactive = inactive },
  highlight_reset_triggers = {},
  force_inactive = {
    filetypes = {
      "NvimTree",
      "packer",
      "dap-repl",
      "dapui_scopes",
      "dapui_stacks",
      "dapui_watches",
      "dapui_repl",
      "LspTrouble",
      "qf",
      "help",
    },
    buftypes = { "terminal" },
    bufnames = {},
  },
  disable = {
    filetypes = {
      "dashboard",
      "startify",
    },
  },
})

-- osc52
vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)

require("obsidian").setup({
  workspaces = {
    {
      name = "personal",
      path = "~/syncthing/notes/personal",
    },
    {
      name = "work",
      path = "~/syncthing/notes/work",
    },
  },
  completion = {
    -- Set to false to disable completion.
    nvim_cmp = true,
    -- Trigger completion at 2 chars.
    min_chars = 2,
  },
  picker = {
    -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
    name = "telescope.nvim",
    -- Optional, configure key mappings for the picker. These are the defaults.
    -- Not all pickers support all mappings.
    mappings = {
      -- Create a new note from your query.
      new = "<C-x>",
      -- Insert a link to the selected note.
      insert_link = "<C-l>",
    },
  },
  follow_url_func = function(url)
    vim.fn.jobstart({"xdg-open", url})  -- linux
  end,
})

require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<C-j>"] = 'move_selection_next',
        ["<C-k>"] = 'move_selection_previous',
      },
    },
  }
})

vim.cmd [[highlight CodeBlock guibg=#1c1c1c]]
require("headlines").setup({
      markdown = {
        query = vim.treesitter.query.parse(
            "markdown",
            [[
                (thematic_break) @dash

                (fenced_code_block) @codeblock

                (block_quote_marker) @quote
                (block_quote (paragraph (inline (block_continuation) @quote)))
                (block_quote (paragraph (block_continuation) @quote))
                (block_quote (block_continuation) @quote)
            ]]
        ),
        headline_highlights = { "Headline" },
        bullet_highlights = {
            "@text.title.1.marker.markdown",
            "@text.title.2.marker.markdown",
            "@text.title.3.marker.markdown",
            "@text.title.4.marker.markdown",
            "@text.title.5.marker.markdown",
            "@text.title.6.marker.markdown",
        },
        bullets = { "◉", "○", "✸", "✿" },
        codeblock_highlight = "CodeBlock",
        dash_highlight = "Dash",
        dash_string = "-",
        quote_highlight = "Quote",
        quote_string = "┃",
        fat_headlines = true,
        fat_headline_upper_string = "▃",
        fat_headline_lower_string = "🬂",
    },
})
