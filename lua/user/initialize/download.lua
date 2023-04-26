local fn = vim.fn

local M = {}

local download = function(plugin)
  if not plugin then return end

  if type(plugin) == "table" then
    for _,item in ipairs(plugin) do
      M.download(item)
    end

    return
  end

  local url = 'https://github.com/' .. plugin

  local plugin_root = fn.stdpath('data') .. '/site/pack/packer/start/'
  local plugin_name = plugin:sub(plugin:find('/.*') + 1)
  local plugin_path = plugin_root .. plugin_name

  if fn.empty(fn.glob(plugin_path)) == 0 then
    return
  end

  vim.notify("Downloading plugin: " .. plugin_name)

  fn.system{
    'git',
    'clone',
    '--depth',
    '1',
    url,
    plugin_path
  }

  vim.cmd ("packadd " .. plugin_name)
end

return download
