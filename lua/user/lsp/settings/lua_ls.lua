local M = {}

M.settings = {
  Lua = {
    diagnostics = {
      globals = { "vim", "bit", "describe", "it" },
    },
    workspace = {
      library = {
        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        [vim.fn.stdpath("config") .. "/lua"] = true,
      },
    },
  },
}

M.on_attach = function (client)
  -- ===================================
  -- Do not format not syntax highlight
  -- using LSP.
  --
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.semanticTokensProvider = false
end


return M
