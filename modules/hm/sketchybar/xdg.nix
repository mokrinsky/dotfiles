{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  flavor = "mocha";
  ctp = inputs.catppuccin.${flavor};
  unsharp = lib.strings.removePrefix "#";
  plugins = "sketchybar/plugins";
  cfg = config.yumi.sketchybar;
in {
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isDarwin;
        message =
          "This module is available only for darwin platform. If you run linux, please, set"
          + "yumi.sketchybar.enable = false; in your configuration";
      }
    ];

    xdg.configFile = {
      "${plugins}/battery.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
          CHARGING=$(pmset -g batt | grep 'AC Power')

          if [ "$PERCENTAGE" = "" ]; then
            exit 0
          fi

          case $PERCENTAGE in
            [8-9][0-9]|100)
              ICON=""
              ICON_COLOR=0xff${unsharp ctp.green.hex}
              ;;
            7[0-9])
              ICON=""
              ICON_COLOR=0xff${unsharp ctp.yellow.hex}
              ;;
            [4-6][0-9])
              ICON=""
              ICON_COLOR=0xff${unsharp ctp.peach.hex}
              ;;
            [1-3][0-9])
              ICON=""
              ICON_COLOR=0xff${unsharp ctp.maroon.hex}
              ;;
            [0-9])
              ICON=""
              ICON_COLOR=0xff${unsharp ctp.red.hex}
              ;;
          esac

          if [ "$CHARGING" != "" ]; then
            ICON=""
            ICON_COLOR=0xff${unsharp ctp.yellow.hex}
          fi

          sketchybar --set "$NAME" icon="$ICON" label="$PERCENTAGE%" icon.color="$ICON_COLOR"
        '';
      };

      "${plugins}/clock.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          LANG=it_IT

          sketchybar --set "$NAME" label="$(date '+%a %b %-d %-H:%M')"
        '';
      };

      "${plugins}/language.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          LANGUAGE=$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | sed -E 's/^.+ = \"?([^\"]+)\"?;$/\1/')

          case $LANGUAGE in
              "U.S.") LANG="US";;
              "RussianWin") LANG="RU";;
              *) LANG="??";;
          esac

          sketchybar --set "$NAME" label="$LANG"
        '';
      };

      "${plugins}/space.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          CURRENT_SPACES="$(yabai -m query --displays | jq -r '.[].spaces | @sh')"
          SPACE_ID=$(echo "$INFO" | jq -r '."display-1"')

          args=(--set spaces_bracket drawing=off --set '/space\..*/' background.drawing=on)
          while read -r line
          do
            for space in $line
            do
              icon_strip=""
              #apps=$(yabai -m query --windows --space "$space" | jq -r ".[].app")
              #if [ "$apps" != "" ]; then
              #  while IFS= read -r app; do
              #    icon_strip+="$("$HOME"/.config/sketchybar/plugins/icons.sh "$app") "
              #  done <<< "$apps"
              #fi
              if [ "$icon_strip" = "" ]; then
                  args+=(--set space."$space" label="" label.drawing=off label.padding_right=5)
              else
                  args+=(--set space."$space" label="$icon_strip" label.drawing=on label.padding_right=5)
              fi
              if [ "$SPACE_ID" == "$space" ]; then
                  args+=(background.color=0xff${unsharp ctp.peach.hex} icon.color=0xff${unsharp ctp.base.hex} label.color=0xff${unsharp ctp.base.hex})
              else
                  args+=(background.color=0xff${unsharp ctp.base.hex} icon.color=0xff${unsharp ctp.text.hex} label.color=0xff${unsharp ctp.text.hex})
              fi
            done
          done <<< "$CURRENT_SPACES"

          sketchybar -m "''${args[@]}"
        '';
      };

      "${plugins}/spaces.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          SPACE_ICONS=("term" "web" "dc" "tg" "obs" "sdg" "slack" "tsx" "九" "十" "十一" "十二" "十三" "十四" "十五")

          sid=0
          for i in "''${!SPACE_ICONS[@]}"
          do
            sid=$((i+1))

            space=(
              associated_space="$sid"
              icon="''${SPACE_ICONS[i]}"
              label.drawing=off
              icon.font="$FONT_FACE:Bold:12.0"
              label.font="$ICON_FACE:2048-em:14.0"
              script="$PLUGIN_DIR/space.sh"
            )

            sketchybar  --add space space.$sid left    \
                        --set space.$sid "''${space[@]}" \
                        --subscribe space.$sid mouse.clicked
          done

          spaces_bracket=(
          )

          sketchybar  --add bracket spaces_bracket '/space\..*/'  \
                      --set spaces_bracket "''${spaces_bracket[@]}"
        '';
      };

      "${plugins}/spotify.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          # Max number of characters so it fits nicely to the right of the notch
          # MAY NOT WORK WITH NON-ENGLISH CHARACTERS

          MAX_LENGTH=35
          # MAX_LENGTH=45

          # Logic starts here, do not modify
          HALF_LENGTH=$(((MAX_LENGTH + 1) / 2))

          # Spotify JSON / $INFO comes in malformed, line below sanitizes it

          # SPOTIFY_JSON="{$(echo $INFO | iconv -f utf-8 -t utf-8 -c | cut -d'}' -f1 | cut -d'{' -f2)}"
          SPOTIFY_JSON="$INFO"

          update_track() {
            PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')

            if [ "$PLAYER_STATE" = "Playing" ]; then
              TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
              ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

              # Calculations so it fits nicely

              TRACK_LENGTH=''${#TRACK}
              ARTIST_LENGTH=''${#ARTIST}

              if [ $(( TRACK_LENGTH + ARTIST_LENGTH )) -gt $MAX_LENGTH ]; then
                # If the total length exceeds the max
                if [ "$TRACK_LENGTH" -gt "$HALF_LENGTH" ] && [ "$ARTIST_LENGTH" -gt "$HALF_LENGTH" ]; then
                  # If both the track and artist are too long, cut both at half length - 1

                  # If MAX_LENGTH is odd, HALF_LENGTH is calculated with an extra space, so give it an extra char
                  TRACK="''${TRACK:0:$(( MAX_LENGTH % 2 == 0 ? HALF_LENGTH - 2 : HALF_LENGTH - 1 ))}…"
                  ARTIST="''${ARTIST:0:$(( HALF_LENGTH - 2 ))}…"

                elif [ "$TRACK_LENGTH" -gt "$HALF_LENGTH" ]; then
                  # Else if only the track is too long, cut it by the difference of the max length and artist length
                  TRACK="''${TRACK:0:$(( MAX_LENGTH - ARTIST_LENGTH - 1 ))}…"
                elif [ "$ARTIST_LENGTH" -gt "$HALF_LENGTH" ]; then
                  ARTIST="''${ARTIST:0:$(( MAX_LENGTH - TRACK_LENGTH - 1 ))}…"
                fi
              fi
              sketchybar --set "$NAME" label="$ARTIST  $TRACK" label.drawing=yes icon.padding_right=3 icon.color=0xff${unsharp ctp.green.hex}

            elif [ "$PLAYER_STATE" = "Paused" ]; then
              sketchybar --set "$NAME" icon.color=0xff${unsharp ctp.yellow.hex}
            elif [ "$PLAYER_STATE" = "Stopped" ]; then
              sketchybar --set "$NAME" icon.color=0xff${unsharp ctp.yellow.hex} label.drawing=no icon.padding_right=7
            else
              sketchybar --set "$NAME" icon.color=0xff${unsharp ctp.yellow.hex}
            fi
          }


          case "$SENDER" in
            "mouse.clicked")
              osascript -e 'tell application "Spotify" to playpause'
              ;;
            *)
              update_track
              ;;
          esac
        '';
      };

      "${plugins}/weather.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          LOCATION_JSON=$(curl -s https://ip-api.com/json)

          LOCATION="$(echo "$LOCATION_JSON" | jq '.city' | tr -d '"')"
          REGION="$(echo "$LOCATION_JSON" | jq '.region' | tr -d '"')"
          # COUNTRY="$(echo "$LOCATION_JSON" | jq '.country' | tr -d '"')"

          # Line below replaces spaces with +
          # LOCATION_ESCAPED="''${LOCATION// /+}+''${REGION// /+}"
          LOCATION_ESCAPED="''${LOCATION// /+}"
          WEATHER_JSON=$(curl -s "https://wttr.in/$LOCATION_ESCAPED?format=j1&lang=it")

          # Fallback if empty
          if [ -z "$WEATHER_JSON" ]; then

            sketchybar --set "$NAME" label="No Data"
            sketchybar --set "$NAME".moon icon=

            return
          fi

          TEMPERATURE=$(echo "$WEATHER_JSON" | jq '.current_condition[0].temp_C' | tr -d '"')
          WEATHER_DESCRIPTION=$(echo "$WEATHER_JSON" | jq '.current_condition[0].lang_it[0].value' | tr -d '"' | sed 's/\(.\{25\}\).*/\1.../')
          WEATHER_CODE=$(echo "$WEATHER_JSON" | jq '.current_condition[0].weatherCode' | tr -d '"')

          # This part was based on wttr.in source code.
          # Sunny weather at midnight is kinda ok.
          case $WEATHER_CODE in
              "113") LABEL="Sunny";;
              "116") LABEL="PartlyCloudy";;
              "119") LABEL="Cloudy";;
              "122") LABEL="VeryCloudy";;
              "143") LABEL="Fog";;
              "176") LABEL="LightShowers";;
              "179") LABEL="LightSleetShowers";;
              "182") LABEL="LightSleet";;
              "185") LABEL="LightSleet";;
              "200") LABEL="ThunderyShowers";;
              "227") LABEL="LightSnow";;
              "230") LABEL="HeavySnow";;
              "248") LABEL="Fog";;
              "260") LABEL="Fog";;
              "263") LABEL="LightShowers";;
              "266") LABEL="LightRain";;
              "281") LABEL="LightSleet";;
              "284") LABEL="LightSleet";;
              "293") LABEL="LightRain";;
              "296") LABEL="LightRain";;
              "299") LABEL="HeavyShowers";;
              "302") LABEL="HeavyRain";;
              "305") LABEL="HeavyShowers";;
              "308") LABEL="HeavyRain";;
              "311") LABEL="LightSleet";;
              "314") LABEL="LightSleet";;
              "317") LABEL="LightSleet";;
              "320") LABEL="LightSnow";;
              "323") LABEL="LightSnowShowers";;
              "326") LABEL="LightSnowShowers";;
              "329") LABEL="HeavySnow";;
              "332") LABEL="HeavySnow";;
              "335") LABEL="HeavySnowShowers";;
              "338") LABEL="HeavySnow";;
              "350") LABEL="LightSleet";;
              "353") LABEL="LightShowers";;
              "356") LABEL="HeavyShowers";;
              "359") LABEL="HeavyRain";;
              "362") LABEL="LightSleetShowers";;
              "365") LABEL="LightSleetShowers";;
              "368") LABEL="LightSnowShowers";;
              "371") LABEL="HeavySnowShowers";;
              "374") LABEL="LightSleetShowers";;
              "377") LABEL="LightSleet";;
              "386") LABEL="ThunderyShowers";;
              "389") LABEL="ThunderyHeavyRain";;
              "392") LABEL="ThunderySnowShowers";;
              "395") LABEL="HeavySnowShowers";;
          esac

          case $LABEL in
              "Unknown") ICON="";;
              "Cloudy") ICON="";;
              "Fog") ICON="";;
              "HeavyRain") ICON="";;
              "HeavyShowers") ICON="";;
              "HeavySnow") ICON="";;
              "HeavySnowShowers") ICON="";;
              "LightRain") ICON="";;
              "LightShowers") ICON="";;
              "LightSleet") ICON="";;
              "LightSleetShowers") ICON="";;
              "LightSnow") ICON="";;
              "LightSnowShowers") ICON="";;
              "PartlyCloudy") ICON="";;
              "Sunny") ICON="";;
              "ThunderyHeavyRain") ICON="";;
              "ThunderyShowers") ICON="";;
              "ThunderySnowShowers") ICON="";;
              "VeryCloudy") ICON="";;
          esac

          sketchybar --set "$NAME" label="$TEMPERATURE 󰔄 $WEATHER_DESCRIPTION"
          sketchybar --set "$NAME".moon icon="$ICON"
        '';
      };

      "${plugins}/wg.sh" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          WG=$(sudo wg)

          if [ "$WG" = "" ]; then
              DRAWING=off
          else
              DRAWING=on
          fi

          sketchybar --set "$NAME" drawing="$DRAWING"
        '';
      };

      "sketchybar/sketchybarrc" = {
        executable = true;
        text = ''
          #!/usr/bin/env bash

          PLUGIN_DIR="${config.xdg.configHome}/${plugins}"
          FONT_FACE="JetBrainsMono Nerd Font"
          ICON_FACE="Symbols Nerd Font Mono"

          sketchybar  --bar \
                      height=32 \
                      blur_radius=0 \
                      position=top \
                      sticky=on \
                      padding_left=5 \
                      padding_right=5 \
                      display=main \
                      color=0x00${unsharp ctp.base.hex}

          sketchybar  --default \
                      updates=when_shown \
                      background.color=0xff${unsharp ctp.base.hex} \
                      background.padding_left=2 \
                      background.padding_right=2 \
                      background.corner_radius=5 \
                      background.height=30 \
                      icon.color=0xff${unsharp ctp.text.hex} \
                      icon.font="$ICON_FACE:2048-em:17.0" \
                      icon.padding_left=8 \
                      icon.padding_right=7 \
                      label.font="$FONT_FACE:Bold:12.0" \
                      label.color=0xff${unsharp ctp.text.hex} \
                      label.padding_left=0 \
                      label.padding_right=7

          # shellcheck source=plugins/spaces.sh
          source "$PLUGIN_DIR/spaces.sh"

          sketchybar  --add bracket front_app_bracket \
                            front_app \
                            front_app.separator \
                            front_app.name \
                      --subscribe front_app front_app_switched

          sketchybar  --add item weather.moon q \
                      --set weather.moon \
                            background.color=0xff${unsharp ctp.sapphire.hex} \
                            background.padding_right=14 \
                            icon.color=0xff${unsharp ctp.crust.hex} \
                            icon.font="$ICON_FACE:2048-em:22.0" \
                            label.drawing=off

          sketchybar  --add item weather q \
                      --set weather \
                            icon= \
                            icon.color=0xff${unsharp ctp.pink.hex} \
                            icon.font="$ICON_FACE:2048-em:15.0" \
                            update_freq=1800 \
                            script="$PLUGIN_DIR/weather.sh" \
                      --subscribe weather system_woke

          SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"
          sketchybar  --add event spotify_change $SPOTIFY_EVENT \
                      --add item spotify e \
                      --set spotify \
                            background.padding_left=14 \
                            icon= \
                            icon.font="$ICON_FACE:2048-em:20.0" \
                            icon.y_offset=1 \
                            label.drawing=off \
                            label.padding_left=2 \
                            script="$PLUGIN_DIR/spotify.sh" \
                      --subscribe spotify spotify_change mouse.clicked

          sketchybar  --add item clock right \
                      --set clock \
                            icon=󰃰 \
                            icon.y_offset=1 \
                            icon.color=0xff${unsharp ctp.red.hex} \
                            update_freq=10 \
                            script="$PLUGIN_DIR/clock.sh"

          sketchybar  --add item wg right \
                      --set wg \
                            script="$PLUGIN_DIR/wg.sh" \
                            icon=󰖂 \
                            icon.y_offset=1 \
                            icon.color=0xff${unsharp ctp.mauve.hex} \
                            update_freq=10 \
                            updates=on \
                            label.drawing=off

          sketchybar  --add item battery right \
                      --set battery \
                            icon.y_offset=1 \
                            update_freq=10 \
                            script="$PLUGIN_DIR/battery.sh" \
                      --subscribe battery system_woke

          sketchybar  --add item language right \
                      --set language \
                            script="$PLUGIN_DIR/language.sh" \
                            update_freq=5 \
                            icon.drawing=off \
                            label.padding_left=7

          ##### Finalizing Setup #####
          sketchybar --update
          sketchybar --trigger space_change
        '';
      };
    };
  };
}
