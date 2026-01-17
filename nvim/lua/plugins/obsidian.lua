local note_format = function(title)
  -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
  -- In this case a note with the title 'My new note' will be given an ID that looks
  -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
  local suffix = ""
  if title ~= nil then
    -- If title is given, transform it into valid file name.
    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
  else
    -- If title is nil, just add 4 random uppercase letters to the suffix.
    for _ = 1, 4 do
      suffix = suffix .. string.char(math.random(65, 90))
    end
  end
  return tostring(os.time()) .. "-" .. suffix
end

return { "obsidian-nvim/obsidian.nvim",
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim", },
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = "notes", path = "~/sync/notes/", }
    },
    daily_notes = { folder = "dailies" },
    note_id_func = note_format,
  },
  keys = {
    { "<leader>on", "<cmd>Obsidian new<cr>", {v, n} },
    { "<leader>os", "<cmd>Obsidian search<cr>" },
    { "<leader>oq", "<cmd>Obsidian quick_switch<cr>" },
    { "<leader>oo", "<cmd>Obsidian open<cr>" },
    { "<leader>ow", "<cmd>Obsidian workspace<cr>" },
    { "<leader>ot", "<cmd>Obsidian today<cr>" },
    { "<leader>oT", "<cmd>Obsidian tomorrow<cr>" },
  },
}
