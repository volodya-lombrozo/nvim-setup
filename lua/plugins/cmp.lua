return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP source
      "hrsh7th/cmp-buffer",      -- buffer source
      "hrsh7th/cmp-path",        -- path source
      "hrsh7th/cmp-cmdline",     -- cmdline source
      "saadparwaiz1/cmp_luasnip" -- Snippet completions
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        preselect = cmp.PreselectMode.None,
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
          ['<C-k>'] = cmp.mapping(function(fallback)
            if not cmp.visible() then
              vim.lsp.buf.signature_help()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "copilot" },
          { name = "nvim_lsp" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
