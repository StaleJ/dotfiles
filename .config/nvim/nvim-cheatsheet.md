# Neovim cheat sheet — current setup

Verified against the active configuration on 2026-07-31.

## Setup at a glance

- Neovim: `0.12.4`
- Start command: `nvim` (the shell alias `vim` also runs `nvim`)
- Active config: `~/.config/nvim/init.lua`
  - This is a symlink into `~/dotfiles/.config/nvim/init.lua`.
- Plugin manager: Neovim's native `vim.pack`
- Leader key: `Space`
- Theme: Gruvbox, dark, hard contrast
- Indentation: 4 spaces
- Line numbers: absolute plus relative
- System clipboard: enabled for ordinary yank, delete, and paste
- Main languages: C#, TypeScript/JavaScript, React, Tailwind CSS, JSON, Lua,
  HTML/CSS, and Markdown

`~/.config/lazyvim` also exists, but plain `nvim` does **not** load it. It is
only used when Neovim is launched with `NVIM_APPNAME=lazyvim`.

Notation used below:

- `<leader>` means `Space`.
- `<C-x>` means `Ctrl+x`.
- `<A-x>` or `<M-x>` means `Option+x`.
- Commands beginning with `:` are typed from Normal mode and confirmed with
  `Enter`.

## Start here

```sh
# Open a project from its root; this gives file search the right scope.
nvim .

# The shell alias works too.
vim .

# Open a file, optionally at a line.
nvim path/to/file
nvim +42 path/to/file
```

The first habit to build is pressing `Esc` whenever you are unsure which mode
you are in. In this config, `Esc` also clears search highlighting in Normal
mode.

## IDE-to-Neovim translation

| Rider / JetBrains action | This setup |
|---|---|
| Search Everywhere: files | `<leader>ff` |
| Find in Files | `<leader>fg` |
| Open buffers/files already visited | `<leader>fb` |
| Solution/file explorer | `<leader>fe` |
| Browse/edit the current directory | `-` |
| Go to declaration/definition | `gd` |
| Go to implementation | `gi` |
| Find usages/references | `gr` |
| Quick documentation / hover | `K` |
| Rename symbol | `<leader>rn` |
| Intention action / quick fix | `<leader>ca` |
| Show current diagnostic | `<leader>e` |
| Next/previous problem | `]d` / `[d` |
| Reformat code | `<leader>f` |
| Run test at cursor | `<leader>tn` |
| Run current test file | `<leader>tf` |
| Test runner window | `<leader>ts` |
| Git changes | `<leader>gs` or `:Git` |
| TODO tool window | `<leader>tc` |
| Rename/move current file | `<leader>rF` |
| Integrated terminal | `:terminal` |
| Debugger | Not configured |
| Run/build configuration | Not configured; use `:!dotnet …` or a terminal |

## Modes

| Mode | Enter it | Leave it |
|---|---|---|
| Normal | `Esc` | Choose another mode |
| Insert | `i`, `a`, `o`, or `O` | `Esc` |
| Visual character | `v` | `Esc` |
| Visual line | `V` | `Esc` |
| Visual block / multicursor-like edits | `<C-v>` | `Esc` |
| Command line | `:` | `Esc` or run with `Enter` |

Most Vim editing follows:

```text
[count] + operator + motion/text object
```

Examples:

```text
3dw    delete three words
ciw    change inside word
ci"    change inside quotes
di(    delete inside parentheses
va{    select around braces
```

## Essential movement

| Keys | Action |
|---|---|
| `h j k l` | Left, down, up, right |
| `w` / `b` / `e` | Next word / previous word / end of word |
| `0` / `^` / `$` | Start / first text / end of line |
| `gg` / `G` | First / last line |
| `{` / `}` | Previous / next paragraph or code block |
| `<C-d>` / `<C-u>` | Half-page down / up |
| `f<char>` / `F<char>` | Find a character forward / backward on the line |
| `t<char>` / `T<char>` | Move until just before a character |
| `;` / `,` | Repeat / reverse the last `f`, `F`, `t`, or `T` |
| `%` | Jump between matching brackets |
| `/text` | Search forward |
| `n` / `N` | Next / previous search match |
| `*` / `#` | Search forward / backward for word under cursor |
| `<C-o>` / `<C-i>` | Back / forward through the jump list |
| `m<char>` / `'<char>` | Set a mark / jump to it |

Uncounted `j` and `k` follow screen lines when a long line wraps. Counts still
address real lines, so `5j` moves five file lines.

## Essential editing

| Keys | Action |
|---|---|
| `i` / `a` | Insert before / after cursor |
| `I` / `A` | Insert at start / end of line |
| `o` / `O` | New line below / above and insert |
| `x` | Delete character |
| `dd` / `D` | Delete line / to end of line |
| `yy` / `Y` | Yank line / to end of line |
| `p` / `P` | Paste after / before |
| `u` / `<C-r>` | Undo / redo |
| `r<char>` / `R` | Replace one character / enter Replace mode |
| `c{motion}` | Change a range, such as `cw` or `c$` |
| `d{motion}` | Delete a range, such as `dw` or `d}` |
| `y{motion}` | Yank a range, such as `yiw` |
| `.` | Repeat the last change |
| `J` | Join the next line |
| `>>` / `<<` | Indent / outdent a line |
| `=` with a motion | Re-indent, for example `=ap` |
| `gcc` | Toggle comment on the current line |
| `gc{motion}` | Toggle comments over a range |
| `gO` / `go` | Add a blank line above / below without entering Insert mode |
| `gy` / `gp` | Explicitly copy to / paste from the system clipboard |
| `<C-s>` | Save; from Insert/Visual mode, also return to Normal mode |

Because `clipboard=unnamedplus` is active, regular `y`, `d`, `c`, and `p`
already use the macOS clipboard. Use the black-hole register when you want to
delete without replacing your current clipboard:

```text
"+ is the system clipboard register
"+yy copies a line explicitly
"+p pastes explicitly
"_ is the discard (black-hole) register
"_dd deletes a line without replacing the clipboard
```

The practical discard command is `"_dd` (replace `dd` with any delete
operation).

In Visual mode, this config adds:

| Keys | Action |
|---|---|
| `J` / `K` | Move the selected lines down / up |
| `gy` | Copy selection to system clipboard |
| `gp` | Paste over selection without replacing the clipboard |
| `g/` | Search only inside the selection |

## Files and search

### Telescope

| Keys | Action |
|---|---|
| `<leader>ff` | Find files under the current working directory |
| `<leader>fg` | Live grep file contents |
| `<leader>fb` | Find an open buffer |
| `<leader>fh` | Search Neovim help |

Common Telescope controls:

| Keys | Action |
|---|---|
| `<C-n>` / `<C-p>` | Next / previous result |
| `<CR>` | Open selection |
| `<C-x>` | Open in a horizontal split |
| `<C-v>` | Open in a vertical split |
| `<C-t>` | Open in a tab |
| `<Esc>` | Close |

Useful discovery commands:

```vim
:Telescope keymaps
:Telescope commands
:Telescope help_tags
```

### Snacks explorer

| Keys | Action |
|---|---|
| `<leader>fe` | Reveal the current file in the explorer |
| `<leader>rF` | Rename the current file and notify attached LSPs |

### Oil

Press `-` to replace the current buffer with an editable directory listing.
Edit file names like normal text, then `:w` to apply filesystem changes.

| Keys inside Oil | Action |
|---|---|
| `<CR>` | Open entry |
| `-` | Parent directory |
| `<C-s>` / `<C-h>` | Open in vertical / horizontal split |
| `<C-t>` | Open in a tab |
| `<C-p>` | Preview |
| `g.` | Toggle hidden files |
| `gs` | Change sorting |
| `gx` | Open with the system application |
| `g?` | Show all Oil bindings |
| `<C-c>` | Close Oil |

Oil supports creating, renaming, moving, and deleting through ordinary buffer
edits. Review the listing before `:w`; those edits affect the real filesystem.

## Buffers, windows, and tabs

A buffer is an open file. A window is a view onto a buffer. A tab is a window
layout, not the primary representation of an open file.

### Buffers

| Keys | Action |
|---|---|
| `]b` / `[b` | Next / previous buffer |
| `<leader>bd` | Close current buffer |
| `<leader>bp` | Pick a buffer from the buffer line |
| `<leader>bH` / `<leader>bL` | Move buffer tab left / right |
| `<leader>fb` | Find an open buffer |

### Windows and splits

| Keys / command | Action |
|---|---|
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Focus left / down / up / right |
| `:split file` | Horizontal split |
| `:vsplit file` | Vertical split |
| `<C-w>q` | Close current window |
| `<C-w>=` | Equalize split sizes |
| `<C-w>_` / `<C-w>|` | Maximize height / width |

## Code intelligence and diagnostics

### LSP bindings

| Keys | Action |
|---|---|
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gr` | Find references with Telescope |
| `K` | Hover documentation when an LSP is attached |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action / quick fix |
| `<leader>e` | Show diagnostic under the cursor |
| `[d` / `]d` | Previous / next diagnostic |
| `[D` / `]D` | First / last diagnostic in the buffer |
| `<leader>li` | Show the names of LSP clients attached to this buffer |

Neovim also supplies buffer-local LSP defaults such as `grn` for rename,
`gra` for code actions, `grr` for references, and `gri` for implementation.
The shorter custom bindings above are the intended path in this setup.

Enabled servers:

| Area | Server |
|---|---|
| C# | `roslyn_ls` |
| TypeScript / JavaScript / React | `vtsls` |
| Tailwind CSS | `tailwindcss` |
| JSON | `jsonls` |
| Lua / Neovim config | `lua_ls` plus `lazydev.nvim` |
| Spelling in code and prose | `typos_lsp` |

Tailwind starts only when a project has a Tailwind config, a Tailwind
dependency, or a PostCSS config that mentions Tailwind.

Useful checks:

```vim
:checkhealth vim.lsp
:Mason
:checkhealth
```

## Completion, snippets, and Emmet

Completion is provided by `mini.completion`, snippets by `mini.snippets` plus
`friendly-snippets`, and pairs by `mini.pairs`.

| Keys in Insert mode | Action |
|---|---|
| `<C-Space>` | Force LSP completion, then fallback completion |
| `<A-Space>` | Force fallback completion |
| `<C-n>` / `<C-p>` | Next / previous completion item |
| `<C-y>` | Accept selected completion item |
| `<C-e>` | Cancel completion |
| `<C-f>` / `<C-b>` | Scroll completion documentation down / up |
| `<C-j>` | Expand a matching snippet |
| `<Tab>` / `<S-Tab>` | Jump forward / backward in an active built-in snippet |

In HTML, CSS, JSX, and TSX buffers, `<Tab>` has special behavior:

- If the completion popup is visible, it selects the next item.
- Otherwise, it tries to expand an Emmet abbreviation.
- If neither applies, it inserts a tab/indent.

Examples: type `div.card>h2+p` or `ul>li*3`, then press `<Tab>`.

## Formatting

| Keys | Action |
|---|---|
| `<leader>f` | Format the current file |
| Visual selection, `<leader>f` | Format only the selection |

Configured formatters:

| File types | Formatter |
|---|---|
| C# | CSharpier |
| TypeScript, TSX, JavaScript, JSX | Prettier |
| HTML, CSS, JSON | Prettier |

Formatting is manual; format-on-save is not configured. Prettier is resolved
from a project's `node_modules` first, then from `PATH`. The Tailwind Prettier
plugin is added when it is installed in a detected Tailwind project.

## Tests

Testing uses Neotest with the VSTest adapter, so the configured test workflow
is primarily for .NET tests.

| Keys | Action |
|---|---|
| `<leader>tn` | Run the nearest test |
| `<leader>tf` | Run all tests in the current file |
| `<leader>to` | Open test output and focus it |
| `<leader>ts` | Toggle the test summary |

There is no test-debug binding and no JavaScript test adapter configured.

## Git

### Telescope Git pickers

| Keys | Action |
|---|---|
| `<leader>gs` | Working-tree status |
| `<leader>gc` | Repository commits |
| `<leader>gh` | Commit history for the current file |
| `<leader>gb` | Branches |
| `<leader>gz` | Stashes |

### Inline diffs with MiniDiff

| Keys | Action |
|---|---|
| `]h` / `[h` | Next / previous hunk |
| `]H` / `[H` | Last / first hunk |
| `<leader>do` | Toggle detailed diff overlay |
| `ghgh` | Apply/stage the hunk under the cursor |
| `gHgh` | Reset/discard the hunk under the cursor |
| `dgh` | Delete the hunk range as a text object |

`gHgh` and `dgh` change buffer contents; inspect the hunk before using them.

### Fugitive

```vim
:Git
```

In the Fugitive status buffer:

| Keys | Action |
|---|---|
| `s` | Stage file or hunk |
| `u` | Unstage file or hunk |
| `-` | Toggle staged state |
| `=` | Toggle inline diff |
| `cc` | Create a commit |
| `g?` | Show all Fugitive bindings |

The shell alias `lg` launches Lazygit. From Neovim, use `:terminal lg`, or run
`lg` in a separate terminal pane.

## Code TODOs

| Keys | Action |
|---|---|
| `<leader>tc` | Search code TODO/FIXME comments |

## Terminal and external commands

```vim
:terminal
:split | terminal
:vsplit | terminal
```

The terminal automatically enters Terminal/Insert mode.

| Keys | Action |
|---|---|
| `<C-\><C-n>` | Leave Terminal mode for Normal mode |
| `i` | Re-enter Terminal mode |
| `<C-w>h/j/k/l` | Move to another window after leaving Terminal mode |
| `:bd` | Close the terminal buffer after leaving Terminal mode |

Run a shell command without opening a terminal buffer:

```vim
:!dotnet build
:!dotnet test
:!dotnet run
:!npm test
```

Use `:make` only after configuring an appropriate `makeprg`; this setup does
not currently set one.

## Search, spelling, and useful toggles

These `mini.basics` mappings begin with a literal backslash, not the leader:

| Keys | Action |
|---|---|
| `\w` | Toggle line wrapping |
| `\s` | Toggle spelling |
| `\r` | Toggle relative line numbers |
| `\n` | Toggle line numbers |
| `\d` | Toggle diagnostics for the buffer |
| `\h` | Toggle search highlighting |
| `\c` | Toggle cursor line |
| `\C` | Toggle cursor column |
| `\l` | Toggle invisible/list characters |
| `\i` | Toggle case-insensitive search |
| `\b` | Toggle dark/light background |

Spelling is enabled automatically in Git commit, Markdown, and text buffers.

| Keys | Action |
|---|---|
| `]s` / `[s` | Next / previous misspelling |
| `z=` | Built-in spelling suggestions |
| `<leader>ss` | Fuzzy spelling suggestions |
| `zg` | Add word to spell file |
| `zw` | Mark word as wrong |

## Saving, quitting, and recovery

| Command / keys | Action |
|---|---|
| `:w` or `<C-s>` | Save |
| `:q` | Close window |
| `:wq` or `ZZ` | Save and close |
| `:q!` or `ZQ` | Close and discard unsaved changes |
| `:qa` | Close all windows |
| `:qa!` | Close everything and discard unsaved changes |
| `:e!` | Reload current file and discard unsaved changes |
| `<leader>so` | Reload `init.lua` |

Persistent undo is enabled, so undo history normally survives closing and
reopening a file. Swap files are disabled.

## Help and self-discovery

```vim
:help topic
:help gd
:help :terminal
:help telescope
:Telescope keymaps
:Telescope commands
:map
:nmap <leader>
:messages
:checkhealth
```

Press `<C-]>` on a help link to follow it and `<C-o>` to go back. The most
useful meta-skill in Neovim is learning to ask `:help` about the key or command
currently in front of you.

## Config and plugin maintenance

```vim
# Open the active config from the shell.
nvim ~/.config/nvim/init.lua
```

Inside Neovim:

```vim
" Reload the config after editing it.
<leader>so

" Ask native vim.pack to check and interactively update plugins.
:lua vim.pack.update()

" Inspect external tools managed for Neovim.
:Mason
```

The plugin lock file is `~/.config/nvim/nvim-pack-lock.json`.

## Current gaps and sharp edges

These are the main differences still standing between this setup and a
comfortable Rider replacement:

1. **No debugger:** there is no DAP client, .NET debug adapter, breakpoint UI,
   or debug keymap.
2. **No run/build workflow:** builds and app launches are still terminal
   commands, with no compiler-output quickfix integration.
3. **C# tests only:** Neotest has VSTest, but no JS/TS test adapter and no test
   debugging.
4. **Two file explorers:** Snacks gives a conventional tree; Oil treats a
   directory as editable text. Both are useful, but choosing one primary mental
   model will make the setup easier to learn.
5. **No key-hint popup:** there is no which-key-style leader menu, so use this
   sheet or `:Telescope keymaps`.
6. **No format-on-save:** formatting is deliberately triggered with
   `<leader>f`.

The strongest existing path is already **editing + navigation + LSP + C# tests
+ Git**. Debugging and repeatable run/build commands are the largest remaining
Rider-shaped holes.
