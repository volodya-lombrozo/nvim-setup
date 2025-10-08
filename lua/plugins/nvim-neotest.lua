return {
  {
    "nvim-neotest/neotest",
    version = "v5.11.1",
    lazy = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-neotest/neotest-plenary",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- "volodya-lombrozo/neotest-ruby-minitest",
      { dir = "~/Workspace/OpenSource/neotest-ruby-minitest", name = "neotest-ruby-minitest", dev = true, ft = "rb", },
      { "fredrikaverpil/neotest-golang",                      version = "v1.15.1",                ft = "go", },
    },
    config = function()
      require("neotest").setup({
        log_level = "DEBUG",
        adapters = {
          require("neotest-golang")({
            args = { "-v" },
          }),
          require("neotest-ruby-minitest"),
          require("neotest-plenary")({}),
        },
        output = { enabled = true, open_on_run = false },
      })
    end,
  }
}
