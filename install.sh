#!/bin/sh

# This script installs these dotfiles.

set -e -u

printf '\e[1mInstalling dotfiles\e[0m\n'
# Recognize OS
OS="$(uname)"
if [ "${OS}" = "Linux" ] && [ -x "$(command -v lsb_release)" ] && [ "$(lsb_release -i -s)" = "Ubuntu" ]; then
    DISTRO="Ubuntu"
elif [ "${OS}" = "Linux" ] && [ -x "$(command -v pacman)" ]; then
    DISTRO="ArchLinux"
else
    printf '\e[1mUbuntu, Arch Linux and Darwin are the only Linux distros currently supported for automated setup\e[0m\n'
    exit 1
fi

case "${DISTRO:-OS}" in

# On Linux, use the respective package manager
'Darwin')

    # Install Xcode Command Line Tools if not installed
    if ! xcode-select -p > /dev/null; then
        printf 'Xcode Command Line Tools not installed. You will have to run the script again after successfully installing them. Install now? (Y/n)'
        read -r
        echo
        if ! "$REPLY" | grep -Eq '^[Nn]'; then
            xcode-select --install
            echo 'Please run the script again after the installation has finished'
        else
            echo 'Please install the Xcode Command Line Tools and run then script again.'
        fi
        exit
    fi

    # Install Homebrew if not installed
    if [ ! -x "$(command -v brew)" ]; then
        printf '\e[1mInstalling Homebrew\e[0m\n'
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Install git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        brew install git
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone git@github.com:mastertinner/dotfiles.git ~/dotfiles
    fi

    # Install Stow if not installed
    if [ ! -x "$(command -v stow)" ]; then
        printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
        brew install stow
    fi
    # Remove existing config files
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
    fi
    # Stow subdirectories of dotfiles
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done

    # Install pip if not installed
    if [ ! -x "$(command -v pip)" ]; then
        sudo easy_install pip
    fi

    # Install oh-my-zsh
    if [ ! -d ~/.oh-my-zsh ]; then
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Install the Python Neovim package
    pip install --upgrade --user pynvim

    # Set dark mode
    sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark
    ;;

'ArchLinux')

    # Install Git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        sudo pacman -Syu git --noconfirm --needed
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone git@github.com:Sonic0/dotfiles.git ~/dotfiles
    fi

    # Install Stow if not installed
    printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
    sudo pacman -Syu stow --noconfirm --needed
    # Remove existing config files
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
    fi
    # Stow subdirectories of dotfiles
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done
    sudo pacman -Rns stow --noconfirm

    # Install Paru if not installed
    if [ ! -x "$(command -v paru)" ]; then
        printf '\e[1mInstalling Paru\e[0m\n'
        git clone https://aur.archlinux.org/paru.git /tmp/paru
        (cd /tmp/paru && makepkg -si)
    fi

    # Set colors for pacman
    sudo sed -i 's/#Color/Color/' /etc/pacman.conf

    # Install Pacmanfile if not installed
    if [ ! -x "$(command -v pacmanfile)" ]; then
        printf '\e[1mInstalling Pacmanfile\e[0m\n'
        paru -Syu --noconfirm --needed pacmanfile
    fi

    # Install packages using Pacmanfile
    printf '\e[1mInstalling desired packages using Pacmanfile\e[0m\n'
    pacmanfile sync --noconfirm
    ;;

'Ubuntu')

    # Install Git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        sudo apt install git --quiet --y
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone git@github.com:Sonic0/dotfiles.git ~/dotfiles
    fi

    # Install Stow if not installed
    printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
    sudo apt install stow --quiet --yes
    # Remove existing config files
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
    fi
    # Stow subdirectories of dotfiles
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles "$(basename "${dir}")"
    done
    sudo apt remove stow --yes

    # Install tools
    printf '\e[1mInstalling desired tools and apps\e[0m\n'
    sudo apt update && xargs -a ubuntu_packages.txt sudo apt install --quiet --yes

    # Install Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    sudo apt update && sudo apt install --yes docker-ce docker-ce-cli containerd.io

    # Install Python packages
    if [ -x "$(command -v python3)" ] && [ -x "$(command -v python3 -m pip)" ]; then
        python3 -m pip install --user -r python_requirements.txt
    else
        printf '\e[91mPlease install or update your Python version\e[0m\n'
    fi

    # Install aws-cli v2
    if [ ! -x "$(command -v aws)" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        (unzip awscliv2.zip && sudo ./aws/install && rm -rf aws awscliv2.zip)
    fi

    printf "\e[1mIt wasn't worth installing Ubuntu... now you have to install those packages manually ¯\_(ツ)_/¯\e[0m\n
    | alacritty | https://github.com/alacritty/alacritty  | Cargo |
    | bat | https://github.com/sharkdp/bat | Cargo |
    | delta | https://github.com/dandavison/delta | Cargo |
    | exa | https://github.com/ogham/exa#installation | Cargo |
    | topgrade | https://github.com/r-darwish/topgrade | Cargo |
    | github-cli | https://github.com/cli/cli/blob/trunk/docs/install_linux.md | Shell |
    | go | https://golang.org/dl/ | Shell |
    | gogh | https://github.com/Mayccoll/Gogh | Shell |
    | golang-lint | https://golangci-lint.run/usage/install/#local-installation | Shell |
    | gron | https://github.com/tomnomnom/gron | Shell |
    | trivy | https://github.com/aquasecurity/trivy | Shell |
    | iputils | https://github.com/iputils/iputils | Shell |
    | kubectl | https://kubernetes.io/docs/tasks/tools/install-kubectl | Shell |
    | kubectx | https://github.com/ahmetb/kubectx | Shell |
    | nerd-font |https://github.com/ryanoasis/nerd-fonts | Shell |
    | spotify-tui | https://github.com/Rigellute/spotify-tui | Snap/Cargo |
    | svgo | https://github.com/svg/svgo | Snap/Cargo |
    | terraform | https://www.terraform.io/docs/cli/install/apt.html | Shell |
    | tflint | https://github.com/terraform-linters/tflint | Shell |
    | Typescript | https://www.typescriptlang.org | npm |
    | wf-recorder | https://github.com/ammen99/wf-recorder | Shell |\n"
    ;;

# Default
*)
    printf '\e[1mOS not supported for automated setup. Please install manually.\e[0m\n'
    exit 1
    ;;
esac

# Common post-actions for Linux distributions
if [ "${OS}" = 'Linux' ]; then
    # Install oh-my-zsh
    if [ ! -d "${HOME}/.oh-my-zsh" ]; then
        printf '\e[1mInstalling oh-my-zsh\e[0m\n'
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Cloning oh-my-zsh plugins and themes
    if [ ! -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/themes/powerlevel10k ]; then
        printf '\e[1mCloning power10k theme for oh-my-zsh\e[0m\n'
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"
    fi
    if [ ! -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting ]; then
        printf '\e[1mCloning zsh-syntax-highlighting plugin for oh-my-zsh\e[0m\n'
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    fi
    if [ ! -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-nvm ]; then
        printf '\e[1mCloning zsh-nvm plugin for oh-my-zsh\e[0m\n'
        git clone https://github.com/lukechilds/zsh-nvm "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-nvm"
    fi
    if [ ! -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions ]; then
        printf '\e[1mCloning zsh-autosuggestions plugin for oh-my-zsh\e[0m\n'
        git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    fi
    if [ ! -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/plugins/zsh-completions ]; then
        printf '\e[1mCloning zsh-completions plugin for oh-my-zsh\e[0m\n'
        git clone https://github.com/zsh-users/zsh-completions "${ZSH_CUSTOM:=${HOME}/.oh-my-zsh/custom}/plugins/zsh-completions"
    fi

    # Cloning tmp tmux plugin manager
    if [ ! -x "$(command -v tmux)" ]; then
        printf '\e[1mCloning Tmux TMP plugin manager\e[0m\n'
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi

    # Install Nvm
    if [ ! -d ~/.nvm ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash
    fi

    # Enable docker service and allow user to run it without sudo
    sudo systemctl enable docker.service
    getent group docker || groupadd docker
    sudo usermod -aG docker "${USER}"

    # Change npm folder
    if [ -x "$(command -v npm)" ]; then
        mkdir -p ~/.node_modules/lib
        npm config set prefix "${HOME}/.node_modules"
    fi
fi
# Install rustup
if [ ! -x "$(command -v rustup)" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    . $HOME/.cargo/env
    rustup component add rls rust-analysis rust-src rustfmt clippy
fi

# Use zsh
if [ -x "$(command -v zsh)" ] && [ "$SHELL" != "$(command -v zsh)" ]; then
    printf '\e[1mChanging your shell to zsh\e[0m\n'
    grep -q -F "$(command -v zsh)" /etc/shells || sudo sh -c 'echo "$(command -v zsh)" >> /etc/shells'
    chsh -s "$(command -v zsh)"
fi

# Remove existing bash config files
rm -rf ~/.bash*

# Run full system upgrade
. ~/dotfiles/zsh/.zsh.d/path.zsh
. ~/dotfiles/zsh/.zsh.d/functions.zsh
pacu

printf '\e[1mDotfiles successfully installed. Please reboot to finalize.\e[0m\n'
