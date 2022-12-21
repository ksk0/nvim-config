local M = {}

M.pass = function()
  local start_t

  return function(message)
    if not start_t then
      start_t = os.clock()
      return
    end

    local curr_t = os.clock()
    local diff = (curr_t - start_t)

    print(string.format("%20s: %6.3f sec\n", message, diff))

    start_t = curr_t
  end
end

M.total = function ()
  local start_t

  return function(message)
    if not start_t then
      start_t = os.clock()
      return
    end

    local curr_t = os.clock()
    local diff = (curr_t - start_t)

    print(string.format("%20s: %6.3f sec\n", message, diff))
  end
end

return M
