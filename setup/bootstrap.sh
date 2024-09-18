#!/usr/bin/env bash

# ====================================================================================================
# bootstrap.sh - Bootstrap a new machine
# ====================================================================================================

REMOTE_BASE_URL="${1:-https://github.com/gtmn/dotfiles/raw/main/scripts}"
DOTFILES_REMOTE_REPO_URL="git@github.com:gtmn/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"
TMP_DIR="$HOME/.tmp_dotfiles"
BOOTSTRAP_SCRIPT_FILES=('ask.sh' 'confirm.sh' 'ssh_key_helper.sh')

# ====================================================================================================
# Check for minimum requirements
# ====================================================================================================
# shellcheck disable=SC2292
if [ -z "${BASH_VERSION:-}" ]; then
    printf "Bash is required to interpret this script.\n" >&2
    exit 1
fi

# ====================================================================================================
# Download & source initial files to enable Git connection
# ====================================================================================================

# Print message and abort
function abort {
    printf "%s\n" "$@" >&2
    exit 1
}

# Download a file from a remote location
function download_file {
    local _REMOTE_FILE=$1
    local _LOCAL_FILE=$2

    echo "Download remote file: $_REMOTE_FILE"

    curl --insecure -Ls "$_REMOTE_FILE" -o "$_LOCAL_FILE" --create-dirs
}

# Source a file
function async_source_file {
    local _LOCAL_FILE=$1

    echo "Source local file: $_LOCAL_FILE"

    while [ ! -f "$_LOCAL_FILE" ]; do sleep 1; done

    # shellcheck source=/dev/null
    source "$_LOCAL_FILE"
}

# Download and source multiple files from a remote location
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# shellcheck disable=SC2048
for item in ${BOOTSTRAP_SCRIPT_FILES[*]}; do
    echo "Start downloading bootstraping files..."

    # TODO: What did I do here?
    if [[ "$(realpath "$SCRIPT_DIR")" != "$(realpath "$DOTFILES_DIR/scripts")" ]]; then
        download_file "$REMOTE_BASE_URL/$item" "$TMP_DIR/$item"
        async_source_file "$TMP_DIR/$item"
    else
        async_source_file "$item"
    fi
done

# ====================================================================================================
# Create new SSH key & copy to clipboard
# ====================================================================================================

echo "Creating new SSH key..."
setup_new_ssh_key
echo "Before cloning the remaining dotfiles from Git make sure SSH key has been added"
confirm "Added SSH key to your account?"

# ====================================================================================================
# Clone dotfiles dir & init from dotfiles file
# ====================================================================================================

if [[ ! -f $DOTFILES_DIR ]]; then
    echo "Did not find dotfiles directory"

    confirm "Clone dotfiles directory to $DOTFILES_DIR directory?" &&
        mkdir -p "$DOTFILES_DIR" &&
        git -C "$DOTFILES_DIR" clone "$DOTFILES_REMOTE_REPO_URL" .
else
    echo "Did find the dotfiles development dir."

    confirm "Pull latest from Git repo?" &&
        git -C "$DOTFILES_DIR" pull
fi

INIT_SCRIPT_FILE="$DOTFILES_DIR/setup/init.sh"
if [[ -f $INIT_SCRIPT_FILE ]]; then
    confirm "Start setup based on checked out dotfiles" &&
        bash "$INIT_SCRIPT_FILE"
else
    echo "WARN Could not find init script, skipping initialization"
fi

# ====================================================================================================
# Cleanup
# ====================================================================================================

if [[ -d "$TMP_DIR" ]]; then
    confirm "Remove temporary script files downloaded for bootstrapping?" &&
        rm -rf "$TMP_DIR"
fi
