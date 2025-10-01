return {
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    lazy = false,
    opts = {},
    keys = {
      { "<leader>ef",  function() return require("refactoring").refactor("Extract Function") end,         mode = { "n", "x" }, expr = true, desc = "Refactor: Extract Function" },
      { "<leader>eff", function() return require("refactoring").refactor("Extract Function To File") end, mode = { "n", "x" }, expr = true, desc = "Refactor: Extract Function To File" },
      { "<leader>ev",  function() return require("refactoring").refactor("Extract Variable") end,         mode = { "n", "x" }, expr = true, desc = "Refactor: Extract Variable" },
      { "<leader>ii",  function() return require("refactoring").refactor("Inline Function") end,          mode = { "n", "x" }, expr = true, desc = "Refactor: Inline Function" },
      { "<leader>iv",  function() return require("refactoring").refactor("Inline Variable") end,          mode = { "n", "x" }, expr = true, desc = "Refactor: Inline Variable" },
      { "<leader>eb",  function() return require("refactoring").refactor("Extract Block") end,            mode = { "n", "x" }, expr = true, desc = "Refactor: Extract Block" },
      { "<leader>ebf", function() return require("refactoring").refactor("Extract Block To File") end,    mode = { "n", "x" }, expr = true, desc = "Refactor: Extract Block To File" },
    },
  },
}
