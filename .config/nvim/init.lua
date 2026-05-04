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
    { src = 'https://github.com/dracula/vim', name = 'dracula' },
    'https://github.com/nvim-mini/mini.nvim',
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/folke/todo-comments.nvim',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/akinsho/bufferline.nvim',
    'https://github.com/folke/snacks.nvim',
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

vim.cmd.colorscheme('dracula')

-- ============================================================================
-- Mini
-- ============================================================================

require('mini.basics').setup()
require('mini.pairs').setup()
require('mini.completion').setup()
require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()
require('mini.snippets').setup()
require('mini.statusline').setup()
require('mini.diff').setup()
require('mini.git').setup()
require('mini.ai').setup()
require('mini.pick').setup()




map('n', '<leader>do', MiniDiff.toggle_overlay, { desc = 'Toggle diff overlay' })

-- ============================================================================
-- SNACKS
-- ============================================================================

local snacks = require('snacks')
if not snacks.did_setup then
    snacks.setup({
        explorer = {
            enabled = true,
            replace_netrw = false,
        },
        picker = {
            enabled = true,
            ui_select = false,
        },
    })
end

map('n', '<leader>fe', function()
    Snacks.explorer.reveal()
end, { desc = 'Reveal file in explorer' })

map('n', '<leader>rF', function()
    Snacks.rename.rename_file()
end, { desc = 'Rename file' })

-- ============================================================================
-- BUFFERLINE
-- ============================================================================

require('bufferline').setup({
    options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "thin",
        always_show_bufferline = false,
        close_command = "bdelete %d",
        right_mouse_command = "bdelete %d",
        offsets = {
            {
                filetype = "oil",
                text = "Oil",
                highlight = "Directory",
                text_align = "left",
            },
        },
    },
})

map("n", "]b", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer tab" })
map("n", "[b", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous buffer tab" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Close buffer" })
map("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer tab" })
map("n", "<leader>bH", "<cmd>BufferLineMovePrev<CR>", { desc = "Move buffer tab left" })
map("n", "<leader>bL", "<cmd>BufferLineMoveNext<CR>", { desc = "Move buffer tab right" })

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

vim.api.nvim_create_autocmd("User", {
    pattern = "OilActionsPost",
    callback = function(event)
        for _, action in ipairs(event.data.actions or {}) do
            if action.type == "move" then
                Snacks.rename.on_rename_file(action.src_url, action.dest_url)
            end
        end
    end,
})

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
    ensure_installed = { 'lua_ls', 'vtsls', 'jsonls' },
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
require('nvim-treesitter').install { 'lua', 'javascript', 'c_sharp', 'markdown', 'typescript', 'tsx', 'html', 'css', 'json' }
vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})
