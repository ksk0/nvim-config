local opts = { noremap = true, silent = true }


-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =================================================
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
-- =================================================

-- =================================================
-- Insert Mode keymaps                             =
-- =================================================

keymap("i", "<C-H>", "<Left>", opts)    -- move cursor left while in insert mode
keymap("i", "<C-L>", "<Right>", opts)   -- move cursor right while in insert mode

-- =================================================
-- Normal Mode keymaps                             =
-- =================================================

-- Toggel NvimTree (CTRL + ])
--
keymap("n", "<C-]>", ":NvimTreeToggle<CR>", opts)


-- open Trouble
keymap("n", "T", ":TroubleToggle document_diagnostics<CR>", opts)

-- open/close windows
-- keymap ("n", "<A-q>/", ":vsplit<CR>", opts)
-- keymap ("n", "<A-q>v", ":vsplit<CR>", opts)
-- keymap ("n", "<C-v>",  ":vsplit<CR>", opts)
-- keymap ("n", "<C-h>",  ":split<CR>", opts)



-- reload folding
-- keymap ("n", "<A-f>", ':set foldmethod=indent<CR>:set foldmethod=expr<CR>:echo "Folding refreshed"', opts)
keymap ("n", "<A-f>", ':set nofoldenable | set foldmethod=indent | set foldmethod=expr | set foldenable | echo "Folding refreshed"<CR>', opts)
-- keymap ("n", "<A-f>", ":set foldmethod=indent<CR>", opts)


-- yank line
keymap ("n", "Y", "yy", opts)

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
-- keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
-- keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
-- keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
-- keymap("v", "<", "<gv", opts)
-- keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
-- keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
-- keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- local term_opts = { silent = true }
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- use <Up> and <Down> arrows for command line completion
--
vim.cmd [[cnoremap <expr> <Up>   wildmenumode() ? "<C-P>" : "<Up>"]]
vim.cmd [[cnoremap <expr> <Down> wildmenumode() ? "<C-N>" : "<Down>"]]

-- Indent selected lines
--
keymap("v", "<C-L>",  ">><esc>gv", opts)
keymap("v", "<C-H>",  "<<<esc>gv", opts)
