return {
    {
        "morhetz/gruvbox",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme gruvbox]])

            -- For terminal opacity
            vim.api.nvim_set_hl(0, "Normal", { bg = "None" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "None" })
        end,
    },
    {
        "itchyny/lightline.vim",
        lazy = false,
        priority = 999,
        config = function()
            vim.g["lightline"] = {
                colorscheme = "gruvbox",
            }
        end,
    }
}
