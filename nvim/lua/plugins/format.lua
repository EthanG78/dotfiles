return {
    {
        "stevearc/conform.nvim",
        event = {
            "BufReadPre",
            "BufNewFile"
        },
        opts = {
            formatters_by_ft = {
                cpp = { "my_cpp_formatter" },
                c = { "my_cpp_formatter" }
            },
            format_on_save = {
                lsp_fallback = true,
                timeout_ms = 500
            },
            formatters = {
                my_cpp_formatter = {
                    command = 'clang-format',
                    args = { "--style=file", "--fallback-style=GNU" },
                }
            }
        },
        keys = {
            {
                "<leader>l",
                function()
                    require("conform").format({
                        lsp_fallback = true,
                        async = false,
                        timeout_ms = 500,
                    })
                end,
                desc = "Format file using conform."
            },
        }
    },
    {
        "zapling/mason-conform.nvim",
        opts = {
            ensure_installed = { "clang-format" }
        }
    }
}
