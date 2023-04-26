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

-- =================================================
-- Initialize some of the plugins
--
require("user.bricks")
require("user.colorscheme")
require("user.notify")

-- =================================================
-- Initialize packer plugins and mason
--
require("user.initialize.plugins").setup()
require("mason").setup()
