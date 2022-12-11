local M = {}

local fn = vim.fn
local pkgs  = require("user.initialize.packages")
local files = require("user.initialize.files")

local load_lsp_mappings = function ()
  return require("mason-lspconfig.mappings.server").package_to_lspconfig
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
