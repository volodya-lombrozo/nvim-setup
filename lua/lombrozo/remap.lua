vim.g.mapleader = " "
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
vim.keymap.set("n", "<leader>ee", vim.diagnostic.open_float)
vim.keymap.set("n", "<S-Tab>", "<C-^>", { noremap = true, silent = true, desc = "Toggle alternate file" })
vim.keymap.set("v", "<C-c>", "\"+y", {  desc = "Copy to clipboard" })
vim.keymap.set("v", "<C-v>", "\"+p", {  desc = "Past from clipboard" })
vim.keymap.set("n", "<leader>y", ":%y<CR>", {  desc = "Yank the entire file" })
vim.keymap.set("v", "<leader>y", ":%y<CR>", {  desc = "Yank the entire file" })
vim.keymap.set("n", "<leader>Y", ":%y+<CR>", {  desc = "Yank the entire file to the system clipboard" })
vim.keymap.set("v", "<leader>Y", '"+y', {  desc = "Yank selection to clipboard" })

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode with jk" })

vim.keymap.set("n", "<leader>tt", function() require("neotest").run.run() end)
vim.keymap.set("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end)
vim.keymap.set("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end)
vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, { desc = "Run all tests in the project" })

vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = false }) end, { buffer = bufnr, desc = "Format file with LSP" })
vim.keymap.set("n", "<leader>oo", function()
  vim.lsp.buf.format({ async = false })
  vim.lsp.buf.code_action({
    context = { only = { "source.organizeImports" } },
    apply = true,
  })
end, { desc = "Format and organize imports" })

vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("w") -- Save the file
  vim.cmd("!echo '' && go run %")
end, { desc = "Run Go file" })

vim.keymap.set('n', '<C-j>', '<Plug>MoveLineDown', {})
vim.keymap.set('n', '<C-k>', '<Plug>MoveLineUp', {})
vim.keymap.set('v', '<C-j>', '<Plug>MoveBlockDown', {})
vim.keymap.set('v', '<C-k>', '<Plug>MoveBlockUp', {})

vim.keymap.set("n", '<leader>ip', ':InspectTree<CR>', { desc = 'Inspect Treesitter Tree' })
vim.keymap.set("n", '<leader>eq', ':EditQuery<CR>', { desc = 'Edit Treesitter Query' })
