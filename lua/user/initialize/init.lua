-- ===============
-- initialize
-- ===============

local plugin = require("user.initialize.plugin")
local pkgs   = require("user.initialize.packages")
local sync   = require("user.initialize.sync")

vim.api.nvim_create_user_command("ConfigInitializeMason",  sync.mason, {})

plugin.download("wbthomason/packer.nvim")
plugin.download("nvim-treesitter/nvim-treesitter")
plugin.download("navarasu/onedark.nvim")
plugin.download("rcarriga/nvim-notify")
plugin.download("nvim-lua/plenary.nvim")
plugin.download("ksk0/nvim-bricks")
plugin.download("williamboman/mason.nvim")
plugin.download("williamboman/mason-lspconfig.nvim")

require("user.bricks")
require("user.colorscheme")
require("user.notify")
require("user.plugins")

if not pkgs.is_new() then
  return
end

if pkgs.is_new("plugins") then
  plugin.download(pkgs.plugins)
end

if pkgs.is_new("LSP") then
  require("user.initialize.lsp").setup()
end

if pkgs.is_new("treesitter") then
  require("user.initialize.treesitter").setup()
end

if pkgs.is_new("plug_file") then
  sync.packer()
end

pkgs.save_hashes("pkgs_file")
