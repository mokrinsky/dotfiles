#!/usr/bin/env bash

case $1 in
  "WezTerm") ICON= ;;
  "Discord") ICON=ﭮ ;;
  "Finder") ICON= ;;
  "Brave Browser") ICON=󰖟 ;;
  "Spotify") ICON= ;;
  "App Store") ICON= ;;
  "Photos") ICON= ;;
  "Preview") ICON= ;;
  "System Preferences") ICON= ;;
  "Telegram") ICON= ;;
  "Sublime Text") ICON= ;;
  "VLC") ICON=󰕼 ;;
  "Microsoft Outlook") ICON=󰊫 ;;
  "RoboForm") ICON= ;;
  "MatterMost") ICON= ;;
  *) ICON=﯂ ;;
esac

echo $ICON
