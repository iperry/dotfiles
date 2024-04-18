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
    }
  },
  config = function(_, opts)
    require('telescope').setup(opts)

    local builtin = require("telescope.builtin")
    vim.keymap.set('n', '<leader>ff', builtin.find_files)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep)
    vim.keymap.set('n', '<leader>fb', builtin.buffers)
    vim.keymap.set('n', '<leader>fh', builtin.help_tags)
    vim.keymap.set('n', '<leader>tt', builtin.commands)
  end,
}
