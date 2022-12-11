local config_root = vim.fn.stdpath('config') .. "/"

return {
  hashes       = config_root .. ".hashes",
  plugins      = config_root .. "lua/user/plugins.lua",
  packages     = config_root .. "lua/user/initialize/packages.lua",
  lsp_servers  = config_root .. "lua/user/lsp/servers.lua",
  ts_languages = config_root .. "lua/user/treesitter/languages.lua",
}
