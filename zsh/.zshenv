# Amend PATH
path+=("${HOME}/.local/bin")
path+=("${HOME}/.node_modules/bin")
path+=("${HOME}/.cargo/bin")
path+=("${HOME}/.cargo/env")
path+=("${HOME}/go/bin")
export PATH

# Prefer US English and use UTF-8
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Set default programs
export TERMINAL='alacritty'
export BROWSER='firefox'
export PAGER='less'
export EDITOR='nvim'
export VISUAL="${EDITOR}"

# Omit duplicates and commands that begin with a space from history
export HISTCONTROL='ignoreboth'

# Time format
export HISTTIMEFORMAT="%d/%m/%y %T"

# Set correct TTY for GPG
# https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY="$(tty)"

# Nvm
if [[ -d "${HOME}/.nvm" ]]; then
    export NVM_DIR="${HOME}/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    export NVM_LAZY_LOAD=true
fi

# Python virtualenvwrapper
if [[ -d "${HOME}/.virtualenvs" ]]; then
    export WORKON_HOME="$HOME/.virtualenvs"
    export VIRTUALENVWRAPPER_PYTHON="$(command -v python3)"
fi

if [[ -d "${HOME}/.pyenv" ]]; then
    export PYENV_ROOT="${HOME}/.pyenv"
    [[ -d ${PYENV_ROOT}/bin ]] && export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi

# pnpm
if [[ -d "${HOME}/.local/share/pnpm" ]]; then
    export PNPM_HOME="${HOME}/.local/share/pnpm"
    export PATH="${PNPM_HOME}:${PATH}"
fi

# Set environment variables for Firefox on Wayland
if [[ -n "${WAYLAND_DISPLAY}" ]]; then
    export MOZ_ENABLE_WAYLAND=1
fi
