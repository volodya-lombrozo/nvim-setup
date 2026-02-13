return {
  {
    "neovim/nvim-lspconfig",
    version = "v2.5.0",
    config = function()
      -- Make LSP completions work with nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Go --
      vim.lsp.config.gopls = {
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        settings = {
          capabilities = capabilities,
        },
      }

      -- Lua --
      vim.lsp.config.lua_ls = {
        settings = {
          capabilities = capabilities,
        }
      }

      -- Groovy --
      vim.lsp.config.groovyls = {
        cmd = { "java", "-jar", "/Users/lombrozo/Workspace/OpenSource/groovy-language-server/build/libs/groovy-language-server-all.jar" },
        filetypes = { "groovy" },
        settings = {
          capabilities = capabilities,
        }
      }

      -- Ruby --
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

      -- Java --
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

      -- JS --
      vim.lsp.config.ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx" },
        capabilities = capabilities,
      }

      vim.lsp.enable({
        'gopls',
        'lua_ls',
        'groovyls',
        'solargraph',
        'jdtls',
        'ts_ls'
      })
    end
  },
}
