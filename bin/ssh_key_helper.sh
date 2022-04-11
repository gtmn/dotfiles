#!/bin/bash

# ssh_key_helper

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR/functions.sh"

# shellcheck disable=SC2088
SSH_BASE_DIR="$HOME/.ssh"
DEFAULT_ALGORITHM="ed25519"
DEFAULT_USER=$(whoami)
DEFAULT_CLIENT=$(hostname -s)
DEFAULT_HOST="github.com"
DEFAULT_SSH_USER="git"

function ask_filename {
    ALGORITHM=$(ask_for_value "Enter algorithm/type for new key" $DEFAULT_ALGORITHM)
    HOST=$(ask_for_value "Enter comment for which HOST this new key is used for" "$DEFAULT_HOST")
    CLIENT=$(ask_for_value "Enter comment for which CLIENT this new key is used for" "$DEFAULT_CLIENT")
    USER=$(ask_for_value "Enter comment for which USER this new key is used for" "$DEFAULT_USER")
    KEY_COMMENT=$(echo "${HOST}-${CLIENT}-${USER}" | sed "s/[.]/_/g")
    KEY_NAME=$(echo "id_${ALGORITHM}-${KEY_COMMENT}" | sed "s/\n/-/g")
    KEY_FILE=$(ask_for_value "Enter file to save the key" "$SSH_BASE_DIR/${KEY_NAME}")

    # echo "Key file path starts with '~/' => apply substitution for absolute path"
    # KEY_FILE=${KEY_FILE/#\~/$HOME}
}

function confirm_overwrite {
    echo "Checking if SSH key already exists at $1"
    local KEY_FILE=$1

    if [ -f "$KEY_FILE" ]; then
        echo "SSH key with this name already exists!"
        echo

        # Ensure overwrite is confirmed a second time
        if confirm "DANGEROUS! Overwrite existing key"; then
            confirm "Are you really sure"

            return $?
        else
            return 1
        fi
    fi

    echo "SSH key with this name does not yet exist."
    return 0
}

function generate_new_ssh_keypair {
    local _ALGORITHM=$1
    local _KEY_FILE=$2
    local _COMMENT=$3

    echo "Generate new SSH key..."

    # Generate new key pair
    ssh-keygen -t "$_ALGORITHM" -f "$_KEY_FILE" -C "$_COMMENT" \
        <<<y >/dev/null 2>&1 # force overwrite (own overwrite used with own confirmation prompt)
        #|| echo "ssh-keygen exited with non-zero code $?"; exit;

    # Add to agent and save password to keychain
    ssh-add --apple-use-keychain "$_KEY_FILE"
    echo

    # Add to local ssh agent
    eval "$(ssh-agent -s)"
}

function add_to_ssh_config {
    local _SSH_HOST=$1
    local _SSH_USER=$2
    local _KEY_FILE=$3

    local _SSH_CONFIG_FILE="$SSH_BASE_DIR/config"

    if [ -f "$_SSH_CONFIG_FILE" ]; then
        touch "$_SSH_CONFIG_FILE"
    fi

    # new ssh config for HOST (replace $HOME with ~ for cross-device/user usage)
    local _SSH_HOST_CONFIG="HOST $_SSH_HOST
    HOSTName $_SSH_HOST
    USER $_SSH_USER
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ${KEY_FILE/#$HOME/~}
    IdentitiesOnly yes"
    local _ESCAPED_SSH_HOST_CONFIG
    _ESCAPED_SSH_HOST_CONFIG=$(echo "$_SSH_HOST_CONFIG" | tr -d "[:space:]")

    # existing ssh config from file
    local _ESCAPED_CONFIG_FILE_CONTENT
    _ESCAPED_CONFIG_FILE_CONTENT=$(tr -d "[:space:]" < "$_SSH_CONFIG_FILE")

    # Check if config already exists, else append new config
    if [[ "$_ESCAPED_CONFIG_FILE_CONTENT" == *"$_ESCAPED_SSH_HOST_CONFIG"* ]]; then
        echo "Config already exists. Skip adding..."
    else
        echo "Config does not yet exist. Adding to config..."
        echo "$_SSH_HOST_CONFIG" >> "$_SSH_CONFIG_FILE"
    fi
}

function setup_new_ssh_key {
    echo "Basic SSH Setup Helper"
    echo "========================="
    echo

    # Determine file name
    ask_filename
    echo

    #Generate
    if confirm_overwrite "$KEY_FILE" -eq 0; then
        echo
        generate_new_ssh_keypair "$ALGORITHM" "$KEY_FILE" "$KEY_COMMENT"
    else
        echo
        confirm "Continue SSH setup with existing key" || exit 1;
    fi

    # generate_new_ssh_keypair "$ALGORITHM" "$KEY_FILE" "$KEY_COMMENT"
    echo

    cat "$KEY_FILE.pub"
    echo

    confirm_yes "Add to SSH config" \
        && SSH_HOST=$(ask_for_value "Enter SSH HOST" "$HOST") \
        && SSH_USER=$(ask_for_value "Enter SSH USER" "$DEFAULT_SSH_USER") \
        && add_to_ssh_config "$SSH_HOST" "$SSH_USER" "$KEY_FILE"
    echo

    confirm_yes "Copy public key to clipboard" && pbcopy < "$KEY_FILE.pub"
    echo

    confirm_yes "Test SSH connection to HOST (uses any of your existing SSH config!)" \
        && SSH_HOST=$(ask_for_value "Enter SSH HOST" "${SSH_HOST:-HOST}") \
        && SSH_USER=$(ask_for_value "Enter SSH USER" "${SSH_USER:-DEFAULT_SSH_USER}") \
        && ssh -T "$SSH_USER"@"$SSH_HOST"
}
