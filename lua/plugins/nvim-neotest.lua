return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            { "fredrikaverpil/neotest-golang", version = "*" },
        },
        config = function()
            -- Specify custom configuration
            require("neotest").setup({
                adapters = {
                    require("neotest-golang")({
                        args = { "-v" }, 
                    }),
                },
                output = { enabled = true, open_on_run = false },
            })
        end,
    }
}
