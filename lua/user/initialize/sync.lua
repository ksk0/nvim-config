local fn = vim.fn
local api = vim.api

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
      sleep 1000m
    ]]
  end

  local bf_name = fn.bufname("\\[packer\\]")
  local winid = fn.bufwinid(bf_name)

  vim.g.packer_has_done = nil
  api.nvim_win_close(winid, true)
end

M.mason = function ()
  local dap_pkgs = pkgs.DAP

  if dap_pkgs then
    local mason_pkgs = fn.join(vim.tbl_keys(dap_pkgs)," ")
    vim.cmd('MasonInstall ' .. mason_pkgs)
  else
    vim.cmd 'Mason'
  end
end

return M
