return {
  {
    "neovim/nvim-lspconfig",
    version = "v2.5.0",
    config = function()
      -- Make LSP completions work with nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.lsp.config.gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          capabilities = capabilities,
        },
      }
      vim.lsp.config.lua_ls = {
        settings = {
          capabilities = capabilities,
        }
      }
      vim.lsp.config.groovyls = {
        cmd = { "java", "-jar", "/Users/lombrozo/Workspace/OpenSource/groovy-language-server/build/libs/groovy-language-server-all.jar" },
        filetypes = { "groovy" },
        settings = {
          capabilities = capabilities,
        }
      }
      vim.lsp.config.solargraph = {
        cmd = { "solargraph", "stdio" },
        filetypes = { "ruby" },
        capabilities = capabilities,
        settings = {
          solargraph = {
            diagnostics = true,
            formatting = true,
            completion = true,
            hover = true,
            symbols = true,
          },
        }
      }
      local formatter_path = vim.fn.stdpath("config") .. "/lua/plugins/eostyle.xml"
      vim.lsp.config.jdtls = {
        cmd = { "jdtls" },
        filetypes = { "java" },
        capabilities = capabilities,
        settings = {
          java = {
            format = {
              enabled = true,
              settings = {
                url = formatter_path,
                profile = "eostyle",
                profile_kind = "CodeFormatterProfileKind.XML",
              }
            },
          },
        },
      }
      vim.lsp.enable({
        'gopls',
        'lua_ls',
        'groovyls',
        'solargraph',
        'jdtls'
      })
    end
  },
}
