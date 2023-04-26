-- =================================================================
--
--
local packer = require("packer")
local window_shutter

local api = vim.api
local fn  = vim.fn

local create_autocmd = api.nvim_create_autocmd
local create_augroup = api.nvim_create_augroup
local delete_autocmd = api.nvim_del_autocmd


-- =================================================================
-- Helper functions
--
local read_file = function(file_name)
  local f = io.open(file_name, "r")

  if not f then return "" end

  local content = f:read("all")

  f:close()

  return content
end


-- =================================================================
-- Close packer floating window (which we get when we issue "sync")
--
local close_packer_window = function()
  delete_autocmd(window_shutter)

  -- find and close packer floating window
  --
  for _,buffer in pairs(fn.tabpagebuflist()) do
    local buffer_name = vim.api.nvim_buf_get_name(buffer)

    if buffer_name:find('%[packer%]$') then
      local window = fn.bufwinid(buffer)
      if window then
        api.nvim_win_close(window, true)
      end

      return
    end
  end
end


-- =================================================================
-- Config plugins
--
local packer_config = {function (use)

  -- ===============================================================
  -- Core plugins. This plugins are donwloaded with "initialize"
  -- script itself (if not already present), but we have to list
  -- them here, since responsibility for their upgrade is up to
  -- packer.
  --
  -- (this could possibly could change in the future)
  --
  use "wbthomason/packer.nvim"
  use "nvim-treesitter/nvim-treesitter"
  use "navarasu/onedark.nvim"
  use "rcarriga/nvim-notify"
  use "nvim-lua/plenary.nvim"
  use "ksk0/nvim-bricks"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "jay-babu/mason-nvim-dap.nvim"

  -- ===============================================================
  -- My plugins here
  --
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim

  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "akinsho/bufferline.nvim" -- enhanced buffer line
  use "moll/vim-bbye" -- more sensible closing/deleting of buffers
  use "nvim-lualine/lualine.nvim" -- enhanced status line

  -- use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim" -- speed up loadgin of lua modules by caching
  use "lukas-reineke/indent-blankline.nvim" -- adds indentation guides to all lines 
  use "goolord/alpha-nvim" -- neovim greeter (splash screen with menu)
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "folke/which-key.nvim"  -- popup showing possible key bindings
  use "lewis6991/gitsigns.nvim" -- Git decoration of code (added, deleted, modified lines) 
  use "nvim-telescope/telescope.nvim" -- fuzzy finder over lists

  -- ===============================================================
  -- Neo-Tree - file system explorer
  --
  -- use {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   requires = {
  --     "nvim-lua/plenary.nvim",
  --     "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
  --     "MunifTanjim/nui.nvim",
  --   },
  -- }


  -- ===============================================================
  -- Nvim-Tree - file system explorer
  --
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icons
    }
  }

  -- ===============================================================
  -- terminal "toggler"
  --
  use {
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = function()
      require("toggleterm").setup{
        open_mapping = [[<M-t>]],
        terminal_mapping = [[<M-t>]],
      }
    end
  }

  -- ===============================================================
  -- Commenting
  --
  use {
    "numToStr/Comment.nvim", -- Easily comment stuff

    requires = {
      -- =============================================
      -- setting the commentstring option based on the
      -- cursor location in the file. The location is
      -- checked via treesitter queries.
      --
      "JoosepAlviste/nvim-ts-context-commentstring",
    }
  }

  -- ===============================================================
  -- Completion plugins
  --
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions (depends on LauSnip)
  use "hrsh7th/cmp-nvim-lsp" -- LSP provided completions
  use "hrsh7th/cmp-nvim-lua" -- completon for nvim lua API (like vim.lsp.util ...)
  use "rcarriga/cmp-dap" -- dap completion

  -- ===============================================================
  -- Snippets plugins
  --
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- ===============================================================
  -- LSP
  --
  use "neovim/nvim-lspconfig" -- simplified/tipical configuration for LSP servers
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

  -- ===============================================================
  -- DEBUGGING
  --
  use "mfussenegger/nvim-dap"              -- need this to use DAPs in nvim
  use "rcarriga/nvim-dap-ui"               -- turn nvim into debuging ui
  use "jbyuki/one-small-step-for-vimkind"  -- lua deubber

  -- use "mfussenegger/nvim-dap-python"

  -- ===============================================================
  -- Code references
  --
  -- use "RRethy/vim-illuminate" -- setup "hover" functionality for LSP, treesitter or regex

  -- ===============================================================
  -- Diagnostics
  --
  use "folke/trouble.nvim" -- show list of diagnostic errors

  -- ===============================================================
  -- localy developed plugins
  --
  use "ksk0/nvim-fade-color"

  use "/home/koske/develop/nvim/nvim-project-tools"
  use "/home/koske/develop/nvim/nvim-alt-modes"
  use "/home/koske/develop/nvim/nvim-widgets"
end}

local sync_packer = function()
  -- ==============================================
  -- check if "stored" and current versions of this
  -- file are same (use hasing mechanism of table).
  -- If not same, sync packer.
  --
  local script_dir = debug.getinfo(2, "S").source:sub(2):match("(.*/)")

  local old_config = script_dir .. ".plugins"
  local new_config = script_dir .. "plugins.lua"

  local old_content = read_file(old_config)
  local new_content = read_file(new_config)

  local hash = {}

  hash[old_content] = false
  hash[new_content] = true

  -- current version of "plugins.lua" is same
  -- as archived one. Do nothing!
  --
  if hash[old_content] then return end

  vim.loop.fs_copyfile(new_config, old_config)

  window_shutter = vim.api.nvim_create_autocmd(
     "User",
    {
      pattern = "PackerComplete",
      callback = close_packer_window,
    }
  )

  packer.startup(packer_config)

  vim.cmd 'PackerSync'
end

local init_packer = function()
  -- =======================================
  -- Have packer use a popup window
  --
  packer.init {
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
  }

  packer.startup(packer_config)

  local group = create_augroup('PackerUserConfigSync', {})

  create_autocmd(
    "BufWritePost",
    {
      pattern  = 'plugins.lua',
      group    = group,
      callback = function()
        require('plenary.reload').reload_module('user.initialize.plugins')
        require('user.initialize.plugins').sync()
      end
    }
  )

  sync_packer()
end


local M = {}

M.setup = init_packer
M.sync  = sync_packer

return M

