# Ultimate Linux Development Cheatsheet

## 🎯 Quick Navigation
- [tmux Keybindings](#tmux-keybindings)
- [Neovim Commands](#neovim-commands)
  - [Debugging (DAP)](#debugging-dap)
- [Zsh/Shell Shortcuts](#zsh-shell-shortcuts)
- [Git Commands](#git-commands)
- [Modern CLI Tools](#modern-cli-tools)
- [System Management](#system-management)
- [Development Tools](#development-tools)

---

# tmux Keybindings

## Prefix Key: `Ctrl+Space`

### Session Management
| Key | Action | Notes |
|-----|--------|-------|
| `Prefix + $` | Rename session | Give meaningful names |
| `Prefix + d` | Detach from session | Session continues running |
| `Prefix + D` | Choose session to detach | Select from list |
| `Prefix + s` | List sessions (tree view) | Navigate with arrows |
| `Prefix + (` | Switch to previous session | Quick toggle |
| `Prefix + )` | Switch to next session | Cycle through |
| `Prefix + L` | Switch to last session | Toggle between two |
| `Prefix + Q` | Kill session (with confirmation) | Careful! |
| `Prefix + Ctrl+c` | Create new session | Fresh start |
| `Prefix + Ctrl+f` | Find session by name | Fuzzy search |
| `Prefix + Ctrl+p` | Session picker (tmux-sessionizer) | Project navigation |
| `Prefix + Ctrl+w` | Window switcher across sessions | Global view |

### Window Management
| Key | Action | Notes |
|-----|--------|-------|
| `Prefix + c` | Create new window | In current path |
| `Prefix + &` | Kill current window | With confirmation |
| `Prefix + ,` | Rename window | Descriptive names |
| `Prefix + .` | Move window to another session | Session:number |
| `Prefix + 0-9` | Switch to window by number | Direct access |
| `Prefix + p` | Previous window | Sequential |
| `Prefix + n` | Next window | Sequential |
| `Prefix + Ctrl+h` | Previous window | Vim-style |
| `Prefix + Ctrl+l` | Next window | Vim-style |
| `Prefix + Tab` | Last active window | Quick toggle |
| `Prefix + w` | List windows | Preview |
| `Prefix + <` | Swap window left | Reorder |
| `Prefix + >` | Swap window right | Reorder |

### Pane Management
| Key | Action | Notes |
|-----|--------|-------|
| `Prefix + |` | Split pane horizontally | Creates vertical divider |
| `Prefix + -` | Split pane vertically | Creates horizontal divider |
| `Prefix + x` | Kill current pane | With confirmation |
| `Prefix + q` | Show pane numbers | Quick jump |
| `Prefix + h/j/k/l` | Navigate panes | Vim-style |
| `Prefix + H/J/K/L` | Resize panes (5 units) | Hold for repeat |
| `Prefix + Space` | Toggle pane layouts | Cycle layouts |
| `Prefix + z` | Toggle pane zoom | Focus mode |
| `Prefix + !` | Convert pane to window | Break out |
| `Prefix + {` | Move pane left | Swap positions |
| `Prefix + }` | Move pane right | Swap positions |

### Copy Mode (Vi-style)
| Key | Action | Notes |
|-----|--------|-------|
| `Prefix + Enter` | Enter copy mode | Start selection |
| `Prefix + v` | Enter copy mode (alternative) | Vim-style |
| `Prefix + [` | Enter copy mode (traditional) | Classic tmux |
| `Prefix + /` | Enter copy mode and search | Find text |
| `v` | Begin selection | In copy mode |
| `Ctrl+v` | Rectangle selection | Block select |
| `y` | Copy selection | To clipboard |
| `Escape` | Exit copy mode | Cancel |

### Popup Windows (tmux 3.2+)
| Key | Action | Notes |
|-----|--------|-------|
| `Prefix + g` | Lazygit popup | Git interface |
| `Prefix + G` | GitHub CLI dashboard | gh required |
| `Prefix + P` | Process viewer | btm/htop/top |
| `Prefix + N` | Quick notes | Today's note |
| `Prefix + u` | URL picker | Extract & open |
| `Prefix + e` | Directory explorer | With preview |
| `Prefix + ?` | Show this cheatsheet | Help |
| `Prefix + T` | Project templates | Quick setup |
| `` Prefix + ` `` | Scratch terminal | Temporary session |

### Other tmux Commands
| Key | Action | Notes |
|-----|--------|-------|
| `Prefix + r` | Reload config | Apply changes |
| `Prefix + S` | Synchronize panes | Type everywhere |
| `Prefix + I` | Install plugins | TPM |
| `Prefix + U` | Update plugins | TPM |
| `Prefix + Shift+s` | Save session | tmux-resurrect |
| `Prefix + Shift+r` | Restore session | tmux-resurrect |

---

# Neovim Commands

## Leader Key: `Space`

### General
| Key | Action | Context |
|-----|--------|---------|
| `<leader>w` | Save file | Normal mode |
| `<leader>q` | Quit | Normal mode |
| `<leader>Q` | Quit all | Normal mode |
| `<leader>nh` | Clear search highlights | After searching |
| `<leader>rn` | Toggle relative line numbers | UI preference |
| `<leader>tw` | Toggle word wrap | Line wrapping on/off |
| `gcc` | Comment/uncomment line | Code editing |
| `gc` | Comment/uncomment selection | Visual mode |

### File Navigation (Telescope)
**Note**: Enhanced with fzf-native for faster, more accurate fuzzy searching

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | Find files | Fuzzy file search (fzf-native powered) |
| `<leader>fg` | Live grep | Search in files |
| `<leader>fb` | Browse buffers | Open buffers |
| `<leader>fh` | Help tags | Search help |
| `<leader>fe` | File browser | Directory navigation with file operations |
| `<leader>fo` | Recent files | History |
| `<leader>fc` | Commands | Command palette |
| `<leader>fk` | Keymaps | Show all keymaps |
| `<leader>fr` | Registers | Clipboard history |
| `<leader>fm` | Marks | Bookmarks |

#### Telescope File Browser (`<leader>fe`)
**Insert Mode:**
| Key | Action | Description |
|-----|--------|-------------|
| `Alt+c` | Create file/folder | Add new item (end with `/` for folder) |
| `Alt+r` | Rename | Rename selected item |
| `Alt+m` | Move | Move item to new location |
| `Alt+y` | Copy | Copy selected item |
| `Alt+d` | Delete | Remove selected item |
| `Ctrl+o` | Open | Open file/folder |
| `Ctrl+g` | Go to parent | Navigate up one directory |
| `Ctrl+e` | Go to home | Navigate to home directory |
| `Ctrl+w` | Go to cwd | Navigate to current working directory |
| `Ctrl+t` | Change cwd | Set current directory as working directory |
| `Ctrl+h` | Toggle hidden | Show/hide hidden files |

**Normal Mode:**
| Key | Action | Description |
|-----|--------|-------------|
| `c` | Create | Create new file/folder |
| `r` | Rename | Rename selected item |
| `m` | Move | Move item to new location |
| `y` | Copy | Copy selected item |
| `d` | Delete | Remove selected item |
| `o` | Open | Open file/folder |
| `g` | Go to parent | Navigate up one directory |
| `e` | Go to home | Navigate to home directory |
| `w` | Go to cwd | Navigate to current working directory |
| `t` | Change cwd | Set current directory as working directory |
| `h` | Toggle hidden | Show/hide hidden files |

### LSP Functions & Code Inspection
| Key | Action | Usage |
|-----|--------|-------|
| `gd` | Go to definition | Jump to code definition |
| `gD` | Go to declaration | Jump to declaration |
| `gr` | Find references | Where is this used? |
| `gi` | Go to implementation | Implementation details |
| `K` | Hover documentation | **Show function signature, params, return type, docs** |
| `<Ctrl-k>` | Signature help | Show function signature while typing parameters |
| `<leader>D` | Type definition | Jump to type definition |
| `<leader>ca` | Code action | Quick fixes/refactors |
| `<leader>rn` | Rename symbol | Rename everywhere |
| `<leader>f` | Format document | Auto-format code |
| `[d` | Previous diagnostic | Jump to previous error |
| `]d` | Next diagnostic | Jump to next error |
| `<leader>E` | Show diagnostics | Error details |

#### Function/Variable Inspection Workflow
1. **Position cursor** on any function or variable name
2. **Press `K`** to see detailed popup with:
   - Function signature and parameters
   - Return type information
   - Documentation and comments
   - Usage examples (if available)
3. **Press `<Ctrl-k>`** while typing function calls to see parameter hints
4. **Use `gd`** to jump to the actual definition for full context
5. **Use `gr`** to see all places where the symbol is used

### LSP Visual Indicators

#### Diagnostic Signs (Left Gutter)
| Symbol | Meaning | Description |
|--------|---------|-------------|
| `` | Error | Code has errors (red) |
| `` | Warning | Code has warnings (yellow) |
| `` | Info | Informational messages (blue) |
| `` | Hint | Code hints/suggestions (green) |

#### Code Action Indicators
| Symbol | Location | Meaning |
|--------|----------|---------|
| `💡` | Left gutter | Code actions available - press `<leader>ca` |
| `💡` | Virtual text | Lightbulb indicates quick fixes available |

#### How to Use Diagnostics
1. **Navigate errors**: Use `]d` and `[d` to jump between issues
2. **View details**: Press `<leader>E` on any line with a diagnostic symbol
3. **Quick fixes**: Press `<leader>ca` when you see the lightbulb (💡)
4. **Hover for info**: Press `K` over any symbol for documentation

#### Diagnostic Workflow
```
1. See 'E' symbol → Code has error
2. Press `<leader>E` → View error details
3. See 💡 lightbulb → Quick fix available
4. Press `<leader>ca` → Choose from available fixes
5. Use `]d` / `[d` → Navigate to next/previous issue
```

### Quickfix Navigation (LSP Results)
| Key | Action | Usage |
|-----|--------|-------|
| `]q` | Next quickfix item | Navigate references/errors |
| `[q` | Previous quickfix item | Navigate references/errors |
| `]Q` | Last quickfix item | Jump to last result |
| `[Q` | First quickfix item | Jump to first result |
| `<leader>xq` | Close quickfix window | Hide results panel |
| `<leader>xo` | Open quickfix window | Show results panel |

### Git Integration
| Key | Action | Tool |
|-----|--------|------|
| `<leader>gg` | Open Lazygit | Full Git UI |
| `<leader>gs` | Git status in vsplit | Fugitive |
| `<leader>gc` | Git commits | Telescope |
| `<leader>gb` | Git branches | Telescope |
| `]c` | Next hunk | Gitsigns |
| `[c` | Previous hunk | Gitsigns |
| `<leader>hs` | Stage hunk | Gitsigns |
| `<leader>hr` | Reset hunk | Gitsigns |
| `<leader>hp` | Preview hunk | Gitsigns |
| `<leader>hb` | Blame line | Gitsigns |

### Git Operations (Diffview)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>do` | Open Diffview | View all changes |
| `<leader>dc` | Close Diffview | Exit diff view |
| `<leader>dm` | Diffview: your changes vs main | Only your changes since merge base |
| `<leader>db` | Diffview: your changes vs branch | Compare with custom branch |
| `<leader>ds` | Diffview: staged changes | View only staged changes |
| `<leader>dh` | File history (current) | History for current file |
| `<leader>dH` | File history (all) | History for all files |

### Git Operations (Fugitive)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>G` | Git status | Full status view |
| `<leader>gP` | Git push | Push to remote |
| `<leader>gp` | Git pull | Pull from remote |
| `<leader>gB` | Git blame | Show blame annotations |
| `<leader>gL` | Git log | Full log view |
| `<leader>gl` | Git log (compact) | One-line log view |
| `<leader>gD` | Diff split | Show diff in split |
| `<leader>gH` | Horizontal diff | Diff in horizontal split |
| `<leader>gV` | Vertical diff | Diff in vertical split |
| `<leader>gw` | Stage current file | Git add current file |
| `<leader>gW` | Stage and force write | Force stage file |
| `<leader>gq` | Discard changes | Checkout file |
| `<leader>gC` | Commit | Open commit window |
| `<leader>gA` | Amend commit | Amend last commit |
| `<leader>gM` | Start merge | Begin merge process |
| `<leader>gS` | Stash changes | Save to stash |
| `<leader>gU` | Pop stash | Apply and remove stash |
| `<leader>gR` | Interactive rebase | Rebase interactively |
| `<leader>gF` | Fetch from remote | Update remote refs |
| `<leader>go` | Open in browser | View on GitHub/GitLab |
| `<leader>gO` | Copy URL to clipboard | Get file URL |
| `<leader>gu` | Copy GitHub URL (current line) | Copy line permalink |
| `<leader>gY` | Copy GitHub URL (selection) | Copy selection permalink |

### Git Diff Variations
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gdi` | Diff against index | Working tree vs index |
| `<leader>gdc` | Diff cached/staged | Index vs HEAD |
| `<leader>gdh` | Diff against HEAD | Working tree vs HEAD |

### Git Branch Operations
| Key | Action | Usage |
|-----|--------|-------|
| `<leader>gbc` | Create branch | Prompt for new branch name |
| `<leader>gbd` | Delete branch | Safe delete (merged only) |
| `<leader>gbD` | Force delete branch | Delete regardless of merge |
| `<leader>gbr` | Rename branch | Change branch name |

### Git Conflict Resolution
| Key | Action | Context |
|-----|--------|---------|
| `<leader>gmt` | Open mergetool | Resolve conflicts |
| `<leader>gmc` | Continue merge | After resolving conflicts |
| `<leader>gma` | Abort merge | Cancel merge operation |
| `<leader>grc` | Continue rebase | After resolving conflicts |
| `<leader>gra` | Abort rebase | Cancel rebase operation |

### Git Visual Mode
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gs` | Stage selection | Stage partial file (visual) |
| `<leader>gr` | Revert selection | Discard partial changes (visual) |

### GitHub URL Copying
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>gO` | Copy file URL | Copy current file's GitHub URL |
| `<leader>gu` | Copy line permalink | Copy GitHub URL with current line number |
| `<leader>gY` | Copy selection permalink | Copy GitHub URL with selected line range (visual mode) |
| `<leader>go` | Open in browser | Open current file/line in GitHub |

**Note**: These commands work when you're in a git repository with a GitHub remote. The URL includes the current branch, file path, and line numbers.

### GitHub Integration (Octo.nvim)

**Setup Required:**
Octo.nvim requires the GitHub CLI (`gh`) which is automatically installed by this setup. You just need to authenticate it. Works with both GitHub.com and GitHub Enterprise servers.

#### Initial Setup (Personal GitHub):
```bash
# GitHub CLI is already installed by the setup!
# Just authenticate with GitHub.com
gh auth login

# Verify authentication
gh auth status
```

#### Enterprise GitHub Setup:
```bash
# Authenticate with GitHub Enterprise Server
gh auth login --hostname your-github-enterprise.com

# Set as default (optional)
gh config set default_host your-github-enterprise.com

# Verify enterprise authentication
gh auth status --hostname your-github-enterprise.com
```

#### Multiple GitHub Accounts:
```bash
# Switch between accounts
gh auth switch --hostname github.com
gh auth switch --hostname your-github-enterprise.com

# List all authenticated accounts
gh auth status --show-token
```

#### Configuration in Neovim:
The plugin is pre-configured but you can customize it by adding to `~/.config/nvim/lua/user/init.lua`:
```lua
require("octo").setup({
  -- For enterprise GitHub, set your hostname
  github_hostname = "your-github-enterprise.com", -- Leave empty for github.com
  
  -- SSH aliases (if you use custom SSH configs)
  ssh_aliases = {
    ["github.com"] = "gh",
    ["your-github-enterprise.com"] = "gh-enterprise"
  },
  
  -- Timeout for API requests (increase for slow networks)
  timeout = 10000,
})
```

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>oi` | List issues | Browse repository issues |
| `<leader>oic` | Create issue | Create new issue |
| `<leader>ois` | Search issues | Search through issues |
| `<leader>opr` | List pull requests | Browse pull requests |
| `<leader>oprc` | Create pull request | Create new PR |
| `<leader>oprs` | Search pull requests | Search through PRs |
| `<leader>oprv` | View PR for current branch | Open specific PR for current branch |
| `<leader>oprr` | Enter PR review mode | Review mode for current branch |
| `<leader>ore` | List repositories | Browse repositories |
| `<leader>orv` | View repository | View repo details |
| `<leader>orf` | Fork repository | Fork current repo |
| `<leader>ogs` | List gists | Browse gists |
| `<leader>ogc` | Create gist | Create new gist |

### GitHub Issue/PR Context (when viewing)
| Key | Action | Description |
|-----|--------|-------------|
| `<space>ic` | Close issue/PR | Close current item |
| `<space>io` | Reopen issue/PR | Reopen closed item |
| `<space>il` | List issues | List repo issues |
| `<space>ca` | Add comment | Add new comment |
| `<space>cd` | Delete comment | Remove comment |
| `]c` | Next comment | Navigate to next comment |
| `[c` | Previous comment | Navigate to previous comment |
| `<space>aa` | Add assignee | Assign user |
| `<space>ad` | Remove assignee | Unassign user |
| `<space>la` | Add label | Add label to issue/PR |
| `<space>ld` | Remove label | Remove label |
| `<space>lc` | Create label | Create new label |
| `<C-r>` | Reload | Refresh current view |
| `<C-b>` | Open in browser | View on GitHub |
| `<C-y>` | Copy URL | Copy GitHub URL |

### GitHub PR Specific
| Key | Action | Description |
|-----|--------|-------------|
| `<space>po` | Checkout PR | Switch to PR branch |
| `<space>pm` | Merge PR | Merge commit PR |
| `<space>psm` | Squash and merge | Squash merge PR |
| `<space>pc` | List commits | Show PR commits |
| `<space>pf` | List changed files | Show modified files |
| `<space>pd` | Show PR diff | Display PR changes |
| `<space>va` | Add reviewer | Request review |
| `<space>vd` | Remove reviewer | Remove review request |
| `gf` | Go to file | Open file in PR |

### GitHub Reactions
| Key | Action | Emoji |
|-----|--------|-------|
| `<space>r+` | Thumbs up | 👍 |
| `<space>r-` | Thumbs down | 👎 |
| `<space>rh` | Heart | ❤️ |
| `<space>rl` | Laugh | 😄 |
| `<space>rp` | Party | 🎉 |
| `<space>rc` | Confused | 😕 |
| `<space>re` | Eyes | 👀 |
| `<space>rr` | Rocket | 🚀 |

### GitHub PR Review
| Key | Action | Description |
|-----|--------|-------------|
| `<space>ca` | Add review comment | Comment on specific line |
| `<space>sa` | Add suggestion | Suggest code change |
| `]t` | Next thread | Next review thread |
| `[t` | Previous thread | Previous review thread |
| `]q` | Next changed file | Navigate file list |
| `[q` | Previous changed file | Navigate file list |
| `<C-a>` | Approve review | Approve PR |
| `<C-m>` | Comment review | Submit review comment |
| `<C-r>` | Request changes | Request changes |
| `<C-c>` | Close review tab | Exit review mode |
| `<leader><space>` | Toggle viewed | Mark file as viewed |

#### Octo.nvim Tips & Troubleshooting:

**Working with Multiple Accounts:**
- Octo uses the currently active `gh` auth session
- Switch accounts with `gh auth switch` before using Octo commands
- Check current account: `:lua print(vim.fn.system('gh auth status'))`

**Enterprise Setup:**
- For GitHub Enterprise, update the config with your hostname
- Ensure your SSH config matches if using custom aliases
- Some enterprise servers may require longer timeout values

**Installation Details:**
- The setup script automatically installs GitHub CLI from official repositories
- On Debian/Ubuntu: Adds GitHub's official apt repository  
- On Fedora/RHEL: Uses dnf package manager
- On Arch: Uses pacman
- On macOS: Uses Homebrew
- Fallback: Downloads from GitHub releases

**Common Issues:**
- **"Not authenticated"**: Run `gh auth login` and restart Neovim
- **"Repository not found"**: Ensure you're in a git repository with GitHub remote
- **API rate limiting**: Wait or authenticate with a personal access token
- **Slow loading**: Increase timeout in config or check network connection
- **"gh not found"**: Restart your shell after installation to reload PATH

**Useful Commands:**
```bash
# Check if repository is properly connected
gh repo view

# Test GitHub CLI connection
gh api user

# View current repository issues (outside Neovim)
gh issue list

# View current repository PRs (outside Neovim)
gh pr list
```

**Integration with Git Workflows:**
- Use `<leader>oprc` to create PR directly from current branch
- Checkout PRs with `<space>po` to test changes locally
- Review and merge PRs without leaving Neovim
- Add comments and suggestions directly in the diff view

### Window Navigation
| Key | Action | Context |
|-----|--------|---------|
| `Ctrl+h/j/k/l` | Navigate windows | Between splits |
| `Ctrl+Up/Down` | Resize horizontal | Window height |
| `Ctrl+Left/Right` | Resize vertical | Window width |
| `<leader>sv` | Split vertical | New vertical split |
| `<leader>sh` | Split horizontal | New horizontal split |
| `<leader>se` | Equal window size | Balance splits |
| `<leader>sx` | Close window | Close split |
| `<leader>mr` | Move to rightmost split | Navigate to right edge |
| `<leader>ml` | Move to leftmost split | Navigate to left edge |
| `<leader>mt` | Move to top split | Navigate to top |
| `<leader>mb` | Move to bottom split | Navigate to bottom |

### Buffer Management
| Key | Action | Usage |
|-----|--------|-------|
| `Shift+h` | Previous buffer | Navigate buffers |
| `Shift+l` | Next buffer | Navigate buffers |
| `<leader>bd` | Delete buffer | Close file |
| `:bnext` | Next buffer | Command mode |
| `:bprev` | Previous buffer | Command mode |

### File Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `gf` | Go to file | Open file under cursor in current window |
| `gF` | Go to file | Same as `gf` |
| `<leader>gf` | Go to file (vertical split) | Open file in vertical split |
| `<leader>gF` | Go to file (horizontal split) | Open file in horizontal split |
| `<leader>gt` | Go to file (new tab) | Open file in new tab |
| `<leader>go` | Go to file (with options) | Interactive menu to choose where to open |

### File Explorer (NvimTree)
| Key | Action | Context |
|-----|--------|---------|
| `<leader>e` | Toggle file explorer | Open/close tree |
| `<leader>nf` | Find current file | Locate in tree |
| `a` | Create file/folder | Add `/` for folder |
| `r` | Rename | File operations |
| `d` | Delete | File operations |
| `x` | Cut | File operations |
| `c` | Copy | File operations |
| `p` | Paste | File operations |
| `y` | Copy name | To clipboard |
| `Y` | Copy path | Relative path |
| `gy` | Copy absolute path | Full path |

#### Multi-File Selection
| Key | Action | Description |
|-----|--------|-------------|
| `v` | Visual selection mode | Enter selection mode |
| `Space` | Toggle selection | Select/deselect individual file |
| `j`/`k` | Move in visual mode | Navigate while selecting |
| `Esc` | Clear selection | Exit selection mode |

**Multi-file operations**: After selecting files with `v` or `Space`, use:
- `x` - Cut all selected files
- `c` - Copy all selected files
- `d` - Delete all selected files
- `p` - Paste files to current location

### Debugging (DAP)

**Prerequisites:**
- **Go**: Requires `delve` debugger (auto-installed via Mason)
- **Node.js**: Requires `js-debug-adapter` (auto-installed via Mason)
- **Python**: Requires `debugpy` (auto-installed via Mason)

#### Basic Debug Controls
| Key | Action | Usage |
|-----|--------|-------|
| `F5` | Start/Continue debugging | Launch or resume execution |
| `F10` | Step over | Execute current line |
| `F11` | Step into | Enter function calls |
| `F12` | Step out | Exit current function |
| `<leader>dt` | Terminate session | Stop debugging |

#### Breakpoint Management
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>db` | Toggle breakpoint | Add/remove breakpoint at cursor |
| `<leader>dB` | Conditional breakpoint | Break only when condition is true |
| `<leader>dp` | Log point | Print message without stopping |
| `<leader>dfb` | List breakpoints | Show all breakpoints (Telescope) |

#### Debug UI & Information
| Key | Action | Usage |
|-----|--------|-------|
| `<leader>du` | Toggle debug UI | Show/hide debug panels |
| `<leader>dr` | Open REPL | Interactive debug console |
| `<leader>de` | Evaluate expression | Inspect variables (normal/visual) |
| `<leader>dl` | Run last config | Repeat last debug session |

#### Telescope Debug Integration
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>dfc` | Debug configurations | Select debug config |
| `<leader>dfv` | Debug variables | View current variables |
| `<leader>dff` | Debug frames | View call stack |

#### Language-Specific Debugging

**Go Debugging:**
| Key | Action | Usage |
|-----|--------|-------|
| `<leader>dgt` | Debug Go test | Debug test under cursor |
| `<leader>dgl` | Debug last Go test | Re-run last test debug |

**Available Go Debug Configurations:**
- **Debug**: Run current Go file
- **Debug test**: Debug current test file
- **Debug test (go.mod)**: Debug tests in current package
- **Attach remote**: Connect to running Go process

**Node.js/JavaScript Debugging:**
Available configurations (select with `F5`):
- **Launch file**: Debug current JS/TS file
- **Attach**: Connect to running Node.js process
- **Debug Jest Tests**: Debug Jest test files
- **Start Chrome**: Debug web applications in Chrome

**Python Debugging:**
- **Launch file**: Debug current Python file
- Uses `debugpy` for full debugging support

#### Debug UI Layout

When debug UI is open (`<leader>du`), you'll see:
- **Left Panel**: Scopes, breakpoints, call stack, watch variables
- **Bottom Panel**: Debug REPL and console output
- **Main View**: Your code with debug highlights

#### Debug Workflow Examples

**Go Application:**
```go
// Set breakpoint with <leader>db
func main() {
    name := "World"  // <- breakpoint here
    fmt.Printf("Hello, %s!\n", name)
}
// Press F5 to start debugging
```

**Node.js Application:**
```javascript
// Set breakpoint with <leader>db
function greet(name) {
    const message = `Hello, ${name}!`;  // <- breakpoint here
    console.log(message);
}
// Press F5 and select "Launch file"
```

**Debugging Tips:**
- Use `<leader>de` to evaluate expressions while paused
- Set conditional breakpoints for complex debugging scenarios
- Use log points to trace execution without stopping
- The debug REPL allows interactive code execution
- Virtual text shows variable values inline while debugging

---

# Zsh/Shell Shortcuts

### Navigation
| Key | Action | Context |
|-----|--------|---------|
| `Ctrl+a` | Beginning of line | Cursor movement |
| `Ctrl+e` | End of line | Cursor movement |
| `Ctrl+f` | Forward one character | Cursor movement |
| `Ctrl+b` | Backward one character | Cursor movement |
| `Alt+f` | Forward one word | Cursor movement |
| `Alt+b` | Backward one word | Cursor movement |

### Editing
| Key | Action | Usage |
|-----|--------|-------|
| `Ctrl+d` | Delete character | Under cursor |
| `Ctrl+h` | Delete backward | Backspace |
| `Ctrl+w` | Delete word backward | Quick delete |
| `Ctrl+k` | Delete to end of line | Clear right |
| `Ctrl+u` | Delete to beginning | Clear left |
| `Ctrl+y` | Paste (yank) | Insert deleted text |
| `Alt+d` | Delete word forward | Quick delete |
| `Ctrl+x Ctrl+e` | Edit command in editor | Complex commands |

### History
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+r` | Search history | Interactive search |
| `Ctrl+p` | Previous command | Up arrow alternative |
| `Ctrl+n` | Next command | Down arrow alternative |
| `!!` | Last command | Repeat last |
| `!$` | Last argument | Reuse argument |
| `!*` | All arguments | From last command |
| `sudo !!` | Last command as root | Quick sudo |

### FZF Integration
| Key | Action | What it does |
|-----|--------|--------------|
| `Ctrl+t` | File picker | Insert file path |
| `Ctrl+r` | History search | Better history |
| `Alt+c` | Directory picker | Change directory |

### Auto-suggestions
| Key | Action | Usage |
|-----|--------|-------|
| `→` or `Ctrl+f` | Accept suggestion | Full suggestion |
| `Ctrl+→` | Accept word | One word only |
| `Alt+→` | Accept line | Current line |

### Process Control
| Key | Action | Usage |
|-----|--------|-------|
| `Ctrl+c` | Interrupt/Cancel | Stop current command |
| `Ctrl+z` | Suspend process | Use `fg` to resume |
| `Ctrl+d` | Exit/EOF | Close shell |

### Directory Shortcuts
| Shortcut | Goes to | Usage |
|----------|---------|-------|
| `~` | Home directory | `cd ~` |
| `-` | Previous directory | `cd -` |
| `..` | Parent directory | `cd ..` |
| `...` | Two levels up | `cd ...` |
| `....` | Three levels up | `cd ....` |

### Vi Mode (Shell)
**Note**: Vi mode is enabled by default in this setup. You'll see a left arrow `◀` when in normal mode.

#### Mode Switching
| Key | Action | Description |
|-----|--------|-------------|
| `Escape` | Enter normal mode | Switch from insert to normal mode |
| `i` | Enter insert mode at cursor | Resume normal typing |
| `a` | Enter insert mode after cursor | Most common way to resume typing |
| `A` | Enter insert mode at end of line | Jump to end and type |
| `I` | Enter insert mode at beginning | Jump to start and type |

#### Navigation in Normal Mode
| Key | Action | Description |
|-----|--------|-------------|
| `h` | Move left one character | Basic movement |
| `l` | Move right one character | Basic movement |
| `w` | Move forward one word | Jump between words |
| `b` | Move backward one word | Jump between words |
| `e` | Move to end of word | Word boundary |
| `0` | Move to beginning of line | Start of line |
| `$` | Move to end of line | End of line |
| `^` | Move to first non-blank char | Skip leading spaces |

#### Editing in Normal Mode
| Key | Action | Description |
|-----|--------|-------------|
| `x` | Delete character under cursor | Quick delete |
| `X` | Delete character before cursor | Backspace equivalent |
| `dd` | Delete entire line | Clear whole command |
| `D` | Delete from cursor to end | Clear rest of line |
| `C` | Change from cursor to end | Delete and enter insert mode |
| `cc` | Change entire line | Replace whole command |
| `r` | Replace single character | Type new character |
| `s` | Substitute character | Delete char and enter insert |

#### Text Objects (Advanced)
| Key | Action | Description |
|-----|--------|-------------|
| `dw` | Delete word | From cursor to end of word |
| `db` | Delete word backward | From cursor to start of word |
| `d0` | Delete to beginning | Clear from start to cursor |
| `d$` | Delete to end | Same as `D` |
| `cw` | Change word | Replace word |
| `cb` | Change word backward | Replace previous word |

#### Quick Commands
| Key | Action | Description |
|-----|--------|-------------|
| `u` | Undo last change | Undo in normal mode |
| `Ctrl+r` | Redo | Redo undone change |
| `/` | Search forward | Enter search pattern |
| `?` | Search backward | Reverse search |
| `n` | Next search result | Continue search |
| `N` | Previous search result | Reverse search direction |

#### Disabling Vi Mode
If you prefer normal shell behavior (emacs mode):
```bash
# Edit ~/.dotfiles/config/zsh/key-bindings.zsh
# Comment out: bindkey -v
# Add: bindkey -e
```

**Pro Tip**: Most beginners should disable vi mode until comfortable with vim. Press `i` or `a` to return to normal typing when you see the left arrow!

---

# Git Commands

### Essential Aliases
| Alias | Command | Description |
|-------|---------|-------------|
| `g` | `git` | Shorthand |
| `ga` | `git add` | Stage files |
| `gaa` | `git add --all` | Stage all |
| `gc` | `git commit -v` | Commit with diff |
| `gc!` | `git commit -v --amend` | Amend last commit |
| `gca` | `git commit -v -a` | Commit all changes |
| `gcmsg` | `git commit -m` | Commit with message |
| `gd` | `git diff` | Show changes |
| `gds` | `git diff --staged` | Show staged changes |
| `gst` | `git status` | Current status |
| `gp` | `git push` | Push to remote |
| `gl` | `git pull` | Pull from remote |
| `glog` | `git log --oneline --graph` | Pretty log |
| `gb` | `git branch` | List branches |
| `gba` | `git branch -a` | All branches |
| `gco` | `git checkout` | Switch branches |
| `gcb` | `git checkout -b` | Create & switch branch |
| `gm` | `git merge` | Merge branch |
| `grb` | `git rebase` | Rebase branch |
| `gstash` | `git stash` | Stash changes |
| `gpop` | `git stash pop` | Apply stash |

### Advanced Git
| Command | Action | Usage |
|---------|--------|-------|
| `git reflog` | Show reference log | Recovery tool |
| `git cherry-pick <sha>` | Apply specific commit | Selective merge |
| `git bisect` | Binary search for bugs | Debug tool |
| `git worktree` | Multiple working trees | Parallel work |

---

# Modern CLI Tools

### File Management
| Tool | Command | Description |
|------|---------|-------------|
| **eza** | `eza -la` | Better ls with icons |
| | `eza --tree` | Tree view |
| | `eza -la --git` | Show git status |
| **fd** | `fd pattern` | Find files fast |
| | `fd -e txt` | Find by extension |
| | `fd -H` | Include hidden |
| **bat** | `bat file.txt` | Cat with syntax highlighting |
| | `bat -n` | Show line numbers |
| | `bat -p` | Plain output |

### Text Search & Processing
| Tool | Command | Description |
|------|---------|-------------|
| **ripgrep** | `rg pattern` | Fast grep |
| | `rg -i pattern` | Case insensitive |
| | `rg -C 3 pattern` | Show context |
| | `rg --type py pattern` | Search Python files |
| **sd** | `sd 'old' 'new' file` | Better sed |
| | `sd -i 'old' 'new' files*` | In-place edit |

### System Monitoring
| Tool | Command | Description |
|------|---------|-------------|
| **btm** | `btm` | Better top/htop |
| | `btm -b` | Basic mode |
| **procs** | `procs` | Modern ps |
| | `procs python` | Filter by name |
| **dust** | `dust` | Disk usage analyzer |
| | `dust -n 10` | Top 10 largest |

### Navigation & Productivity
| Tool | Command | Description |
|------|---------|-------------|
| **zoxide** | `z project` | Smart cd |
| | `zi` | Interactive selection |
| **fzf** | `vim $(fzf)` | Fuzzy finder |
| | `kill -9 $(ps aux | fzf)` | Interactive kill |
| **tldr** | `tldr git` | Simplified man pages |

### Development Tools
| Tool | Command | Description |
|------|---------|-------------|
| **lazygit** | `lg` or `lazygit` | Git TUI |
| **lazydocker** | `lazydocker` | Docker TUI |
| **httpie** | `http GET api.example.com` | Better curl |
| **jq** | `curl api | jq '.items[]'` | JSON processor |
| **delta** | `git diff | delta` | Better diff |

---

# System Management

### Package Management
| Distro | Update | Install | Remove |
|--------|---------|----------|---------|
| **Ubuntu/Debian** | `sudo apt update && sudo apt upgrade` | `sudo apt install pkg` | `sudo apt remove pkg` |
| **Fedora** | `sudo dnf upgrade` | `sudo dnf install pkg` | `sudo dnf remove pkg` |
| **Arch** | `sudo pacman -Syu` | `sudo pacman -S pkg` | `sudo pacman -R pkg` |

### Service Management (systemd)
| Command | Action |
|---------|--------|
| `systemctl status service` | Check status |
| `systemctl start service` | Start service |
| `systemctl stop service` | Stop service |
| `systemctl restart service` | Restart service |
| `systemctl enable service` | Auto-start on boot |
| `journalctl -u service -f` | Follow logs |

### Process Management
| Command | Action |
|---------|--------|
| `ps aux | grep process` | Find process |
| `kill -9 PID` | Force kill |
| `killall process` | Kill by name |
| `jobs` | List background jobs |
| `fg` | Bring to foreground |
| `bg` | Send to background |
| `Ctrl+z` | Suspend current process |

### Network Tools
| Command | Action |
|---------|--------|
| `ss -tulpn` | Show listening ports |
| `ip a` | Show network interfaces |
| `curl -I https://example.com` | Check headers |
| `wget -c url` | Download with resume |
| `rsync -avz src/ dest/` | Sync directories |

---

# Development Tools

### Docker
| Command | Action |
|---------|--------|
| `docker ps` | List running containers |
| `docker ps -a` | List all containers |
| `docker images` | List images |
| `docker exec -it container bash` | Enter container |
| `docker logs -f container` | Follow logs |
| `docker-compose up -d` | Start services |
| `docker-compose down` | Stop services |
| `docker system prune -a` | Clean up everything |

### Node.js/npm
| Command | Action |
|---------|--------|
| `npm init -y` | Initialize project |
| `npm i package` | Install dependency |
| `npm i -D package` | Install dev dependency |
| `npm run script` | Run package script |
| `npm list` | Show dependencies |
| `npx package` | Run without installing |

### Python
| Command | Action |
|---------|--------|
| `python -m venv venv` | Create virtual env |
| `source venv/bin/activate` | Activate venv |
| `pip install -r requirements.txt` | Install deps |
| `pip freeze > requirements.txt` | Export deps |
| `python -m http.server` | Quick web server |

### SSH
| Command | Action |
|---------|--------|
| `ssh-keygen -t ed25519` | Generate key |
| `ssh-copy-id user@host` | Copy key to server |
| `ssh -L 8080:localhost:80 server` | Local port forward |
| `ssh -R 8080:localhost:80 server` | Remote port forward |
| `~.` | Disconnect frozen session |

---

## 📝 Quick Tips

### Terminal Productivity
1. **Use aliases**: Check `~/.zshrc` for custom aliases
2. **History search**: Type partial command + `↑` to search
3. **Directory jumping**: Use `z partial-name` to jump to frequent directories
4. **Command editing**: `Ctrl+x Ctrl+e` to edit command in editor

### tmux Workflow
1. **Sessions for projects**: One session per project
2. **Windows for tasks**: Editor, server, git, logs
3. **Panes for related work**: Split when needed
4. **Save layouts**: Use resurrect to persist

### Neovim Efficiency
1. **Leader key combos**: Most custom commands start with `<Space>`
2. **Fuzzy finding**: Use Telescope for everything
3. **LSP power**: Let the language server do the work
4. **Git integration**: Use Lazygit for complex operations

### Shell Customization
- **Local overrides**: `~/.zshrc.local`
- **Machine-specific**: `~/.zshrc.$(hostname)`
- **Environment vars**: Set in `~/.zshenv`

---

## 🚀 Power User Combos

### Quick Development Setup
```bash
# Create new project session
tmux new -s myproject
# Split for editor and terminal
Prefix + |
# Open editor
nvim .
# Start dev server in other pane
Prefix + l
npm run dev
# Open git in new window
Prefix + c
lazygit
```

### File Search & Replace
```bash
# Find all TypeScript files with 'oldFunction'
rg "oldFunction" --type ts
# Replace across all files
sd 'oldFunction' 'newFunction' $(fd -e ts)
# Verify changes with git
git diff
```

### System Monitoring Dashboard
```bash
# Create monitoring session
tmux new -s monitor
# Split into quadrants
Prefix + |
Prefix + -
Prefix + h
Prefix + -
# Run different monitors
btm                    # Pane 1
journalctl -f          # Pane 2
docker stats           # Pane 3
tail -f /var/log/syslog # Pane 4
```

### Find → Edit Workflows
```bash
# Find and edit files
fd -e py | fzf --preview 'bat {}' | xargs nvim

# Search content and edit
rg -l "class.*Model" | fzf | xargs nvim

# Recent files (if in git)
git ls-files | fzf | xargs nvim
```

### Search → Process Workflows
```bash
# Find and delete old logs
fd -e log --changed-before 30d -x rm

# Search and replace across files
rg -l "old_name" | xargs sed -i 's/old_name/new_name/g'

# Find large files
dust | head -20
```

### Git Workflows
```bash
# Quick commit all
ga . && gc -m "Update" && gp

# Interactive rebase
git rebase -i HEAD~3

# Stash with message
git stash push -m "WIP: feature X"

# Search git history
git log --oneline | fzf | awk '{print $1}' | xargs git show
```

---

## 🎨 Customization Locations

| Component | Config Location | Local Override |
|-----------|----------------|----------------|
| Zsh | `~/.zshrc` | `~/.zshrc.local` |
| Bash | `~/.bashrc` | `~/.bashrc.local` |
| Tmux | `~/.tmux.conf` | `~/.tmux.conf.local` |
| Neovim | `~/.config/nvim/` | `~/.config/nvim/lua/user/` |
| Git | `~/.gitconfig` | Project `.git/config` |
| Starship | `~/.config/starship.toml` | - |

---

## 🔥 Pro Tips

### Clipboard Integration
```bash
# Copy to clipboard
echo "text" | xclip -selection clipboard
# Paste from clipboard
xclip -selection clipboard -o
```

### Quick HTTP Server
```bash
# Python HTTP server
python3 -m http.server 8000
# With specific directory
python3 -m http.server 8000 --directory /path/to/serve
```

### Watch Commands
```bash
# Watch directory changes
watch -n 1 'ls -la'
# Watch with color
watch -c -n 1 'ls -la --color=always'
```

### Process Port Management
```bash
# Find process using port
lsof -i :8080
# Or with ss
ss -tulpn | grep :8080
```

### Extract Archives
```bash
# Smart extract function (included)
extract file.tar.gz
extract file.zip
extract file.7z
```

---

## 🆘 Getting Help

| Command | Shows |
|---------|-------|
| `man command` | Manual page |
| `command --help` | Quick help |
| `tldr command` | Examples (simplified) |
| `which command` | Command location |
| `type command` | Command type/alias |
| `command -V` | Version info |

---

## 💡 Remember

- **Tab** completes everything (files, commands, options)
- **Tab Tab** shows all options
- **Ctrl+c** cancels/stops current operation
- **Ctrl+z** suspends (use `fg` to resume)
- **!!** runs last command
- **!$** uses last command's last argument
- **!*` uses all arguments from last command
- **sudo !!** runs last command as root
- **cd -** returns to previous directory
- **pushd/popd** for directory stack navigation

---

## 📊 Visual Mode Selection (Neovim)

| Key | Action | Use Case |
|-----|--------|----------|
| `v` | Character selection | Precise selection |
| `V` | Line selection | Whole lines |
| `Ctrl+v` | Block selection | Columns |
| `gv` | Reselect last | Repeat selection |
| `o` | Other end of selection | Adjust selection |
| `O` | Other corner (block) | Block adjustment |

---

## 🔍 Most Used Command Combos

### File Navigation & Search
| Command | Description | Example |
|---------|-------------|---------|
| `z proj` | Jump to project directory | `z myproject` |
| `fd pattern` | Find files/dirs | `fd "*.py"` |
| `rg "text"` | Search in files | `rg "TODO"` |
| `fzf` | Interactive finder | `vim $(fzf)` |
| `Ctrl+t` | Fuzzy file insert | Type command then `Ctrl+t` |
| `Alt+c` | Fuzzy cd | Press `Alt+c` anywhere |

### File Operations
| Command | Description | Example |
|---------|-------------|---------|
| `bat file` | View with highlighting | `bat README.md` |
| `eza -la` | List all with details | `ll` (alias) |
| `eza --tree` | Tree view | `lt` (alias) |
| `eza --git` | Show git status | `eza --git -la` |

### System Monitoring
| Command | Description | Key Feature |
|---------|-------------|-------------|
| `btm` | System monitor | Interactive graphs |
| `procs firefox` | Find process | Human-readable |
| `dust` | Disk usage | Visual tree |
| `htop` | Process viewer | Classic interface |

---

**Remember**: This cheatsheet is always available with `Prefix + ?` in tmux!
