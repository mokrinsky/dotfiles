#!/usr/bin/env bash

# SPACES=$(yabai -m query --windows | jq -r '[.[] | {app,space}] | sort_by(.space)')
 

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15")

sid=0
for i in "${!SPACE_ICONS[@]}"
do
  sid=$((i+1))

  space=(
    associated_space="$sid"
    icon="${SPACE_ICONS[i]}"
    label.drawing=off
    icon.font="$FONT_FACE:Bold:12.0"
    label.font="$ICON_FACE:2048-em:14.0"
    script="$PLUGIN_DIR/space.sh"
  )

  sketchybar --add space space.$sid left    \
             --set space.$sid "${space[@]}" \
             --subscribe space.$sid mouse.clicked
done

spaces_bracket=(
)

sketchybar --add bracket spaces_bracket '/space\..*/'  \
           --set spaces_bracket "${spaces_bracket[@]}" \
