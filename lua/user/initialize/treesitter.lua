local M = {}

local pkgs  = require("user.initialize.packages")
local files = require("user.initialize.files")

M.setup = function ()
  local f = io.open(files.ts_languages, "w")

  if not f then
    error('Failed to open "' .. files.ts_languages .. '" for writing')
  end

  f:write("return " .. vim.inspect(pkgs.treesitter))

  f:close()

  pkgs.save_hashes("treesitter")
end

return M
