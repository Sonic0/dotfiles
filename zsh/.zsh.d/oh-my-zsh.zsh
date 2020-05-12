# Theme

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh";

# Enable command auto-correction.
ENABLE_CORRECTION="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"


export TERM="xterm-256color";
export ZSH_THEME="bullet-train";
BULLETTRAIN_PROMPT_ORDER=(
  time
  virtualenv
  context
  dir
  status
  nvm
  git
)

BULLETTRAIN_VIRTUALENV_BG="black"
BULLETTRAIN_VIRTUALENV_FG="megenta"

# Plugins
plugins=(
	git
  	sudo
  	lol
  	systemd
  	npm
  	yarn
  	docker
  	zsh-nvm
  	dirhistory
  	cp
  	colorize
  	colored-man-pages
  	compleat
	zsh-syntax-highlighting
 	zsh-autosuggestions
	virtualenvwrapper
	)

source "${ZSH}/oh-my-zsh.sh"

zstyle ':completion:*' rehash true
