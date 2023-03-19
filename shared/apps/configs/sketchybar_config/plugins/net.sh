#!/usr/bin/env sh

update() {
    LABEL=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk 'NR==13 {print $2}')

    sketchybar --set net_name label="$LABEL"
}

popup() {
    sketchybar --set net popup.drawing="$1"
}

case $SENDER in
    "mouse.entered") popup on;;
    "mouse.exited"|"mouse.exited.global") popup off;;
    *) update;;
esac
