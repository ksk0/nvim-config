
local mason_lspconfig = require("mason-lspconfig")
local lspconfig       = require("lspconfig")
local servers         = require("user.lsp.servers")

mason_lspconfig.setup{ensure_installed = servers}

-- =======================================================================
-- as part of init proces, each LSP server will be configured using
-- "nvim-lspconfig" plugin. As part of that phase, "setup" function
-- will be run for each LSP server. Custom configuration will be passed
-- to "setup" function.
--
-- =======================================================================
-- Config for handlers is given in separate file
--
local H = require("user.lsp.handlers")

-- some general setup for handlers. Common to all
-- LSP servers.
--
H.setup()

local basic_opts = {
  on_attach = H.on_attach,
  capabilities = H.capabilities,
}


-- =======================================================================
-- for each server, call setup function. Pass it custom configuration.
--
for _, server in pairs(servers) do
  local opts = {}
	local custom_config, server_config = pcall(require, "user.lsp.settings." .. server)

	if custom_config and server_config.settings then
	 	opts.settings = server_config.settings
	 	opts = vim.tbl_deep_extend("force", opts, basic_opts)
	end

	lspconfig[server].setup(opts)
end
