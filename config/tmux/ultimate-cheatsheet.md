# Ultimate Linux Development Cheatsheet

## 🎯 Quick Navigation
- [tmux Keybindings](#tmux-keybindings)
- [Neovim Commands](#neovim-commands)
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
| `gcc` | Comment/uncomment line | Code editing |
| `gc` | Comment/uncomment selection | Visual mode |

### File Navigation (Telescope)
| Key | Action | Description |
|-----|--------|-------------|
| `<leader>ff` | Find files | Fuzzy file search |
| `<leader>fg` | Live grep | Search in files |
| `<leader>fb` | Browse buffers | Open buffers |
| `<leader>fh` | Help tags | Search help |
| `<leader>fe` | File browser | Directory navigation |
| `<leader>fo` | Recent files | History |
| `<leader>fc` | Commands | Command palette |
| `<leader>fk` | Keymaps | Show all keymaps |
| `<leader>fr` | Registers | Clipboard history |
| `<leader>fm` | Marks | Bookmarks |
### LSP Functions
| Key | Action | Usage |
|-----|--------|-------|
| `gd` | Go to definition | Jump to code definition |
| `gD` | Go to declaration | Jump to declaration |
| `gr` | Find references | Where is this used? |
| `gi` | Go to implementation | Implementation details |
| `K` | Hover documentation | Show info popup |
| `<leader>ca` | Code action | Quick fixes/refactors |
| `<leader>rn` | Rename symbol | Rename everywhere |
| `<leader>f` | Format document | Auto-format code |
| `[d` | Previous diagnostic | Jump to previous error |
| `]d` | Next diagnostic | Jump to next error |
| `<leader>e` | Show diagnostics | Error details |

### Quickfix Navigation (LSP Results)
| Key | Action | Usage |
|-----|--------|-------|
| `]q` | Next quickfix item | Navigate references/errors |
| `[q` | Previous quickfix item | Navigate references/errors |
| `]Q` | Last quickfix item | Jump to last result |
| `[Q` | First quickfix item | Jump to first result |

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

### Buffer Management
| Key | Action | Usage |
|-----|--------|-------|
| `Shift+h` | Previous buffer | Navigate buffers |
| `Shift+l` | Next buffer | Navigate buffers |
| `<leader>bd` | Delete buffer | Close file |
| `:bnext` | Next buffer | Command mode |
| `:bprev` | Previous buffer | Command mode |

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
