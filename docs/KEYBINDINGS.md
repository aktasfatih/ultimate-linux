# Complete Keybinding Reference

This document provides a comprehensive reference for all keybindings in the Ultimate Linux Development Setup.

## Table of Contents
- [tmux Keybindings](#tmux-keybindings)
- [Neovim Keybindings](#neovim-keybindings)
- [Zsh Keybindings](#zsh-keybindings)
- [Terminal Shortcuts](#terminal-shortcuts)

## tmux Keybindings

### Prefix Key
- **Prefix**: `Ctrl+Space` (all commands below require prefix unless noted)

### Session Management
| Key | Action |
|-----|--------|
| `Prefix + $` | Rename session |
| `Prefix + d` | Detach from session |
| `Prefix + D` | Choose session to detach |
| `Prefix + s` | List sessions (choose from tree view) |
| `Prefix + (` | Switch to previous session |
| `Prefix + )` | Switch to next session |
| `Prefix + L` | Switch to last session |
| `Prefix + Q` | Kill session (with confirmation) |
| `Prefix + Ctrl+c` | Create new session |
| `Prefix + Ctrl+f` | Find session by name |
| `Prefix + Ctrl+p` | Session picker with directory browsing (tmux-sessionizer) |
| `Prefix + Ctrl+w` | Window switcher across sessions |
| `Prefix + g` | Go to session (tmux-sessionist plugin) |

### Window Management
| Key | Action |
|-----|--------|
| `Prefix + c` | Create new window |
| `Prefix + &` | Kill current window |
| `Prefix + X` | Kill window |
| `Prefix + ,` | Rename window |
| `Prefix + .` | Move window |
| `Prefix + 0-9` | Switch to window by number |
| `Prefix + p` | Previous window |
| `Prefix + n` | Next window |
| `Prefix + Ctrl+h` | Previous window |
| `Prefix + Ctrl+l` | Next window |
| `Prefix + Tab` | Last active window |
| `Prefix + w` | List windows |
| `Prefix + f` | Find window |
| `Prefix + <` | Swap window left |
| `Prefix + >` | Swap window right |

### Pane Management
| Key | Action |
|-----|--------|
| `Prefix + \|` | Split pane horizontally |
| `Prefix + -` | Split pane vertically |
| `Prefix + x` | Kill current pane |
| `Prefix + q` | Show pane numbers |
| `Prefix + o` | Switch to next pane |
| `Prefix + h/j/k/l` | Navigate panes (vim-style) |
| `Prefix + H/J/K/L` | Resize panes (5 units) |
| `Prefix + Space` | Toggle pane layouts |
| `Prefix + z` | Toggle pane zoom |
| `Prefix + !` | Convert pane to window |
| `Prefix + {` | Move pane left |
| `Prefix + }` | Move pane right |
| `Prefix + J` | Join pane from window |
| `Prefix + B` | Break pane to new window |

### Copy Mode
| Key | Action |
|-----|--------|
| `Prefix + Enter` | Enter copy mode |
| `v` | Begin selection (in copy mode) |
| `Ctrl+v` | Rectangle selection |
| `y` | Copy selection |
| `Escape` | Exit copy mode |
| `h/j/k/l` | Navigate (vim-style) |
| `H/L` | Start/End of line |
| `/` | Search forward |
| `?` | Search backward |
| `n/N` | Next/Previous search result |

### Other Commands
| Key | Action |
|-----|--------|
| `Prefix + r` | Reload tmux config |
| `Prefix + S` | Synchronize panes toggle |
| `Prefix + b` | Toggle status bar |
| `Prefix + t` | Show time |
| `Prefix + i` | Display message |
| `Prefix + ~` | Show previous messages |
| `Prefix + :` | Command prompt |

### Layout Shortcuts
| Key | Action |
|-----|--------|
| `Prefix + Alt+1` | Main horizontal layout |
| `Prefix + Alt+2` | Main vertical layout |
| `Prefix + Alt+3` | Even horizontal layout |
| `Prefix + Alt+4` | Even vertical layout |
| `Prefix + Alt+5` | Tiled layout |
| `Prefix + Ctrl+1` | Even horizontal layout (with message) |
| `Prefix + Ctrl+2` | Even vertical layout (with message) |
| `Prefix + Ctrl+3` | Main horizontal layout (with message) |
| `Prefix + Ctrl+4` | Main vertical layout (with message) |
| `Prefix + Ctrl+5` | Tiled layout (with message) |

### Popup Windows (Modern tmux 3.2+)
| Key | Action |
|-----|--------|
| `Prefix + g` | Open Lazygit in popup |
| `Prefix + G` | Open GitHub CLI dashboard in popup |
| `Prefix + P` | Process viewer (btm/htop/top) in popup |
| `Prefix + N` | Quick notes - opens today's note in popup |
| `Prefix + u` | URL picker - extract and open URLs from pane |
| `Prefix + e` | Directory explorer with preview |
| `Prefix + ?` | Show tmux cheatsheet |
| `Prefix + T` | Project templates selector |
| `` Prefix + ` `` | Toggle scratch terminal session |

### Advanced Copy Mode
| Key | Action |
|-----|--------|
| `Prefix + v` | Enter copy mode (alternative to Enter) |
| `Prefix + /` | Enter copy mode and start search |
| `Prefix + Ctrl+s` | Enter copy mode and start search |

### Additional Pane Commands
| Key | Action |
|-----|--------|
| `Prefix + "` | Split pane vertically (maintains path) |
| `Prefix + %` | Split pane horizontally (maintains path) |

### Plugin-Specific Keybindings
| Key | Action | Plugin |
|-----|--------|--------|
| `Prefix + Shift+s` | Save session | tmux-resurrect |
| `Prefix + Shift+r` | Restore session | tmux-resurrect |
| `Prefix + j` | Jump to text with hints | tmux-jump |
| `Prefix + Tab` (in copy mode) | Extract text | extrakto |
| `Prefix + @` | Join last active pane | tmux-sessionist |

### Session Navigation Shortcuts  
| Key | Action |
|-----|--------|
| `Prefix + g` | Go to session (sessionist) or Open Lazygit (see popup windows) |
| `Prefix + Shift+c` | Create new session (sessionist) |
| `Prefix + Shift+x` | Kill session without detaching (sessionist) |

## Neovim Keybindings

### Leader Key
- **Leader**: `Space`

### General
| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>Q` | Quit all |
| `<leader>nh` | Clear search highlights |
| `<leader>rn` | Toggle relative line numbers |

### Window Navigation
| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Navigate windows |
| `Ctrl+Up/Down` | Resize horizontal |
| `Ctrl+Left/Right` | Resize vertical |
| `<leader>sv` | Split vertical |
| `<leader>sh` | Split horizontal |
| `<leader>se` | Equal window size |
| `<leader>sx` | Close window |

### Buffer Management
| Key | Action |
|-----|--------|
| `Shift+h` | Previous buffer |
| `Shift+l` | Next buffer |
| `<leader>bd` | Delete buffer |
| `:bnext` or `:bn` | Next buffer |
| `:bprevious` or `:bp` | Previous buffer |
| `:b<number>` | Jump to specific buffer |
| `:buffers` or `:ls` | List all buffers |

### File Navigation (Telescope)
| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Browse buffers |
| `<leader>fh` | Help tags |
| `<leader>fe` | File browser |
| `<leader>fo` | Recent files |
| `<leader>fc` | Commands |
| `<leader>fk` | Keymaps |
| `<leader>fr` | Registers |
| `<leader>fm` | Marks |

### Git Integration

#### Quick Reference
| Tool | Launch Command | Description |
|------|----------------|-------------|
| **Lazygit** | `<leader>gg` | Full-featured Git UI (recommended) |
| **Fugitive** | `:Git` or `:G` | Vim-based Git interface |
| **Diffview** | `:DiffviewOpen` | Advanced diff viewer |
| **Gitsigns** | Built-in | Inline Git indicators |

#### Gitsigns (Hunks & Blame)
| Key | Action |
|-----|--------|
| `]c` | Next hunk |
| `[c` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>tb` | Toggle current line blame |
| `<leader>hd` | Diff this |
| `<leader>hD` | Diff this against ~ |
| `<leader>td` | Toggle deleted |
| `ih` | Select hunk (text object) |

#### Git Operations (Leader + g)
| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gj` | Next hunk |
| `<leader>gk` | Previous hunk |
| `<leader>gl` | Blame line |
| `<leader>gp` | Preview hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gR` | Reset buffer |
| `<leader>gs` | Git status (Telescope) |
| `<leader>gu` | Undo stage hunk |
| `<leader>gd` | Diff against HEAD |

#### Telescope Git
| Key | Action |
|-----|--------|
| `<leader>gc` | Git commits (browse history) |
| `<leader>gb` | Git branches (switch/create) |
| `<leader>gs` | Git status (changed files) |

#### Fugitive - Core Commands
| Command | Action |
|---------|--------|
| `:Git` or `:G` | Open Git status window |
| `:Git add %` | Stage current file |
| `:Git add .` | Stage all files |
| `:Git commit` | Commit staged changes |
| `:Git commit --amend` | Amend last commit |
| `:Git push` | Push to remote |
| `:Git pull` | Pull from remote |
| `:Git fetch` | Fetch from remote |
| `:Git blame` | Show blame for current file |
| `:Git log` | Show commit log |
| `:Git log --oneline` | Compact log view |
| `:Gwrite` or `:Gw` | Stage current file |
| `:Gread` or `:Gr` | Checkout file (discard changes) |
| `:GMove <path>` | Rename/move file |
| `:GDelete` | Delete file and stage |
| `:GBrowse` | Open file in web browser |

#### Fugitive - Status Window (`:Git`)
| Key | Action |
|-----|--------|
| `s` | Stage file/hunk |
| `u` | Unstage file/hunk |
| `-` | Toggle stage/unstage |
| `=` | Toggle inline diff |
| `dd` | Open file diff |
| `dv` | Open diff in vertical split |
| `ds` | Open diff in horizontal split |
| `dp` | Open diff in preview window |
| `<Enter>` | Open file |
| `o` | Open in horizontal split |
| `O` | Open in new tab |
| `gO` | Open in vertical split |
| `cc` | Commit |
| `ca` | Commit amend |
| `ce` | Commit amend without editing |
| `cw` | Reword last commit |
| `X` | Discard change |
| `gq` | Close status window |
| `R` | Refresh status |
| `.` | Enter command line with `:Git` |

#### Fugitive - Diff and Merge
| Command | Action |
|---------|--------|
| `:Gdiffsplit` or `:Gds` | Open 3-way diff (merge conflicts) |
| `:Gdiffsplit!` | Open 3-way diff (force) |
| `:Ghdiffsplit` | Horizontal diff split |
| `:Gvdiffsplit` | Vertical diff split (default) |
| `:Git mergetool` | Launch merge tool |

#### Fugitive - In Diff Mode
| Key | Action |
|-----|--------|
| `]c` | Jump to next change |
| `[c` | Jump to previous change |
| `do` | Diff obtain (take other version) |
| `dp` | Diff put (use current version) |
| `:diffget //2` | Get from target branch (left) |
| `:diffget //3` | Get from merge branch (right) |
| `:diffget` | Get from other window |
| `:diffput` | Put to other window |
| `:diffupdate` | Re-scan for differences |
| `zo` | Open fold |
| `zc` | Close fold |
| `zr` | Open all folds |
| `zm` | Close all folds |

#### Fugitive - Blame Mode (`:Git blame`)
| Key | Action |
|-----|--------|
| `<Enter>` | Open commit |
| `o` | Open commit in split |
| `O` | Open commit in tab |
| `-` | Reblame at parent commit |
| `P` | Reblame at parent commit (in new tab) |
| `~` | Reblame at [count]th first grandparent |
| `g?` | Show help |
| `q` | Close blame |
| `A` | Resize to author column |
| `C` | Resize to commit column |
| `D` | Resize to date column |

#### Diffview - Commands
| Command | Action |
|---------|--------|
| `:DiffviewOpen` | Open diff view of working changes |
| `:DiffviewOpen HEAD~2` | View changes from 2 commits ago |
| `:DiffviewOpen HEAD~2..HEAD` | View range of commits |
| `:DiffviewOpen <branch>` | Compare with branch |
| `:DiffviewClose` | Close diff view |
| `:DiffviewToggleFiles` | Toggle file panel |
| `:DiffviewRefresh` | Refresh the diff |
| `:DiffviewFileHistory` | View file history |
| `:DiffviewFileHistory %` | History of current file |
| `:DiffviewFileHistory path/` | History of directory |
| `:DiffviewFocusFiles` | Focus file panel |
| `:DiffviewLog` | Show Diffview log |

#### Diffview - Keybindings (In Diffview)
| Key | Action | Context |
|-----|--------|--------|
| `Tab` | Select next entry | File panel |
| `Shift+Tab` | Select previous entry | File panel |
| `gf` | Open file in new tab | File panel |
| `<C-w>gf` | Open file in split | File panel |
| `<C-w><C-f>` | Open file in split | File panel |
| `<C-t>` | Open in new tab | File panel |
| `<C-v>` | Open in vertical split | File panel |
| `<C-x>` | Open in horizontal split | File panel |
| `-` | Toggle stage/unstage | File panel |
| `S` | Stage all | File panel |
| `U` | Unstage all | File panel |
| `X` | Restore entry | File panel |
| `L` | Open commit log | File panel |
| `zo` | Expand fold | File panel |
| `zc` | Collapse fold | File panel |
| `za` | Toggle fold | File panel |
| `zR` | Expand all folds | File panel |
| `zM` | Collapse all folds | File panel |
| `<leader>e` | Focus files | Diff view |
| `<leader>b` | Toggle files | Diff view |
| `]x` | Jump to next conflict | Diff view |
| `[x` | Jump to previous conflict | Diff view |
| `g?` | Show help | Any |

#### Diffview - File History View
| Key | Action |
|-----|--------|
| `<C-n>` or `j` | Next entry |
| `<C-p>` or `k` | Previous entry |
| `<Enter>` | Open commit |
| `o` | Open in horizontal split |
| `O` | Open in new tab |
| `gO` | Open in vertical split |
| `y` | Copy commit hash |
| `zR` | Open all folds |
| `zM` | Close all folds |
| `q` | Close file history |

#### Conflict Resolution (Fugitive)
| Key/Command | Action |
|-------------|--------|
| `:Gdiffsplit` | Open 3-way merge |
| `]c` | Next conflict |
| `[c` | Previous conflict |
| `:diffget //2` | Get from left (target) |
| `:diffget //3` | Get from right (merge) |
| `:Gwrite` | Save and stage |
| `do` | Obtain diff (take theirs) |
| `dp` | Put diff (give ours) |

### LSP Functions
| Key | Action |
|-----|--------|
| `gD` | Go to declaration |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gi` | Go to implementation |
| `Ctrl+k` | Signature help |
| `<leader>wa` | Add workspace folder |
| `<leader>wr` | Remove workspace folder |
| `<leader>wl` | List workspace folders |
| `<leader>D` | Type definition |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (see TypeScript section) |
| `gr` | Find references |
| `<leader>e` | Show diagnostics |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>q` | Diagnostic list |
| `<leader>f` | Format document |

### LSP Telescope
| Key | Action |
|-----|--------|
| `<leader>lr` | LSP references |
| `<leader>ld` | LSP definitions |
| `<leader>li` | LSP implementations |
| `<leader>lt` | LSP type definitions |
| `<leader>ls` | Document symbols |
| `<leader>lw` | Workspace symbols |

### TypeScript/JavaScript Specific

#### Core Navigation
| Key | Action | Notes |
|-----|--------|-------|
| `gd` | Go to definition | Works with imports, functions, components |
| `gr` | Find all references | See where a component/function is used |
| `gi` | Go to implementation | Jump to actual implementation |
| `<leader>D` | Type definition | See TypeScript type definitions |
| `K` | Hover info | Shows type info, JSDoc comments |

#### Code Actions (`<leader>ca`)
When you press `<leader>ca`, you'll see context-specific actions:
- **Organize imports** - Sort and remove unused imports
- **Add missing imports** - Auto-import unresolved symbols
- **Fix all auto-fixable problems** - Apply ESLint fixes
- **Remove unused variables**
- **Add missing function return type**
- **Convert to arrow function**
- **Extract to function/variable**
- **Move to new file**

#### TypeScript Commands
| Command | Action |
|---------|--------|
| `:TSC` | Run TypeScript compiler check |
| `:EslintFixAll` | Fix all ESLint issues |
| `:Prettier` | Format with Prettier |

#### Import Management Tips
```vim
" Quick import organization (add to your config)
vim.keymap.set('n', '<leader>lo', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = {"source.organizeImports"},
      diagnostics = {},
    },
  })
end, { desc = "Organize Imports" })

" Remove unused imports
vim.keymap.set('n', '<leader>lu', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = {"source.removeUnused"},
      diagnostics = {},
    },
  })
end, { desc = "Remove Unused" })
```

#### Next.js Specific Tips
1. **Component Navigation**:
   - `gd` on a component jumps to its definition
   - `gr` shows all pages using that component
   - Use `<leader>ls` to see all components in current file

2. **Quick Actions**:
   - On import errors: `<leader>ca` → "Add missing import"
   - On type errors: `K` to see expected types
   - `<leader>rn` to rename components across files

3. **Debugging TypeScript Errors**:
   - Errors are translated to plain English (ts-error-translator)
   - Use `<leader>e` to see full error
   - `[d` / `]d` to jump between errors

#### React/JSX Snippets
While coding, these snippets expand:
- `rafce` → React Arrow Function Component
- `useState` → `const [state, setState] = useState()`
- `useEffect` → Full useEffect block

#### File Navigation for Next.js
| Key | Action | Example |
|-----|--------|--------|
| `<leader>ff` | Find files | Quick jump to pages/components |
| `<leader>fg` | Grep in files | Search for component usage |
| `<leader>fb` | Browse buffers | Switch between open files |

#### Format & Lint
| Key | Action |
|-----|--------|
| `<leader>f` | Format file (Prettier) |
| `<leader>ca` → "Fix all" | Apply ESLint fixes |
| `:w` | Auto-formats on save (if enabled) |
| `<leader>tf` | Toggle format on save |
| `<leader>lo` | Organize imports |
| `<leader>lu` | Remove unused imports |

### File Explorer (NvimTree)

#### Opening/Closing
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>nf` | Find current file in tree |

#### Navigation (Inside NvimTree)
| Key | Action |
|-----|--------|
| `j`/`k` or `↑`/`↓` | Move up/down |
| `h`/`l` or `←`/`→` | Close/open folders |
| `Enter` or `o` | Open file/folder |
| `Tab` | Open file but stay in tree |
| `-` | Go to parent directory |
| `Backspace` | Close current folder |

#### Window Switching
| Key | Action |
|-----|--------|
| `Ctrl+w h` or `Ctrl+h` | Move to left window (tree → editor) |
| `Ctrl+w l` or `Ctrl+l` | Move to right window (editor → tree) |
| `Ctrl+w w` | Cycle through windows |

#### File Operations
| Key | Action |
|-----|--------|
| `a` | Create file/folder (add `/` for folder) |
| `r` | Rename |
| `d` | Delete |
| `x` | Cut |
| `c` | Copy |
| `p` | Paste |
| `y` | Copy name |
| `Y` | Copy relative path |
| `gy` | Copy absolute path |

#### Opening Methods
| Key | Action |
|-----|--------|
| `Enter` or `o` | Open in current window |
| `Ctrl+v` | Open in vertical split |
| `Ctrl+s` | Open in horizontal split |
| `Ctrl+t` | Open in new tab |
| `Tab` | Preview (open but stay in tree) |

#### View Options
| Key | Action |
|-----|--------|
| `H` | Toggle hidden files |
| `I` | Toggle ignored files |
| `R` | Refresh tree |
| `W` | Collapse all |
| `E` | Expand all |
| `S` | Search |
| `f` | Filter (live) |
| `F` | Clear filter |

### Text Manipulation
| Key | Action |
|-----|--------|
| `<` | Indent left (visual) |
| `>` | Indent right (visual) |
| `Alt+j` | Move line down |
| `Alt+k` | Move line up |
| `p` | Paste without yanking (visual) |
| `Y` | Yank to end of line |

### Search and Replace
| Key | Action |
|-----|--------|
| `<leader>s` | Replace word under cursor |

### Clipboard Operations
| Key | Action |
|-----|--------|
| `<leader>y` | Copy to system clipboard (normal/visual) |
| `<leader>Y` | Copy line to system clipboard |
| `<leader>p` | Paste from system clipboard |
| `<leader>P` | Paste before from system clipboard |

### Terminal
| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Navigate from terminal |

## Zsh Keybindings

### Navigation
| Key | Action |
|-----|--------|
| `Ctrl+a` | Beginning of line |
| `Ctrl+e` | End of line |
| `Ctrl+f` | Forward one character |
| `Ctrl+b` | Backward one character |
| `Alt+f` | Forward one word |
| `Alt+b` | Backward one word |

### Editing
| Key | Action |
|-----|--------|
| `Ctrl+d` | Delete character |
| `Ctrl+h` | Delete backward |
| `Ctrl+w` | Delete word backward |
| `Ctrl+k` | Delete to end of line |
| `Ctrl+u` | Delete to beginning |
| `Ctrl+y` | Paste (yank) |
| `Alt+d` | Delete word forward |
| `Alt+Backspace` | Delete word backward |

### History
| Key | Action |
|-----|--------|
| `Ctrl+r` | Search history |
| `Ctrl+p` | Previous command |
| `Ctrl+n` | Next command |
| `!!` | Last command |
| `!$` | Last argument |

### Auto-suggestions
| Key | Action |
|-----|--------|
| `→` | Accept suggestion |
| `Ctrl+→` | Accept word |
| `Alt+→` | Accept line |

### FZF Integration
| Key | Action |
|-----|--------|
| `Ctrl+t` | File picker |
| `Ctrl+r` | History search |
| `Alt+c` | Directory picker |

## Terminal Shortcuts

### General Terminal
| Key | Action |
|-----|--------|
| `Ctrl+Shift+c` | Copy |
| `Ctrl+Shift+v` | Paste |
| `Ctrl+l` | Clear screen |
| `Ctrl+z` | Suspend process |
| `Ctrl+c` | Interrupt process |
| `Ctrl+d` | Exit/EOF |

### Job Control
| Key | Action |
|-----|--------|
| `Ctrl+z` | Suspend job |
| `fg` | Resume job |
| `bg` | Background job |
| `jobs` | List jobs |

## Custom Aliases

### Navigation
| Alias | Command |
|-------|---------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `~` | `cd ~` |
| `-` | `cd -` |

### Git Shortcuts
| Alias | Command |
|-------|---------|
| `g` | `git` |
| `ga` | `git add` |
| `gc` | `git commit -v` |
| `gd` | `git diff` |
| `gst` | `git status` |
| `gp` | `git push` |
| `gl` | `git pull` |

### Utility
| Alias | Command |
|-------|---------|
| `ll` | `ls -l` |
| `la` | `ls -la` |
| `lt` | `ls -tree` |
| `reload` | `source ~/.zshrc` |

## Tips and Tricks

### tmux
- Hold `Shift` to select text with mouse (bypasses tmux mouse mode) (built-in)
- Use `Prefix + z` to zoom a pane for focused work (built-in)
- `Prefix + S` to type in all panes simultaneously (built-in)
- `Prefix + Ctrl+p` opens tmux-sessionizer to quickly create/switch sessions in any directory (custom script)
- `Prefix + f` is bound to session manager, not the default find-window (built-in, remapped)

#### Popup Windows (tmux 3.2+)
- `Prefix + P` opens process viewer - btm → htop → top fallback (custom popup)
- `Prefix + N` creates/opens today's note in ~/notes/ (custom popup)
- `Prefix + u` extracts URLs from current pane and lets you open them (custom popup)
- `Prefix + e` explores directories with live preview (custom popup)
- `` Prefix + ` `` toggles a scratch terminal session (custom popup)
- `Prefix + G` opens GitHub CLI dashboard if gh is installed (custom popup)
- `Prefix + T` shows project templates for quick setup (custom popup + script)

#### Plugin Features
- **tmux-resurrect**: Save/restore complete tmux environment with `Prefix + Shift+s/r`
- **tmux-jump**: Press `Prefix + j` then type letters to jump to text on screen
- **extrakto**: In copy mode, `Tab` extracts text snippets like paths, URLs, IPs, etc.
- **tmux-yank**: Enhanced clipboard integration with system clipboard
- **tmux-copycat**: Enhanced search in copy mode with predefined regex patterns
- **tmux-open**: In copy mode, `o` opens highlighted file/URL (Shift+o for editor)
- **tmux-fpp**: Facebook PathPicker integration for selecting files from output
- **tmux-prefix-highlight**: Shows when prefix is active in status bar

### Neovim
- Use `gcc` to comment/uncomment lines
- `<leader>z` for Zen mode (distraction-free editing)
- `:Mason` to manage language servers

### Shell
- Type partial command and press `↑` to search history
- Use `z <partial-path>` to jump to frequently used directories
- `Ctrl+x Ctrl+e` to edit command in editor

### TypeScript Development
- **Auto-imports**: Start typing a component name and use `<C-n>` for completion
- **Quick info**: Hover over any variable with `K` to see its type
- **Error navigation**: Use `]d` to jump to next error, `[d` for previous
- **Rename everywhere**: `<leader>rn` on a component renames it in all files
- **Find usages**: `gr` on a function/component to see where it's used
- **Quick fix**: `<leader>ca` offers contextual fixes (missing imports, etc.)
- **Type checking**: Errors appear as you type, no need to run `npm run build`

## Git Workflow Best Practices

### Choosing the Right Tool

#### Use Lazygit (`<leader>gg`) when:
- You want a full visual Git interface
- Doing complex operations (rebase, cherry-pick)
- Managing multiple files/commits
- You prefer interactive UI

#### Use Fugitive (`:Git`) when:
- You want to stay in Vim
- Quick commits and staging
- Resolving merge conflicts
- You know exact Git commands

#### Use Diffview (`:DiffviewOpen`) when:
- Reviewing large sets of changes
- Comparing branches or commits
- Exploring file history
- Need side-by-side diffs

#### Use Gitsigns (inline) when:
- Reviewing changes while coding
- Quick hunk staging/unstaging
- Inline blame information
- Navigating changes in current file

### Common Workflows

#### 1. Making a Commit
```
Method A - Lazygit (Visual):
1. <leader>gg                    # Open Lazygit
2. Space to stage files          # Stage what you want
3. c to commit                   # Write commit message

Method B - Fugitive (Vim-style):
1. :Git                          # Open status
2. Navigate to file, press s     # Stage files
3. cc                           # Commit

Method C - Gitsigns (Quick):
1. <leader>hs                    # Stage hunks as you review
2. :Git commit                   # Commit when ready
```

#### 2. Interactive Rebase
```
Method A - Lazygit (Recommended):
1. <leader>gg                    # Open Lazygit
2. Navigate to commit
3. r                            # Start rebase
4. e/s/f/d for edit/squash/fixup/drop

Method B - Fugitive:
1. :Git rebase -i HEAD~3         # Start rebase
2. Edit in Vim buffer            # Change pick to edit/squash/etc
3. :wq                          # Save and start rebase
4. :Git rebase --continue        # After making changes
```

#### 3. Resolving Conflicts
```
Method A - Fugitive 3-way merge:
1. Open conflicted file
2. :Gdiffsplit                   # Opens 3-way view
3. ]c / [c                       # Navigate conflicts
4. :diffget //2 or //3           # Choose version
5. :Gwrite                       # Save and stage

Method B - Lazygit:
1. <leader>gg                    # Open Lazygit
2. Enter on conflicted file      # See conflicts
3. Space to pick chunks          # Choose what to keep

Method C - Diffview:
1. :DiffviewOpen                 # See all conflicts
2. Navigate with ]x / [x         # Jump between conflicts
3. Use do/dp or manual edit      # Resolve
```

#### 4. Reviewing Changes
```
Before commit:
:DiffviewOpen                    # See all changes
<leader>gp                       # Preview specific hunk

Compare branches:
:DiffviewOpen main...feature     # See branch differences

File history:
:DiffviewFileHistory %           # Current file history
```

#### 5. Branch Operations
```
Switch branches:
<leader>gb                       # Telescope branch picker
:Git checkout -b new-feature     # Create new branch

Merge:
:Git merge feature-branch        # Merge branch
:Gdiffsplit                      # If conflicts arise
```

### Advanced Tips

#### Fugitive Power User
- In `:Git` status, use `.` to populate command line
- Use `dv` on a file to see diff in vertical split
- `X` on a file discards all changes (careful!)
- In blame view, `-` goes to parent commit

#### Diffview Navigation
- Use `Tab`/`Shift+Tab` to quickly navigate files
- `gf` opens file in new tab from file panel
- `L` shows commit log for selected file
- `g?` shows context-sensitive help

#### Quick Commands
```vim
" Quick amend
:Git commit --amend --no-edit

" Stash operations
:Git stash
:Git stash pop

" Reset operations
:Git reset --soft HEAD^
:Git reset --hard HEAD

" Quick push
:Git push origin HEAD
```

### Recommended Keybinding Additions

Add these to your Neovim config for more power:

```lua
-- Quick Diffview bindings
vim.keymap.set('n', '<leader>do', ':DiffviewOpen<CR>')
vim.keymap.set('n', '<leader>dc', ':DiffviewClose<CR>')
vim.keymap.set('n', '<leader>dh', ':DiffviewFileHistory %<CR>')

-- Quick Fugitive bindings  
vim.keymap.set('n', '<leader>G', ':Git<CR>')
vim.keymap.set('n', '<leader>gP', ':Git push<CR>')
vim.keymap.set('n', '<leader>gp', ':Git pull<CR>')

-- Additional Fugitive keybindings
vim.keymap.set('n', '<leader>gB', ':Git blame<CR>')              -- Git blame
vim.keymap.set('n', '<leader>gL', ':Git log<CR>')                -- Git log
vim.keymap.set('n', '<leader>gl', ':Git log --oneline<CR>')      -- Compact log
vim.keymap.set('n', '<leader>gD', ':Gdiffsplit<CR>')             -- Diff split
vim.keymap.set('n', '<leader>gH', ':Ghdiffsplit<CR>')            -- Horizontal diff
vim.keymap.set('n', '<leader>gV', ':Gvdiffsplit<CR>')            -- Vertical diff
vim.keymap.set('n', '<leader>gw', ':Gwrite<CR>')                 -- Stage current file
vim.keymap.set('n', '<leader>gW', ':Gwrite!<CR>')                -- Stage and force write
vim.keymap.set('n', '<leader>gq', ':Git checkout %<CR>')         -- Discard changes
vim.keymap.set('n', '<leader>gC', ':Git commit<CR>')             -- Commit
vim.keymap.set('n', '<leader>gA', ':Git commit --amend<CR>')     -- Amend commit
vim.keymap.set('n', '<leader>gM', ':Git merge<CR>')              -- Start merge
vim.keymap.set('n', '<leader>gS', ':Git stash<CR>')              -- Stash changes
vim.keymap.set('n', '<leader>gU', ':Git stash pop<CR>')          -- Pop stash
vim.keymap.set('n', '<leader>gR', ':Git rebase -i<CR>')          -- Interactive rebase
vim.keymap.set('n', '<leader>gF', ':Git fetch<CR>')              -- Fetch from remote
vim.keymap.set('n', '<leader>go', ':GBrowse<CR>')                -- Open in browser
vim.keymap.set('n', '<leader>gO', ':GBrowse!<CR>')               -- Copy URL to clipboard

-- Quick status with auto-refresh
vim.keymap.set('n', '<leader>gs', function()
  vim.cmd('Git')
  vim.cmd('wincmd L')  -- Move to right split
end, { desc = "Git status in vsplit" })

-- Quick diff against index
vim.keymap.set('n', '<leader>gdi', ':Git diff<CR>', { desc = "Diff against index" })
vim.keymap.set('n', '<leader>gdc', ':Git diff --cached<CR>', { desc = "Diff cached/staged" })
vim.keymap.set('n', '<leader>gdh', ':Git diff HEAD<CR>', { desc = "Diff against HEAD" })

-- Branch operations
vim.keymap.set('n', '<leader>gbc', ':Git checkout -b ', { desc = "Create branch" })
vim.keymap.set('n', '<leader>gbd', ':Git branch -d ', { desc = "Delete branch" })
vim.keymap.set('n', '<leader>gbD', ':Git branch -D ', { desc = "Force delete branch" })
vim.keymap.set('n', '<leader>gbr', ':Git branch -m ', { desc = "Rename branch" })

-- Quick conflict resolution helpers
vim.keymap.set('n', '<leader>gmt', ':Git mergetool<CR>', { desc = "Open mergetool" })
vim.keymap.set('n', '<leader>gmc', ':Git merge --continue<CR>', { desc = "Continue merge" })
vim.keymap.set('n', '<leader>gma', ':Git merge --abort<CR>', { desc = "Abort merge" })
vim.keymap.set('n', '<leader>grc', ':Git rebase --continue<CR>', { desc = "Continue rebase" })
vim.keymap.set('n', '<leader>gra', ':Git rebase --abort<CR>', { desc = "Abort rebase" })

-- Visual mode mappings for partial staging
vim.keymap.set('v', '<leader>gs', ':Gwrite<CR>', { desc = "Stage selection" })
vim.keymap.set('v', '<leader>gr', ':Gread<CR>', { desc = "Revert selection" })
```