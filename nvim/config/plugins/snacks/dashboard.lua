return function()
  local Snacks = require("snacks")
  local in_git = Snacks.git.get_root() ~= nil

  local git_pane = vim.tbl_map(function(cmd)
    return vim.tbl_extend("force", {
      pane    = 2,
      section = "terminal",
      enabled = in_git,
      padding = 1,
      ttl     = 5 * 60,
      indent  = 3,
    }, cmd)
  end, {
    {
      icon   = " ",
      title  = "Git Status",
      cmd    = "git --no-pager diff --stat -B -M -C",
      height = 10,
    },
  })

  return {
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
      git_pane,
      { section = "startup" },
    },
  }
end
