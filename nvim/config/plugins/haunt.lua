return {
  name = "haunt.nvim",
  dir = vim.loop.os_homedir() .. "/.dotfiles/nvim/local-plugins/haunt.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function(_, opts)
    require("haunt").setup(opts)
  end,
  opts = {
    -- share annotations across branches (repo-scoped persistence)
    storage_scope = "repo",
    -- keep defaults; explicitly set picker keys for clarity
    picker_keys = {
      delete = { key = "d", mode = { "n" } },
      edit_annotation = { key = "a", mode = { "n" } },
    },
  },
  init = function()
    vim.api.nvim_set_hl(0, "HauntAnnotation", { link = "Comment" })
  end,
  cmd = {
    "HauntAnnotate",
    "HauntClear",
    "HauntClearAll",
    "HauntDelete",
    "HauntList",
    "HauntNext",
    "HauntPrev",
    "HauntQf",
    "HauntQfAll",
  },
  keys = {
    { "<leader>ha", "<cmd>HauntAnnotate<CR>", desc = "Haunt annotate" },
    { "<leader>ht", function() require("haunt.api").toggle_annotation() end, desc = "Haunt toggle annotation" },
    { "<leader>hT", function() require("haunt.api").toggle_all_lines() end, desc = "Haunt toggle all annotations" },
    { "<leader>hd", "<cmd>HauntDelete<CR>", desc = "Haunt delete bookmark" },
    { "<leader>hC", "<cmd>HauntClearAll<CR>", desc = "Haunt clear all bookmarks" },
    { "<leader>h[", "<cmd>HauntPrev<CR>", desc = "Haunt previous bookmark" },
    { "<leader>h]", "<cmd>HauntNext<CR>", desc = "Haunt next bookmark" },
    { "<leader>hl", "<cmd>HauntList<CR>", desc = "Haunt list (Snacks picker)" },
    { "<leader>hq", "<cmd>HauntQf<CR>", desc = "Haunt to quickfix (buffer)" },
    { "<leader>hQ", "<cmd>HauntQfAll<CR>", desc = "Haunt to quickfix (all)" },
    { "<leader>hy", function() require("haunt.api").yank_locations({ current_buffer = true }) end, desc = "Haunt yank (buffer)" },
    { "<leader>hY", function() require("haunt.api").yank_locations() end, desc = "Haunt yank (all)" },
  },
}
