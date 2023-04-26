local MODULES = {
  "initialize",
  "general",

  "lsp",
  "dap",
  "ide",
  "debug",
  "treesitter",
}

local timer = require("user.timer")
local pass  = timer.pass()
local total = timer.total()

pass()
total()

for _,module in ipairs(MODULES) do
  require("user." .. module)
end

total("Total load time")
