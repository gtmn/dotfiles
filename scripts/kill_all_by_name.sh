#!/usr/bin/env bash

killallbyname() {
    local process_name=$1
    echo "$process_name"
    local process_ids
    process_ids=$(ps aux | grep "$process_name" | grep -v grep | awk '{print $2}')
    echo "$process_ids"

    if [ -z "$process_ids" ]; then
        echo "No processes found for '$process_name'"
        return 0
    fi

    echo "Processes found for '$process_name': '$process_ids'"
    echo "Killing all these processes..."

    kill "$process_ids"

    return 1
}
