return
{
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp", -- LSP items
        "hrsh7th/cmp-path",     -- filesystem paths
        "hrsh7th/cmp-buffer",   -- buffer words
    },
    config = function()
        local cmp = require("cmp")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- set up cmp
        cmp.setup({
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
            }, {
                { name = "path" }, -- <-- file/path completion
                { name = "buffer" },
            }),
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<CR>"]      = cmp.mapping.confirm({ select = true }),
            }),
        })

        -- make sure to pass `capabilities` into your LSP setup below
        _G._CMP_CAPS = capabilities
    end,
}
