-- =================================================================
--
--

-- Autocommand that reloads neovim whenever you save the plugins.lua file
--
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]


-- Have packer use a popup window
--
local packer = require("packer")

packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- ===============================================================
-- localy developed plugins
--

local indevelopment = {
  "/home/koske/develop/nvim/nvim-alt-modes",
  "/home/koske/develop/nvim/nvim-project-tools",
}

-- =================================================================
-- Install plugins
--
return packer.startup(function(use)

  -- ===============================================================
  -- My plugins here
  --
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used by lots of plugins

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
  use "rcarriga/nvim-notify" -- fancy notification manager (vim.notify command fancier)
  use "lewis6991/gitsigns.nvim" -- Git decoration of code (added, deleted, modified lines) 
  use "nvim-telescope/telescope.nvim" -- fuzzy finder over lists

  -- ===============================================================
  -- Neo-Tree - file system explorer
  --
  use {
    "nvim-neo-tree/neo-tree.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
  }


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
  -- Colorschemes
  --
  use "navarasu/onedark.nvim"

  -- ===============================================================
  -- TreeSitter plugin
  --
  use "nvim-treesitter/nvim-treesitter"

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
  use "williamboman/mason.nvim" -- replaces "nvim-lsp-installer" plugin
  use "williamboman/mason-lspconfig.nvim" -- bridge to "nvim-lspconfig"
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
  use "ksk0/nvim-bricks"

  for _,plugin in pairs(indevelopment) do
    if vim.fn.isdirectory(plugin) == 1 then
      use(plugin)
    end
  end
end)

