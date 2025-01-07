#!/bin/bash

# Log file setup
LOG_FILE="install_script.log"
exec > >(tee -a "$LOG_FILE") 2>&1

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

# Update package lists and install basic dependencies
update_system() {
	if [ "$OS" == "ubuntu" ]; then
		apt update && apt upgrade -y
		apt install -y curl git stow unzip 7zip zsh-syntax-highlighting zsh-autosuggestions build-essential gpg stow
	elif [ "$OS" == "fedora" ]; then
		dnf update -y
		dnf install -y curl git stow unzip 7zip zsh-syntax-highlighting zsh-autosuggestions gcc make stow
	else
		echo "Unsupported operating system."
		exit 1
	fi
}
update_system

# Function to check if a program is installed
is_installed() {
	command -v "$1" >/dev/null 2>&1
}

# Add ~/.local/bin to PATH if not already present
add_to_path() {
	if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
		echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.zshrc
		export PATH="$HOME/.local/bin:$PATH"
	fi
}
add_to_path

# Function to install a tool if not already installed
install_tool() {
	local tool=$1
	local install_cmd=$2

	if ! is_installed "$tool"; then
		echo "Installing $tool..."
		eval "$install_cmd"
		if is_installed "$tool"; then
			echo "$tool installation successful."
		else
			echo "Error installing $tool."
		fi
	else
		echo "$tool is already installed."
	fi
}

# Install Neovim
install_tool "nvim" "curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz && sudo tar -C /opt -xzf nvim-linux64.tar.gz && echo 'export PATH=/opt/nvim-linux64/bin:\$PATH' >>~/.zshrc && rm nvim-linux64.tar.gz"

# Install fzf
install_tool "fzf" "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install --all"

# Install Zsh
install_tool "zsh" "if [ \"$OS\" == \"ubuntu\" ]; then apt install -y zsh; elif [ \"$OS\" == \"fedora\" ]; then dnf install -y zsh; fi && chsh -s \$(which zsh)"

# Install Starship
install_tool "starship" "curl -sS https://starship.rs/install.sh | sh -s -- -y && echo 'eval \"\$(starship init zsh)\"' >>~/.zshrc"

# Install Zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	echo "source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >>~/.zshrc
else
	echo "Zsh-autosuggestions is already installed."
fi

# Install Yazi
install_tool "yazi" "curl -Lo yazi.zip https://github.com/sxyazi/yazi/releases/download/v0.4.2/yazi-x86_64-unknown-linux-gnu.zip && unzip yazi.zip -d /usr/local/bin && mv /usr/local/bin/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/yazi && rm -rf /usr/local/bin/yazi-x86_64-unknown-linux-gnu yazi.zip"

# Install Eza
install_tool "eza" "if [ \"$OS\" == \"ubuntu\" ]; then mkdir -p /etc/apt/keyrings && wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg && echo \"deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main\" | sudo tee /etc/apt/sources.list.d/gierens.list && chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list && apt update && apt install -y eza; elif [ \"$OS\" == \"fedora\" ]; then dnf install -y eza; fi"

# Install Zoxide
install_tool "zoxide" "curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/refs/heads/main/install.sh | bash && echo 'eval \"\$(zoxide init zsh)\"' >>~/.zshrc"

# Install Zellij
install_tool "zellij" "curl -Lo zellij.tar.gz https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz && tar -xzvf zellij.tar.gz -C /usr/local/bin && rm zellij.tar.gz"

# Install LazyGit
install_tool "lazygit" "LAZYGIT_VERSION=\$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep 'tag_name' | cut -d '\"' -f 4) && curl -Lo lazygit.tar.gz https://github.com/jesseduffield/lazygit/releases/download/\$LAZYGIT_VERSION/lazygit_\$LAZYGIT_VERSION_Linux_x86_64.tar.gz && tar -xzvf lazygit.tar.gz -C /usr/local/bin && rm lazygit.tar.gz"

# Install LazyVim
install_lazyvim() {
	echo "Installing LazyVim..."
	NVIM_CONFIG_DIR="$HOME/.config/nvim"
	if [ ! -d "$NVIM_CONFIG_DIR" ]; then
		git clone https://github.com/LazyVim/starter "$NVIM_CONFIG_DIR"
	else
		echo "Neovim configuration directory already exists. Skipping LazyVim installation."
	fi
}
install_lazyvim

# Apply changes
source ~/.zshrc

# Finish
echo "All programs have been installed and configured!!"
