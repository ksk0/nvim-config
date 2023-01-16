local M = {}

M.settings = function(callback, config)
  callback({ type = 'server', host = "127.0.0.1", port = 8086 })
end

--   {
--     type = 'server',
--     host = "127.0.0.1",
--     port = 8086
--   },
-- }


M.config = {
  {
    type = 'lua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  },
}

return M
