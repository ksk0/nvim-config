local api = vim.api
local pt = require ("project-tools")
local project = pt.config.load()

print(vim.inspect(project))

local test_runner
local ok_tester,tester = pcall (require, "user.testing." .. project.lang)

if ok_tester then
  test_runner = tester.setup(project)
else
  test_runner = function () print("There is no lang " .. project.lang) end
end

api.nvim_create_user_command("RunTests", test_runner, {})




