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

return { "epwalsh/obsidian.nvim",
  lazy = false,
  ft = "markdown",
  dependencies = { "nvim-lua/plenary.nvim", },
  opts = {
    workspaces = {
      { name = "notes", path = "~/syncthing/notes/", }
    },
    daily_notes = { folder = "dailies" },
    note_id_func = note_format,
  },
  keys = {
    { "<leader>ol", "<cmd>ObsidianLinkNew<cr>", {v, n} },
    { "<leader>og", "<cmd>ObsidianSearch<cr>" },
    { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>" },
    { "<leader>oo", "<cmd>ObsidianOpen<cr>" },
    { "<leader>ow", "<cmd>ObsidianWorkspace<cr>" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>" },
    { "<leader>oT", "<cmd>ObsidianTomorrow<cr>" },
  },
}
