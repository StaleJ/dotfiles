vim.cmd("let g:netrw_banner = 0")

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.clipboard = 'unnamedplus'

-- Auto-pairing for brackets, braces, and parentheses in Insert mode
vim.keymap.set('i', '(', '()<Left>', {noremap = true})
vim.keymap.set('i', '{', '{}<Left>', {noremap = true})
vim.keymap.set('i', '[', '[]<Left>', {noremap = true})
vim.keymap.set('i', '"', '""<Left>', {noremap = true})
vim.keymap.set('i', "'", "''<Left>", {noremap = true})


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
    local char_before = string.sub(line, col, col) -- Lua index 'col' corresponds to Vim column 'col-1'
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
end, {expr = true, noremap = true})

