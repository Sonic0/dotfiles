# Load the shell dotfiles
# extra.zsh can be used for settings you don’t want to commit.
for file in ~/.zsh.d/*.zsh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Source Python virtualenvwrapper
if [[ -s "$(which virtualenvwrapper.sh)" ]]; then
  source "$(which virtualenvwrapper.sh)"
fi

# History navigation commands
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
