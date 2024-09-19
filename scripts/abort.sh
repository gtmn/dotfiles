#!/usr/bin/env bash

# abort.sh - bootstrap GIT and DEVELOP setup for a new machine

# ==================================================

function abort {
  printf "%s\n" "$@" >&2
  exit 1
}