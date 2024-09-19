#!/usr/bin/env bash

type_insert() {
    osascript -e "tell application \"System Events\" to keystroke \"$1\""
}

# type_insert_date() "$(date -j +'%Y-%m-%d')"
