local map = vim.keymap.set

vim.g.mapleader = " "

-- File explorer
map("n", "<leader>e", ":Ex<CR>")

-- Save / Quit
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")

-- Better navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
