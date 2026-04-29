-- ============================================================================
-- Missing aka todo
-- ============================================================================
-- Need formatter
-- Make lsp ref and code action nice with mini
-- C# support done. TS/React Native support added ✓


-- ============================================================================
-- OPTIONS
-- ============================================================================

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local o = vim.o

o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = 4
o.expandtab = true
o.smartindent = true

o.number = true
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.scrolloff = 8
o.termguicolors = true

o.ignorecase = true
o.smartcase = true

o.splitbelow = true
o.splitright = true

o.undofile = true
o.swapfile = false
o.updatetime = 250
o.clipboard = "unnamedplus"

o.colorcolumn = "120"

o.completeopt = "menuone,noinsert,noselect,popup"
vim.cmd('syntax off')

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
    pattern = "*",
    command = "checktime",
})
-- ============================================================================
-- KEYMAPS
-- ============================================================================

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")
map('n', '<leader>so', function()
    vim.cmd('source $MYVIMRC')
    vim.api.nvim_echo({ { 'Config reloaded', 'Normal' } }, false, {})
end, { desc = 'Source init.lua' })

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Move lines in visual mode
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<leader>gs", "<cmd>Telescope git_status<cr>")


-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to defintion" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "gr", function()
    require('telescope.builtin').lsp_references()
end, { desc = "Telescope references" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<leader>li", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        vim.api.nvim_echo({ { "No LSP attached", "WarningMsg" } }, false, {})
        return
    end

    local names = vim.tbl_map(function(client)
        return client.name
    end, clients)
    table.sort(names)

    vim.api.nvim_echo({ { "LSP: " .. table.concat(names, ", "), "Normal" } }, false, {})
end, { desc = "Show active LSP" })

-- Add all plugins at once
vim.pack.add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/drewtempelmeyer/palenight.vim',
    'https://github.com/nvim-mini/mini.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/folke/todo-comments.nvim',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/tpope/vim-fugitive',
})


vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
        },
    },
})

vim.lsp.enable('roslyn_ls')
vim.lsp.enable('vtsls')

-- ============================================================================
-- COLORSCHEME
-- ============================================================================

vim.cmd.colorscheme('palenight')

-- ============================================================================
-- Mini
-- ============================================================================

require('mini.basics').setup()
require('mini.pairs').setup()
require('mini.completion').setup()
require('mini.icons').setup()
require('mini.snippets').setup()
require('mini.statusline').setup()
require('mini.diff').setup()
require('mini.git').setup()
require('mini.ai').setup()
require('mini.pick').setup()




map('n', '<leader>do', MiniDiff.toggle_overlay, { desc = 'Toggle diff overlay' })

-- ============================================================================
-- TELESCOPE
-- ============================================================================

local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- ============================================================================
-- SETUPS
-- ============================================================================

require('todo-comments').setup()
require('oil').setup()

map('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

-- ============================================================================
-- LAZYDEV
-- ============================================================================

require("lazydev").setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
})

-- ============================================================================
-- MASON
-- ============================================================================

require('mason').setup()

require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'vtsls' },
})


-- ============================================================================
-- CONFORM
-- ============================================================================

local conform = require('conform')
local mason_bin = vim.fn.expand("$MASON/bin")

conform.setup({
    formatters_by_ft = {
        cs = { "csharpier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
    },
    formatters = {
        csharpier = {
            command = mason_bin .. "/csharpier",
            args = { "format", "--write-stdout" },
        },
    },
})

map({ "n", "v" }, "<leader>f", function()
    conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
    })
end, { desc = "Format file or selection" })

-- ============================================================================
-- TREESITTER
-- ============================================================================
require('nvim-treesitter').install { 'lua', 'javascript', 'c_sharp', 'markdown', 'typescript', 'tsx', 'html', 'css' }
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})
