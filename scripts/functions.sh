#!/usr/bin/env bash

# functions.sh - Internally used functions

apply_common_functions() {
    local SCRIPT_DIR
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

    # shellcheck source=/dev/null
    source "$SCRIPT_DIR/abort.sh"
    source "$SCRIPT_DIR/ask.sh"
    source "$SCRIPT_DIR/confirm.sh"
}
apply_common_functions

url_is_resolvable() {
    local url=$1

    if curl --output /dev/null --silent --head --fail "$url"; then
        return 0
    fi

    return 1
}
