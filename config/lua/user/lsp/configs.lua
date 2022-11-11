local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	return
end

local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_ok then
	return
end

local servers_ok, servers = pcall(require, "user.lsp.servers")
if not servers_ok then
	servers = {}
end

mason.setup()
mason_lspconfig.setup{
  ensure_installed = servers
}

-- local installer_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
-- if not installer_ok then
-- 	return
-- end


-- lsp_installer.setup {
--   ensure_installed = servers
-- }

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
