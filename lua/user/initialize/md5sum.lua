local fn = vim.fn

local M = {}

M.string = function(sum_string)
  return fn.system('md5sum',sum_string):gsub(" .*","")
end

M.list= function(sum_list)
  local list = vim.deepcopy(sum_list)
  table.sort(list)
  return M.string(fn.join(list," "))
end

M.table= function(sum_table)
  return M.list(vim.tbl_keys(sum_table))
end

M.file = function (sum_file)
  return fn.system({'md5sum',sum_file}):gsub(" .*","")
end


return M
