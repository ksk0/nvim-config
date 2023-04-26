local M = {}

M.settings = {
  python = {
    analysis = {
      typeCheckingMode = "off",
    },
  },
}

M.on_attach = function (client)
  -- ===================================
  -- Do not format using LSP.
  --
  client.server_capabilities.documentFormattingProvider = false
end


return M
