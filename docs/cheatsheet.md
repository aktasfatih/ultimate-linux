# Ultimate Linux Cheatsheet

## 🚀 Most Used Commands

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

### Git Shortcuts
| Command | Description | Full Command |
|---------|-------------|--------------|
| `lg` | Interactive git | `lazygit` |
| `ga` | Add files | `git add` |
| `gc` | Commit | `git commit` |
| `gp` | Push | `git push` |
| `gl` | Pull | `git pull` |
| `gst` | Status | `git status` |
| `gd` | Diff | `git diff` |
| `gco` | Checkout | `git checkout` |

### tmux Essentials (Prefix: `Ctrl+a`)
| Key | Action | Remember |
|-----|--------|----------|
| `prefix c` | Create window | **C**reate |
| `prefix \|` | Split vertical | Pipe = vertical |
| `prefix -` | Split horizontal | Minus = horizontal |
| `prefix z` | Zoom pane | **Z**oom |
| `prefix d` | Detach session | **D**etach |
| `prefix [` | Copy mode | Like vim |
| `prefix n/p` | Next/prev window | **N**ext/**P**revious |

### System Monitoring
| Command | Description | Key Feature |
|---------|-------------|-------------|
| `btm` | System monitor | Interactive graphs |
| `procs firefox` | Find process | Human-readable |
| `dust` | Disk usage | Visual tree |
| `htop` | Process viewer | Classic (server) |

## 🎯 Power User Combos

### Find → Edit
```bash
# Find and edit files
fd -e py | fzf --preview 'bat {}' | xargs nvim

# Search content and edit
rg -l "class.*Model" | fzf | xargs nvim

# Recent files (if in git)
git ls-files | fzf | xargs nvim
```

### Search → Process
```bash
# Find and delete old logs
fd -e log --changed-before 30d -x rm

# Search and replace
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

## 📁 Directory Shortcuts

| Shortcut | Goes to | Usage |
|----------|---------|-------|
| `~` | Home directory | `cd ~` |
| `-` | Previous directory | `cd -` |
| `..` | Parent directory | `cd ..` |
| `...` | Two levels up | `cd ...` |
| `....` | Three levels up | `cd ....` |

## ⌨️ Neovim Quick Keys

### Normal Mode
| Key | Action | Mnemonic |
|-----|--------|----------|
| `<Space>ff` | Find files | **F**ind **F**iles |
| `<Space>fg` | Find grep | **F**ind **G**rep |
| `<Space>e` | Explorer | **E**xplorer |
| `<Space>gg` | Git UI | **G**it **G**UI |
| `gd` | Go to definition | **G**o **D**efinition |
| `K` | Show hover info | Documentation |
| `<C-o>` | Jump back | **O**ut |
| `<C-i>` | Jump forward | **I**n |

### Visual Mode
| Key | Action |
|-----|--------|
| `v` | Start selection |
| `V` | Line selection |
| `Ctrl+v` | Block selection |
| `y` | Copy (yank) |
| `d` | Cut (delete) |
| `p` | Paste |

## 🔧 Shell Magic

### History Search
- `Ctrl+r` - Fuzzy search command history
- Type to filter, `Enter` to execute
- `Ctrl+g` to cancel

### Auto-suggestions
- Start typing → see gray suggestion
- `→` or `Ctrl+f` to accept
- `Ctrl+→` to accept one word

### Quick Edits
- `Ctrl+w` - Delete word backward
- `Ctrl+u` - Delete to line start
- `Ctrl+k` - Delete to line end
- `Ctrl+a` - Go to line start
- `Ctrl+e` - Go to line end

## 🎨 Customization Locations

| Component | Config Location | Local Override |
|-----------|----------------|----------------|
| Zsh | `~/.zshrc` | `~/.zshrc.local` |
| Bash | `~/.bashrc` | `~/.bashrc.local` |
| Tmux | `~/.tmux.conf` | `~/.tmux.conf.local` |
| Neovim | `~/.config/nvim/` | `~/.config/nvim/lua/user/` |
| Git | `~/.gitconfig` | Project `.git/config` |
| Starship | `~/.config/starship.toml` | - |

## 🔥 Pro Tips

1. **Clipboard Integration**
   ```bash
   # Copy to clipboard
   echo "text" | xclip -selection clipboard
   # Paste from clipboard
   xclip -selection clipboard -o
   ```

2. **Quick Server**
   ```bash
   # Python HTTP server
   python3 -m http.server 8000
   ```

3. **Watch Commands**
   ```bash
   # Watch directory changes
   watch -n 1 'ls -la'
   ```

4. **Process Port**
   ```bash
   # Find process using port
   lsof -i :8080
   ```

5. **Extract Archives**
   ```bash
   # Smart extract function (included)
   extract file.tar.gz
   extract file.zip
   ```

## 🆘 Getting Help

| Command | Shows |
|---------|-------|
| `man command` | Manual page |
| `command --help` | Quick help |
| `tldr command` | Examples (if installed) |
| `which command` | Command location |
| `type command` | Command type |

## 💡 Remember

- **Tab** completes everything
- **Ctrl+c** cancels/stops
- **Ctrl+z** suspends (use `fg` to resume)
- **!!** runs last command
- **!$** last command's last argument
- **sudo !!** run last command as root
