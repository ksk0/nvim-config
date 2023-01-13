local project_ok, project = pcall(require, "project-tools")
if not project_ok then
  return
end

project:setup()
