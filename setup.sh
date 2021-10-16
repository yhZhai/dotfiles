#!/bin/bash

## DESCRIPTION
# This script will first backup all existing dotfiles from the home directory,
# and create symlinks in the home directory for all dotfiles in this repo.

## USAGE
# ./setup.sh <home directory



git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git config --global help.autocorrect 5
vim +PluginInstall +qall
vim +PlugInstall +qall


# ===== Below is WIP =====
# symlink() {
#   file=$1
#   link=$2
#   if [ ! -e "$link" ]; then
#     echo "----- Symlinking the new $link -----"
#     ln -s $file $link
#   fi
# }
# 
# 
# backup() {
#   target=$1
#   if [ -e "$target" ]; then
#     if [ ! -L "$target" ]; then
#       mv "$target" "$target.backup"
#       echo "----- Moved the old $target config file to $target.backup -----"
#     fi
#   fi
# }
# 
# 
# # For all files `$name` in the present folder except `*.sh`, `README.md`, 
# # `settings.json`, and `config`, backup the target file located at `~/.$name` 
# # and symlink `$name` to `~/.$name`.
# for name in *; do
#   if [ ! -d "$name" ]; then
#     target="$HOME/.$name"
#     if [[ ! "$name" =~ '\.sh$' ]] && [ "$name" != 'README.md' ] && [[ "$name" != 'settings.json' ]] && [[ "$name" != 'config' ]]; then
#       backup $target
#       symlink $PWD/$name $target
#     fi
#   fi
# done
# 
# 
# # Install zsh-syntax-highlighting plugin
# CURRENT_DIR=`pwd`
# ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
# mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"
# if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
#   echo "----- Installing zsh plugin 'zsh-syntax-highlighting' -----"
#   git clone https://github.com/zsh-users/zsh-autosuggestions
#   git clone https://github.com/zsh-users/zsh-syntax-highlighting
# fi
# cd "$CURRENT_DIR"
# 
# 
# # Symlink VS Code settings to the present `settings.json` file
# # If it's a macOS
# if [[ `uname` =~ "Darwin" ]]; then
#   CODE_PATH=~/Library/Application\ Support/Code/User
# # Else, it's a Linux
# else
#   CODE_PATH=~/.config/Code/User
#   # If this folder doesn't exist, it's a WSL
#   if [ ! -e $CODE_PATH ]; then
#     CODE_PATH=~/.vscode-server/data/Machine
#   fi
# fi
# target="$CODE_PATH/settings.json"
# backup $target
# symlink $PWD/settings.json $target
# 
