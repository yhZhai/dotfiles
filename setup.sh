#!/bin/bash

# DESCRIPTION
## This script will first backup all existing dotfiles from the home directory,
## and create symlinks in the home directory for all dotfiles in this repo.

# USAGE
## Under the dotfiles directory, run:
## ./setup.sh


symlink() {
  file=$1
  link=$2
  if [ ! -e "$link" ]; then  # if the link doesn't exist
    echo "----- Symlinking the new $link -----"
    ln -s $file $link
  fi
}


backup() {
  target=$1
  if [ -e "$target" ]; then  # if the target file exists
    if [ ! -L "$target" ]; then  # if the target file is not a symlink
      echo "----- Moving $target to $target.backup -----"
      mv "$target" "$target.backup"
    fi
  fi
}


# For all files `$name` in the present folder except `setup.sh`, `README.md`,
# `molokai.vim`, and `LICENSE`, backup the target file located at `~/.$name` and
# symlink `$name` to `~/.$name`.
for name in *; do  # for all files in the present folder
  if [ ! -d "$name" ]; then  # not a directory
    target="$HOME/.$name"
    if [ "$name" != 'setup.sh' ] && [ "$name" != 'README.md' ] && \
       [ "$name" != 'LICENSE' ] && [ "$name" != 'molokai.vim' ]; then
      backup $target
      symlink $PWD/$name $target
    fi
  fi
done

# install oh-my-zsh
echo "----- Installing oh-my-zsh -----"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh-syntax-highlighting plugin
CURRENT_DIR=`pwd`
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"
cd "$ZSH_PLUGINS_DIR"
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "----- Installing zsh plugin 'zsh-syntax-highlighting' -----"
  git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  echo "----- Installing zsh plugin 'zsh-autosuggestions' -----"
  git clone https://github.com/zsh-users/zsh-autosuggestions
fi
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-completions" ]; then
  echo "----- Installing zsh plugin 'zsh-completions' -----"
  git clone https://github.com/zsh-users/zsh-completions
fi
cd $CURRENT_DIR

# vim configs
## Vundle
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
## vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PluginInstall +qall
vim +PlugInstall +qall
## color scheme
mkdir -p $HOME/.vim/colors
cp molokai.vim $HOME/.vim/colors/

# git configs
git config --global help.autocorrect 5
git config --global core.editor "vim"
