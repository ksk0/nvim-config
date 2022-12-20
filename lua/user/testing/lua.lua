local M = {}

local api = vim.api
local project

M.run = function ()
  local tool = project.config.tool
  local root = project.root .. "/"

  local test_dir   = root .. tool.tests.dir
  local opts = {}

  opts.minimal_init = root .. tool.tests.init
  opts.sequential   = tool.tests.sequential or true

  local harness = require("plenary.test_harness")

  harness.test_directory(test_dir, opts)
end

M.setup = function(pr_data)
  project = pr_data

  return M.run
end

return M
