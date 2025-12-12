local M = {}

local default_encouragements = {

    "File saved. I'm not saying your code's bad, but maybe keep your day job.",
    "Your code's saved. Don't worry, I've seen worse... I just can't remember when.",
    "File saved! It's like polishing a brick.",
    "Your code is saved. I'd say 'good job', but I'm not a liar.",
    "File successfully saved. Unfortunately, that’s the only thing successful here.",
    "You saved the file! Too bad you can't save it from itself. 😬",
    "Code saved. Somewhere, a rubber duck is weeping.",
    "File saved. Alert the press, or maybe just your mom. She'd care.",
    "File saved. It's like a participation trophy, but for code.",
    "Saved. This is technically code.",
    "Saved. Yikes.",
    "Your code is saved. You showed up, and that counts.",
    "Saved. Future you is drafting an apology email.",
    "Your code is saved. Hope you enjoy explaining this later.",
    "Your code is saved. Ambition exceeded skill by a healthy margin.",
    "Saved. You typed that with conviction, I’ll give you that.",
    "File saved. The compiler is already disappointed.",
    "Saved. Another bold attempt at mediocrity.",
    "File saved. This is why linters drink.",
    "Saved. Another monument to technical debt.",
    "Your code is now permanent. Regret will follow shortly.",
    "Your code is saved. The bar was low, yet here we are.",
    "Saved. Huh.",
    "File saved. Please don’t push this.",
    "File saved. I regret being conscious.",
    "File saved. I hope this is a draft.",
    "File saved. This is indefensible.",
    "Saved. This is going to production, isn’t it.",
    "Saved. This ain’t it.",
    "Saved. There is no defending this.",


}

---Chooses a random message and displays it using the notify API
---@param encouragements string[]
local function custom_write_message(encouragements)
  local message = encouragements[math.random(#encouragements)]
  -- The third parameter is ignored by default, unless you have a plugin like `nvim-notify`
  vim.notify(message, nil, { title = "encourage.nvim" } )
end

function M.setup(opts)
  opts = opts or {}
  local encouragements = opts.messages or default_encouragements
  local plugin = vim.api.nvim_create_augroup("CustomWriteMessage", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group=plugin,
    callback=function()
      custom_write_message(encouragements)
    end
  })
end

return M
