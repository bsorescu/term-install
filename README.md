Term-Install
Overview

Term-Install is a versatile Bash script designed to automate the installation and configuration of essential terminal tools on Ubuntu and Fedora systems. The script handles package updates, dependency installation, and the setup of tools commonly used by developers and power users.
Features

    Detects the operating system (Ubuntu or Fedora).

    Installs and configures:

        Neovim

        fzf

        Zsh

        Starship prompt

        Zsh-autosuggestions

        Yazi

        Eza

        Zoxide

        Zellij

        LazyGit

    Adds ~/.local/bin to the PATH if not already present.

    Automatically updates the system and installs basic dependencies.

Requirements

    Root privileges: The script must be run as root or with sudo.

    Supported Operating Systems: Ubuntu or Fedora.

Installation

Run the following command to clone the repository and execute the script:
sudo bash -c "git clone https://github.com/bsorescu/term-install.git && cd term-install && chmod +x term-install.sh && ./term-install.sh"
Usage

The script is designed to:

    Detect your operating system.

    Update the system and install essential dependencies.

    Check if each tool is already installed.

    Install and configure the tools if they are not already installed.

Tools Installed
1. Neovim

    Modern Vim-based text editor.

    Installs the latest version from GitHub releases.

2. fzf

    A general-purpose command-line fuzzy finder.

    Installs via GitHub repository.

3. Zsh

    Z shell, an extended Bourne shell with many improvements.

    Changes the default shell to Zsh upon installation.

4. Starship

    Minimal, blazing-fast shell prompt.

    Configures Starship to initialize in Zsh.

5. Zsh-autosuggestions

    Provides real-time command-line suggestions.

6. Yazi

    Blazing fast terminal file manager.

7. Eza

    Modern replacement for ls.

8. Zoxide

    Smarter cd command.

9. Zellij

    Terminal workspace with a rich set of features.

10. LazyGit

    Simple terminal UI for Git commands.

Logging

The script logs its output to install_script.log in the current directory for troubleshooting and audit purposes.
Contributing

Contributions are welcome! Feel free to open issues or submit pull requests.
License

This project is licensed under the MIT License. See the LICENSE file for details.
Disclaimer

This script modifies your system's configuration and installs software. Use at your own risk. Ensure you review the script before running it.
