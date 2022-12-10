-- Only run setup if "nvim-tree" is installed
--
local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end


local tree_cb = nvim_tree_config.nvim_tree_callback

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
    renamed = "➜",
    deleted = "✗",
    untracked = "",
    -- untracked = "",
    ignored = "",
  },

    -- staged = "✓",
    -- unstaged = "北",
    -- unstaged = "",
    -- deleted = "",
    -- deleted = "",
    -- untracked = "",
    -- untracked = "",
    -- untracked = "U",
    -- ignored = "◌",

  folder = {
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
  },
}

nvim_tree.setup {
  remove_keymaps = {
    "<C-]>" -- disable "CTRL + ]" since it is used for toggleing nvim-tree
  },

  renderer ={
    icons = {
      glyphs = glyphs
    }
  },
}

do return end


-- glyphs = {}

nvim_tree.setup {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {
    "startify",
    "dashboard",
    "alpha",
  },
  -- auto_close = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  -- update_to_buf_dir = {
    -- enable = true,
    -- auto_open = true,
  -- },
  renderer ={
    icons = {
      glyphs = glyph_icons
    }
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  filters = {
    dotfiles = false,
    custom = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },

  remove_keymaps = {
    "<C-]>"
  },

  view = {
    width = 30,
    height = 30,
    hide_root_folder = false,
    side = "left",
    -- auto_resize = true,
    mappings = {
      custom_only = false,
      list = {
        { key = { "<CR>", "o" }, cb = tree_cb "edit" },
        { key = { "l" }, cb = ":KskTools nvim-tree node_toggle<CR>"},
        -- { key = { "k" }, cb = ":KskTools nvim-tree node_show<CR>"},
        { key = { "m" }, cb = ":KskTools nvim-tree node_info<CR>"},
        { key = "h", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
      },
    },
    number = false,
    relativenumber = false,
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  -- quit_on_open = 0,
  -- git_hl = 1,
  -- disable_window_picker = 0,
  -- root_folder_modifier = ":t",
  -- show_icons = {
  --   git = 1,
  --   folders = 1,
  --   files = 1,
  --   folder_arrows = 1,
  --   tree_width = 30,
  -- },
}
