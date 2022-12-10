local dap = require('dap')


local dap_adapters = function ()
  local adapters_dir = vim.fn.stdpath("config") .. "/lua/user/dap/adapters"
  local adapter_paths = vim.split(vim.fn.glob(adapters_dir .. '/*.lua'), '\n')

  local adapters = {}

  for _, full_path in pairs(adapter_paths) do
    local language = full_path:gsub('^' .. adapters_dir .. '/',"")
    language = language:gsub('%.lua$',"")

    if language ~= "init" then
      table.insert(adapters, language)
    end
  end

  return adapters
end

-- =============================================================
-- setup adapter for every language in dap/adapters directory
--
for _, language in pairs(dap_adapters()) do
  local adapter = require("user.dap.adapters." .. language)

  dap.adapters[language] = adapter.settings
  dap.configurations[language] = adapter.config
end


