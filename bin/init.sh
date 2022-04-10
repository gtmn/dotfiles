#!/bin/bash

# init.sh - Initialize new machine based on dotfiles

# shellcheck source=/dev/null
source ./functions.sh

BREW_FILE=~/Developer/dotfiles/brewfiles/Brewfile

function install_homebrew() {
    # if (( ! $+commands[brew] )); then
    if ! command -v brew &> /dev/null
    then
    echo "Installing Homebrew ..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        brew update

        # brew bundle Brewfile
        # brew bundle Brewfile-casks
        # ln -s "$(brew --prefix)/Library/Contributions/brew_zsh_completion.zsh" /usr/local/share/zsh/site-functions/_brew

        echo "eval \"$(/opt/homebrew/bin/brew shellenv)\"" >> /Users/"$(whoami)"/.zprofile
    else
        echo "Homebrew is already installed. Updating ..."
        brew update && brew upgrade
    fi
}

function apply_settings {
    echo "Apply"
}

function link_dotfiles {
    echo "Link"
}

echo "--------------------------------------------------
INITIALIZING ...
--------------------------------------------------"

confirm_yes "Allow third-party apps (sudo required!)" && sudo spctl --master-disable

confirm_yes "Install Homebrew" && install_homebrew

confirm_yes "Install Homebrew formulaes from Brewfile" && brew bundle install --file=$BREW_FILE

confirm_yes "Apply settings" && apply_settings

confirm_yes "Link dotfiles" && link_dotfiles
