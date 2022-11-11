local M

M.on_attach = function (client)
  client.server_capabilities.documentFormattingProvider = false
end

return M
