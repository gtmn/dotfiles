#!/bin/bash

# functions.sh - Internally used functions

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# shellcheck source=/dev/null
source "$SCRIPT_DIR/ask.sh"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/confirm.sh"