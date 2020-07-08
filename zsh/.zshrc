# Load the shell dotfiles
# extra.zsh can be used for settings you don’t want to commit.
for file in ~/.zsh.d/*.zsh; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# History navigation commands
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

# Start tmux for every terminal session
[[ -z "$TMUX" && $(tty) != /dev/tty[0-9] ]] && { tmux || exec tmux new-session && exit }

# Start Neofetch
neofetch --ascii ${HOME}/Unicorn.txt --install_time_format 24h --disk_show / --disk_subtitle name