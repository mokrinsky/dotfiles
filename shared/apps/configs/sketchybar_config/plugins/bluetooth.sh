#!/usr/bin/env bash

BLUETOOTH=$(system_profiler SPBluetoothDataType -json)
BT_STATE=$(echo "$BLUETOOTH" | jq -r '.SPBluetoothDataType[0].controller_properties.controller_state')
# BT_DEVICES=$(echo "$BLUETOOTH" | jq -r '.SPBluetoothDataType[0].device_connected[] | keys' 2> /dev/null)

case $BT_STATE in
    "attrib_on") COLOR=0xff89b4fa;;
    "attrib_off") COLOR=0xffcad3f5;;
esac

sketchybar --set "$NAME" icon.color="$COLOR"
