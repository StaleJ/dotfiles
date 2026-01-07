return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        
        require("telescope").setup({
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown {
                        -- even more opts
                    }
                }
            }
        })
        require("telescope").load_extension("ui-select")

        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>bb', vim.cmd.buffers, { silent = true })
        vim.keymap.set('n', '<leader>bn', vim.cmd.bnext, { desc = "Next buffer" })
        vim.keymap.set('n', '<leader>bp', vim.cmd.bprevious, { desc = "Prev buffer" })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
}
