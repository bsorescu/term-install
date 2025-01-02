#!/bin/bash

# Ensure the script is run as root or with sudo
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root. Use sudo."
	exit 1
fi

# Detect the OS (Ubuntu or Fedora)
if [ -f /etc/os-release ]; then
	. /etc/os-release
	OS=$ID
else
	echo "Unsupported operating system."
	exit 1
fi

# Update package lists and install dependencies
if [ "$OS" == "ubuntu" ]; then
	apt update && apt upgrade -y
	apt install -y curl git unzip build-essential
elif [ "$OS" == "fedora" ]; then
	dnf update -y
	dnf install -y curl git unzip gcc make
else
	echo "Unsupported operating system."
	exit 1
fi

# Function to check if a program is installed
is_installed() {
	command -v "$1" >/dev/null 2>&1
}

# Add ~/.local/bin to PATH if not already present
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
	echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.zshrc
	export PATH="$HOME/.local/bin:$PATH"
fi

# Install Neovim
if ! is_installed nvim; then
	if [ "$OS" == "ubuntu" ]; then
		apt install -y neovim
	elif [ "$OS" == "fedora" ]; then
		dnf install -y neovim
	fi
else
	echo "Neovim is already installed."
fi

# Install fzf
if ! is_installed fzf; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install --all
else
	echo "fzf is already installed."
fi

# Install Lazyvim (via Neovim configuration)
if [ ! -d "$HOME/.config/nvim" ]; then
	git clone https://github.com/LazyVim/starter $HOME/.config/nvim
	echo "Lazyvim installed in ~/.config/nvim"
else
	echo "Lazyvim is already configured."
fi

# Install Zsh
if ! is_installed zsh; then
	if [ "$OS" == "ubuntu" ]; then
		apt install -y zsh
	elif [ "$OS" == "fedora" ]; then
		dnf install -y zsh
	fi
	chsh -s $(which zsh)
else
	echo "Zsh is already installed."
fi

# Install Starship
if ! is_installed starship; then
	curl -sS https://starship.rs/install.sh | sh -s -- -y
	echo 'eval "$(starship init zsh)"' >>~/.zshrc
else
	echo "Starship is already installed."
fi

# Install Zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
else
	echo "Zsh-autosuggestions is already installed."
fi

# Install Yazi
if ! is_installed yazi; then
	curl -Lo yazi.zip https://github.com/sxyazi/yazi/releases/download/v0.4.2/yazi-x86_64-unknown-linux-gnu.zip &&
		unzip yazi.zip -d /usr/local/bin || echo "Yazi installation failed"
	rm -f yazi.zip
else
	echo "Yazi is already installed."
fi

# Install Eza
if ! is_installed eza; then
	if [ "$OS" == "ubuntu" ]; then
		curl -Lo eza.deb https://github.com/eza-community/eza/releases/latest/download/eza.deb &&
			apt install -y ./eza.deb && rm -f eza.deb
	elif [ "$OS" == "fedora" ]; then
		dnf install -y exa
	fi
else
	echo "Eza is already installed."
fi

# Install Zioxide
if ! is_installed zoxide; then
	curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
	echo 'eval "$(zoxide init zsh)"' >>~/.zshrc
else
	echo "Zoxide is already installed."
fi

# Install Zellij
if ! is_installed zellij; then
	curl -Lo zellij.tar.gz https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz &&
		tar -xzvf zellij.tar.gz -C /usr/local/bin || echo "Zellij installation failed"
	rm -f zellij.tar.gz
else
	echo "Zellij is already installed."
fi

# Install LazyGit
if ! is_installed lazygit; then
	LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
	curl -Lo lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz &&
		tar xf lazygit.tar.gz -C /usr/local/bin lazygit && rm lazygit.tar.gz || echo "LazyGit installation failed"
else
	echo "LazyGit is already installed."
fi

# Install Git
if ! is_installed git; then
	if [ "$OS" == "ubuntu" ]; then
		apt install -y git
	elif [ "$OS" == "fedora" ]; then
		dnf install -y git
	fi
else
	echo "Git is already installed."
fi

# Apply changes
source ~/.zshrc

# Finish
echo "All programs have been installed and configured!"
