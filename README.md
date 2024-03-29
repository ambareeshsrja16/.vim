USAGE

1. Clone repo, go to .vim and init submodules/plugins with:
  `git submodule update --init`
    OR
  `git clone --recurse-submodules https://www.github.com/ambareeshsrja16/.vim.git`

2. Shell
  * Install zsh
  * Install oh-my-zsh
  * Modify .zshrc using .vim/dotfiles/.zshrc_generic 
  * Install zsh-autosuggestions, zsh-syntax-highlighting (INSTALL.md/oh-my-zsh)

3. Tmux
  * Install tmux (version > 1.9, check with tmux -V)
  * Install tpm (plugin manager)
  * Copy .tmux.conf from .vim/dotfiles to ~
  * Open tmux and activate plugins with:
  `prefix I`
  * Uncomment `tmux` from .zshrc plugin list

4. Warpd
  * Copy ./vim/dotfiles/.warpd_config to ~/.config/warpd/config (after
  installing warpd)

Details: [Synchronizing plugins with git submodules and pathogen](http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen)
