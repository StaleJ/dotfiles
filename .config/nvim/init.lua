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

vim.g.user_emmet_install_global = 0
vim.g.user_emmet_settings = {
    javascriptreact = { extends = 'jsx' },
    typescriptreact = { extends = 'jsx' },
}

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
    'https://github.com/nvim-neotest/nvim-nio',
    'https://github.com/nvim-neotest/neotest',
    'https://github.com/nsidorenco/neotest-vstest',
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/folke/todo-comments.nvim',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/stevearc/oil.nvim',
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/akinsho/bufferline.nvim',
    'https://github.com/folke/snacks.nvim',
    'https://github.com/rafamadriz/friendly-snippets',
    'https://github.com/mattn/emmet-vim',
    { src = 'https://github.com/obsidian-nvim/obsidian.nvim', version = vim.version.range('*') },
})


local tailwind_config_files = {
    'tailwind.config.js',
    'tailwind.config.cjs',
    'tailwind.config.mjs',
    'tailwind.config.ts',
    'tailwind.config.cts',
    'tailwind.config.mts',
}

local postcss_config_files = {
    'postcss.config.js',
    'postcss.config.cjs',
    'postcss.config.mjs',
    'postcss.config.ts',
}

local function file_exists(path)
    return path and vim.uv.fs_stat(path) ~= nil
end

local function read_json_file(path)
    local lines = vim.fn.readfile(path)
    if vim.v.shell_error ~= 0 then
        return nil
    end

    local ok, decoded = pcall(vim.json.decode, table.concat(lines, '\n'))
    if ok then
        return decoded
    end
end

local function package_has_dependency(package_json, dependency)
    local package = read_json_file(package_json)
    if not package then
        return false
    end

    for _, key in ipairs({ 'dependencies', 'devDependencies', 'peerDependencies', 'optionalDependencies' }) do
        if package[key] and package[key][dependency] then
            return true
        end
    end

    return false
end

local function file_contains(path, pattern)
    local lines = vim.fn.readfile(path, '', 200)
    if vim.v.shell_error ~= 0 then
        return false
    end

    return string.find(table.concat(lines, '\n'), pattern, 1, true) ~= nil
end

local function find_node_package(start_dir, package_name)
    local node_modules = vim.fs.find('node_modules', {
        path = start_dir,
        upward = true,
        type = 'directory',
        limit = math.huge,
    })

    for _, dir in ipairs(node_modules) do
        local package_dir = vim.fs.joinpath(dir, package_name)
        if file_exists(vim.fs.joinpath(package_dir, 'package.json')) then
            return package_dir
        end
    end
end

local function find_tailwind_root(filename)
    local start_dir = filename ~= '' and vim.fs.dirname(filename) or vim.uv.cwd()

    local config = vim.fs.find(tailwind_config_files, {
        path = start_dir,
        upward = true,
        limit = 1,
    })[1]
    if config then
        return vim.fs.dirname(config)
    end

    local package_jsons = vim.fs.find('package.json', {
        path = start_dir,
        upward = true,
        limit = math.huge,
    })
    for _, package_json in ipairs(package_jsons) do
        if package_has_dependency(package_json, 'tailwindcss') then
            return vim.fs.dirname(package_json)
        end
    end

    local postcss_configs = vim.fs.find(postcss_config_files, {
        path = start_dir,
        upward = true,
        limit = math.huge,
    })
    for _, postcss_config in ipairs(postcss_configs) do
        if file_contains(postcss_config, 'tailwindcss') or file_contains(postcss_config, '@tailwindcss/postcss') then
            return vim.fs.dirname(postcss_config)
        end
    end
end

vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
        },
    },
})

vim.lsp.config('typos_lsp', {
    filetypes = {
        'css',
        'cs',
        'gitcommit',
        'html',
        'javascript',
        'javascriptreact',
        'json',
        'lua',
        'markdown',
        'text',
        'typescript',
        'typescriptreact',
    },
    root_markers = { '.git', 'typos.toml', '_typos.toml', '.typos.toml', 'pyproject.toml', 'Cargo.toml' },
})

vim.lsp.config('tailwindcss', {
    root_dir = function(bufnr, on_dir)
        local root = find_tailwind_root(vim.api.nvim_buf_get_name(bufnr))
        if root then
            on_dir(root)
        end
    end,
    settings = {
        tailwindCSS = {
            emmetCompletions = true,
            classFunctions = { 'cn', 'clsx', 'cva', 'cx', 'tw', 'tw\\.[a-z-]+' },
        },
    },
})

vim.lsp.enable('roslyn_ls')
vim.lsp.enable('vtsls')
vim.lsp.enable('tailwindcss')
vim.lsp.enable('typos_lsp')

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
local snippets = require('mini.snippets')
local gen_loader = snippets.gen_loader
local csharp_snippets = {
    'csharp/csharp.json',
    'csharp/csharpdoc.json',
    '**/cs.json',
}

snippets.setup({
    snippets = {
        gen_loader.from_lang({
            lang_patterns = {
                cs = csharp_snippets,
                c_sharp = csharp_snippets,
                csharp = csharp_snippets,
            },
        }),
    },
})
snippets.start_lsp_server()
require('mini.statusline').setup()
require('mini.diff').setup()
require('mini.git').setup()
require('mini.ai').setup()
require('mini.pick').setup()
require('mini.extra').setup()




map('n', '<leader>do', MiniDiff.toggle_overlay, { desc = 'Toggle diff overlay' })
map('n', '<leader>ss', function()
    MiniExtra.pickers.spellsuggest()
end, { desc = 'Spell suggestions' })

-- ============================================================================
-- EMMET
-- ============================================================================

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'javascript.jsx', 'typescript.tsx' },
    callback = function()
        vim.cmd.EmmetInstall()
        vim.api.nvim_buf_set_keymap(
            0,
            'i',
            '<Tab>',
            'pumvisible() ? "\\<C-n>" : emmet#expandAbbrIntelligent("\\<Tab>")',
            { expr = true, noremap = false, silent = true, desc = 'Expand Emmet abbreviation' }
        )
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'gitcommit', 'markdown', 'text' },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = 'en_us'
        if vim.bo.filetype == 'markdown' then
            vim.opt_local.conceallevel = 2
        end
    end,
})

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

-- Git: Telescope pickers fuzzy-match by path, commit message, branch name, etc.
map('n', '<leader>gs', builtin.git_status, { desc = 'Telescope git status (working tree changes)' })
map('n', '<leader>gc', builtin.git_commits, { desc = 'Telescope git commits' })
map('n', '<leader>gh', builtin.git_bcommits, { desc = 'Telescope git commits (this file)' })
map('n', '<leader>gb', builtin.git_branches, { desc = 'Telescope git branches' })
map('n', '<leader>gz', builtin.git_stash, { desc = 'Telescope git stash' })

-- ============================================================================
-- SETUPS
-- ============================================================================

require('todo-comments').setup()
require('oil').setup()

-- ============================================================================
-- OBSIDIAN / TASKS
-- ============================================================================

local babel_vault = '/Users/stale/Babel'
local task_files = {
    inbox = babel_vault .. '/Inbox.md',
    tasks = babel_vault .. '/Tasks.md',
}

require('obsidian').setup({
    legacy_commands = false,
    workspaces = {
        {
            name = 'Babel',
            path = babel_vault,
        },
    },
    picker = {
        name = 'telescope.nvim',
    },
    completion = {
        nvim_cmp = false,
        blink = false,
    },
})

local function task_file_defaults(path)
    if path == task_files.tasks then
        return { '---', 'tags:', '  - tasks', '  - long-running', '---', '', '# Tasks', '', '## Long-running', '' }
    end
    return { '---', 'tags:', '  - tasks', '  - inbox', '---', '', '# Inbox', '', '## Short-lived', '' }
end

local function ensure_task_file(path)
    if vim.fn.filereadable(path) == 0 then
        vim.fn.writefile(task_file_defaults(path), path)
    end
end

local function open_task_file(path)
    ensure_task_file(path)
    vim.cmd.edit(vim.fn.fnameescape(path))
end

local function find_task_buffer(path)
    local target = vim.fn.fnamemodify(path, ':p')
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name ~= '' and vim.fn.fnamemodify(name, ':p') == target then
            return bufnr
        end
    end
end

local function append_task_lines(path, task_lines)
    ensure_task_file(path)
    local bufnr = find_task_buffer(path)

    if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
        local line_count = vim.api.nvim_buf_line_count(bufnr)
        local last_line = vim.api.nvim_buf_get_lines(bufnr, line_count - 1, line_count, false)[1] or ''
        local lines = {}
        if line_count > 0 and last_line ~= '' then
            table.insert(lines, '')
        end
        vim.list_extend(lines, task_lines)
        vim.api.nvim_buf_set_lines(bufnr, line_count, line_count, false, lines)
        return line_count + #lines
    end

    local lines = vim.fn.readfile(path)
    if #lines > 0 and lines[#lines] ~= '' then
        table.insert(lines, '')
    end
    vim.list_extend(lines, task_lines)
    vim.fn.writefile(lines, path)

    return #lines
end

local function append_task(path, task)
    task = vim.trim(task or '')
    if task == '' then
        return
    end

    append_task_lines(path, { '- [ ] ' .. task })
    vim.api.nvim_echo({ { 'Added task to ' .. vim.fn.fnamemodify(path, ':t'), 'Normal' } }, false, {})
end

local function capture_task(path, prompt)
    vim.ui.input({ prompt = prompt }, function(input)
        append_task(path, input)
    end)
end

local function append_task_section(path, title)
    title = vim.trim(title or '')
    if title == '' then
        return
    end

    local cursor_line = append_task_lines(path, { '### ' .. title, '' })
    open_task_file(path)
    vim.api.nvim_win_set_cursor(0, { cursor_line, 0 })
    vim.cmd.startinsert()
end

local function capture_task_section(path, prompt)
    vim.ui.input({ prompt = prompt }, function(input)
        append_task_section(path, input)
    end)
end

vim.api.nvim_create_user_command('TaskLong', function()
    open_task_file(task_files.tasks)
end, { desc = 'Open long-running tasks' })

vim.api.nvim_create_user_command('TaskInbox', function()
    open_task_file(task_files.inbox)
end, { desc = 'Open task inbox' })

vim.api.nvim_create_user_command('TaskCapture', function(opts)
    if opts.args ~= '' then
        append_task(task_files.inbox, opts.args)
    else
        capture_task(task_files.inbox, 'Inbox task: ')
    end
end, { nargs = '*', desc = 'Capture short-lived task' })

vim.api.nvim_create_user_command('TaskCaptureLong', function(opts)
    if opts.args ~= '' then
        append_task(task_files.tasks, opts.args)
    else
        capture_task(task_files.tasks, 'Long-running task: ')
    end
end, { nargs = '*', desc = 'Capture long-running task' })

vim.api.nvim_create_user_command('TaskSection', function(opts)
    if opts.args ~= '' then
        append_task_section(task_files.inbox, opts.args)
    else
        capture_task_section(task_files.inbox, 'Inbox section: ')
    end
end, { nargs = '*', desc = 'Create short-lived task section' })

vim.api.nvim_create_user_command('TaskSectionLong', function(opts)
    if opts.args ~= '' then
        append_task_section(task_files.tasks, opts.args)
    else
        capture_task_section(task_files.tasks, 'Long-running section: ')
    end
end, { nargs = '*', desc = 'Create long-running task section' })

vim.api.nvim_create_user_command('TaskSearch', function()
    builtin.live_grep({
        cwd = babel_vault,
        default_text = '- \\[ \\]',
        glob_pattern = '*.md',
        prompt_title = 'Unchecked vault tasks',
    })
end, { desc = 'Search unchecked vault tasks' })

map('n', '<leader>tt', function()
    open_task_file(task_files.tasks)
end, { desc = 'Open long-running tasks' })

map('n', '<leader>ti', function()
    open_task_file(task_files.inbox)
end, { desc = 'Open task inbox' })

map('n', '<leader>ta', function()
    capture_task_section(task_files.inbox, 'Inbox section: ')
end, { desc = 'Create short-lived task section' })

map('n', '<leader>tA', function()
    capture_task_section(task_files.tasks, 'Long-running section: ')
end, { desc = 'Create long-running task section' })

map('n', '<leader>ts', '<cmd>TaskSearch<CR>', { desc = 'Search unchecked vault tasks' })
map('n', '<leader>tc', '<cmd>TodoTelescope<CR>', { desc = 'Code TODOs' })
map('n', '<leader>tx', '<cmd>Obsidian toggle_checkbox<CR>', { desc = 'Toggle task checkbox' })

-- ============================================================================
-- NEOTEST
-- ============================================================================

require('neotest').setup({
    adapters = {
        require('neotest-vstest'),
    },
})

map('n', '<leader>tn', function()
    require('neotest').run.run()
end, { desc = 'Run nearest test' })

map('n', '<leader>tf', function()
    require('neotest').run.run(vim.fn.expand('%'))
end, { desc = 'Run test file' })

map('n', '<leader>to', function()
    require('neotest').output.open({ enter = true })
end, { desc = 'Open test output' })

map('n', '<leader>ts', function()
    require('neotest').summary.toggle()
end, { desc = 'Toggle test summary' })

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
    ensure_installed = { 'lua_ls', 'vtsls', 'jsonls', 'tailwindcss', 'typos_lsp' },
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
        prettier = {
            append_args = function(_, ctx)
                if not find_tailwind_root(ctx.filename) then
                    return {}
                end

                local plugin = find_node_package(ctx.dirname, 'prettier-plugin-tailwindcss')
                if plugin then
                    return { '--plugin', plugin }
                end

                return {}
            end,
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
