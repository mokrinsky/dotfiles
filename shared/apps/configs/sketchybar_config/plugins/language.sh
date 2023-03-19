#!/usr/bin/env bash

LANGUAGE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | sed -E 's/^.+ = \"?([^\"]+)\"?;$/\1/')

case $LANGUAGE in
    "U.S.") LANG="US";;
    "RussianWin") LANG="RU";;
    *) LANG="??";;
esac

sketchybar --set "$NAME" label="$LANG"
