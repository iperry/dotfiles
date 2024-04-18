return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    { "<leader>nt", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
  },

  opts = {
    window = {
      width = 30,
    },
    filesystem = {
      window = {
        mappings = {
          ["o"]  = { "open", nowait = true },
          -- Disable order by mappings
          ["oc"] = "none",
          ["od"] = "none",
          ["og"] = "none",
          ["om"] = "none",
          ["on"] = "none",
          ["os"] = "none",
          ["ot"] = "none",
        }
      },
    }
  }
}
