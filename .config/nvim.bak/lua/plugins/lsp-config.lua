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
                    local client  = vim.lsp.get_client_by_id(args.data.client_id)

                    map('n', 'gy', vim.lsp.buf.type_definition, bufopts)
                    map('n', 'gD', vim.lsp.buf.declaration, bufopts)
                    map('n', 'gd', vim.lsp.buf.definition, bufopts)
                    map('n', 'gi', vim.lsp.buf.implementation, bufopts)
                    map('n', 'gl', vim.diagnostic.open_float, bufopts)
                    map('n', 'gr', vim.lsp.buf.references, bufopts)
                    map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
                    map('n', 'gr', require("telescope.builtin").lsp_references, bufopts)

                    if client and client.name == "roslyn" then
                        map('n', '<leader>lt', '<cmd>Roslyn target<CR>', vim.tbl_extend("force", bufopts, {
                            desc = "Roslyn: Select Target",
                        }))
                    end
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

            vim.lsp.config('sourcekit', {
                cmd = { vim.trim(vim.fn.system("xcrun -f sourcekit-lsp")) },
                filetypes = { "swift" },
                root_dir = function(bufnr, on_dir)
                    local fname = vim.api.nvim_buf_get_name(bufnr)
                    local dir = vim.fn.fnamemodify(fname, ":p:h")
                    -- walk up looking for project markers
                    while dir ~= "/" do
                        if vim.fn.filereadable(dir .. "/buildServer.json") == 1
                            or vim.fn.glob(dir .. "/*.xcodeproj") ~= ""
                            or vim.fn.glob(dir .. "/*.xcworkspace") ~= ""
                            or vim.fn.filereadable(dir .. "/Package.swift") == 1 then
                            on_dir(dir)
                            return
                        end
                        dir = vim.fn.fnamemodify(dir, ":h")
                    end
                    -- fallback to git root
                    local git = vim.fs.root(bufnr, ".git")
                    if git then
                        on_dir(git)
                    end
                end,
            })
            vim.lsp.enable('sourcekit')
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
