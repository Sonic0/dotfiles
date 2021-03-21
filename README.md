# Dotfiles

This repository is forked from [mastertinner/dotfiles](https://github.com/mastertinner/dotfiles), with [Apache2.0](https://github.com/mastertinner/dotfiles/blob/main/LICENSE) License, and customized with my own configurations.

I mainly work with [Python](https://python.org), [shell scripts](https://en.wikipedia.org/wiki/Shell_script) so my setup is geared towards working with these technologies.
Other languages  [Rust](https://www.rust-lang.org), [JavaScript](https://en.wikipedia.org/wiki/JavaScript), [TypeScript](https://www.typescriptlang.org).

Supported operating systems are macOS, Arch Linux and Ubuntu (and their derivates).

## Features and Usage

### Terminal

This setup uses a powerful combination of [Alacritty](https://github.com/jwilm/alacritty), [tmux](https://github.com/tmux/tmux) and [zsh](https://www.zsh.org/) with a very minimalistic prompt.

### Commands

- `pacu`: Update and upgrade the whole system (using `Brewfile` on macOS and `pacmanfile` on Arch Linux)
- `depu`: Update and upgrade the dependencies for the current project
- `mkcd`: Create a directory and enter it
- `fcd`: cd into a directory using fuzzy search
- `fe`: Edit a directory or file using fuzzy search
- `fco`: Checkout Git branches or tags using fuzzy search
- `fkill`: Kill any process with fuzzy search
- `fshow`: Git commit browser with fuzzy search

### Text Editor

Text editing is based on [Neovim](https://neovim.io/) configured to be an "IDE". The whole setup with all plugins can also be run as a [Docker Container](https://github.com/mastertinner/vide).

- `e`: Start Neovim with all plugins
- `ide`: Start Neovim with all plugins in an IDE like window layout
- `ctrl + p`: Fuzzy search files across whole project
- `ctrl + n`: Open visual file explorer

## Installation

1. Clone this repo to `~/dotfiles` by running `git clone git@github.com:Sonic0/dotfiles.git ~/dotfiles`
1. Change the name and email address in `git/.gitconfig`
1. Arch Linux only: Change `pacmanfile/.config/pacmanfile/pacmanfile.txt` to your liking or add `pacmanfile-extra.txt` to the same directory for independent packages per machine
1. macOS only: Change `Brewfile` to your liking or add `extra.Brewfile` for independent packages per machine
1. macOS only: If you have apps installed which you didn't install through `brew` but that you now added to `Brewfile`, you need to reinstall them with `brew install <name> --force` so `brew` knows it's supposed to manage these apps.

   Note: This won't delete any of your data. The app will just be reinstalled with `brew` and everything will be back to normal once the installation script has run.

1. Run `~/dotfiles/install.sh`

   **WARNING: This may install and/or remove software and change your configs!**

1. Either import an existing PGP key pair by using `gpg --import my-key.asc` and `gpg --import my-key-pub.asc` or create a new one by following the [GitHub guide](https://help.github.com/en/articles/generating-a-new-gpg-key). You need to use the same name and email address as an ID that you have configured in `git/.gitconfig` in order to correctly sign your Git commits.
1. Either import an existing SSH key pair by copying it to `~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub` or create a new one by following the [GitHub guide](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).

## Quick Installation without customization (not recommended unless you're the owner of this repo :wink:)

1.  Run the following command:

    **WARNING: This may install and/or remove software and change your configs!**

    ```shell
    $ curl -s https://raw.githubusercontent.com/Sonic0/dotfiles/main/install.sh | sh
    ```
