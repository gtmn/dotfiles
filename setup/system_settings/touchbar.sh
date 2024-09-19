#!/usr/bin/env bash

###############################################################################
# Touchbar                                                                    #
###############################################################################

# Always display full control strip (ignoring App Controls)
# defaults write com.apple.touchbar.agent PresentationModeGlobal fullControlStrip

# com.apple.system.brightness
# com.apple.system.dashboard
# com.apple.system.dictation
# com.apple.system.do-not-disturb
# com.apple.system.input-menu
# com.apple.system.launchpad
# com.apple.system.media-play-pause
# com.apple.system.mission-control
# com.apple.system.mute
# com.apple.system.notification-center
# com.apple.system.screen-lock
# com.apple.system.screen-saver
# com.apple.system.screencapture
# com.apple.system.search
# com.apple.system.show-desktop
# com.apple.system.siri
# com.apple.system.sleep
# com.apple.system.volume
defaults write com.apple.controlstrip MiniCustomized '(
    com.apple.system.brightness,
    com.apple.system.volume,
    com.apple.system.do-not-disturb,
    com.apple.system.screen-lock
)'

killall ControlStrip
