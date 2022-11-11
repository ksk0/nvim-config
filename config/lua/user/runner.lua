local parser_ok, parser = pcall(require, "toml")
if not parser_ok then
  vim.notify('There is no "toml" parser module installed')
  return
end

local extend_env_var = function (name, path, separator, prepend)
  separator = separator or ":"

  if not vim.env[name] then
    vim.env[name] = path
    return
  end

  local paths = vim.split(vim.env[name], separator)

  if not vim.tbl_contains(paths, path) then
    if prepend then
      vim.env[name] = path .. separator .. vim.env[name]
    else
      vim.env[name] = vim.env[name] .. separator .. path
    end
  end
end

local append_to_env_var = function (name, path, separator)
  extend_env_var (name, path, separator)
end

local prepend_to_env_path = function (name, path, separator)
  extend_env_var (name, path, separator, true)
end


local abs_path = function (path, root)
  if path == "" then
    return
  elseif path:sub(1,1) == "/" then
    return path
  else
    return (root or vim.fn.getcwd()) .. "/" .. path
  end
end

local project_config = function (root)
  local search_path = (root or vim.fn.getcwd()) .. ";/"
  local config_file = vim.fn.findfile('pyproject.toml', search_path)

  if config_file == "" then
    vim.notify("There is no project file")
    return
  end

  vim.notify ("project file: " .. config_file)

  local file = io.open(config_file, "r")

  if not file then
    vim.notify("Failed to open project file")
    return
  end

  local config = parser.decode(file:read("*a"))

  file:close()

  local project_file = abs_path(config_file, root)
  local project_dir = vim.fs.dirname (project_file)

  config._project_file = project_file
  config._project_dir  = project_dir

  return config
end


local M = {}

M.setup = function()
  vim.cmd [[
    if !exists(':Runner')
      command Runner lua require("user.runner").init()
    endif
  ]]

end


M.init = function()
  local project = project_config(vim.fn.getcwd())

  if not project or not project.tool or not project.tool.runner then
    vim.notify("There is NO config")
    return
  end

  vim.notify("Full config is: " .. vim.inspect(project))

  local config = project.tool.runner
  vim.notify("Runner config is: " .. vim.inspect(config))

  if not config.pythonPaths then
    return
  end

  for _,path in pairs(config.pythonPaths) do
    vim.notify ("Adding path: " .. path)
    append_to_env_var("PYTHONPATH", project._project_dir .. "/" .. path)
  end

  vim.notify ("Python path: " .. tostring(vim.env.PYTHONPATH))

end

return M
