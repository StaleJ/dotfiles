return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    lazy = false, -- load immediately
    opts = {
        close_if_last_window = true,
        filesystem = {
            filtered_items = {
                visible = true,
            }
        }
    },
    keys = {
        { "<C-n>", ':Neotree filesystem left toggle<CR>' },
    },
}
