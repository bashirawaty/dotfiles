local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.cursorline = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.clipboard = "unnamedplus"

-- macOS Python host (Homebrew)
if vim.fn.has("mac") == 1 then
  vim.g.python3_host_prog = "/opt/homebrew/bin/python3"
elseif vim.fn.has("unix") == 1 then
  vim.g.python3_host_prog = "/usr/bin/python3"
end

