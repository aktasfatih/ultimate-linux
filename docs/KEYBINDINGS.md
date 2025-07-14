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
| Key | Action |
|-----|--------|
| `<leader>gc` | Git commits |
| `<leader>gb` | Git branches |
| `<leader>gs` | Git status |

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
| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>nf` | Find current file |

### Text Manipulation
| Key | Action |
|-----|--------|
| `<` | Indent left (visual) |
| `>` | Indent right (visual) |
| `Alt+j` | Move line down |
| `Alt+k` | Move line up |
| `p` | Paste without yanking (visual) |

### Search and Replace
| Key | Action |
|-----|--------|
| `<leader>s` | Replace word under cursor |

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