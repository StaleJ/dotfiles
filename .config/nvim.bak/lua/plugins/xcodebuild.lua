return {
    "wojciech-kulik/xcodebuild.nvim",
    lazy = false,
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-neo-tree/neo-tree.nvim",
        "nvim-treesitter/nvim-treesitter",
        "folke/snacks.nvim",
    },
    config = function()
        require("xcodebuild").setup({
            integrations = {
                pymobiledevice = { enabled = false },
            },
        })
    end,
    keys = {
        { "<leader>X", "<cmd>XcodebuildPicker<cr>", desc = "Show Xcodebuild Actions" },
        { "<leader>xb", "<cmd>XcodebuildBuild<cr>", desc = "Build Project" },
        { "<leader>xr", "<cmd>XcodebuildBuildRun<cr>", desc = "Build & Run" },
        { "<leader>xt", "<cmd>XcodebuildTest<cr>", desc = "Run Tests" },
        { "<leader>xT", "<cmd>XcodebuildTestClass<cr>", desc = "Run Test Class" },
        { "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Toggle Logs" },
        { "<leader>xe", "<cmd>XcodebuildTestExplorerToggle<cr>", desc = "Toggle Test Explorer" },
        { "<leader>xd", "<cmd>XcodebuildSelectDevice<cr>", desc = "Select Device" },
        { "<leader>xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", desc = "Generate Preview" },
        { "<leader>x<cr>", "<cmd>XcodebuildPreviewToggle<cr>", desc = "Toggle Preview" },
    },
}