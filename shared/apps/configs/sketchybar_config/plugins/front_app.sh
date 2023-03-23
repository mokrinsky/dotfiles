#!/usr/bin/env sh

# echo $INFO

ICON_PADDING_RIGHT=10

ICON=$("$HOME"/.config/sketchybar/plugins/icons.sh "$INFO")

case $INFO in
  "WezTerm") ICON_PADDING_RIGHT=8;;
  "Brave Browser") ICON_PADDING_RIGHT=7;;
esac

sketchybar --set "$NAME" icon="$ICON" icon.padding_right="$ICON_PADDING_RIGHT"
sketchybar --set "$NAME".name label="$INFO"
