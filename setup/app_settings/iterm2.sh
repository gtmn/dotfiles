#!/usr/bin/env bash

###############################################################################
# iTerm 2                                                                     #
###############################################################################

# Install the Solarized Dark theme for iTerm
# open "${HOME}/init/Solarized Dark.itermcolors"

# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false

# Use custom settings folder
defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$(pwd)g/iterm2"

# Save changes to folder when iTerm2 quits
defaults write com.googlecode.iterm2 NoSyncNeverRemindPrefsChangesLostForFile_selection 0
