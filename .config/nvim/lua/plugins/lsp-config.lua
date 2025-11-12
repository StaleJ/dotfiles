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
                ensure_installed = { "lua_ls", "marksman", "pyright" }
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
            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(args)
                    local bufopts = { noremap = true, silent = true, buffer = args.buf }
                    local map     = vim.keymap.set

                    map('n', 'gy', vim.lsp.buf.type_definition, bufopts)
                    map('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    map('n', 'gd', vim.lsp.buf.definition, bufopts)
                    map('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    map('n', 'gl', vim.diagnostic.open_float, bufopts)
                    map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
                    map('n', 'gr', require("telescope.builtin").lsp_references, bufopts)
                end,
            })


            -- enable and lsb configs for different lsps
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
            vim.lsp.enable('ts_ls')
            vim.lsp.enable('tailwindcss')
            vim.lsp.enable('pyright')
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
