#!/bin/bash
echo "Installing software..."

# Mac App Store
brew install mas
mas install 497799835 # Xcode
mas install 1037126344 # Apple Configurator

# Homebrew
brew tap caskroom/cask
brew tap caskroom/versions
brew tap caskroom/fonts
brew install homebrew/completions/brew-cask-completion

brew tap buo/cask-upgrade

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# general
brew cask install little-snitch
brew cask install alfred

# quicklook
brew cask install qlcolorcode 
brew cask install qlstephen 
brew cask install qlmarkdown 
brew cask install quicklook-json 
brew cask install qlprettypatch 
brew cask install quicklook-csv 
brew cask install betterzipql 
brew cask install qlimagesize 
brew cask install webpquicklook 
brew cask install suspicious-package 
brew cask install quicklookase 
brew cask install qlvideo
brew cask install provisionql
brew cask install stringsfile


# terminal
brew install z
brew install zsh zsh-completions 
brew cask install iterm2
brew install bash-completion


# GNU core utilities (those that come with OS X are outdated)
brew install coreutils
brew install moreutils
# GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed
brew install findutils
# GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --with-default-names

# scm
brew cask install github-desktop 
brew cask install sourcetree 
brew cask install svnx

# dev editors
brew cask install sublime-text
brew cask install visual-studio-code
brew cask install visual-studio-code-insiders
brew cask install intellij-idea
brew cask install intellij-idea-ce

# dev android
brew cask install java
brew install gradle
brew install maven
brew install ant
brew cask install android-studio
brew cask install android-file-transfer
brew cask install android-platform-tools
# brew cask install android-sdk
brew cask install android-ndk
# brew cask install androidtool
brew install pidcat
brew install jadx

# dev ios
brew install cocoapods
# pod setup
brew cask install application-loader

# browsers
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install firefox
brew cask install firefoxnightly
brew cask install safari-technology-preview

# other
brew cask install the-unarchiver
brew cask install skype-for-business
brew cask install adium
# brew cask install dropbox
# brew cask install google-backup-and-sync
brew cask install spotify
# brew cask install vlc
brew cask install postman
brew cask install wireshark
# moom
# evernote
# lastpasse
# 1password

# fonts
brew cask install font-source-code-pro-for-powerline
brew cask install font-source-code-pro
brew cask install font-open-sans-condensed
brew cask install font-open-sans
brew cask install font-roboto-condensed
brew cask install font-roboto-mono-for-powerline
brew cask install font-roboto-mono
brew cask install font-roboto-slab
brew cask install font-roboto
brew cask install font-robotomono-nerd-font-mono
brew cask install font-robotomono-nerd-font
brew cask install font-fira-code
brew cask install font-fira-mono-for-powerline
brew cask install font-fira-mono
brew cask install font-fira-sans
brew cask install font-firacode-nerd-font-mono
brew cask install font-firacode-nerd-font
brew cask install font-firamono-nerd-font-mono
brew cask install font-firamono-nerd-font


# node
brew install nvm

# python
sudo easy_install pip


# brew install \
#   mysql \
#   postgresql \
#   mongodb \
#   redis \
#   elasticsearch

# brew cask install mysqlworkbench
