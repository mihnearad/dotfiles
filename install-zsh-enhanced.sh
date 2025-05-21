#!/bin/bash

set -e

echo "🛠️ Installing Zsh + Oh My Zsh + Starship + chezmoi..."

# Use sudo only if not root
if [ "$(id -u)" -eq 0 ]; then
  APT="apt"
else
  APT="sudo apt"
fi

# Install base packages
$APT update
$APT install -y zsh git curl wget

# Install Starship
if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Plugin path
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Install plugins
[[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] && \
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

[[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]] && \
  git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🔁 Setting zsh as default shell..."
  chsh -s "$(which zsh)"
fi

# Install chezmoi if missing
if ! command -v chezmoi &> /dev/null; then
  echo "📦 Installing chezmoi..."
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"
fi

# Apply your dotfiles
chezmoi init mihnearad --apply

echo "✅ Done! Your Zsh + Starship environment is fully set up."
