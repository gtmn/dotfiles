#!/bin/bash

# bootstrap.sh - bootstrap GIT and DEVELOP setup for a new machine

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTFILES_DIR="$HOME/Developer/dotfiles"
TMP_DIR="$HOME/.my_bootstrap_scripts"
REMOTE_BASEURL="https://github.com/gtmn/dotfiles/raw/2022-update/bin"
FILE_LIST=('ask.sh' 'confirm.sh' 'functions.sh' 'ssh_key_helper.sh')

# ==================================================

# Function to download files from a remote location and source them
function download_file {
    _REMOTE_FILE=$1
    _LOCAL_FILE=$2

    echo "Download remote file: $_REMOTE_FILE"

    curl --insecure -Ls "$_REMOTE_FILE" -o "$_LOCAL_FILE" --create-dirs
}

function async_source_file {
    _LOCAL_FILE=$1

    echo "Source local file: $_LOCAL_FILE"

    while [ ! -f "$_LOCAL_FILE" ]; do sleep 1; done

    # shellcheck source=/dev/null
    source "$_LOCAL_FILE"
}

# Source files from location
# shellcheck disable=SC2048
for item in ${FILE_LIST[*]}
do
    if [[ "$(realpath "$SCRIPT_DIR")" != "$(realpath "$DOTFILES_DIR/bin")" ]]; then
        download_file "$REMOTE_BASEURL/$item" "$TMP_DIR/$item"
        async_source_file "$TMP_DIR/$item"

    else
        async_source_file "$item"
    fi

done

# ==================================================

# function upload_ssh_key_github {
#     # https://gist.github.com/juanique/4092969?permalink_comment_id=3078760#gistcomment-3078760
#     if [ -n $comment ]; then
#         read -p "Enter ssh key title: " comment
#     else
#         echo "Using ssh key title: $comment"
#     fi

#     read -p "Enter github username: " githubuser
#     read -s -p "Enter github password for user $githubuser: " githubpass
#     echo
#     read -p "Enter github access token: " access_token
#     echo
#     curl -u "$githubuser:$githubpass" \
#         -X POST \
#         -H "Authorization: token $access_token" \
#         -d '{"title":"'$comment'", "key":"'$(cat $PUB_KEY_FILE)'"}' \
#         https://api.github.com/user/keys
# }

# ==================================================

function clone_dotfiles_repo {
    mkdir -p ~/Developer
    cd ~/Developer || return
    git clone git@github.com:gtmn/dotfiles
}

# ==================================================

# clear

echo
echo "BOOTSTRAPING ...
=================================================="
echo

# Attention, if SSH setup is aborted whole bootstraping process is aborted
confirm_yes "Start SSH setup:" \
    && setup_new_ssh_key
echo

# confirm "Upload ssh key ($PUB_KEY_FILE) to github.com [y/N]:" \
#    && upload_ssh_key_github && ssh -T git@github.com

confirm "Clone dotfiles directory to ~/Developer/dotfiles directory " \
    && clone_dotfiles_repo
echo

confirm "Start setup based on checked out dotfiles" \
    && "$DOTFILES_DIR/bin/init.sh"
echo

if [[ -d "$TMP_DIR" ]]; then
    echo "Remove scripts from local download directory under '$TMP_DIR'?"
    echo "If no, download 'setup_new_ssh_key.sh' script for further easy SSH keys setup."
    confirm "Remove downloaded bootstrap scripts?" \
        && rm -rf "$TMP_DIR"

    if [[ $? -eq 0 ]]; then
        echo "Cleaning up ..."
        rm -rf "$TMP_DIR"
    else
        download_file "$REMOTE_BASEURL/setup_new_ssh_key.sh" "$TMP_DIR/setup_new_ssh_key.sh"
    fi
fi
