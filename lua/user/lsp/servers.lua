local lsp_servers = {
  -- ==========================================================================
  --  formatters
  -- 
  --  black               -- python formatter
  --  blue                -- python formatter (alternative to black)
  --  shfmt               -- A shell formatter (sh/bash/mksh)
  --  prettierd           -- formatter for many languages
  --  luaformatter        -- lua formatter


  -- ==========================================================================
  --  linters
  -- 
  "pyright",              -- Static type checker for Python (by Microsoft)
  "python-lsp-server",    -- fork of the python-language-server project,
                          -- maintained by the Spyder IDE team and the community
  "shellcheck",           -- static analysis tool for shell scripts


  -- ==========================================================================
  --  language servers
  -- 
  "awk-language-server",
  "bash-language-server",
  "lua-language-server",
  "yaml-language-server",
  "dockerfile-language-server",
  "json-lsp",
  "taplo",                        -- TOML language server
  "lemminx",                      -- XML language server
}


local servers_list = function ()
  local servers = {}
  local mappings = require("mason-lspconfig.mappings.server").package_to_lspconfig

  for _,mason_server in ipairs(lsp_servers) do
    table.insert(servers, mappings[mason_server])
  end

  return servers
end

return servers_list()
