local dapui = require('dapui')

local config = {
  icons = {
    expanded = "",
    collapsed = "",
    current_frame = ""
  },

  controls = {
    enabled = vim.fn.exists("+winbar") == 1,
    element = "repl",
  },

  layouts = {
    -- ============================
    -- On the left side show:
    --   scopes
    --   breakpoints
    --   stacks
    --   watches
    --
    {
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
    },

    -- ============================
    -- On the bottom show console
    -- 
    {
      elements = { {
          id = "console",
          size = 1.0
        } },
      position = "bottom",
      size = 15
    },

    -- ============================
    -- On the right side show REPL
    -- 
    {
      elements = { {
          id = "repl",
          size = 1.0
        } },
      position = "right",
      size = 80
    },
  },
}

dapui.setup(config)
