return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        local config = require("nvim-treesitter.configs")
        config.setup({
            ensure_installed = { "lua", "javascript", "markdown", "c_sharp", "typescript" },
            highlight = { enable = true },
            indent = { enable = true }
        })
    end
}
