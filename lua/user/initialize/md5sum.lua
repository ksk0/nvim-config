local fn = vim.fn

local M = {}

M.string = function(sum_table)
  local sum_list = vim.tbl_keys(sum_table)
  table.sort(sum_list)
  local sum_string = fn.join(sum_list," ")

  return fn.system('md5sum',sum_string):gsub(" .*","")
end

return M
