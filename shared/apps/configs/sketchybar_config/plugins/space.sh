#!/usr/bin/env bash

CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"
SPACE_ID=$(echo "$INFO" | jq -r '."display-1"')

args=(--set spaces_bracket drawing=off --set '/space\..*/' background.drawing=on)
while read -r line
do
  for space in $line
  do
    icon_strip=""
    apps=$(yabai -m query --windows --space "$space" | jq -r ".[].app")
    if [ "$apps" != "" ]; then
      while IFS= read -r app; do
        icon_strip+="$("$HOME"/.config/sketchybar/plugins/icons.sh "$app") "
      done <<< "$apps"
    fi
    if [ "$icon_strip" = "" ]; then
        args+=(--set space."$space" label="" label.drawing=off label.padding_right=5)
    else
        args+=(--set space."$space" label="$icon_strip" label.drawing=on label.padding_right=5)
    fi
    if [ "$SPACE_ID" == "$space" ]; then
        args+=(background.color=0xfff5a97f icon.color=0xff24273a label.color=0xff24273a)
    else
        args+=(background.color=0xff24273a icon.color=0xffffffff label.color=0xffffffff)
    fi
  done
done <<< "$CURRENT_SPACES"

sketchybar -m "${args[@]}"

