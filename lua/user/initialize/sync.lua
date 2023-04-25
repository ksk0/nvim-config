local fn = vim.fn
local api = vim.api
local pkgs = require("user.initialize.packages")

local M = {}

local close_packer_window = function()
  -- api.nvim_del_user_command("PackerComplete")

  -- find and close floating window
  --
  local bf_name

  for _,buffer in pairs(fn.tabpagebuflist()) do
    bf_name = vim.api.nvim_buf_get_name(buffer)

    if bf_name:find('%[packer%]$') then
      break
    end
  end

  if bf_name then
    local winid = fn.bufwinid(bf_name)

    vim.g.packer_has_done = nil

    if winid then
      api.nvim_win_close(winid, true)
    end
  end

  pkgs.save_hashes("plug_file")
end

M.packer = function()
  if not pkgs.is_new("plug_file") then return end

  vim.api.nvim_create_autocmd(
     "User",
    {
      pattern = "PackerComplete",
      callback = close_packer_window,
    }
  )

  vim.cmd 'PackerSync'
end

M.mason = function ()
  api.nvim_del_user_command("ConfigInitializeMason")

  if pkgs.is_new("DAP") and #pkgs.DAP ~= 0 then
    vim.cmd('MasonInstall ' .. fn.join(pkgs.DAP," "))
  elseif pkgs.is_new("LSP") then
    vim.cmd('Mason')
  else
    return
  end

  vim.notify("Initializing mason")
  pkgs.save_hashes("DAP")
end

return M
