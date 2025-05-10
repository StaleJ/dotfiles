-- Clear search highlights
vim.keymap.set('n', '<leader><space>', '<cmd>nohlsearch<CR>', { noremap = true })
vim.keymap.set('n', '<F4>', '<cmd>nohlsearch<CR>', { noremap = true })

-- Center next/previous search result and open folds
vim.keymap.set('n', 'n', 'nzzzv', { noremap = true })
vim.keymap.set('n', 'N', 'Nzzzv', { noremap = true })
