local config = {
  parameter_1 = 101,
  parameter_2 = 102,
  parameter_3 = 103,
  parameter_4 = 104,
  group_1 = {
    g_param_1 = 2001,
    g_param_2 = 2002,
    g_param_3 = 2003,
    g_param_4 = 2004,
    group_1_2 = {
      g_pp_11 = 21001,
      g_pp_12 = 21002,
      g_pp_13 = 21003,
      g_pp_14 = 21004,
    }
  },
  group_2 = {
    g_param_1 = 2001,
    g_param_2 = 2002,
    g_param_3 = 2003,
    g_param_4 = 2004,
    group_1_2 = {
      g_pp_11 = 21001,
      g_pp_12 = 21002,
      g_pp_13 = 21003,
      g_pp_14 = 21004,
    }
  }
}

local config_2 = {
  parameter_1 = 101,
  parameter_4 = 104,
  group_1 = {
    g_param_4 = 2004,
    group_1_2 = {
      g_pp_14 = 21004,
    }
  },
  group_2 = {
    g_param_4 = 2004,
    group_1_2 = {
      g_pp_14 = 21004,
    }
  },
  window = {
    size = "80",
    pos = "nesto",
  }
}

require("flexy-files"):setup(config_2)

vim.cmd [[nnoremap <silent> <C-]> :lua FlexyFiles:exec("focus")<CR>]]
vim.cmd [[nnoremap <silent> <C-o> :lua FlexyFiles:exec("show")<CR>]]
-- vim.cmd [[nnoremap <silent> <C-p> :lua FlexyFiles:exec("hide")<CR>]]
vim.cmd [[nnoremap <silent> <C-t> :lua FlexyFiles:exec("toggle")<CR>]]
