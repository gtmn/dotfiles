#!/bin/bash

# setup_new_ssh_key.sh

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck disable=1091
source "$SCRIPT_DIR/ssh_key_helper.sh"

clear
setup_new_ssh_key