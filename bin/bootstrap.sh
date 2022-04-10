#!/bin/bash

# bootstrap.sh - bootstrap GIT and DEVELOP setup for a new machine

# Function to download files from a remote location and source them
function source_remote_file {
    _REMOTE_FILE=$1
    _LOCAL_FILE=$2

    curl --insecure -Ls "$_REMOTE_FILE" -o "$_LOCAL_FILE" --create-dirs
    while [ ! -f "$_LOCAL_FILE" ]; do sleep 1; done
    # shellcheck source=/dev/null
    source "$_LOCAL_FILE"
}

# Source file from remote location
TMP_DIR="$HOME/.tmp_bootstrap"
REMOTE_BASEURL="https://github.com/gtmn/dotfiles/raw/2022-update/bin"
FILE_LIST=('ask.sh' 'confirm.sh' 'functions.sh' 'ssh_key_helper.sh')

# shellcheck disable=SC2048
for item in ${FILE_LIST[*]}
do
    source_remote_file "$REMOTE_BASEURL/$item" "$TMP_DIR/$item"
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


function clone_dotfiles_repo {
    mkdir -p ~/Developer
    cd ~/Developer || return
    git clone git@github.com:gtmn/dotfiles
}

# ==================================================

clear

echo "--------------------------------------------------
BOOTSTRAPING ...
--------------------------------------------------"

confirm_yes "Start SSH setup:" \
    && echo; setup_new_ssh_key

# confirm "Upload ssh key ($PUB_KEY_FILE) to github.com [y/N]:" \
#    && upload_ssh_key_github && ssh -T git@github.com

confirm "Clone dotfiles directory to ~/Developer/dotfiles directory " \
    && echo; clone_dotfiles_repo

confirm "Start setup based on checked out dotfiles" \
    && echo; ~/Developer/dotfiles/bin/init.sh