#!/bin/bash

# ask.sh - Ask for a value and offer optionally a default value

function ask_for_value {
    local _QUESTION=$1
    local _DEFAULT_VALUE=$2

    if [[ -n $_DEFAULT_VALUE ]]; then
        IFS= read -erp "$_QUESTION ($_DEFAULT_VALUE): " input
    else
        IFS= read -erp "$_QUESTION: " input
    fi

    echo "${input:-$_DEFAULT_VALUE}"
}

function ask_to_set_variable {
    local _RESULT_VAR=$1
    local _QUESTION=$2
    local _DEFAULT_VALUE=$3

    eval "$_RESULT_VAR=$(ask_for_value "$_QUESTION" "$_DEFAULT_VALUE")"
}