return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        preset = "helix", -- "classic", "modern", "helix"
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        
        -- Register group names for your <leader> mappings
        wk.add({
            { "<leader>b", group = "Buffers" },
            { "<leader>c", group = "Code" },
            { "<leader>f", group = "Find/Format" },
            { "<leader>g", group = "Git" }, -- Assuming you might add git mappings later
            { "<leader>l", group = "LSP" },
        })
    end,
}
