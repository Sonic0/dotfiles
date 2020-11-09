# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh";

# Case-sensitive completion.
CASE_SENSITIVE="true"
# Enable command auto-correction.
ENABLE_CORRECTION="true"
# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

export TERM="xterm-256color";
export ZSH_THEME="powerlevel10k/powerlevel10k";
export UPDATE_ZSH_DAYS=10

# Plugins
plugins=(
  colored-man-pages
  colorize
  compleat
  cp
  dirhistory
  docker
  git
  lol
  npm
  pip
  sudo
  systemd
  virtualenvwrapper
  zsh-autosuggestions
  zsh-nvm
  zsh-syntax-highlighting
)

source "${ZSH}"/oh-my-zsh.sh

zstyle ':completion:*' rehash true
