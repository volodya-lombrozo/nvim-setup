return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")

    -- Make LSP completions work with nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Set up gopls for Go
    lspconfig.gopls.setup({
      capabilities = capabilities,
    })
  end
}

