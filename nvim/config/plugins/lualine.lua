local function get_filepath()
	local cur_path = vim.fn.expand("%:p")
	local home_dir = vim.fn.expand("~")
	local home = vim.fs.find(".git", {
		path = cur_path,
		upward = true,
		type = "directory"
	})[1]

	if home == nil then
		-- Return the absolute path if the file is not part of a Git repository
		return cur_path:gsub("^" .. home_dir, "~")
	end

	home = vim.fs.dirname(home)
	local relative_path = cur_path:sub(#home + 2)
	local repo_root = vim.fs.basename(home)
	local final_path = repo_root .. '/' .. relative_path
	return final_path:gsub("^" .. home_dir, "~")
end

local function filename_component()
	local filepath = get_filepath()

	-- Determine the file status
	local file_status = ""
	if vim.bo.readonly then
		file_status = "RO" -- Symbol for readonly file
	elseif vim.fn.expand("%:t") == "" then
		file_status = "[No Name]" -- Symbol for unnamed file
	end

	-- Return the full path with the appropriate symbol
	return filepath .. file_status
end

local function session_component()
  local session = vim.v.this_session
  if not session or session == "" then
    return ""
  end

  -- Just the filename (no path); keep extension if you want
  local name = vim.fn.fnamemodify(session, ":t")

  -- Optional: drop extension (e.g. "my-session.vim" -> "my-session")
  -- name = vim.fn.fnamemodify(name, ":r")

  -- Pick any nerd font icon you like here
  return " " .. name
end


local kanagawa_paper = require("lualine.themes.kanagawa-paper-ink")

require("lualine").setup({
  options = {
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    theme = kanagawa_paper,
    globalstatus = true,
    transparent = false,
    blend = false,
  },
  sections = {
    lualine_a = { { "mode", icon = "" } },
    lualine_b = { { "branch", icon = "" } },
    lualine_c = {
        {
            'diagnostics',
            sections = { 'error', 'warn', 'info', 'hint' },

            diagnostics_color = {
                -- Same values as the general color option can be used here.
                error = 'DiagnosticError', -- Changes diagnostics' error color.
                warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
                info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
                hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
            },
            symbols = {error = 'E', warn = 'W', info = 'I', hint = 'H'},
            colored = true,           -- Displays diagnostics status in color if set to true.
            update_in_insert = false, -- Update diagnostics in insert mode.
            always_visible = false,   -- Show diagnostics even if there are none.
        },
      {
        require("noice").api.statusline.mode.get,
        cond = require("noice").api.statusline.mode.has,
      },

      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      {
        filename_component,
      },
    },
    lualine_x = {
        {
            session_component,
        },
        {
          'tabs',
          mode = 0,
        },
    },
    lualine_y = {
    },
  },
})


