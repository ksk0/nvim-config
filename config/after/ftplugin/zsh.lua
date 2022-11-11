local buffer_options = {
  expandtab  = false,      -- do not convert tabs to spaces
  shiftwidth = 2,          -- the number of spaces inserted for each indentation
  tabstop    = 2,          -- insert 4 spaces for a tab
}

local window_options = {
  foldnestmax = 1,         -- max sublevels of fold
  foldmethod  = "syntax",  -- fold by syntax
}

for k, v in pairs(buffer_options) do
  vim.bo[k] = v
end

for k, v in pairs(window_options) do
  vim.wo[k] = v
end
