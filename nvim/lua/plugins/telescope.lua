return { "nvim-telescope/telescope.nvim",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = vim.fn.executable("make") == 1 and "make"
        or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      enabled = vim.fn.executable("make") == 1 or vim.fn.executable("cmake") == 1,
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
  },
  opts = {
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = 'move_selection_next',
          ["<C-k>"] = 'move_selection_previous',
        },
      },
      path_display = {
        "smart", "filename_first"
      },
      dynamic_preview_title = true,
    },
    pickers = {
      -- note: remove the 'builtin.' prefix.
--      ["lsp_references"] = { wrap_results = true, },
--      ["lsp_definitions"] = { wrap_results = true, },
--      ["diagnostics"] = { wrap_results = true, },
--      ["find_files"] = { wrap_results = true },
      ["buffers"] = { sort_mru = true, ignore_current_buffer = true },
    }
  },
  config = function(_, opts)
    require('telescope').setup(opts)
    require("telescope").load_extension("fzf")

    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<leader>ff', function()
      builtin.find_files({ search_dirs = vim.g.my_fzf_dirs })
    end)
    vim.keymap.set('n', '<leader>rg', function()
      builtin.live_grep({ search_dirs = vim.g.my_fzf_dirs })
    end)
    vim.keymap.set('n', '<leader>fb', builtin.buffers)
    vim.keymap.set('n', '<leader>fh', builtin.help_tags)
    vim.keymap.set('n', '<leader>tt', builtin.commands)
  end,
}
