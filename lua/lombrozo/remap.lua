vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set("n", "<S-Tab>", "<C-^>", { noremap = true, silent = true, desc = "Toggle alternate file" })

