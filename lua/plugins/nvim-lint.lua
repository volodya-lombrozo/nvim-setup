return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" },
        lua = { "luacheck" },
        java = { "checkstyle" },
      }
      -- Find checkstyle config file
      local find = function()
        local cwd = vim.fn.getcwd()
        local candidates = {
          "sun_checks_modified.xml",
          "sun_checks.xml",
          "google_checks.xml",
        }
        for _, name in ipairs(candidates) do
          local path = cwd .. "/" .. name
          if vim.fn.filereadable(path) == 1 then
            return path
          end
        end
        -- fallback to bundled Google rules
        return "/google_checks.xml"
      end
      lint.linters.checkstyle.config_file = find()
      -- Define custom command
      vim.api.nvim_create_user_command("LintNow", function()
        lint.try_lint()
      end, {})
      -- Key mapping
      vim.keymap.set("n", "<leader>ll", ":LintNow<CR>", { desc = "Lint current file" })
    end,
  },
}
