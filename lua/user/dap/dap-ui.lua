local dapui = require('dapui')

-- using obsolete icons, since my font awsame
-- is not updated
--
local config = {
  -- icons = {
  --   expanded = "",
  --   collapsed = "",
  --   current_frame = ""
  -- },

  controls = {
    enabled = vim.fn.exists("+winbar") == 1,
    element = "repl",

    -- icons = {
    --   pause = "",
    --   play = "", -- 
    --   -- play = "",
    --   step_into = "",
    --   step_over = "",
    --   step_out = "",
    --   step_back = "倫",
    --   run_last = "累",
    --   terminate = "",
    --   disconnect = "",
    -- },
  },

  layouts = { {
      elements = { {
          id = "scopes",
          size = 0.25
        }, {
          id = "breakpoints",
          size = 0.25
        }, {
          id = "stacks",
          size = 0.25
        }, {
          id = "watches",
          size = 0.25
        } },
      position = "left",
      size = 60
    }, {
      elements = { {
          id = "console",
          size = 1.0
        } },
      position = "bottom",
      size = 15
    }, {
      elements = { {
          id = "repl",
          size = 1.0
        } },
      position = "right",
      size = 80
    },
  },
}

local config_2 = {
    controls = {
      element = "repl",
      enabled = true,
      icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = ""
      }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      expanded = "",
      collapsed = "",
      current_frame = ""
    },
    layouts = { {
        elements = { {
            id = "scopes",
            size = 0.25
          }, {
            id = "breakpoints",
            size = 0.25
          }, {
            id = "stacks",
            size = 0.25
          }, {
            id = "watches",
            size = 0.25
          } },
        position = "left",
        size = 60
      }, {
        elements = { {
            id = "repl",
            size = 0.5
          }, {
            id = "console",
            size = 0.5
          } },
        position = "bottom",
        size = 10
      } },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  }

dapui.setup(config)

local options = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>D', ':lua require("dapui").toggle()<CR>', options)
