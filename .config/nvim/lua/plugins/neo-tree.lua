return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal left<CR>', {})
    end,
    lazy = false, -- neo-tree will lazily load itself
      ---@module "neo-tree"
      ---@type neotree.Config?
      opts = {
      },
}
