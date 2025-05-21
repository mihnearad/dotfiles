#!/bin/bash

set -e

echo "🛠️ Installing Zsh and tools on Ubuntu/Debian..."

# Install dependencies
sudo apt update
sudo apt install -y zsh git curl wget

# Install Starship
if ! command -v starship &> /dev/null; then
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "💡 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install autosuggestions
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install syntax highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo "✨ Creating ~/.zshrc..."

# Backup existing .zshrc
cp ~/.zshrc ~/.zshrc.backup.$(date +%s) 2>/dev/null || true

# Generate new .zshrc
cat > ~/.zshrc <<EOF
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source \$ZSH/oh-my-zsh.sh

# Starship prompt
eval "\$(starship init zsh)"
EOF

# Install Starship config (optional)
mkdir -p ~/.config
cat > ~/.config/starship.toml <<EOF
format = """\$directory\$git_branch\$git_status\n\$character"""

[directory]
style = "cyan bold"

[git_branch]
symbol = "🌱 "
style = "purple"

[git_status]
style = "red"
EOF

# Set default shell to zsh
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🌀 Changing your default shell to zsh..."
  chsh -s "$(which zsh)"
fi

echo "✅ Done! Open a new terminal or run: zsh"
