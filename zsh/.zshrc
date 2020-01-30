# Load the shell dotfiles
# .path can be used to extend `$PATH`.
# .extra can be used for other settings you don’t want to commit.
for file in ~/.zsh.d/*.zsh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# Source oh-my-zsh
if [[ -s "${ZSH}/oh-my-zsh.sh" ]]; then
  source "${ZSH}/oh-my-zsh.sh"
fi

# Source Python virtualenvwrapper
if [[ -s "$(which virtualenvwrapper.sh)" ]]; then
  source "$(which virtualenvwrapper.sh)"
fi

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
