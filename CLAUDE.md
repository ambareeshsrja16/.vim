# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal Vim configuration repository. It manages `vimrc`, plugins, dotfiles (zsh, tmux, warpd, vimium), and spell files.

## Setup

After cloning, initialize all plugins (git submodules):

```sh
git submodule update --init
```

Or clone with submodules in one step:

```sh
git clone --recurse-submodules https://www.github.com/ambareeshsrja16/.vim.git
```

## Plugin Management

Plugins are managed in two ways:

- **Pathogen** (`bundle/vim-pathogen`): loads plugins from `bundle/`. All directories under `bundle/` are on the Vim `runtimepath`.
- **Vim 8 native packages** (`pack/`): loaded via `:packloadall` in `vimrc`. Subdirectories follow the `pack/{name}/start/` convention.

To add a new plugin as a submodule:

```sh
# Pathogen-managed (bundle/)
git submodule add <url> bundle/<plugin-name>

# Native package (pack/)
git submodule add <url> pack/<namespace>/start/<plugin-name>
```

## Structure

- `vimrc` — main Vim configuration; all mappings, settings, plugin config
- `bundle/` — Pathogen-managed plugins (submodules)
- `pack/` — Vim 8 native packages (submodules); includes `tla-support/start/tla.vim` for TLA+ filetype support
- `autoload/pathogen.vim` — Pathogen plugin manager (vendored)
- `spell/` — custom spell files
- `dotfiles/` — supplementary configs (`.zshrc_generic`, `.tmux.conf`, `.warpd_config`, `vimium.mappings`) to be copied to `~`

## Key Mappings (Leader = `<Space>`)

| Mapping | Action |
|---|---|
| `<leader>ev` / `<leader>sv` | Edit / source `$MYVIMRC` |
| `<leader>/` | Toggle comment (vim-commentary) |
| `<leader>.` | CtrlP tag search |
| `<leader>b` | Toggle Tagbar |
| `<leader>k` | Run clang-format via `~/clang-format.py` |
| `<leader>w` / `<leader>W` | Wrap word/WORD with backticks (vim-surround) |
| `<leader>d` | Delete without yanking |
| `<leader>p` | Replace selection without yanking |
| `<leader>cd` | Set cwd to directory of current file |
| `:Gentags` | Generate ctags for `.hpp`, `.cpp`, `.proto` files |
