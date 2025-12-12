local function get_filepath()
  local cur_path = vim.fn.expand("%:p")
  local home_dir = vim.fn.expand("~")

  -- Try LSP root first (best indicator of project root)
  local lsp_root = nil
  for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
    if client.config.root_dir then
      lsp_root = client.config.root_dir
      break
    end
  end

  if lsp_root then
    local relative_path = cur_path:sub(#lsp_root + 2)
    return (relative_path ~= "" and relative_path or vim.fn.expand("%:t"))
  end

  -- Fallback: Use Git root if present
  local git_dir = vim.fs.find(".git", {
    path = cur_path,
    upward = true,
    type = "directory",
  })[1]

  if git_dir then
    local repo_root = vim.fs.dirname(git_dir)
    local relative_path = cur_path:sub(#repo_root + 2)
    return relative_path
  end

  -- Fallback: Absolute path
  return cur_path:gsub("^" .. home_dir, "~")
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


