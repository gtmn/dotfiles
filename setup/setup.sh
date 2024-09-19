#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# script_dir="$(dirname "$(realpath "${BASH_SOURCE[0]}")")"

# ====================================================================================================
# init.sh - Initialize new machine based on dotfiles
# ====================================================================================================

# shellcheck source=/dev/null
source "$SCRIPT_DIR/../scripts/functions.sh"

BREW_FILE="$SCRIPT_DIR/Brewfile"

# ====================================================================================================
# Functions
# ====================================================================================================

# Function to execute all *.sh files in a directory
run_scripts() {
    local dir=$1

    # Check if the directory exists
    if [[ ! -d "$dir" ]]; then
        echo "Directory does not exist: $dir"
        return 1
    fi

    # Loop through all *.sh files and execute them
    for file in "$dir"/*.sh; do
        if [[ -f "$file" ]]; then
            echo "Executing $file"
            bash "$file"
        fi
    done
}

# ====================================================================================================
# Install app, apply my settings & configurations
# ====================================================================================================

# if [[ $(spctl --status) =~ "disabled" ]]; then
#     confirm_yes "Allow third-party apps (sudo required!)" && sudo spctl --master-disable
# else
#     echo "Already enabled"
# fi
confirm_yes "Install formulaes from Brewfile?" && brew bundle install --file="$BREW_FILE"
confirm_yes "Apply system settings?" && run_scripts "macos/system_settings/"
confirm_yes "Apply app settings?" && run_scripts "macos/app_settings/"

# ====================================================================================================
# Set up terminal
# ====================================================================================================

confirm_yes "Stow dotfiles?" &&
    stow

# confirm_yes "Set up oh-my-zsh & powerline now?" &&
#     # git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" &&
#     pip install --user powerline-status &&
