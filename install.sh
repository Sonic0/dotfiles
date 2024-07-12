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

'ArchLinux')
    # Install Git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        sudo pacman -S --noconfirm --needed git
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone https://github.com/Sonic0/dotfiles.git ~/dotfiles
    fi

	# Install Stow if not installed
	sudo pacman -S --noconfirm --needed stow
	# Remove existing config files
	if [ -f ~/.zshrc ]; then
		rm ~/.zshrc
	fi
	if [ -f ~/.zshenv ]; then
		rm ~/.zshenv
	fi
	# Stow subdirectories of dotfiles
	printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
	for dir in ~/dotfiles/*/; do
		stow --dir ~/dotfiles --target ~ "$(basename "${dir}")"
	done
	sudo pacman -Rns --noconfirm stow

	# Install Paru if not installed
	if [ ! -x "$(command -v paru)" ]; then
		printf '\e[1mInstalling Paru\e[0m\n'
		git clone https://aur.archlinux.org/paru-bin.git /tmp/paru
		(cd /tmp/paru && makepkg -si)
	fi

	# Set colors for pacman
	sudo sed -i 's/#Color/Color/' /etc/pacman.conf

	# Install Pacmanfile if not installed
	if [ ! -x "$(command -v pacmanfile)" ]; then
		printf '\e[1mInstalling Pacmanfile\e[0m\n'
		paru -S --noconfirm --needed pacmanfile
	fi

	# Install packages using Pacmanfile
	printf '\e[1mInstalling desired packages using Pacmanfile\e[0m\n'
	pacmanfile sync --noconfirm

	# Change npm folder
	if [ -x "$(command -v npm)" ]; then
		mkdir -p ~/.node_modules/lib
		npm config set prefix '~/.node_modules'
	fi
	;;

'Ubuntu')
    # Install Git if not installed
    if [ ! -x "$(command -v git)" ]; then
        printf '\e[1mInstalling Git\e[0m\n'
        sudo apt install --quiet --yes git
    fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone https://github.com/Sonic0/dotfiles.git ~/dotfiles
    fi

    # Install Stow if not installed
    sudo apt install --quiet --yes stow
    # Remove existing config files
    if [ -f ~/.zshrc ]; then
        rm ~/.zshrc
    fi
    if [ -f ~/.zshenv ]; then
        rm ~/.zshenv
    fi
    # Stow subdirectories of dotfiles
    printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
    for dir in ~/dotfiles/*/; do
        stow --dir ~/dotfiles --target ~ "$(basename "${dir}")"
    done
    sudo apt remove --yes stow

    # Install tools
    printf '\e[1mInstalling desired apps and tools\e[0m\n'
    sudo apt update && xargs -a ~/.config/apt_packages/ubuntu_packages.txt sudo apt install --quiet --yes

    # Install Docker
    if [ ! -x "$(command -v docker)" ]; then
        sudo install -m 0755 -d /etc/apt/keyrings
        sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
        sudo chmod a+r /etc/apt/keyrings/docker.asc
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
          $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
          sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install --yes docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        # Enable docker service and allow user to run it without sudo
        getent group docker || groupadd docker
        sudo usermod -aG docker "${USER}"
        newgrp docker
        sudo systemctl enable docker.service
        sudo systemctl enable containerd.service
    fi

    # Install aws-cli v2
    if [ ! -x "$(command -v aws)" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
        (unzip awscliv2.zip && sudo ./aws/install && rm -rf aws awscliv2.zip)
    fi

    # Install rustup
    if [ ! -x "$(command -v rustup)" ]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        . $HOME/.cargo/env
        rustup component add rls rust-analysis rust-src rustfmt clippy
    fi

    # Change npm folder
    if [ -x "$(command -v npm)" ]; then
        mkdir -p ~/.node_modules/lib
        npm config set prefix ~/.node_modules
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

'Darwin')

	# Install Xcode Command Line Tools if not installed
	if ! xcode-select -p >/dev/null; then
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
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	# Install git if not installed
	if [ ! -x "$(command -v git)" ]; then
		printf '\e[1mInstalling Git\e[0m\n'
		brew install git
	fi

    # git clone these dotfiles if not done yet
    if [ ! -d ~/dotfiles ]; then
        printf '\e[1mCloning dotfiles repo\e[0m\n'
        git clone https://github.com/Sonic0/dotfiles.git ~/dotfiles
    fi

	# Install Stow if not installed
	if [ ! -x "$(command -v stow)" ]; then
		brew install stow
	fi
	# Remove existing config files
	if [ -f ~/.zshrc ]; then
		rm ~/.zshrc
	fi
	# Stow subdirectories of dotfiles
	printf '\e[1mLinking dotfiles to your home directory\e[0m\n'
	for dir in ~/dotfiles/*/; do
		stow --dir ~/dotfiles --target ~ "$(basename "${dir}")"
	done
	# Remove Stow
	brew uninstall stow

	# Install packages using Brewfile
	printf '\e[1mInstalling desired packages using Pacmanfile\e[0m\n'
	brew update
	brew upgrade
	cat ~/.config/homebrew/*Brewfile | brew bundle --file=-

    # Install the Python Neovim package
    pip3 install --upgrade --user pynvim

	# Install additional Go tooling currently not available via Homebrew
	go install golang.org/x/tools/cmd/goimports@latest

	# Set dark mode
	sudo defaults write /Library/Preferences/.GlobalPreferences AppleInterfaceTheme Dark
	;;

# Default
*)
	printf '\e[1mOS not supported for automated setup. Please install manually.\e[0m\n'
	exit 1
	;;
esac

# Install oh-my-zsh
if [ ! -d "${HOME}/.oh-my-zsh" ]; then
    printf '\e[1mInstalling oh-my-zsh\e[0m\n'
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
# Clone oh-my-zsh theme
if [ ! -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}"/themes/powerlevel10k ]; then
     printf '\e[1mCloning powerlevel10k theme for oh-my-zsh\e[0m\n'
     git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/themes/powerlevel10k"
fi
# Clone oh-my-zsh plugins
oh_my_zsh_plugins="lukechilds/zsh-nvm zsh-users/zsh-syntax-highlighting zsh-users/zsh-autosuggestions zsh-users/zsh-completions"
for plugin in ${oh_my_zsh_plugins}; do
    zsh_plugin_dir_path="plugins/$(echo "${plugin}" | cut -d'/' -f2)"
    if [ ! -d "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/${zsh_plugin_dir_path}" ]; then
        printf '\e[1mCloning %s plugin for oh-my-zsh\e[0m\n' "${plugin}"
        git clone "https://github.com/${plugin}" "${ZSH_CUSTOM:-${HOME}/.oh-my-zsh/custom}/${zsh_plugin_dir_path}"
    fi
done

# Cloning tpm tmux plugin manager
if [ -x "$(command -v tmux)" ] && [ ! -d "${HOME}/.config/tmux/plugins/tpm" ]; then
    tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "${HOME}/.config/tmux/plugins"
    printf '\e[1mCloning Tmux TPM plugin manager\e[0m\n'
    git clone https://github.com/tmux-plugins/tpm "${HOME}/.config/tmux/plugins/tpm"
    "${HOME}/.config/tmux/plugins/tpm/bin/install_plugins"
fi

# Install Nvm
if ! command -v nvm; then
    latest_nvm_tag=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
    # Check if the latest_tag variable is not empty
    if [ -n "${latest_nvm_tag}" ]; then
        printf "\e[1mInstalling nvm using installation script version ${latest_nvm_tag}\e[0m\n"
        # Install nvm using the latest tag
        PROFILE=/dev/null curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${latest_nvm_tag}/install.sh | bash
        if ! command -v nvm; then
            source "${HOME}/.zshrc"
        fi
        nvm install --lts && nvm install-latest-npm && nvm alias default node
    else
        printf "\e[1mFailed to fetch the latest nvm tag. Skip installation\e[0m\n"
    fi
fi

# Use zsh
if [ ! -x "$(command -v zsh)" ] && [ "${SHELL}" != "$(command -v zsh)" ]; then
	printf '\e[1mChanging your shell to zsh\e[0m\n'
	grep -q -F "$(command -v zsh)" /etc/shells || sudo sh -c 'echo "$(command -v zsh)" >> /etc/shells'
	chsh -s "$(command -v zsh)"
fi

# Remove existing bash config files
rm -rf ~/.bash*

# Run full system upgrade
. ~/dotfiles/zsh/.zsh.d/functions.zsh
EDITOR=nvim pacu

printf '\e[1mDotfiles successfully installed. Please reboot to finalize.\e[0m\n'
