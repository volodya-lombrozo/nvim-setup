vim.opt.nu = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.scrolloff = 8

vim.opt.updatetime = 750

vim.opt.wrap = false

vim.g.mapleader = " "


vim.opt.cursorline = true
vim.opt.cursorcolumn = true

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("highlight CursorLine ctermbg=238 guibg=#3a3a3a")
  end,
})
