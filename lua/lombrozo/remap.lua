vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pp", vim.cmd.Ex)
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
vim.keymap.set("n", "<S-Tab>", "<C-^>", { noremap = true, silent = true, desc = "Toggle alternate file" })
vim.keymap.set("v", "<C-c>", "\"+y", {  desc = "Copy to clipboard" })
vim.keymap.set("v", "<C-v>", "\"+p", {  desc = "Past from clipboard" })

