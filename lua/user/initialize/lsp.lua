local M = {}

local fn = vim.fn
local pkgs  = require("user.initialize.packages")
local files = require("user.initialize.files")

local load_lsp_mappings = function()
	vim.notify("Retrieving LSP servers mapping")

	local raw_git  = "https://raw.githubusercontent.com/"
	local list_url = "williamboman/mason-lspconfig.nvim/main/doc/server-mapping.md"

  local mapping_page = vim.split(
    fn.system{
      'curl',
      '-so',
      '-',
      raw_git .. list_url
    }, "\n"
  )

  local mapping_table = vim.tbl_filter(
    function(line)
      return line:find("^| %[") ~= nil
    end,

    mapping_page
  )

  local mapping_pairs = vim.tbl_map(
    function (item)
      local _, _, lsp_name, mason_name = item:find("| %[([^%]]+).* | %[([^%]]+)")
      return {mason_name, lsp_name}
    end,

    mapping_table
  )

  local mappings = {}

  for _,map in ipairs(mapping_pairs) do
    mappings[map[1]] = map[2]
  end

  return mappings
end

M.setup = function ()
  local servers = {}
  local mappings = load_lsp_mappings()

  for _,mason_server in ipairs(pkgs.LSP) do
    table.insert(servers, mappings[mason_server])
  end

  local f = io.open(files.lsp_servers, "w")

  if not f then
    error('Failed to open "' .. files.lsp_servers .. '" for writing')
  end
  
  f:write("return " .. vim.inspect(servers))

  f:close()

  pkgs.save_hashes("LSP")
end

return M
