require("gp").setup({
    hooks = {
        InspectPlugin = function(plugin, params)
            local bufnr = vim.api.nvim_create_buf(false, true)
            local copy = vim.deepcopy(plugin)
            local key = copy.config.openai_api_key
            copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
            local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
            local params_info = string.format("Command params:\n%s", vim.inspect(params))
            local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.api.nvim_win_set_buf(0, bufnr)
        end,

        -- GpImplement rewrites the provided selection/range based on comments in it
        Implement = function(gp, params)
            local template = "Having following from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please rewrite this according to the contained instructions."
                .. "\n\nRespond exclusively with the snippet that should replace the selection above."

            local agent = gp.get_command_agent()
            gp.info("Implementing selection with agent: " .. agent.name)

            gp.Prompt(
                params,
                gp.Target.rewrite,
                nil, -- command will run directly without any prompting for user input
                agent.model,
                template,
                agent.system_prompt
            )
        end,
        -- example of adding command which writes unit tests for the selected code
        UnitTests = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please respond by writing table driven unit tests for the code above. Do not use unittest.mock for mocking, use pytest-mock instead."
            local agent = gp.get_command_agent()
            gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
        end,

        -- example of adding command which explains the selected code
        Explain = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please respond by explaining the code above."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
        end,

        -- example of usig enew as a function specifying type for the new buffer
        CodeReview = function(gp, params)
            local template = "I have the following code from {{filename}}:\n\n"
                .. "```{{filetype}}\n{{selection}}\n```\n\n"
                .. "Please analyze for code smells and suggest improvements."
            local agent = gp.get_chat_agent()
            gp.Prompt(params, gp.Target.enew("markdown"), nil, agent.model, template, agent.system_prompt)
        end,
    },

})
require("gp")._state.chat_agent = "ChatGPT4o"
require("gp")._state.command_agent = "CodeGPT4o"
require("gp").agents['CodeGPT4o'].model = "gpt-4-turbo"
require("gp").agents['ChatGPT4o'].model = "gpt-4-turbo"
require("gp").agents['ChatGPT4o'].system_prompt = "You are a coding assistant, be helpful and do not omit code in your response"

local function keymapOptions(desc)
    return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
    }
end


-- Chat commands
vim.keymap.set({"n", "i"}, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
vim.keymap.set({"n", "i"}, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
vim.keymap.set({"n", "i"}, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))

vim.keymap.set({ "n", "i" }, "<C-g><C-x>", "<cmd>GpChatNew split<cr>", keymapOptions("New Chat split"))
vim.keymap.set({ "n", "i" }, "<C-g><C-v>", "<cmd>GpChatNew vsplit<cr>", keymapOptions("New Chat vsplit"))
vim.keymap.set({ "n", "i" }, "<C-g><C-t>", "<cmd>GpChatNew tabnew<cr>", keymapOptions("New Chat tabnew"))

vim.keymap.set("v", "<C-g><C-x>", ":<C-u>'<,'>GpChatNew split<cr>", keymapOptions("Visual Chat New split"))
vim.keymap.set("v", "<C-g><C-v>", ":<C-u>'<,'>GpChatNew vsplit<cr>", keymapOptions("Visual Chat New vsplit"))
vim.keymap.set("v", "<C-g><C-t>", ":<C-u>'<,'>GpChatNew tabnew<cr>", keymapOptions("Visual Chat New tabnew"))

-- Prompt commands
vim.keymap.set({"n", "i"}, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
vim.keymap.set({"n", "i"}, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
vim.keymap.set({"n", "i"}, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

vim.keymap.set("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
vim.keymap.set("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
vim.keymap.set("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
vim.keymap.set("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))
vim.keymap.set("v", "<C-g>u", ":<C-u>'<,'>GpUnitTests<cr>", keymapOptions("Unittest selection"))

vim.keymap.set({"n", "i"}, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
vim.keymap.set("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

vim.keymap.set({"n", "i", "v", "x"}, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))


