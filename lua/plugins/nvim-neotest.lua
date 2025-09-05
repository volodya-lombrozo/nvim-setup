return {
    {
        "nvim-neotest/neotest",
        version = "v5.9.1",
        lazy = false,
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-neotest/neotest-plenary",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            {
                dir = "~/Workspace/OpenSource/neotest-ruby-minitest",
                name = "neotest-ruby-minitest",
                dev = true,
                ft = "ruby",
            },
            { "fredrikaverpil/neotest-golang", version = "*", ft = "go", },
        },
        config = function()
            -- Specify custom configuration
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
