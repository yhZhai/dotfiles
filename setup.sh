#!/usr/bin/env bash
# Dot-files bootstrapper — safe, idempotent, and (mostly) cross-platform.
# Usage:  ./setup.sh [--dry-run]

set -euo pipefail

DRY_RUN=false
[[ ${1:-} == "--dry-run" ]] && DRY_RUN=true

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IGNORE=(setup.sh README.md LICENSE molokai.vim zshrc)

# ---------- helpers ----------------------------------------------------------
log() { printf ">>> %s\n" "$*"; }
doit() { $DRY_RUN && log "[dry-run] $*" || eval "$*"; }

timestamp() { date +%Y%m%d%H%M%S; }

backup() {
  local target="$1"
  [[ -e "$target" && ! -L "$target" ]] || return 0
  local bak="${target}.$(timestamp).bak"
  log "Backup $target  →  $bak"
  doit mv "$target" "$bak"
}

symlink() {
  local src="$1" dst="$2"
  [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]] && return 0
  backup "$dst"
  log "Symlink $dst  →  $src"
  doit ln -sf "$src" "$dst"
}

# ---------- dotfiles ---------------------------------------------------------
log "Installing dotfiles from $DOTFILES_DIR"
for file in "$DOTFILES_DIR"/*; do
  fn="$(basename "$file")"
  [[ " ${IGNORE[*]} " =~ " $fn " || -d "$file" ]] && continue
  symlink "$file" "$HOME/.$fn"
done

# ---------- zsh & Oh-My-Zsh ---------------------------------------------------
if ! command -v zsh >/dev/null; then
  log "Installing zsh"
  if command -v apt >/dev/null;   then doit sudo apt -y install zsh
  elif command -v brew >/dev/null; then doit brew install zsh
  else log "⚠️  Package manager not detected; install zsh manually."; fi
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  log "Installing Oh-My-Zsh (unattended)"
  doit sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

symlink "$DOTFILES_DIR/zshrc" "$HOME/.zshrc"

# Plugins
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"
declare -a plugins=(
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-completions
)
for repo in "${plugins[@]}"; do
  dir="$ZSH_PLUGINS_DIR/$(basename "$repo")"
  [[ -d "$dir" ]] || doit git clone "https://github.com/$repo" "$dir"
done

# ---------- Vim --------------------------------------------------------------
symlink "$DOTFILES_DIR/vimrc" "$HOME/.vimrc"

# colour scheme
mkdir -p "$HOME/.vim/colors"
symlink "$DOTFILES_DIR/molokai.vim" "$HOME/.vim/colors/molokai.vim"

# vim-plug
if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  log "Installing vim-plug"
  doit curl -fsLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

log "Installing Vim plugins (vim-plug)"
doit vim -E -s +PlugInstall +qall

# ---------- Git --------------------------------------------------------------
log "Setting Git defaults"
doit git config --global help.autocorrect 5
doit git config --global core.editor "vim"

log "✅  All done${DRY_RUN:+ (dry-run)}!"
