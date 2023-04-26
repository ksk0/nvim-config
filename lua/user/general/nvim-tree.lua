-- Only run setup if "nvim-tree" is installed
--
local nvim_tree = require("nvim-tree")

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.del('n', '<C-]>', {buffer = bufnr})
end

-- Use same higlighting of the NvimTree window as Normal higlighting
--
vim.cmd [[ 
  :hi clear NvimTreeNormal
  :hi clear NvimTreeEndOfBuffer
  :hi clear NvimTreeVertSplit
]]

local glyphs = {
  default = "",
  symlink = "",
  git = {
    unstaged = "",
    staged = "",
    unmerged = "",
    renamed = "󰑕",
    deleted = "✗",
    untracked = "",
    ignored = "",

    -- staged = "✓",
    -- unstaged = "北",
    -- unstaged = "",
    -- deleted = "",
    -- deleted = "",
    -- untracked = "",
    -- untracked = "",
    -- untracked = "U",
    -- ignored = "◌",
  },

  folder = {
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
  },
}

nvim_tree.setup {
  on_attach = on_attach,

  remove_keymaps = {
  },

  renderer ={
    icons = {
      glyphs = glyphs
    }
  },
}

