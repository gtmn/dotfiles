#!/usr/bin/env bash

###############################################################################
# Menu bar                                                                    #
###############################################################################

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# Disable transparency in the menu bar and elsewhere on Yosemite
# defaults write com.apple.universalaccess reduceTransparency -bool true

# Show battery percentage in menu bar
defaults write com.apple.menuextra.battery ShowPercent YES

# Show additional menu bar items
# See addtional menu extras: `open '/System/Library/CoreServices/Menu Extras/'`
# defaults write com.apple.systemuiserver menuExtras -array "/System/Library/CoreServices/Menu Extras/AirPort.menu" "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

defaults write com.apple.systemuiserver menuExtras -array \
    "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
    "/System/Library/CoreServices/Menu Extras/Battery.menu" \
    "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
    "/System/Library/CoreServices/Menu Extras/Clock.menu" \
    "/System/Library/CoreServices/Menu Extras/Displays.menu" \
    "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
    "/System/Library/CoreServices/Menu Extras/User.menu"
    # "/System/Library/CoreServices/Menu Extras/Eject.menu"
    # "/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu"
    # "/System/Library/CoreServices/Menu Extras/Volume.menu"
    # "/System/Library/CoreServices/Menu Extras/VPN.menu"

# Restart menu bar
killall SystemUIServer
