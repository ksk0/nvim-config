-- ===============
-- initialize
-- ===============

-- =================================================
-- Download core plugins, if they are not already
-- present/downloaded.
--
local download = require("user.initialize.download")

download("wbthomason/packer.nvim")
download("nvim-treesitter/nvim-treesitter")
download("navarasu/onedark.nvim")
download("rcarriga/nvim-notify")
download("nvim-lua/plenary.nvim")
download("ksk0/nvim-bricks")
download("williamboman/mason.nvim")
download("williamboman/mason-lspconfig.nvim")
download("jay-babu/mason-nvim-dap.nvim")
download("lewis6991/impatient.nvim")

-- =================================================
-- Initialize some of core the plugins
--
require("user.initialize.bricks")
require("user.initialize.colorscheme")
require("user.initialize.notify")

-- =================================================
-- Initialize packer plugins, mason and impatient
--
require("user.initialize.plugins").setup()
require("mason").setup()
require("impatient")
