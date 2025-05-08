vim.cmd("let g:netrw_banner = 0")                -- disable the netrw banner at the top when browsing files

vim.opt.nu = true                                -- show absolute line numbers
vim.opt.relativenumber = true                    -- show line numbers relative to the cursor

vim.opt.tabstop = 4                              -- a tab character equates to 4 spaces
vim.opt.softtabstop = 4                          -- editing ‹Tab› and ‹Backspace› treat 4 spaces as a tab
vim.opt.shiftwidth = 4                           -- indentation operations shift by 4 spaces
vim.opt.expandtab = true                         -- convert tabs to spaces
vim.opt.autoindent = true                        -- copy indent from current line when starting a new one
vim.opt.smartindent = true                       -- add extra indent in certain programming constructs
vim.opt.wrap = false                             -- don't wrap long lines, let them scroll horizontally

vim.opt.swapfile = false                         -- don’t use a swapfile (no .swp files)
vim.opt.backup = false                           -- don’t keep backup files around
vim.opt.undofile = true                          -- enable persistent undo so undo history survives restarts

vim.opt.clipboard = "unnamedplus"                -- use the system clipboard for all yank, delete, change and paste operations

vim.opt.incsearch = true                         -- show search matches as you type
vim.opt.inccommand = "split"                     -- preview substitutions in a split window
vim.opt.ignorecase = true                        -- case-insensitive search…
vim.opt.smartcase = true                         -- …unless the search pattern has uppercase letters

vim.opt.termguicolors = true                     -- enable true-color support in the terminal
vim.opt.background = "dark"                      -- tell color schemes that you have a dark background
vim.opt.scrolloff = 8                            -- keep 8 lines visible above/below the cursor
vim.opt.signcolumn = "yes"                       -- always reserve space for the sign column

vim.opt.backspace = { "start", "eol", "indent" } -- make backspace work like most editors

vim.opt.splitright = true                        -- force vertical splits to open to the right
vim.opt.splitbelow = true                        -- force horizontal splits to open below

vim.opt.isfname:append("@-@")                    -- treat “@-@” as part of filenames (improves gf)
vim.opt.updatetime = 50                          -- faster CursorHold events (default is 4000ms)
vim.opt.colorcolumn = "120"                      -- highlight column 80 to guide line length

vim.opt.hlsearch = true                          -- highlight all search matches

vim.opt.mouse = "a"                              -- enable mouse in all modes
vim.g.editorconfig = true                        -- enable EditorConfig integration (if plugin is installed)


-- Auto-pairing for brackets, braces, and parentheses in Insert mode
vim.keymap.set('i', '(', '()<Left>', { noremap = true })
vim.keymap.set('i', '{', '{}<Left>', { noremap = true })
vim.keymap.set('i', '[', '[]<Left>', { noremap = true })
vim.keymap.set('i', '"', '""<Left>', { noremap = true })
vim.keymap.set('i', "'", "''<Left>", { noremap = true })


-- Smart backspace: delete closing pair if immediately following opening pair
vim.keymap.set('i', '<BS>', function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()

    -- If at the start of the line or no character before cursor, just do default backspace
    if col == 0 then
        return "<BS>"
    end

    -- Get the character before the cursor (at 0-indexed column 'col - 1')
    -- and the character at the cursor (at 0-indexed column 'col')
    -- Note: Lua string indexing is 1-based, Vim column is 0-based
    local char_before = string.sub(line, col, col)     -- Lua index 'col' corresponds to Vim column 'col-1'
    local char_at = string.sub(line, col + 1, col + 1) -- Lua index 'col+1' corresponds to Vim column 'col'

    local pairs = {
        ['('] = ')',
        ['{'] = '}',
        ['['] = ']',
        ['"'] = '"',
        ["'"] = "'"
    }

    -- Check if the character before the cursor is an opening pair
    -- AND the character at the cursor is its corresponding closing pair
    if pairs[char_before] == char_at then
        -- If it's a pair, delete the character before (<BS>)
        -- and then delete the character at the cursor (<Del>).
        -- The sequence "<BS><Del>" simulates pressing backspace then delete.
        return "<BS><Del>"
    else
        -- If it's not a pair, perform the default backspace action.
        return "<BS>"
    end
end, { expr = true, noremap = true })
