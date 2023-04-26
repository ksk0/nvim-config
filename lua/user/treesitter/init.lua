local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

local languages_ok, languages = pcall(require, "user.treesitter.languages")
if not languages_ok then
  languages = {}
end

configs.setup{
  ensure_installed = languages,
  ignore_install = {},

  highlight = {
    enable = true,      -- false will disable the whole extension
    disable = {"css"},  -- list of language that will be disabled
  },

  autopairs = {
    enable = true,
  },

  indent = {
    enable = true,
    disable = { "python", "css" }
  },
}

