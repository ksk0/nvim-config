local md5sum = require("user.initialize.md5sum")
local files  = require("user.initialize.files")

local P = {}   -- list of packages (by group)
local H = {}   -- list of hashes (new and old)
local M = {}   -- main object

local read_file = function(file_name)
  local f = io.open(file_name, "r")

  if not f then return end

  local content = vim.split(f:read("all"), "\n")

  f:close()

  return content
end

local load_hashes = function ()
  local content = read_file(files.hashes)

  if not content then return {} end

  local hashes = {}

  for _,line in ipairs(content) do
    local parts = vim.split(line, ";")
    hashes[parts[1]] = parts[2]
  end

  return hashes
end

local save_hashes = function (what)
  local f = io.open(files.hashes, "w")

  if not f then
    error('Failed to open ".hashes" for writing')
  end

  if what then
    H.old[what] = H.new[what]
  end

  for k,v in pairs(H.old) do
    f:write(k .. ";" .. v .. "\n")
  end

  f:close()
end

local get_hashes = function ()
  H.old = load_hashes()
  H.new = vim.deepcopy(H.old)
  H.new.pkgs_file = md5sum.file(files.packages)
  H.new.plug_file = md5sum.file(files.plugins)
end

local load_packages_list = function()
  local content = read_file(files.packages)

  if not content then return {} end

  local group
  local pkgs = {}

  for _,line in ipairs(content) do
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
        pkgs[group] = pkgs[group] or {}
      end

    elseif not line:find("^$") then
      for pkg in vim.gsplit(line, " ") do
        if pkg:find("^[%w-_.]+$") then
          pkgs[group][pkg] = true
        elseif (group == "plugins") and pkg:find("^[%w-_./]+$") then
          pkgs[group][pkg] = true
        else
          vim.api.nvim_err_writeln('Error: "' .. pkg .. '" is not valid group item! Ignoring ...')
        end
      end
    end
  end

  for section in pairs(pkgs) do
    P[section] = vim.tbl_keys(pkgs[section])
  end

  local hashes = H.new

  for section in pairs(P) do
    hashes[section] = md5sum.list(P[section])
  end
end

local init = function ()
  get_hashes()

  if (H.old.pkgs_file ~= H.new.pkgs_file) then
    load_packages_list()
  end
end

local is_new = function (what)
  local new = H.new
  local old = H.old

  if not what then
    return (new.pkgs_file ~= old.pkgs_file) or (new.plug_file ~= old.plug_file)
  end

  return new[what] ~= old[what]
end

init()

M.is_new = is_new
M.save_hashes = save_hashes

setmetatable(M,{
  __index = function(_,k)
    return P[k]
  end
})

return M
