return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            {
                "hrsh7th/cmp-nvim-lsp"
            },
            {
                "hrsh7th/nvim-cmp",
                event = "InsertEnter",
                dependencies = {
                    "hrsh7th/cmp-buffer",
                    "hrsh7th/cmp-path",
                    "onsails/lspkind.nvim",
                }
            }
        },
        config = function()
            vim.opt.signcolumn = "yes"

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            local lspconfig_defaults = require("lspconfig").util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                "force",
                lspconfig_defaults.capabilities,
                require("cmp_nvim_lsp").default_capabilities()
            )

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local opts = { buffer = event.buf }

                    if not client then return end

                    --  Format on buffer save/open
                    --if client.supports_method("textDocument/formatting") then
                    --    vim.api.nvim_create_autocmd("BufWritePre", {
                    --        buffer = event.buf,
                    --        callback = function()
                    --            vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
                    --        end,
                    --    })
                    --end

                    vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                    vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                    vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                    --vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                    vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                    vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                    --vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                    --vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                    vim.keymap.set("n", "gA", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
                end,
            })

            -- Setup autocomplete with custom keybinds
            local cmp = require("cmp")

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "path" },
                },
                mapping = cmp.mapping.preset.insert({
                    -- Navigate between completion items
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),

                    -- `Enter` key to confirm completion
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),

                    -- Ctrl+Space to trigger completion menu
                    ['<C-Space>'] = cmp.mapping.complete(),
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
                formatting = {
                    format = require("lspkind").cmp_format({}),
                    expandable_indicator = true,
                    fields = { cmp.ItemField.Abbr, cmp.ItemField.Menu, cmp.ItemField.Kind }
                }
            })
        end
    },
    {
        "williamboman/mason.nvim",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "lua_ls", "clangd", "eslint", "ts_ls" },
            automatic_installation = false,
            handlers = {
                -- Configure lspconfig for each lsp we install
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end
            }
        }
    },
}
