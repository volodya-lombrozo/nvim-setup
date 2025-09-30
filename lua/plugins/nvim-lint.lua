return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        go = { "golangcilint" },
        lua = { "luacheck" },
      }
      -- Define custom command
      vim.api.nvim_create_user_command("LintNow", function()
        lint.try_lint()
      end, {})
      -- Key mapping
      vim.keymap.set("n", "<leader>ll", ":LintNow<CR>", { desc = "Lint current file" })
    end,
  },
}
