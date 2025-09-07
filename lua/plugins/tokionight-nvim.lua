return {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
        require("tokyonight").setup(opts)
        vim.cmd.colorscheme("tokyonight-night")
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#3a3a3a" })
        vim.api.nvim_set_hl(0, "Pmenu", { bg = "#3a3a3a", fg = "#c0caf5" })
    end,
}
