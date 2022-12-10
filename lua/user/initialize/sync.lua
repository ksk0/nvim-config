local fn = vim.fn

local M = {}

local plugin = require("user.initialize.plugin")
local pkgs = require("user.initialize.packages")

M.packer = function ()
  if not plugin.downloaded["packer.nvim"] then return end

  vim.g.packer_has_done = 0

  vim.cmd 'autocmd User PackerComplete let g:packer_has_done = 1'
  vim.cmd 'PackerSync'

  while vim.g.packer_has_done ~= 1 do
    vim.cmd [[
      redraw
      sleep 200m
    ]]
  end

  vim.cmd [[
    unlet g:packer_has_done
    autocmd! User PackerComplete
    quit
  ]]
end

M.mason = function ()
  local dap_pkgs = pkgs.load_list().DAP

  if dap_pkgs then
    local mason_pkgs = fn.join(vim.tbl_keys(dap_pkgs)," ")
    vim.cmd('MasonInstall ' .. mason_pkgs)
  else
    vim.cmd 'Mason'
  end
end

return M
