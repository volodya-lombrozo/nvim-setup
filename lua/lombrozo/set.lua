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

vim.opt.number = true
vim.opt.relativenumber = true

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#3a3a3a" })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "#3a3a3a", fg = "#c0caf5" })
        vim.api.nvim_set_hl(0, "Visual", { bg = "#8a8a8a", fg = "NONE" })
    end,
})

vim.opt.colorcolumn = "80"
