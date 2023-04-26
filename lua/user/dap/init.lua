require "user.dap.dap-ui"
require "user.dap.adapters"
require "user.dap.keymaps"


-- ============================================================================
-- Set icons for some debugign "points/stages"
--
vim.fn.sign_define('DapBreakpoint', {text='', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='', texthl='', linehl='', numhl=''})
