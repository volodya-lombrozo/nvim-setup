vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.class",
  callback = function()
    local file = vim.fn.expand("%:p")
    vim.cmd("%!javap -v -p " .. vim.fn.shellescape(file))
    vim.bo.filetype = "java" -- syntax highlighting for the output
  end
})

