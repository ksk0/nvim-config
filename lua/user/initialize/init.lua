-- ===============
-- initialize
-- ===============

local plugin = require("user.initialize.plugin")
local pkgs = require("user.initialize.packages")
local sync = require("user.initialize.sync")

vim.cmd [[
  colorscheme default
  set background=dark
]]

plugin.download("wbthomason/packer.nvim")
plugin.download("navarasu/onedark.nvim")
plugin.download("rcarriga/nvim-notify")
plugin.download("nvim-lua/plenary.nvim")
plugin.download("ksk0/nvim-bricks")

require("user.bricks")
require("user.colorscheme")
require("user.notify")
require("user.plugins")

plugin.download(pkgs.plugins)

sync.packer()

vim.api.nvim_create_user_command("MasonInstallDAP", sync.mason, {
    desc = "Opens mason's UI window.",
    nargs = 0,
})
