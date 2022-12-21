local fn = vim.fn


local M = {}

local function flatten(item, prefix, extension)
  if extension and type(extension) ~= "number" then
    if prefix then
      prefix = prefix .. ":" .. extension
    else
      prefix = extension
    end
  end

  local pfx = ""

  if prefix then
    pfx = prefix .. ":"
  end

  if type(item) ~= "table" then
    return {pfx .. tostring(item)}
  end

  local list = {}

  for k,v in pairs(item) do
    list = vim.fn.extend(list, flatten(v,prefix,k))
  end

  return list
end

M.string = function(sum_string)
  return fn.system('md5sum',sum_string):gsub(" .*","")
end

M.list= function(sum_list)
  local list = vim.deepcopy(sum_list)
  table.sort(list)
  return M.string(fn.join(list," "))
end

M.table= function(sum_table)
  if vim.tbl_islist(sum_table) then
    return M.list(sum_table)
  else
    return M.list(flatten(sum_table))
  end
end

M.file = function (sum_file)
  return fn.system({'md5sum',sum_file}):gsub(" .*","")
end


return M
