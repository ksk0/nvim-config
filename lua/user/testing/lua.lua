local M = {}
local project_data

M.run = function ()
  local project = project_data

  print(vim.inspect(project))

  if not project then return end

  local tool = project.config.tool
  local root = project.root .. "/"

  local test_dir   = root .. tool.tests.dir
  local opts = {
    sequential = true
  }

  if tool.tests.init then
    opts.minimal_init = root .. tool.tests.init
  end

  if tool.tests.sequential then
    opts.sequential = tool.tests.sequential or true
  end

  local harness = require("plenary.test_harness")

  harness.test_directory(test_dir, opts)
end

M.setup = function(pr_data)
  project_data = pr_data
  return M.run
end

return M
