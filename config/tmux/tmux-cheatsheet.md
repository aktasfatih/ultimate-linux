# tmux Cheatsheet - Ultimate Linux Setup

## Prefix Key: `Ctrl+Space`

## Session Management
- `prefix + C-c` - Create new session
- `prefix + C-f` - Find and switch session
- `prefix + d` - Detach from session
- `prefix + $` - Rename session
- `prefix + s` - Session switcher
- `prefix + (` - Previous session
- `prefix + )` - Next session

## Window Management
- `prefix + c` - Create window (in current path)
- `prefix + w` - Window switcher
- `prefix + ,` - Rename window
- `prefix + &` - Kill window
- `prefix + 0-9` - Switch to window number
- `prefix + n` - Next window
- `prefix + p` - Previous window
- `Ctrl+h/l` - Previous/next window (no prefix)
- `prefix + </>` - Swap window left/right

## Pane Management
- `prefix + |` - Split vertical
- `prefix + -` - Split horizontal
- `prefix + h/j/k/l` - Navigate panes
- `prefix + H/J/K/L` - Resize panes (repeatable)
- `prefix + z` - Zoom/unzoom pane
- `prefix + x` - Kill pane
- `prefix + !` - Convert pane to window
- `prefix + Space` - Cycle layouts
- `prefix + {/}` - Swap panes

## Modern Features (Popup Windows)
- `prefix + g` - LazyGit popup
- `prefix + G` - GitHub Dashboard
- `prefix + Ctrl-f` - Fuzzy file finder
- `prefix + Ctrl-p` - Project sessionizer
- `prefix + Ctrl-w` - Window switcher with preview
- `prefix + backtick` - Scratch terminal
- `prefix + u` - URL picker
- `prefix + N` - Quick notes
- `prefix + e` - Directory explorer
- `prefix + P` - Process viewer (btm)
- `prefix + ?` - This cheatsheet
- `prefix + T` - Project templates

## Copy Mode
- `prefix + v` - Enter copy mode
- `prefix + [` - Enter copy mode (alternative)
- `v` - Start selection (in copy mode)
- `y` - Copy selection
- `Ctrl+v` - Rectangle selection
- `Escape` - Exit copy mode
- `prefix + ]` - Paste from buffer
- `prefix + p` - Paste from clipboard

## Search
- `prefix + /` - Search up (in copy mode)
- `prefix + Ctrl-s` - Search up (in copy mode)
- `prefix + C` - Copy to clipboard (copycat)
- `prefix + Ctrl-u` - URL search (copycat)
- `prefix + Ctrl-f` - File search (copycat)

## Other Features
- `prefix + r` - Reload config
- `prefix + S` - Toggle pane synchronization
- `prefix + s` - Toggle status bar
- `prefix + j` - Jump to text (tmux-jump)
- `prefix + Tab` - Extract text (extrakto)

## Quick Layouts
- `prefix + Ctrl-1` - Even horizontal
- `prefix + Ctrl-2` - Even vertical
- `prefix + Ctrl-3` - Main horizontal
- `prefix + Ctrl-4` - Main vertical
- `prefix + Ctrl-5` - Tiled

## Plugin Shortcuts
- `prefix + I` - Install plugins
- `prefix + U` - Update plugins
- `prefix + Alt-u` - Uninstall plugins
- `prefix + Ctrl-s` - Save session (resurrect)
- `prefix + Ctrl-r` - Restore session (resurrect)

## Tips
- Hold `Shift` to bypass tmux and select text with mouse
- `prefix + :` for command mode
- `prefix + ?` to list all key bindings
- Sessions persist even if you disconnect
- Use `tmux ls` to list sessions from terminal
- Use `tmux attach` to reattach to last session