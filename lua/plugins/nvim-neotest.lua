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
            -- { "zidhuss/neotest-minitest", branch = "main" },
            {
                -- Use local path for neotest-minitest
                dir = "~/Workspace/OpenSource/neotest-ruby-minitest",
                name = "neotest-ruby-minitest",
                -- optional: prevent Lazy from updating this plugin
                dev = true,
            },
            { "fredrikaverpil/neotest-golang", version = "*" },
        },
        config = function()
            -- Specify custom configuration
            require("neotest").setup({
                log_level = "DEBUG",
                adapters = {
                    require("neotest-golang")({
                        args = { "-v" }, 
                    }),
                    -- require("neotest-ruby-minitest")({}),
                    require("neotest-ruby-minitest").setup({
                        command = "ruby ruby ruby"
                    }),
                    require("neotest-plenary")({
                        -- min_init = "tests/adapter/minimal_init.lua",
                        -- projects = {
                        --     ["~/Workspace/OpenSource/neotest-minitest"] = require("neotest-plenary")({
                        --         min_init = "./tests/adapter/minimal_init.lua",
                        --     }),
                        -- },
                    }),
                },
                output = { enabled = true, open_on_run = false },
            })
        end,
    }
}
