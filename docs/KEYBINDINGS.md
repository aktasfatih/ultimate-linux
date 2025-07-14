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
| `Prefix + s` | List sessions |
| `Prefix + (` | Switch to previous session |
| `Prefix + )` | Switch to next session |
| `Prefix + L` | Switch to last session |
| `Prefix + Q` | Kill session (with confirmation) |
| `Prefix + Ctrl+c` | Create new session |
| `Prefix + Ctrl+f` | Find session |

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
| `Prefix + s` | Toggle status bar |
| `Prefix + t` | Show time |
| `Prefix + i` | Display message |
| `Prefix + ~` | Show previous messages |
| `Prefix + :` | Command prompt |

### Layout Shortcuts
| Key | Action |
|-----|--------|
| `Prefix + Alt+1` | Even horizontal layout |
| `Prefix + Alt+2` | Even vertical layout |
| `Prefix + Alt+3` | Main horizontal layout |
| `Prefix + Alt+4` | Main vertical layout |
| `Prefix + Alt+5` | Tiled layout |

## Neovim Keybindings

### Leader Key
- **Leader**: `Space`

### General
| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>Q` | Quit all |
| `<leader>h` | Clear search highlights |
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
| `<leader>gs` | Stage hunk |
| `<leader>gu` | Undo stage hunk |
| `<leader>gd` | Diff against HEAD |

#### Telescope Git
| Key | Action |
|-----|--------|
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |
| `<leader>go` | Git status (changed files) |

#### Fugitive Commands
| Command | Action |
|---------|--------|
| `:Git` or `:G` | Git status |
| `:Git add %` | Stage current file |
| `:Git commit` | Commit |
| `:Git push` | Push |
| `:Git pull` | Pull |
| `:Git blame` | Blame |
| `:Git log` | Log |
| `:Gdiffsplit` | 3-way merge conflict resolution |
| `:Gwrite` | Choose current buffer version |
| `:Gread` | Choose other version |

#### Diffview Commands
| Command | Action |
|---------|--------|
| `:DiffviewOpen` | Open diff view |
| `:DiffviewClose` | Close diff view |
| `:DiffviewToggleFiles` | Toggle file panel |
| `:DiffviewFileHistory` | File history |

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
| `<leader>ca` | Code action |
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
- Hold `Shift` to select text with mouse (bypasses tmux mouse mode)
- Use `Prefix + z` to zoom a pane for focused work
- `Prefix + S` to type in all panes simultaneously

### Neovim
- Use `gcc` to comment/uncomment lines
- `<leader>z` for Zen mode (distraction-free editing)
- `:Mason` to manage language servers

### Shell
- Type partial command and press `↑` to search history
- Use `z <partial-path>` to jump to frequently used directories
- `Ctrl+x Ctrl+e` to edit command in editor

## Git Workflow Best Practices

### Interactive Rebase
1. **Using Lazygit** (Recommended):
   - `<leader>gg` to open Lazygit
   - Press `r` on a commit to start rebase
   - Use `e` to edit, `s` to squash, `f` to fixup
   - Much easier than command line!

2. **Using Fugitive**:
   - `:Git rebase -i HEAD~3` to rebase last 3 commits
   - Edit in Vim's buffer with full power
   - Save and close to continue

### Resolving Conflicts
1. **Quick Resolution**:
   - When conflict occurs, open file
   - `:Gdiffsplit` for 3-way merge view
   - Navigate conflicts with `]c` and `[c`
   - Use `:diffget //2` or `:diffget //3` to choose version
   - `:Gwrite` to save and stage

2. **Visual Resolution with Lazygit**:
   - `<leader>gg` to open Lazygit
   - Navigate to conflicted file
   - Press `Enter` to see conflict
   - Choose resolution visually

### Staging Workflow
1. **Partial Staging**:
   - Review changes with `<leader>gp` (preview hunk)
   - Stage individual hunks with `<leader>gs`
   - Or use Lazygit for visual staging

2. **Quick Commands**:
   - `:Git add %` - Stage current file
   - `:Git reset %` - Unstage current file
   - `:Git checkout %` - Discard changes

### Recommended Plugins to Add
For enhanced Git workflow, consider adding:
- **git-conflict.nvim** - Better conflict markers visualization
- **git-rebase-auto-diff.nvim** - Auto diff during rebase
- **neogit** - Magit-like interface for Neovim