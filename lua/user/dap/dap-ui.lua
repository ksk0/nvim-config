local dapui = require('dapui')

dapui.setup()

local options = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>D', ':lua require("dapui").toggle()<CR>', options)
