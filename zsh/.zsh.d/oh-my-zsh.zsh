# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh";

ZSH_THEME="powerlevel10k/powerlevel10k"
# How often oh-my-zsh should automatic updates happen (in days)
UPDATE_ZSH_DAYS=10
# Case-sensitive completion.
CASE_SENSITIVE=true
# Enable command auto-correction.
ENABLE_CORRECTION=true
# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS=true
# Oh-my-zsh history command wrapper output format
HITS_STAMPS="dd-mm-yyyy"

plugins=(
  aws
  colored-man-pages
  colorize
  compleat
  cp
  dirhistory
  docker
  git
  kubectl
  lol
  npm
  nvm
  pip
  sudo
  systemd
  terraform
  virtualenvwrapper
  zsh-autosuggestions
  zsh-nvm
  zsh-syntax-highlighting
)

source "${ZSH}/oh-my-zsh.sh"
