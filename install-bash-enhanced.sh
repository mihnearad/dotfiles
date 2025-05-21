#!/bin/bash

set -e

echo "🔧 Installing dependencies..."

# Install Starship
if ! command -v starship &> /dev/null; then
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    brew install starship
  fi
fi

# Install bash-autocomplete
if [ ! -d "$HOME/.bash-autocomplete" ]; then
  git clone https://github.com/marlonrichert/bash-autocomplete "$HOME/.bash-autocomplete"
fi

echo "✨ Updating ~/.bashrc..."

# Backup original bashrc
cp ~/.bashrc ~/.bashrc.backup.$(date +%s)

# Overwrite .bashrc with enhanced version
cat > ~/.bashrc <<EOF
# ~/.bashrc - Enhanced by install-bash-enhanced.sh

# Only run for interactive shells
[ -z "\$PS1" ] && return

# History settings
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

# Aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Autocomplete (tab suggestions)
if [ -f "\$HOME/.bash-autocomplete/bash-autocomplete.plugin.bash" ]; then
  source "\$HOME/.bash-autocomplete/bash-autocomplete.plugin.bash"
fi

# Starship prompt
eval "\$(starship init bash)"
EOF

# Install starter starship config
mkdir -p ~/.config
cat > ~/.config/starship.toml <<EOF
format = """
$directory$git_branch$git_status
$character
"""

[directory]
style = "blue bold"

[git_branch]
style = "purple"
symbol = "🌱 "

[git_status]
style = "red"
EOF

echo "✅ All set! Run: source ~/.bashrc or open a new terminal."
