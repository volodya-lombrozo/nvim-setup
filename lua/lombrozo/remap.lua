vim.g.mapleader = " "
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { noremap = true, silent = true })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP Rename" })
vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code Action' })
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting the default register" })
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
vim.keymap.set("n", "<leader>ta", function() require("neotest").run.run({ suite = true }) end, { desc = "Run all tests in the project" })
vim.keymap.set("n", "<leader>td", function() require("neotest").run.run(vim.fn.expand("%:p:h")) end, { desc = "Run all tests in the directory" })
-- vim.keymap.set("n", "<leader>td", function() require("neotest").run.run({suite = true, adapter = "neotest-ruby-minitest" }) end, { desc = "Run all tests in the directory" })
vim.keymap.set("n", "<leader>rl", function() 
    require("lazy.core.loader").reload("neotest-ruby-minitest") 
    vim.notify("Reloaded neotest-ruby-minitest", vim.log.levels.INFO)
end, { desc = "Reload neotest-ruby-minitest plugin" })
vim.keymap.set("n", "<leader>lf", function() vim.lsp.buf.format({ async = false }) end, { desc = "Format file with LSP" })
vim.keymap.set("n", "<leader>fl", function()
  local current_line = vim.fn.line(".")
  local current_col = vim.fn.col(".")
  local winview = vim.fn.winsaveview()
  vim.cmd("normal! gg=G")
  vim.fn.cursor(current_line, current_col)
  vim.fn.winrestview(winview)
end, { desc = "Format file with default formatter" })
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

-- Move lines up and down with Alt+J/K
vim.keymap.set('n', '<S-j>', '<Plug>MoveLineDown', {})
vim.keymap.set('v', '<S-j>', '<Plug>MoveBlockDown', {})
vim.keymap.set('n', '<S-k>', '<Plug>MoveLineUp', {})
vim.keymap.set('v', '<S-k>', '<Plug>MoveBlockUp', {})

-- Navigate between windows using Ctrl+hjkl
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to down window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to up window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

vim.keymap.set("n", '<leader>ip', ':InspectTree<CR>', { desc = 'Inspect Treesitter Tree' })
vim.keymap.set("n", '<leader>eq', ':EditQuery<CR>', { desc = 'Edit Treesitter Query' })

vim.keymap.set("n", "<leader>tl", function()
  vim.cmd("e " .. vim.fn.stdpath("state") .. "/neotest.log")
end, { desc = "Open Neotest log file" })

vim.keymap.set("n", "<leader>va", "ggVG", { desc = "Select all" })
