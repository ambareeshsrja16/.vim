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

Plugins are managed via **Vim 8 native packages** (`pack/*/start/`), loaded by `:packloadall` in `vimrc`. All plugins are git submodules.

To add a new plugin:

```sh
git submodule add <url> pack/<namespace>/start/<plugin-name>
```

Tpope plugins go under `pack/tpope/start/`, others under `pack/plugins/start/`.

## Structure

- `vimrc` — main Vim configuration; all mappings, settings, plugin config
- `pack/` — Vim 8 native packages (submodules); includes `tla-support/start/tla.vim` (vendored) for TLA+ filetype support
- `spell/` — custom spell files
- `dotfiles/` — supplementary configs (`.zshrc_generic`, `.tmux.conf`, `.warpd_config`, `vimium.mappings`) to be copied to `~`

## Key Mappings (Leader = `<Space>`)

| Mapping | Action |
|---|---|
| `<leader>ev` / `<leader>sv` | Edit / source `$MYVIMRC` |
| `<leader>/` | Toggle comment (vim-commentary) |
| `<leader>k` | Run clang-format via `~/clang-format.py` |
| `<leader>w` / `<leader>W` | Wrap word/WORD with backticks (vim-surround) |
| `<leader>d` | Delete without yanking |
| `<leader>p` | Replace selection without yanking |
| `<leader>cd` | Set cwd to directory of current file |
| `:Gentags` | Generate ctags for `.hpp`, `.cpp`, `.proto` files |
