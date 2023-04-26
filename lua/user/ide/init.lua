local MODULES = {
  "autopairs",
  "comment",
  "completion",
  "gitsigns",
  "indentline",
  "project",
}

for _,module in ipairs(MODULES) do
  require("user.ide." .. module)
end
