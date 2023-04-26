-- ==================================================================
-- For each DAP adapter ther will be config file in "adapters"
-- directory. List the files in directory to get the list of
-- required/configured adapters (ignore this file, i.e. "init.lua")
--
local dap_adapters = function ()
  local adapters_dir = debug.getinfo(2, "S").source:sub(2):match("(.*/)")
  local adapter_paths = vim.split(vim.fn.glob(adapters_dir .. '/*.lua'), '\n')

  local adapters = {}

  for _, full_path in pairs(adapter_paths) do
    local language = full_path:gsub('.*/', ''):gsub('%.lua$', '')

    if language ~= "init" then
      table.insert(adapters, language)
    end
  end

  return adapters
end


-- ==================================================================
-- Setup "mason-nvim-dap" to automaticaly download needed
-- adapters.
--
local adapters = dap_adapters()

require ('mason-nvim-dap').setup({
    ensure_installed = adapters,
    handlers = {}, -- sets up dap in the predefined manner
})


-- ==================================================================
-- Setup adapter for every language in dap/adapters directory
--
local dap = require('dap')

for _, language in pairs(adapters) do
  local adapter = require("user.dap.adapters." .. language)

  if adapter then
    dap.adapters[language] = adapter.settings
    dap.configurations[language] = adapter.config
  end
end

