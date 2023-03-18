#!/usr/bin/env sh

# echo $INFO

ICON_PADDING_RIGHT=10

case $INFO in
  "WezTerm") ICON_PADDING_RIGHT=8; ICON= ;;
  "Discord") ICON=ﭮ ;;
  "Finder") ICON= ;;
  "Brave Browser") ICON_PADDING_RIGHT=7; ICON= ;;
  "Spotify") ICON= ;;
  "App Store") ICON= ;;
  "Photos") ICON= ;;
  "Preview") ICON= ;;
  "System Preferences") ICON= ;;
  "Telegram") ICON= ;;
  "Sublime Text") ICON= ;;
  "VLC") ICON=󰕼 ;;
  "Microsoft Outlook") ICON=󰴢 ;;
  "RoboForm") ICON= ;;
  *) ICON=﯂ ;;
esac

sketchybar --set "$NAME" icon="$ICON" icon.padding_right="$ICON_PADDING_RIGHT"
sketchybar --set "$NAME".name label="$INFO"
