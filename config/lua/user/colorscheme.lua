local status_ok, scheme = pcall(require, 'onedark')

if status_ok then
	scheme.setup {style = 'darker'}
  scheme.load()
else
	vim.cmd [[
	  colorscheme default
	  set background=dark
	]]
end

