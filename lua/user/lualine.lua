local lualine = require("lualine")
local path = require('plenary.path')

local work_buf
local buff_name = ""
local work_dir = vim.loop.cwd()

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = function ()
  local mode
  local altmode = require('alt-modes')

  if altmode then
    mode = altmode:status()
  end

  if not mode then
    mode = require('lualine.utils.mode').get_mode()
  end

  return "-- " .. mode .. " --"
end

local filename = function()
  local buff_path
  local curr_dir = vim.loop.cwd()
  local curr_buf = vim.fn.bufnr()

  if not work_buf or (work_dir ~= curr_dir) or (work_buf ~= curr_buf) then
    work_buf = curr_buf
    work_dir = curr_dir

    buff_path = path:new(vim.api.nvim_buf_get_name(work_buf))
    buff_name = buff_path:make_relative()

    return buff_name
  end

  return buff_name
end

local filetype = {
	"filetype",
	icons_enabled = true,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}

-- cool function for progress
--
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	-- local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local chars = { "██", "▇▇", "▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁", "  "}
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { branch, diagnostics },
		lualine_b = { mode },
		lualine_c = {},
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		-- lualine_x = { diff, spaces, "encoding", filetype },
		lualine_x = { filename, filetype },
		lualine_y = { location },
		lualine_z = { progress },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
