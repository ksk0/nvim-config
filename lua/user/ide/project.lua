local ok, ptools = pcall(require, "project-tools")
if not ok then return  end

local project = ptools:load()
if not project then return  end

project:setup()
