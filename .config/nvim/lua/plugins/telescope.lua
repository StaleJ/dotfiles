return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        
        local utils = require("telescope.utils")
        local function filename_with_last_three(_, path)
            local tail = utils.path_tail(path)
            local sep = utils.get_separator()
            local parts = vim.split(path, sep, { plain = true })
            local start_idx = math.max(#parts - 3, 1)
            local parent = table.concat(vim.list_slice(parts, start_idx, #parts - 1), sep)
            if parent ~= "" then
                return string.format("%s  …/%s", tail, parent)
            end
            return tail
        end

        require("telescope").setup({
            defaults = {
                path_display = filename_with_last_three,
                layout_strategy = "horizontal",
                layout_config = {
                    width = 0.9,
                    height = 0.9,
                    preview_width = 0.6,
                },
            },
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
