#!/usr/bin/env bash

###############################################################################
# Screen related settings                                                     #
###############################################################################

# Enable Night Shift
CORE_BRIGHTNESS="/var/root/Library/Preferences/com.apple.CoreBrightness.plist"
ENABLE='{
  CBBlueReductionStatus =     {
    AutoBlueReductionEnabled = 1;
    BlueLightReductionDisableScheduleAlertCounter = 3;
    BlueLightReductionSchedule =         {
      DayStartHour = 7;
      DayStartMinute = 0;
      NightStartHour = 22;
      NightStartMinute = 0;
    };
    BlueReductionEnabled = 0;
    BlueReductionMode = 1;
    BlueReductionSunScheduleAllowed = 1;
    Version = 1;
  };
}'

sudo defaults write $CORE_BRIGHTNESS "CBUser-0" "$ENABLE"
sudo defaults write $CORE_BRIGHTNESS "CBUser-$(dscl . -read $HOME GeneratedUID | sed 's/GeneratedUID: //')" "$ENABLE"

sudo killall cfprefsd
sudo killall corebrightnessd
