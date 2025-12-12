local sessions = require("mini.sessions")

sessions.setup({
  directory = vim.fn.stdpath("data") .. "/sessions",
  autoread = false,
  autowrite = true,
})

vim.keymap.set("n", "<leader>sl", function()
  sessions.select()
end, { desc = "List sessions" })

vim.keymap.set("n", "<leader>sn", function()
  local name = vim.fn.input("Session name: ")
  if name ~= "" then
    sessions.write(name)
  end
end, { desc = "Create session" })

vim.keymap.set("n", "<leader>sr", function()
  sessions.select("delete")
end, { desc = "Delete session" })

