
local MODULES = {
  "alpha",
  "autocommands",
  "bufferline",
  "keymaps",
  "lualine",
  "nvim-tree",
  "options",
  "toggleterm",
  "whichkey",
  "telescope",
}

for _,module in ipairs(MODULES) do
  require("user.general." .. module)
end
