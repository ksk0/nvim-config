-- ===============
-- initialize
-- ===============

local fn = vim.fn
local downloaded = {}

local md5sum_string = function(sum_table)
  local sum_list = vim.tbl_keys(sum_table)
  table.sort(sum_list)
  local sum_string = fn.join(sum_list," ")

  return fn.system('md5sum',sum_string):gsub(" .*","")
end

local load_packages_list = function()
  local config_root = fn.stdpath('config')
  local package_list = config_root .. "/packages"

  local packages = {}
  local f = io.open(package_list, "r")

  if not f then return packages end

  local line = f:read("l")
  local group

  while line do
    line = line:gsub("^%s+", "")
    line = line:gsub("%s*#.*", "")
    line = line:gsub("%s+$", "")
    line = line:gsub("%s+", " ")

    if line:find("^%[%s*[^%]]*%s*%]$") then
      local gname = line

      gname = gname:gsub("%[%s*", "")
      gname = gname:gsub("%s*%]", "")

      if not gname:find("^[^ ]+$") then
        vim.api.nvim_err_writeln('Error: "' .. line .. '" is not valid group definition! Ignoring ...')
      else
        group = gname
        packages[group] = packages[group] or {}
      end

    elseif not line:find("^$") then
      for pkg in vim.gsplit(line, " ") do
        if pkg:find("^[%w-_.]+$") then
          packages[group][pkg] = true
        elseif (group == "plugins") and pkg:find("^[%w-_./]+$") then
          packages[group][pkg] = true
        else
          vim.api.nvim_err_writeln('Error: "' .. pkg .. '" is not valid group item! Ignoring ...')
        end
      end
    end

    line = f:read("l")
  end


  f:close()

  local hash = {}

  for section in pairs(packages) do
    hash[section] = md5sum_string(packages[section])
  end

  packages["__hash"] = hash

  return packages
end

local download_plugin = function(plugin)
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
  downloaded[plugin_name] = true
end

local packer_sync = function ()
  if not downloaded["packer.nvim"] then return end

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

local mason_sync = function ()
  local pkgs = load_packages_list().DAP

  if pkgs then
    local mason_pkgs = fn.join(vim.tbl_keys(pkgs)," ")
    vim.cmd('MasonInstall ' .. mason_pkgs)
  else
    vim.cmd 'Mason'
  end
end

vim.cmd [[
  colorscheme default
  set background=dark
]]

download_plugin("wbthomason/packer.nvim")
download_plugin("navarasu/onedark.nvim")
download_plugin("rcarriga/nvim-notify")
download_plugin("nvim-lua/plenary.nvim")
download_plugin("ksk0/nvim-bricks")

require("user.bricks")
require("user.colorscheme")
require("user.notify")
require("user.plugins")

local packages = load_packages_list()

for plugin in pairs(packages.plugins or {}) do
  download_plugin(plugin)
end

packer_sync()

vim.api.nvim_create_user_command("MasonInstallDAP", mason_sync, {
    desc = "Opens mason's UI window.",
    nargs = 0,
})
