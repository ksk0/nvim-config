local status_ok, notify = pcall(require, "notify")
if not status_ok then
	return
end

notify.setup({
  timeout = 500,
  stages = "slide",
})

vim.notify = notify
