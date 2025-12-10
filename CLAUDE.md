# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Setup and Installation
- `make init` - Initialize the repository by linking config files and installing oh-my-zsh
- `make test` - Install zsh plugins and setup shell environment

### Key Scripts
- The Makefile provides the main commands for setup and configuration
- No package.json or traditional build/test commands - this is a dotfiles repository

## Repository Architecture

This is a personal dotfiles repository containing configuration files for development tools:

### Main Configuration Areas

**Neovim Configurations:**
- `config/lazy_nvim/` - LazyVim-based configuration with standard LazyVim structure
- `config/my_nvim/` - Custom Neovim configuration with:
  - LSP setup in `config/my_nvim/lua/plugins/lsp/`
  - Plugin configurations in `config/my_nvim/lua/plugins/`
  - Japanese keymap comments and custom keybindings

**Shell Configuration:**
- `config/zsh/` - Zsh configuration files including history and init scripts
- `template/default.zsh` - Template for oh-my-zsh configuration with bira theme

**Other Tools:**
- `config/git/` - Git configuration
- `config/github-copilot/` - GitHub Copilot settings
- `config/iterm2/` - iTerm2 configuration
- `config/raycast/` - Raycast extensions (Arc browser integration)

### Key Implementation Details

**Neovim Setup:**
- Uses Lazy.nvim plugin manager
- Custom LSP keybindings: `<Leader>/` for hover, `<Leader><Leader>` for definition
- Terminal integration with `tt` command
- Format command available via `:Format`
- Japanese development environment with double-byte space highlighting

**Shell Environment:**
- oh-my-zsh with bira theme
- Plugins: git, zsh-completions, zsh-syntax-highlighting
- Custom zsh initialization in `config/zsh/init.zsh`

### File Structure
- All configurations are symlinked from `~/.config` via `make init`
- Template files in `template/` directory provide base configurations
- Individual tool configs are organized in `config/[tool-name]/` directories

## Development Workflow

This repository is designed for setting up a development environment:
1. Run `make init` to link configuration files
2. Run `make test` to install shell plugins and setup zsh
3. Configurations are immediately available after symlinking

The setup is designed for vim-heavy development with integrated LSP support and terminal workflows.
