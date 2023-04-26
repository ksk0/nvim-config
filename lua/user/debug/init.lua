local set_keymap = vim.keymap.set
local loop = vim.loop
local api = vim.api

local altmodes  = require("alt-modes")
local ptools    = require("project-tools")
local normal    = require("alt-modes.native.normal")
local dap       = require("dap")
local bpt       = require('dap.breakpoints')
local cmd_after = dap.listeners.after
local dapui     = require('dapui')

local DEBUGGING
local OSV_RUNNING

-- =============================================
-- widget functions
--
local show_scopes = function ()
  dapui.float_element('scopes', {width = 60, enter = true})
end

local show_expressions = function ()
  dapui.float_element('watches', {width = 60, enter = true})
end

local show_terminal = function ()
  dapui.float_element('repl', {width = 80, height = 60, enter = true, position = 'center'})
end


-- =============================================
-- start/stop debugging
--
local filter_project_files = function (buffer)
  return (vim.fn.getbufvar(buffer,'&filetype') == ptools._lang)
end

local enter_buffer_debug_mode = function(buffer)
  altmodes:enter('debug', buffer)
end

local exit_buffer_debug_mode = function(buffer)
  altmodes:exit(buffer)
end

local exit_debug_mode = function()
  altmodes:unfollow(exit_buffer_debug_mode)
  dapui.close()

  DEBUGGING = false
end

local enter_debug_mode = function()
  local opts = {
    once = true,
    init = true,
    filter = filter_project_files,
    BufEnter = enter_buffer_debug_mode,
  }

  altmodes:follow(opts)
  dapui.open()

  DEBUGGING = true
end

local toggle_debugging = function()
  if DEBUGGING then
    exit_debug_mode()
  else
    enter_debug_mode()
  end
end


-- =============================================
-- worker functions
--
local debug_status = function()
  if dap.session() then
    return 'DEBUG (running)'
  else
    return 'DEBUG (stopped)'
  end
end

local tcp_error = function ()
  local error

  return function(err)
    print("In function")
    print("err: " .. vim.inspect(err) .. " error:" .. vim.inspect(error))

    if err then
      error = err
    else
      return error
    end
  end
end

local dap_continue = function ()
  dap.continue()
end

local breakpoints_restorer = function (points)
  return function(_, body)
    if body.reason ~= 'breakpoint' then return end

    cmd_after['event_stopped']['run-to-cursor'] = nil

    local buffs = vim.tbl_keys(points)

    bpt.clear()

    for _,buf in pairs(buffs) do
      for _, bp in pairs(points[buf]) do
        local line = bp.line
        bpt.set({}, buf, line)
      end
    end
  end
end

local run_to_cursor = function ()
  vim.notify("Running to cursor")

  if dap.session() then
    dap.run_to_cursor()

    return
  end

  local points = bpt.get()

  cmd_after['event_stopped']['run-to-cursor'] = breakpoints_restorer(points)

  bpt.clear()
  bpt.set()
  dap_continue()
end

local step_over = function ()
  local session = dap.session()

  if not session then
    run_to_cursor()
    return
  end

  -- print(vim.inspect(session))

  local sess_frame = session.current_frame

  if not sess_frame then
    dap.step_over()
    return
  end

  -- print(vim.inspect(sess_frame))

  local sess_path  = sess_frame.source.path
  local sess_line  = sess_frame.line

  local curr_path = api.nvim_buf_get_name(0)

  if curr_path ~= sess_path then
    run_to_cursor()
    return
  end

  local curr_poss = api.nvim_win_get_cursor(0)
  local curr_line = curr_poss[1]

  if (curr_line ~= sess_line) then
    run_to_cursor()
    return
  end

  -- print("C path: " .. curr_path)
  -- print("S path: " .. sess_path)
  --
  -- print("C line: " .. curr_line)
  -- print("S line: " .. sess_line)

  dap.step_over()
end

local go_up = function()
  vim.notify("Going up")
  dap.up()
end

local go_down = function ()
  vim.notify("Going down")
  dap.down()
end


-- =============================================
-- initialize
--:
local debug_keymaps = {
  name = 'DEBUG',
  mode = 'n',
  exit = "",
  help = "",
  status = debug_status,

  timeout = 200,

  overlay = {
    keep = {
      native = {
        ":",
        normal.movement,
        normal.scroll,
        normal.folding,
      },

      global = {"<C-D>", "<C-K>", "<M-t>"}
    },
  },

  keymaps = {
    -- ======================================
    -- start/continue/setep/run to cursor
    --
    {
      {
        lhs  = '<F5>',
        rhs  = dap_continue,
        desc = 'start/continue',
      },
      {
        lhs  = '<C-R>',
        rhs  = dap.restart,
        desc = 'restart',
      },
      {
        lhs  = '<C-X>',
        rhs  = dap.terminate,
        desc = 'terminate',
      },
    },
    {
      {
        lhs  = '<C-J>',
        rhs  = step_over,
        desc = 'step over/run to cursor',
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
    -- moving around stacktrace
    --
    {
      {
        lhs  = '<M-j>',
        rhs  = go_down, -- dap.down,
        desc = 'go down',
      },
      {
        lhs  = '<M-k>',
        rhs  = go_up, --dap.up,
        desc = 'go up',
      },
    },

    -- ======================================
    -- widgets
    --
    {
      {
        lhs  = 'S',
        rhs  = show_scopes,
        desc = 'view scopes',
      },
      {
        lhs  = 'W',
        rhs  = show_expressions,
        desc = 'view expressions',
      },
      {
        lhs  = 'T',
        rhs  = show_terminal,
        desc = 'show terminal',
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
    -- This help
    --
    {
      {
        lhs  = 'g?',
        rhs = ':lua require("alt-modes"):help()<CR>',
        desc = 'Show this help 1',
      },
    },
  },
}

local init = function()
  local opts = {
    noremap = true,
    silent = true
  }

  set_keymap("n", "<C-D>", toggle_debugging, opts)

  altmodes:add('debug', debug_keymaps)
end

init()


-- =============================================
-- user commands
--
-- api.nvim_create_user_command("DebugShowScopes", show_scopes, {})


