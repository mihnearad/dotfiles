#!/bin/bash

set -e

echo "🛠️ Installing Zsh and tools on Ubuntu/Debian..."

# Install core tools
sudo apt update
sudo apt install -y zsh git curl wget

# Install Starship (prompt)
if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Define plugin directory
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Install zsh plugins
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

echo "✨ Done! Oh My Zsh, Starship, and plugins are ready."
echo "👉 Now run: chezmoi apply to deploy your dotfiles (zshrc, starship.toml, etc.)"
