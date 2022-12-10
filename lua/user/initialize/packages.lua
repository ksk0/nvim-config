local fn = vim.fn
local hash = require("user.initialize.md5sum")

local M = {}

M.load_list = function()
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

  local hashes = {}

  for section in pairs(packages) do
    hashes[section] = hash.string(packages[section])
  end

  packages["__hash"] = hashes

  return packages
end

return M
