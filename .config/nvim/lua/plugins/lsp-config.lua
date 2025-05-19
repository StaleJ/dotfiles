return {
    {
        "mason-org/mason.nvim",
        config = function()
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })
        end
    },
    {
        "mason-org/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "marksman" }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "seblyng/roslyn.nvim",
                ft = { "cs" },
            },
        },
        config = function()
            -- Go to Type Definition
            vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, bufopts)
            -- Go to Declaration
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
            -- **Go to Implementation**
            vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
            vim.lsp.enable('lua_ls')
            vim.lsp.config('lua_ls', {
                settings = {
                }
            })
            vim.lsp.enable('roslyn')
            vim.lsp.config('roslyn', {
                settings = {

                }
            })
            vim.lsp.enable('marksman')
        end,
        opts = {
            inlay_hints = {
                enabled = true
            },
            codelens = {
                enabled = true
            }
        },
    },
    {
        "seblyng/roslyn.nvim",
        ft = "cs",
        ---@module 'roslyn.config'
        ---@type RoslynNvimConfig
        opts = {
            -- your configuration comes here; leave empty for default settings
            -- NOTE: You must configure `cmd` in `config.cmd` unless you have installed via mason
        }
    }
}
