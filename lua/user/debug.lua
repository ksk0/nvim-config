local set_keymap = vim.keymap.set
local api = vim.api

local altmodes  = require("alt-modes")
local ptools    = require("project-tools")
local normal    = require("alt-modes.native.normal")
local dap       = require("dap")
local widgets   = require("dap.ui.widgets")
local cmd_after = dap.listeners.after



-- =============================================
-- widget functions
--
wg = {}
wg.scopes = widgets.sidebar(widgets.scopes, {width = 50})
wg.values = widgets.sidebar(widgets.expression, {width = 50})

local show_scopes = function ()
  vim.notify('Showing scopes')
  widgets.centered_float(widgets.scopes,{width = 50})
end

-- =============================================
-- start/stop debugging
--
local enter_buffer_debug_mode = function(buffer)
  altmodes:enter('debug', buffer)
end

local exit_buffer_debug_mode = function(buffer)
  altmodes:exit(buffer)
end

local exit_debug_mode = function()
  ptools:unfollow(exit_buffer_debug_mode)
end

local enter_debug_mode = function()
  local opts = {
    enter = {
      action = enter_buffer_debug_mode
    }
  }

  ptools:follow(opts)
end


-- =============================================
-- worker functions
--
local breakpoints_restorer = function (points)
  return function(_, body)
    vim.notify("breakpoints restorer: "  .. tostring(body.reason))

    if body.reason ~= 'breakpoint' then return end

    cmd_after['event_stopped']['run-to-cursor'] = nil
    vim.notify('Restoring break points')

    local bpt = require('dap.breakpoints')
    local buffs = vim.tbl_keys(points)

    bpt.clear()

    for _,buf in pairs(buffs) do
      for _, bp in pairs(points[buf]) do
        local line = bp.line
        bpt.set({}, buf, line)
      end
    end

    print("Points 2:" .. vim.inspect(bpt.get()))
  end

end

local run_to_cursor = function ()
  if dap.session() then
    vim.notify("Running to the cursor")
    dap.run_to_cursor()

    return
  end

  local bpt = require('dap.breakpoints')
  local points = bpt.get()

  cmd_after['event_stopped']['run-to-cursor'] = breakpoints_restorer(points)

  print("Points 1:" .. vim.inspect(points))

  bpt.clear()
  dap.set_breakpoint()
  dap.continue()

end

local goup = function()
  vim.notify("Going up")
  dap.up()
end

local godown = function ()
  vim.notify("Going down")
  dap.down()
end


-- =============================================
-- initialize
--
local modes = {}

modes.debug = {
  name = 'DEBUG',
  mode = 'n',
  exit = "",
  help = "hh",

  timeout = 200,

  overlay = {
    keep = {
      native = {
        ":",
        normal.movement,
        normal.scroll,
        normal.folding,
      }
    },
  },

  keymaps = {
    -- ======================================
    -- exit debug mode
    --
    {
      {
        lhs  = '<C-D>',
        rhs  = exit_debug_mode,
        desc = 'exit debug mode',
      },
    },

    -- ======================================
    -- breakpoints
    --
    {
      {
        lhs  = '<C- >',
        rhs  = dap.toggle_breakpoint,
        desc = 'breakpoint - toggle',
      },
    },

    -- ======================================
    -- start/continue/setep/run to cursor
    --
    {
      {
        lhs  = '<F5>',
        rhs  = dap.continue,
        desc = 'start/continue',
      },
      {
        lhs  = '<C-P>',
        rhs  = run_to_cursor,
        desc = 'run to cursor',
      },
      {
        lhs  = '<C-J>',
        rhs  = dap.step_over,
        desc = 'step over',
      },
    },

    -- ======================================
    -- moving around stacktrace
    --
    {
      {
        lhs  = '<M-j>',
        rhs  = godown, -- dap.down,
        desc = 'go down',
      },
      {
        lhs  = '<M-k>',
        rhs  = goup, --dap.up,
        desc = 'go up',
      },
      {
        lhs  = '<C-L>',
        rhs  = dap.step_into,
        desc = 'step into',
      },
      {
        lhs  = '<C-H>',
        rhs  = dap.step_out,
        desc = 'step out',
      },
    },

    -- ======================================
    -- widgets
    --
    {
      {
        lhs  = 'K',
        rhs  = wg.scopes.toggle,
        desc = 'view scopes',
      },
      {
        lhs  = 'I',
        rhs  = wg.values.toggle,
        desc = 'view expressions',
      },
    },

    -- ======================================
    -- This help
    --
    {
      {
        lhs  = 'g?',
        rhs = ':lua require("alt-modes"):help()<CR>',
        desc = 'Show this help 1',
      },
      {
        lhs  = 'gg',
        rhs = ':lua require("alt-modes"):help()<CR>',
        desc = 'Show this help 2',
      },
    },
  },
}

local init = function()
  local opts = {
    noremap = true,
    silent = true
  }

  set_keymap("n", "<C-D>", enter_debug_mode, opts)

  altmodes:add('debug', modes.debug)
end

init()


-- =============================================
-- user commands
--
api.nvim_create_user_command("DebugShowScopes", show_scopes, {})


