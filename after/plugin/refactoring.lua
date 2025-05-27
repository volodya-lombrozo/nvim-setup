require('refactoring').setup()

vim.keymap.set({ "n", "x" }, "<leader>ef", function() return require('refactoring').refactor('Extract Function') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>eff", function() return require('refactoring').refactor('Extract Function To File') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>ev", function() return require('refactoring').refactor('Extract Variable') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>ii", function() return require('refactoring').refactor('Inline Function') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>iv", function() return require('refactoring').refactor('Inline Variable') end, { expr = true })

vim.keymap.set({ "n", "x" }, "<leader>eb", function() return require('refactoring').refactor('Extract Block') end, { expr = true })
vim.keymap.set({ "n", "x" }, "<leader>ebf", function() return require('refactoring').refactor('Extract Block To File') end, { expr = true })
