local md5sum = require("user.initialize.md5sum")
local files  = require("user.initialize.files")

local P = {}   -- list of packages (by group)
local H = {}   -- list of hashes (new and old)
local M = {}   -- main object


-- ============================================================================
-- List of packages to preinstall
--
P.plugins = {
  -- ==========================================================================
  --  These plugins will be manualy downloaded, since some of them issue
  --  warning if automaticaly installed using PackerSync command
  -- 
}

P.LSP = {
  -- ==========================================================================
  --  formatters
  -- 
  --  black               -- python formatter
  --  blue                -- python formatter (alternative to black)
  --  shfmt               -- A shell formatter (sh/bash/mksh)
  --  prettierd           -- formatter for many languages
  --  luaformatter        -- lua formatter


  -- ==========================================================================
  --  linters
  -- 
  "pyright",              -- Static type checker for Python (by Microsoft)
  "python-lsp-server",    -- fork of the python-language-server project,
                          -- maintained by the Spyder IDE team and the community
  "shellcheck",           -- static analysis tool for shell scripts


  -- ==========================================================================
  --  language servers
  -- 
  "awk-language-server",
  "bash-language-server",
  "lua-language-server",
  "yaml-language-server",
  "dockerfile-language-server",
  "json-lsp",
  "taplo",                        -- TOML language server
  "lemminx",                      -- XML language server
}

P.DAP = {
  -- ==========================================================================
  --  DAP (Debug Adapter Protocol) servers
  -- 
  "debugpy",                     -- debug adapter protocol for python
  "bash-debug-adapter",          -- debug adapter for bash
}

P.treesitter = {
  -- ===============================
  --  Install support for following
  --  languages automatically
  -- 
  "bash",
  "c",
  "html",
  "json",
  "lua",
  "make",
  "markdown",
  "perl",
  "python",
  "regex",
  "toml",
  "yaml",
  "awk",
  "vim",
  "help"
}


-- ============================================================================
-- Worker functions
--
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

local is_new = function (what)
  local new = H.new
  local old = H.old

  if not what then
    return (new.pkgs_file ~= old.pkgs_file) or (new.plug_file ~= old.plug_file)
  end

  return new[what] ~= old[what]
end

local init = function ()
  H.old = load_hashes()

  H.new = {}
  H.new.pkgs_file = md5sum.file(files.packages)
  H.new.plug_file = md5sum.file(files.plugins)

  for section in pairs(P) do
    H.new[section] = md5sum.table(P[section])
  end
end

local function raw_getval(var, key)
  if key:find("%.") then
    local _,_,ckey,skey = key:find("([^.]+)%.(.*)")
    return raw_getval(var[ckey], skey)
  else
    return var[key]
  end
end

local function getval(var, key)
  local ok,rval = pcall(raw_getval, var, key)

  if ok then
    return rval
  end

  return
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
