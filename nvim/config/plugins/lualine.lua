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

-- Custom Lualine component
local function custom_filename_component()
	local filepath = get_filepath()

	-- Determine the file status
	local file_status = ""
	if vim.bo.modified then
		file_status = "  " -- Symbol for modified file
	elseif vim.bo.readonly then
		file_status = "RO" -- Symbol for readonly file
	elseif vim.fn.expand("%:t") == "" then
		file_status = "[No Name]" -- Symbol for unnamed file
	end

	-- Return the full path with the appropriate symbol
	return filepath .. file_status
end

local colors = {
  blue   = '#61afef',
  green  = '#98c379',
  purple = '#c678dd',
  cyan   = '#56b6c2',
  red1   = '#e06c75',
  red2   = '#be5046',
  yellow = '#e5c07b',
  fg     = '#abb2bf',
  bg     = '#282c34',
  gray1  = '#828997',
  gray2  = '#2c323c',
  gray3  = '#3e4452',
}

local copilot_colors = {
  [""] = { fg = colors.grey, bg = colors.none },
  ["Normal"] = { fg = colors.grey, bg = colors.none },
  ["Warning"] = { fg = colors.red, bg = colors.none },
  ["InProgress"] = { fg = colors.yellow, bg = colors.none }
}
local custom_iceberg = require("lualine.themes.iceberg_dark")
custom_iceberg.command = { a = {bg = "#be8c8c", fg = "#17171b", gui = "bold"}, z = {bg = "#be8c8c", fg = "#17171b", gui = "bold"} }
custom_iceberg.normal.a.bg = "#7894ab"
custom_iceberg.normal.c.bg = "#282830"
custom_iceberg.insert.a.bg = "#8faf77"

require("lualine").setup({
  options = {
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = '' },
    theme = custom_iceberg,
    globalstatus = true,
    transparent = false,
    blend = false,
  },
  sections = {
    lualine_a = { { "mode", icon = "" } },
    lualine_b = { { "branch", icon = "" } },
    lualine_c = {
      {
        "diagnostics",
        symbols = {
          error = " ",
          warn = " ",
          info = " ",
          hint = "󰝶 ",
        },
      },
      {
        require("noice").api.statusline.mode.get,
        cond = require("noice").api.statusline.mode.has,
      },

      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      {
        custom_filename_component,
        symbols = { modified = "  ", readonly = "RO", unnamed = "" }, -- Retaining the symbols in case they are needed elsewhere
      },
    },
    lualine_x = {
    {
        require("nvim-possession").status,
        cond = function()
            return require("nvim-possession").status() ~= nil
        end,
    },
    {
      'tabs',
      tab_max_length = 100,
      max_length = vim.o.columns / 3,

      mode = 1,

    },

    {
      'fileformat',
      symbols = {
        unix = '', -- e712
        dos = '',  -- e70f
        mac = '',  -- e711
      }
    },
      {
        function()
          local icon = " "
          local status = require("copilot.api").status.data
          return icon .. (status.message or "")
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot" })
          return ok and #clients > 0
        end,
        color = function()
          if not package.loaded["copilot"] then
            return
          end
          local status = require("copilot.api").status.data
          return copilot_colors[status.status] or copilot_colors[""]
        end,
      },
      {

        "diff",
        symbols = { added = " ", modified = " ", removed = " " },
        source = function()
            local ok, gitsigns_status_dict = pcall(vim.api.nvim_buf_get_var, 0, 'gitsigns_status_dict')
            if ok and gitsigns_status_dict then
                gitsigns_status_dict.modified = gitsigns_status_dict.changed
            end
            return gitsigns_status_dict
        end,

      },
    },
    lualine_y = {
    },
  },
})
