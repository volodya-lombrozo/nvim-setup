return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { 
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            -- Close the tree when you open a file
            actions = {
                open_file = {
                    quit_on_open = true,
                },
            },
            -- Don't show netrw (so nvim-tree is default)
            disable_netrw = true,
            hijack_netrw = true,
        })

        vim.keymap.set("n", "<leader>pp", ":NvimTreeFindFileToggle<CR>", { silent = true, desc = "Toggle NvimTree" })
    end,
}

